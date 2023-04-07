module Test.Parsing where

import Prelude

import Data.DateTime as DT
import Data.Either (Either(..), isLeft)
import Data.Enum (toEnum)
import Data.List (List(..), (:))
import Data.Maybe (fromJust)
import Data.String (replaceAll)
import Data.String.Pattern (Pattern(..), Replacement(..))
import Data.Unfoldable (replicate)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class.Console (logShow)
import Partial.Unsafe (unsafePartial)
import Test.Unit (suite, it)
import Test.Unit.Main (runTest)
import Test.Unit.Assert (assert, assertFalse, equal)

import Parsing (ParseError)

import Markup.Syntax
  ( Inline(..)
  , Markup(..)
  , Block(..)
  , LinkTarget(..)
  , ListType(..)
  , CodeBlockType(..)
  , consolidate
  )

import Markup.Parser
  ( parseMarkup
  , Container(..)
  , someOf
  , allChars
  , isSpace
  , tabsToSpaces
  , isATXHeader
  , removeNonIndentingSpaces
  , splitATXHeader
  , isSetextHeader
  , setextLevel
  , isRule 
  , isRuleChar
  , isBlockquoteLine
  , splitBlockquote
  , isListItemLine
  , isBulleted
  , isOrderedListMarker
  , splitListItem
  , listItemIndent
  , listItemType
  , isIndentedChunk
  , fromIndentedChunk
  , splitIndentedChunks
  , isCodeFence
  , isEvaluatedCode
  , isFenceChar
  , codeFenceInfo
  , codeFenceChar
  , splitCodeFence
  , isLinkReference
  )

import Markup.Pretty (prettyPrintMd)

--parseInline :: String -> Either String Inline
--parseInline i = inlines
--  where
--    inlines = parrse

testDocument :: Either ParseError Markup -> Aff Unit
testDocument mkup = do
  let
    printed = prettyPrintMd <$> mkup
    parsed = printed >>= parseMarkup
  equal parsed mkup

failDocument :: Either String Markup -> Aff Unit
failDocument sd = assert "fails" (isLeft sd)

main :: Effect Unit
main = runTest do
  suite "low level components" do
    it "should get list types" do
      equal (listItemType "1. My List Item") (Ordered ".")
      equal (listItemType "* My List Item") (Bullet "*")
      equal (listItemType "* My List Item") (Bullet "*")
    it "should match codefences" do
      assert "`isCodeFence` didn't match triple backticks" (isCodeFence "``` asdfsadfa")
      assertFalse "`isCodeFence` matched backtickless string" (isCodeFence "asdfsadfa")
    it "should count header depth" do
      assert "" (isATXHeader "# Title 1 ")
      assertFalse "" (isATXHeader "####### Too Deep")
    it "should remove non indenting spaces" do
      let s = "Three spaces gets removed"
          t = "    Four spaces aren't removed"
      equal (removeNonIndentingSpaces "   " <> s) s
      equal (removeNonIndentingSpaces t) t
    it "should split headers and determine depth" do
      let h1 = "# asdfsadf"
          h2 = "## asdfsadf"
          h3 = "### asdfsadf"
      equal (_.contents $ splitATXHeader h1) "asdfsadf"
      equal (_.contents $ splitATXHeader h2) "asdfsadf"
      equal (_.contents $ splitATXHeader h3) "asdfsadf"
      equal (_.level $ splitATXHeader h1) 1
      equal (_.level $ splitATXHeader h2) 2
      equal (_.level $ splitATXHeader h3) 3
    {-
    it "what are ext headers here?" do
      assert "" (isSetextHeader "==" (Just (CText "content ==")))
      assert "" (isSetextHeader "--" (Just (CText "content ==")))
      assert "" (isSetextHeader "--" (Just (CText "= content")))
      assert "" (isSetextHeader "" (Just (CText "asdfinapawj")))
    -}
    it "should match rules" do
      assert "" (isRule "******")
      assert "" (isRule "---")
      assertFalse "" (isRule "---x")
      assertFalse "" (isRule "--x")
    it "should split blockquotes" do
      pure unit
      -- (_.blockquoteLines <<< splitBlockquote) $ replicate 3 "> Block quote!\n"
    it "should recognize lists" do
      assert "via *" $ isListItemLine "* list item"
      assert "via +" $ isListItemLine "+ list item"
      assert "via -" $ isListItemLine "- list item"
      assert "ordered list" $ isOrderedListMarker "1)"
      --assert "via )" $ isListItemLine "1 ) list item"
      --assert "via ." $ isListItemLine "2. list item"
      --assertFalse "" $ isListItemLine "asdf"
      --assert "indented" $ isListItemLine "    - list item"
    
  suite "Obtaining Inlines" do
    it "should consolidate strings" do
      let expected = Str "Parse this string with spaces" : Nil
      equal expected (consolidate (Str "Parse" : Space : Str "this" : Space : Str "string" : Space : Str "with" : Space : Str "spaces" : Nil))
    it "should parse paragraphs" do
      let
        expected =
          ( Right
              ( Markup
                  (Paragraph ((Str "Parse this Paragraph") : Nil) : Nil)
              )
          )
      equal expected (parseMarkup "Parse this Paragraph")
  suite "parsing blocks" do
    it "should handle soft breaks" do
      let softBreaks = Right (Markup (Paragraph ((Str "asdf"):SoftBreak:(Str "asdf"):Nil):Nil))
      equal softBreaks (parseMarkup (replaceAll (Pattern "x") (Replacement "asdf") """
x
x

      """))
    it "handle multiple paragraphs" do
      let
        threeParagraphs =
          ( Right
            (Markup (replicate 3 (Paragraph ((Str lorem):Nil)))
            )
          )
      equal threeParagraphs (parseMarkup (replaceAll (Pattern "x") (Replacement lorem) """
x

x

x"""))
    it "Math" do
      let
        expected =
          ( Right
              ( Markup
                  ( Paragraph (Math ("asdf") : Nil) : Nil
                  )
              )
          )
      equal expected (parseMarkup "$asdf$")
    it "Emph" do
      let
        expected =
          ( Right
              ( Markup
                  ( Paragraph (Strong ((Str "emphasized") : Nil) : Nil) : Nil
                  )
              )
          )
      equal expected (parseMarkup "**emphasized**")
      equal expected (parseMarkup "__emphasized__")
    it "StrongEmph" do
      let
        expected =
          ( Right
              ( Markup
                  ( Paragraph (Strong (Emph ((Str "emphasized") : Nil) : Nil) : Nil) : Nil
                  )
              )
          )
      equal expected (parseMarkup "***emphasized***")
      equal expected (parseMarkup "___emphasized___")
    it "Link" do
      let
        expected =
          ( Right
              ( Markup
                  ( Paragraph ((Link ((Str "link") : Nil)) (InlineLink "http://purescript.org") : Nil) : Nil
                  )
              )
          )
      equal expected (parseMarkup "[link](http://purescript.org)")
    it "Image" do
      let
        expected =
          ( Right
              ( Markup
                  ( Paragraph ((Str "Paragraph with an "):(Link (Str "image":Nil)) (InlineLink "image.png"):Nil):Nil
                  )
              )
          )
      equal expected (parseMarkup "Paragraph with an ![image](image.png)")
    it "code" do
      let
        expected =
          ( Right
              ( Markup
                  ( Paragraph ((Code false "inline code"):Nil):Nil
                  )
              )
          )
      equal expected (parseMarkup "`inline code`")
  suite "Blocks" do
    it "Blocks" do
      let blank = ( Right (Markup (Paragraph ((Str ""):Nil):Nil)))
      let header = ( Right (Markup (Header 1 (((Str ""):Nil)):Nil)))
      let block = ( Right (Markup (Blockquote (Paragraph ((Str "Here is some text":SoftBreak:(Str "inside a blockquote"):Nil)):Nil):Nil)))
      let bullet = ( Right (Markup (Lst (Bullet "*") ((Paragraph ((Str "example"):Nil):Nil):Nil):Nil)))
      let ordered = ( Right (Markup (Lst (Ordered ".") ((Paragraph ((Str ""):Nil):Nil):Nil):Nil)))
      let codeBlock = (Right (Markup (CodeBlock Indented ("":Nil):Nil)))
      equal block (parseMarkup """
> Here is some text
> inside a blockquote
      """)
      equal bullet (parseMarkup """
* example
      """)
--      equal ordered (parseMarkup """
--1. bulleted
--2. list
--3. example
      --""")
      equal codeBlock (parseMarkup """
```
codeblock

import asdf

let x = y in z
```
      """)
      equal header (parseMarkup """
      """)

  suite "from original slamdown repo" do
    it "" do
      testDocument $ parseMarkup "Paragraph"
      testDocument $ parseMarkup "Paragraph with spaces"
      testDocument $ parseMarkup "Paragraph with an entity: &copy;"
      testDocument $ parseMarkup "Paragraph with a [link](http://purescript.org)"
      testDocument $ parseMarkup "Paragraph with an ![image](image.png)"
      testDocument $ parseMarkup "Paragraph with some `embedded code`"
      testDocument $ parseMarkup "Paragraph with some !`code which can be evaluated`"
      testDocument $ parseMarkup "Paragraph with _emphasis_"
      testDocument $ parseMarkup "Paragraph with _emphasis_ and __strong text__"

      testDocument $
        parseMarkup
          "Paragraph with a\n\
          \soft break"

      testDocument $
        parseMarkup
          "Paragraph with a  \n\
          \line break"

      testDocument $
        parseMarkup
          "Two\n\
          \\n\
          \paragraphs"

    it "Headers" do
      testDocument $
        parseMarkup
          "Header\n\
          \==="

      testDocument $
        parseMarkup
          "# Header\n\
          \\n\
          \Paragraph text"

      testDocument $
        parseMarkup
          "## Header\n\
          \\n\
          \Paragraph text"

      testDocument $
        parseMarkup
          "### Header\n\
          \\n\
          \Paragraph text"

      testDocument $
        parseMarkup
          "#### Header\n\
          \\n\
          \Paragraph text"

      testDocument $
        parseMarkup
          "##### Header\n\
          \\n\
          \Paragraph text"

      testDocument $
        parseMarkup
          "###### Header\n\
          \\n\
          \Paragraph text"

    it "Rule" do
      testDocument $
        parseMarkup
          "Rule:\n\
          \\n\
          \-----"

    it "Blockquote" do
      testDocument $
        parseMarkup
          "A blockquote:\n\
          \\n\
          \> Here is some text\n\
          \> inside a blockquote"

      testDocument $
        parseMarkup
          "A nested blockquote:\n\
          \\n\
          \> Here is some text\n\
          \> > Here is some more text"

    it "Lists" do
      testDocument $
        parseMarkup
          "An unordered list:\n\
          \\n\
          \* Item 1\n\
          \* Item 2"

      testDocument $
        parseMarkup
          "An ordered list:\n\
          \\n\
          \1. Item 1\n\
          \1. Item 2"

      testDocument $
        parseMarkup
          "A nested list:\n\
          \\n\
          \1. Item 1\n\
          \1. 1. Item 2\n\
          \   1. Item 3"

    it "Code" do
      testDocument $
        parseMarkup
          "Some indented code:\n\
          \\n\
          \    import Debug.Log\n\
          \    \n\
          \    main = log \"Hello World\""

      testDocument $
        parseMarkup
          "Some fenced code:\n\
          \\n\
          \```purescript\n\
          \import Debug.Log\n\
          \\n\
          \main = log \"Hello World\"\n\
          \```"

      testDocument $
        parseMarkup
          "Some fenced code which can be evaluated:\n\
          \\n\
          \!~~~purescript\n\
          \import Debug.Log\n\
          \\n\
          \main = log \"Hello World\"\n\
          \~~~"

      let
        probablyParsedCodeForEvaluation =
          parseMarkup
            "Some evaluated fenced code:\n\
            \\n\
            \!~~~purescript\n\
            \import Debug.Log\n\
            \\n\
            \main = log \"Hello World\"\n\
            \~~~"

      --testDocument
      --  case probablyParsedCodeForEvaluation of
      --    Right sd ->
      --      Right
      --        $ un ID.Identity
      --        $ SDE.eval
      --          { code: \_ _ -> pure $ SD.stringValue "Evaluated code block!"
      --          , textBox: \_ t ->
      --              case t of
      --                SD.PlainText _ -> pure $ SD.PlainText $ pure "Evaluated plain text!"
      --                SD.Numeric _ -> pure $ SD.Numeric $ pure $ HN.fromNumber 42.0
      --                SD.Date _ -> pure $ SD.Date $ pure $ unsafeDate 1992 7 30
      --                SD.Time (prec@SD.Minutes) _ -> pure $ SD.Time prec $ pure $ unsafeTime 4 52 0
      --                SD.Time (prec@SD.Seconds) _ -> pure $ SD.Time prec $ pure $ unsafeTime 4 52 10
      --                SD.DateTime (prec@SD.Minutes) _ ->
      --                  pure $ SD.DateTime prec $ pure $
      --                    DT.DateTime (unsafeDate 1992 7 30) (unsafeTime 4 52 0)
      --                SD.DateTime (prec@SD.Seconds) _ ->
      --                  pure $ SD.DateTime prec $ pure $
      --                    DT.DateTime (unsafeDate 1992 7 30) (unsafeTime 4 52 10)
      --          , value: \_ _ -> pure $ SD.stringValue "Evaluated value!"
      --          , list: \_ _ -> pure $ L.singleton $ SD.stringValue "Evaluated list!"
      --          }  sd
      --    a -> a

      --      testDocument $ parseMarkup "name = __ (Phil Freeman)"
      --      testDocument $ parseMarkup "name = __ (!`name`)"
      --      testDocument $ parseMarkup "sex* = (x) male () female () other"
      --      testDocument $ parseMarkup "sex* = (!`def`) !`others`"
      --      testDocument $ parseMarkup "city = {BOS, SFO, NYC} (NYC)"
      --      testDocument $ parseMarkup "city = {!`...`} (!`...`)"
      --      testDocument $ parseMarkup "phones = [] Android [x] iPhone [x] Blackberry"
      --      testDocument $ parseMarkup "phones = [!`...`] !`...`"
      --      testDocument $ parseMarkup "start = __ - __ - ____ (06-06-2015)"
      --      testDocument $ parseMarkup "start = __ - __ - ____ (!`...`)"
      --      testDocument $ parseMarkup "start = __ : __ (10:32 PM)"
      --      failDocument $ parseMarkup "start = __ : __ (10:32:46 PM)"
      --      failDocument $ parseMarkup "start = __ : __ : __ (10:32 PM)"
      --      testDocument $ parseMarkup "start = __ : __ : __ (10:32:46 PM)"
      --      testDocument $ parseMarkup "start = __ : __ (!`...`)"
      --      testDocument $ parseMarkup "start = __-__-____ __:__ (06-06-2015 12:00 PM)"
      --      testDocument $ parseMarkup "start = __ - __ - ____ __ : __ (!`...`)"
      --      testDocument $ parseMarkup "[zip code]* = __ (12345)"
      --      testDocument $ parseMarkup "defaultless = __"
      --      testDocument $ parseMarkup "city = {BOS, SFO, NYC}"
      --      testDocument $ parseMarkup "start = __ - __ - ____"
      --      testDocument $ parseMarkup "start = __ : __"
      --      testDocument $ parseMarkup "start = __ : __ : __"
      --      testDocument $ parseMarkup "start = __ - __ - ____ __ : __ : __"
      --      testDocument $ parseMarkup "zip* = ________"
      --      testDocument $ parseMarkup "[numeric field] = #______ (23)"
      --      testDocument $ parseMarkup "i9a0qvg8* = ______ (9a0qvg8h)"
      --      testDocument $ parseMarkup "xeiodbdy  = [x] "
      --
      logShow "All static tests passed!"

unsafeDate :: Int -> Int -> Int -> DT.Date
unsafeDate y m d = unsafePartial $ fromJust $ join $ DT.exactDate <$> toEnum y <*> toEnum m <*> toEnum d

unsafeTime :: Int -> Int -> Int -> DT.Time
unsafeTime h m s = unsafePartial $ fromJust $ DT.Time <$> toEnum h <*> toEnum m <*> toEnum s <*> toEnum bottom

lorem :: String
lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
