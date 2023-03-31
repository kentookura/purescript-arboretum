module Markup.Pretty 
  ( prettyPrintMd
  ) where

import Prelude

import Data.Array as A
import Data.DateTime as DT
import Data.Foldable (fold, elem)
import Data.Functor.Compose (Compose)
import Data.HugeNum as HN
import Data.Identity (Identity(..))
import Data.List as L
import Data.Maybe as M
import Data.Enum (fromEnum)
import Data.Newtype (unwrap)
import Data.String (Pattern(..), indexOf, joinWith, length, split, stripSuffix) as S
import Data.String.CodeUnits (fromCharArray) as S
import Data.Unfoldable as U

import Markup.Syntax (Markup(..), Inline(..), Block(..), ListType(..), LinkTarget(..), CodeBlockType(..))

unlines :: L.List String -> String
unlines lst = S.joinWith "\n" $ A.fromFoldable lst

prettyPrintMd :: Markup -> String
prettyPrintMd (Markup bs) = unlines $ L.concatMap prettyPrintBlock bs

replicateS :: Int -> String -> String
replicateS n s = fold (const s <$> (1 L... n))

indent :: Int -> String -> String
indent n s = replicateS n " " <> s

overLines :: (String -> String) -> L.List String -> L.List String
overLines f = map f <<< L.concatMap lines

lines :: String -> L.List String
lines "" = mempty
lines s = L.fromFoldable $ S.split (S.Pattern "\n") s

prettyPrintBlock :: Block -> L.List String
prettyPrintBlock bl =
  case bl of
    Paragraph is -> L.Cons (prettyPrintInlines is) (L.Cons "" L.Nil)
    Header n is -> L.singleton (replicateS n "#" <> " " <> prettyPrintInlines is)
    Blockquote bs -> overLines ((<>) "> ") (L.concatMap prettyPrintBlock bs)
    Lst lt bss ->
      let
        addMarker :: L.List String -> L.List String
        addMarker L.Nil = L.Nil
        addMarker (L.Cons s ss) =
          let
            m = prettyPrintMarker lt
            len = S.length m
          in
            L.Cons (m <> " " <> s) $ overLines (indent (len + 1)) ss

        prettyPrintMarker :: ListType -> String
        prettyPrintMarker (Bullet s) = s
        prettyPrintMarker (Ordered s) = "1" <> s

        listItem :: L.List Block -> L.List String
        listItem = addMarker <<< L.concatMap lines <<< L.concatMap prettyPrintBlock
      in
        L.concatMap listItem bss
    CodeBlock ct ss ->
      case ct of
        Indented -> indent 4 <$> ss
        Fenced eval info ->
          let
            bang
              | eval = "!"
              | otherwise = ""
          in
            L.singleton (bang <> "```" <> info) <> ss <> L.singleton "```"
    LinkReference l url -> L.singleton $ squares l <> ": " <> url
    Rule -> L.singleton "***"

prettyPrintInlines :: L.List Inline -> String
prettyPrintInlines is = S.joinWith "" $ A.fromFoldable $ (map prettyPrintInline is)

prettyPrintInline :: Inline -> String
prettyPrintInline il =
  case il of
    Str s -> s
    --Entity s -> s
    Space -> " "
    SoftBreak -> "\n"
    LineBreak -> "  \n"
    Emph is -> "*" <> prettyPrintInlines is <> "*"
    Strong is -> "**" <> prettyPrintInlines is <> "**"
    Code e s ->
      let
        bang = if e then "!" else ""
      in
        bang <> "`" <> s <> "`"
    Link is tgt -> "[" <> prettyPrintInlines is <> "]" <> printTarget tgt
    --Image is url -> "![" <> prettyPrintInlines is <> "](" <> url <> ")"
    --FormField l r e ->
    --  let
    --    star = if r then "*" else" "
    --  in
    --    esc l <> star <> " = " <> prettyPrintFormElement e
    where
      esc s = M.maybe s (const $ "[" <> s <> "]") $ S.indexOf (S.Pattern " ") s
      printTarget :: LinkTarget -> String
      printTarget (InlineLink url) = parens url
      printTarget (ReferenceLink tgt) = squares (M.fromMaybe "" tgt)


prettyPrintDate :: DT.Date -> String
prettyPrintDate d =
  printIntPadded 4 (fromEnum $ DT.year d)
    <> "-"
    <> printIntPadded 2 (fromEnum $ DT.month d)
    <> "-"
    <> printIntPadded 2 (fromEnum $ DT.day d)

printIntPadded :: Int -> Int -> String
printIntPadded l i =
  if dl > 0
  then S.fromCharArray (U.replicate dl '0') <> s
  else s
  where
    s = show i
    dl = l - S.length s

parens :: String -> String
parens s = "(" <> s <> ")"

braces :: String -> String
braces s = "{" <> s <> "}"

squares :: String -> String
squares s = "[" <> s <> "]"