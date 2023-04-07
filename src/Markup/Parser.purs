module Markup.Parser where

import Prelude

import Markup.Syntax
  ( Block(..)
  , ListType(..)
  , Inline(..)
  , LinkTarget(..)
  , Markup(..)
  , CodeBlockType(..)
  , consolidate
  )
import Control.Alt ((<|>))
import Control.Lazy as Lazy
import Data.Array (any, cons, replicate, fromFoldable)
import Data.Array as A
import Data.Bifunctor (lmap)
import Data.CodePoint.Unicode (isAlphaNum)
import Data.Foldable (foldr, foldl, length, elem, all)
import Data.Either (Either(..), fromRight)
import Data.List (List(..), toUnfoldable, (:))
import Data.List as L
import Data.Maybe as M
import Data.String (trim, replace)
import Data.String as S
import Data.String.CodeUnits (fromCharArray, singleton)
import Data.String.CodePoints (codePointFromChar)
import Data.String.CodePoints as CP
import Data.String.Regex (regex, Regex, test, replace) as R
import Data.String.Regex.Unsafe (unsafeRegex)
import Data.String.Regex.Flags as RF
import Data.Traversable (traverse)
import Partial.Unsafe (unsafePartial)
import Parsing.Combinators (option, optionMaybe, many, many1, choice, try, manyTill, lookAhead, (<?>), skipMany1)

import Parsing.String (string, eof, char, anyChar, satisfy)
import Parsing.String.Basic (oneOf)
import Parsing.Token (LanguageDef, GenLanguageDef(..), letter, digit, letter)
import Parsing (runParser, Parser, ParseError, fail, parseErrorMessage)

import Markup.Parser.References as Ref
import Markup.Parser.Utils (isWhitespace)

type P a = Parser String a

data Container
  = CText String
  | CBlank
  | CRule
  | CATXHeader Int String
  | CSetextHeader Int
  | CBlockquote (List Container)
  | CListItem ListType (List Container)
  | CCodeBlockFenced Boolean String (List String)
  | CCodeBlockIndented (List String)
  | CLinkReference Block

parseMarkup :: String -> Either ParseError Markup
parseMarkup mkup = map Markup (parseBlocks containers)
  where
  lines =
    L.fromFoldable
      $ S.split (S.Pattern "\n") -- should this happen here?
      $ R.replace slashR ""
      $ tabsToSpaces mkup
  containers = parseContainers mempty lines
  slashR = unsafeRegex "\\r" RF.global

--parseInlines :: String -> Either ParseError (List Inline)
--parseInlines is = runParser is inlines 

parseInlines :: List String -> Either ParseError (List Inline)
parseInlines s = map consolidate $ runParser (S.joinWith "\n" $ A.fromFoldable s) inlines

--map consolidate
--  $ lmap parseErrorMessage

inlines :: P (List Inline)
inlines = L.many inline2 <* eof
  where
  inline0 :: P Inline
  inline0 =
    Lazy.fix \p ->
      alphaNumStr
        <|> space
        <|> strongEmph p
        <|> strong p
        <|> emph p
        <|> code
        <|> math

  --        <|> autolink
  --        <|> entity

  inline1 :: P Inline
  inline1 =
    try inline0
      <|> try link

  inline2 :: P Inline
  inline2 = do
    res <-
      try (Right <$> inline1)
        <|> (Right <$> other)
    case res of
      Right v -> pure v
      Left e -> fail e

  alphaNumStr :: P Inline
  alphaNumStr = Str <$> someOf (isAlphaNum <<< codePointFromChar)

  space :: P Inline
  space = (toSpace <<< (singleton <$> _)) <$> L.some (satisfy isWhitespace)
    where
    toSpace cs
      | "\n" `elem` cs =
          case L.take 2 cs of
            L.Cons " " (L.Cons " " L.Nil) -> LineBreak
            _ -> SoftBreak
      | otherwise = Space

  code :: P Inline
  code = do
    eval <- option false (string "!" *> pure true)
    ticks <- someOf (\x -> singleton x == "`")
    contents <- (fromCharArray <<< A.fromFoldable) <$> manyTill anyChar (string ticks)
    pure <<< Code eval <<< trim $ contents

  emph :: P Inline -> P Inline
  emph p = emphasis p Emph "*" <|> emphasis p Emph "_"

  math :: P Inline
  math = do
    _ <- string "$"
    contents <- (fromCharArray <<< A.fromFoldable) <$> manyTill anyChar (string "$")
    pure <<< Math <<< trim $ contents

  --Math <$> manyTill p (string "$")

  strong :: P Inline -> P Inline
  strong p = emphasis p Strong "**" <|> emphasis p Strong "__"

  strongEmph :: P Inline -> P Inline
  strongEmph p = emphasis p f "***" <|> emphasis p f "___"
    where
    f is = Strong $ L.singleton $ Emph is

  link :: P Inline
  link = Link <$> linkLabel <*> linkTarget
    where
    linkLabel :: P (List Inline)
    linkLabel = string "[" *> manyTill (inline0 <|> other) (string "]")

    linkTarget :: P LinkTarget
    linkTarget = inlineLink <|> referenceLink

    inlineLink :: P LinkTarget
    inlineLink = InlineLink <<< fromCharArray <<< A.fromFoldable <$> (string "(" *> manyTill anyChar (string ")"))

    referenceLink :: P LinkTarget
    referenceLink = ReferenceLink <$> optionMaybe ((fromCharArray <<< A.fromFoldable) <$> (string "[" *> manyTill anyChar (string "]")))

  emphasis
    :: P (Inline)
    -> (List (Inline) -> Inline)
    -> String
    -> P Inline
  emphasis p f s = do
    _ <- string s
    f <$> manyTill p (string s)

  other :: P Inline
  other = do
    c <- singleton <$> anyChar
    if c == "\\" then
      (Str <<< singleton) <$> anyChar
        <|> ((satisfy (\x -> singleton x == "\n")) *> pure LineBreak)
        <|> pure (Str "\\")
    else pure (Str c)

parseBlocks :: List Container -> Either ParseError (List Block)
parseBlocks =
  case _ of
    Nil -> pure Nil
    CText s : CSetextHeader n : cs -> do
      hd <- parseInlines $ L.singleton s
      tl <- parseBlocks cs
      pure $ (Header n hd) : tl

    CText s : cs -> do
      let
        sp = L.span isTextContainer cs
      is <- parseInlines $ s : (map getCText sp.init)
      tl <- parseBlocks sp.rest
      pure $ (Paragraph is) : tl

    CRule : cs ->
      map (Rule : _) $ parseBlocks cs

    (CATXHeader n s) : cs -> do
      hd <- parseInlines $ L.singleton s
      tl <- parseBlocks cs
      pure $ (Header n hd) : tl
    (CBlockquote cs) : cs1 -> do
      hd <- parseBlocks cs
      tl <- parseBlocks cs1
      pure $ (Blockquote hd) : tl
    (CListItem lt cs) : cs1 -> do
      let
        sp = L.span (isListItem lt) cs1
      bs <- parseBlocks cs
      bss <- traverse (parseBlocks <<< getCListItem) sp.init
      tl <- parseBlocks sp.rest
      pure $ (Lst lt (bs : bss)) : tl
    (CCodeBlockIndented ss) : cs ->
      map ((CodeBlock Indented ss) : _) $ parseBlocks cs
    (CCodeBlockFenced eval info ss) : cs ->
      map ((CodeBlock (Fenced eval info) ss) : _) $ parseBlocks cs
    (CLinkReference b) : cs ->
      map (b : _) $ parseBlocks cs
    L.Cons _ cs ->
      parseBlocks cs

someOf
  :: (Char -> Boolean)
  -> P String
someOf =
  map (fromCharArray <<< A.fromFoldable)
    <<< L.some
    <<< satisfy

toString :: List Char -> String
toString = (fromCharArray <<< toUnfoldable)

parseContainers
  :: List Container
  -> List String
  -> List Container
parseContainers acc L.Nil = L.reverse acc
parseContainers acc (L.Cons s ss)
  | allChars isSpace s =
      parseContainers (L.Cons CBlank acc) ss
  | isATXHeader (removeNonIndentingSpaces s) =
      let
        o = splitATXHeader (removeNonIndentingSpaces s)
      in
        parseContainers (L.Cons (CATXHeader o.level o.contents) acc) ss
  | isSetextHeader (removeNonIndentingSpaces (S.trim s)) (L.last acc) =
      parseContainers (L.Cons (CSetextHeader $ setextLevel (removeNonIndentingSpaces (S.trim s))) acc) ss
  | isRule (removeNonIndentingSpaces s) =
      parseContainers (L.Cons CRule acc) ss
  | isBlockquoteLine s =
      let
        o = splitBlockquote $ L.Cons s ss
      in
        parseContainers (L.Cons (CBlockquote (parseContainers mempty o.blockquoteLines)) acc) o.otherLines
  | isListItemLine s =
      let
        o = splitListItem s ss
      in
        parseContainers (L.Cons (CListItem o.listType $ parseContainers mempty o.listItemLines) acc) o.otherLines
  | isIndentedChunk s =
      let
        o = splitIndentedChunks (L.Cons s ss)
      in
        parseContainers (L.Cons (CCodeBlockIndented o.codeLines) acc) o.otherLines
  | isCodeFence (removeNonIndentingSpaces s) =
      let
        s1 = removeNonIndentingSpaces s
        eval = isEvaluatedCode s1
        s2 = if eval then S.drop 1 s1 else s1
        info = codeFenceInfo s2
        ch = codeFenceChar s2
        o = splitCodeFence (countLeadingSpaces s) ch ss
      in
        parseContainers (L.Cons (CCodeBlockFenced eval info o.codeLines) acc) o.otherLines
  | isLinkReference (removeNonIndentingSpaces s) =
      let
        s1 = removeNonIndentingSpaces s
        b = unsafePartial M.fromJust $ Ref.parseLinkReference s1
      in
        parseContainers (L.Cons (CLinkReference b) acc) ss
  | otherwise = parseContainers (L.Cons (CText s) acc) ss

allChars :: (String -> Boolean) -> String -> Boolean
allChars p = all p <<< S.split (S.Pattern "")

isSpace :: String -> Boolean
isSpace " " = true
isSpace _ = false

tabsToSpaces :: String -> String
tabsToSpaces = S.replace (S.Pattern "\t") (S.Replacement "    ")

isATXHeader :: String -> Boolean
isATXHeader s =
  let
    level = S.countPrefix (\c -> S.singleton c == "#") s
    rest = S.drop level s
  in
    level >= 1 && level <= 6 && S.take 1 rest == " "

removeNonIndentingSpaces :: String -> String
removeNonIndentingSpaces s
  | S.countPrefix (isSpace <<< S.singleton) s < 4 = S.dropWhile (isSpace <<< S.singleton) s
  | otherwise = s

splitATXHeader :: String -> { level :: Int, contents :: String }
splitATXHeader s =
  let
    level = S.countPrefix (\c -> S.singleton c == "#") s
    contents = S.drop (level + 1) s
  in
    { level: level
    , contents: contents
    }

isSetextHeader :: String -> M.Maybe Container -> Boolean
isSetextHeader s (M.Just (CText _)) = S.length s >= 1 && any (\c -> allChars ((==) c) s) [ "=", "-" ]
isSetextHeader _ _ = false

setextLevel :: String -> Int
setextLevel s
  | S.take 1 s == "=" = 1
  | otherwise = 2

isRule :: String -> Boolean
isRule s =
  allChars isRuleChar s
    && S.length s >= 3
    && allChars ((==) (S.take 1 s)) s

isRuleChar :: String -> Boolean
isRuleChar "*" = true
isRuleChar "-" = true
isRuleChar "_" = true
isRuleChar _ = false

isBlockquoteLine :: String -> Boolean
isBlockquoteLine s = S.take 1 (removeNonIndentingSpaces s) == ">"

splitBlockquote :: L.List String -> { blockquoteLines :: L.List String, otherLines :: L.List String }
splitBlockquote ss =
  let
    sp = L.span isBlockquoteLine ss
    bq = map (blockquoteContents <<< removeNonIndentingSpaces) sp.init
  in
    { blockquoteLines: bq
    , otherLines: sp.rest
    }
  where
  blockquoteContents :: String -> String
  blockquoteContents s = S.drop (if S.take 2 s == "> " then 2 else 1) s

isListItemLine :: String -> Boolean
isListItemLine s =
  let
    s' = removeNonIndentingSpaces s
  in
    isBulleted s' || isOrderedListMarker s'

isBulleted :: String -> Boolean
isBulleted s =
  let
    b = S.take 1 s
    ls = countLeadingSpaces (S.drop 1 s)
  in
    isBullet b && ls > 0 && ls < 5
  where
  isBullet :: String -> Boolean
  isBullet "*" = true
  isBullet "+" = true
  isBullet "-" = true
  isBullet _ = false

isOrderedListMarker :: String -> Boolean
isOrderedListMarker s =
  let
    n = S.countPrefix (isDigit <<< S.singleton) s
    next = S.take 2 (S.drop n s)
    ls = countLeadingSpaces (S.drop (n + 1) s)
  in
    n > 0 && (next == "." || next == ")") && ls > 0

countLeadingSpaces :: String -> Int
countLeadingSpaces = S.countPrefix (isSpace <<< S.singleton)

isDigit :: String -> Boolean
isDigit "0" = true
isDigit "1" = true
isDigit "2" = true
isDigit "3" = true
isDigit "4" = true
isDigit "5" = true
isDigit "6" = true
isDigit "7" = true
isDigit "8" = true
isDigit "9" = true
isDigit _ = false

splitListItem
  :: String
  -> L.List String
  -> { listType :: ListType
     , listItemLines :: L.List String
     , otherLines :: L.List String
     }
splitListItem s ss =
  let
    s1 = removeNonIndentingSpaces s
    sp = L.span (isIndentedTo indent) ss
    indent = listItemIndent s1
    listItemLines = L.Cons (S.drop indent s1) $ map (S.drop indent) sp.init
    listType = listItemType s1
  in
    { listType: listType
    , listItemLines: listItemLines
    , otherLines: sp.rest
    }

isIndentedTo :: Int -> String -> Boolean
isIndentedTo n s = countLeadingSpaces s >= n

listItemIndent :: String -> Int
listItemIndent s
  | isBulleted s = 1 + min 4 (countLeadingSpaces (S.drop 1 s))
  | otherwise =
      let
        n = S.countPrefix (isDigit <<< S.singleton) s
      in
        n + 1 + min 4 (countLeadingSpaces (S.drop (n + 1) s))

listItemType :: String -> ListType
listItemType s
  | isBulleted s = Bullet (S.take 1 s)
  | otherwise =
      let
        n = S.countPrefix (isDigit <<< S.singleton) s
      in
        Ordered (S.take 1 (S.drop n s))

isIndentedChunk :: String -> Boolean
isIndentedChunk s = isIndentedTo 4 s

fromIndentedChunk :: String -> String
fromIndentedChunk = S.drop 4

splitIndentedChunks
  :: L.List String
  -> { codeLines :: L.List String
     , otherLines :: L.List String
     }
splitIndentedChunks ss =
  let
    sp = L.span isIndentedChunk ss
    codeLines = map fromIndentedChunk sp.init
  in
    { codeLines: codeLines
    , otherLines: sp.rest
    }

isCodeFence :: String -> Boolean
isCodeFence s = isSimpleFence s || (isEvaluatedCode s && isSimpleFence (S.drop 1 s))
  where
  isSimpleFence s' = S.countPrefix (isFenceChar <<< S.singleton) s' >= 3

isEvaluatedCode :: String -> Boolean
isEvaluatedCode s = S.take 1 s == "!"

isFenceChar :: String -> Boolean
isFenceChar "~" = true
isFenceChar "`" = true
isFenceChar _ = false

codeFenceInfo :: String -> String
codeFenceInfo = S.trim <<< S.dropWhile (isFenceChar <<< S.singleton)

codeFenceChar :: String -> String
codeFenceChar = S.take 1

splitCodeFence
  :: Int
  -> String
  -> L.List String
  -> { codeLines :: L.List String
     , otherLines :: L.List String
     }
splitCodeFence indent fence ss =
  let
    sp = L.span (not <<< isClosingFence) ss
    codeLines = map removeIndentTo sp.init
  in
    { codeLines: codeLines
    , otherLines: L.drop 1 sp.rest
    }
  where
  isClosingFence :: String -> Boolean
  isClosingFence s = S.countPrefix (\c -> S.singleton c == fence) (removeNonIndentingSpaces s) >= 3

  removeIndentTo :: String -> String
  removeIndentTo s = S.drop (min indent (countLeadingSpaces s)) s

isLinkReference :: String -> Boolean
isLinkReference s = S.take 1 s == "[" && M.isJust (Ref.parseLinkReference s)

min :: forall a. (Ord a) => a -> a -> a
min n m = if n < m then n else m

isTextContainer :: Container -> Boolean
isTextContainer (CText _) = true
isTextContainer _ = false

getCText :: Container -> String
getCText (CText s) = s
getCText _ = ""

isListItem :: ListType -> Container -> Boolean
isListItem lt1 (CListItem lt2 _) = lt1 == lt2
isListItem _ _ = false

getCListItem :: Container -> L.List Container
getCListItem (CListItem _ cs) = cs
getCListItem _ = L.Nil