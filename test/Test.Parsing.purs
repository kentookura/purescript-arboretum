module Test.Parsing where

import Prelude

import Data.DateTime as DT
import Data.Newtype (un)
import Data.Identity as ID
import Data.List.Types ((:), List(..))
import Data.Either (Either(..), isLeft)
import Data.Enum (toEnum)
import Data.Maybe as M
import Data.String as String
import Effect (Effect)
import Effect.Class.Console (log, logShow)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Partial.Unsafe (unsafePartial)
import Test.Unit (suite, test, failure)
import Test.Unit.Main (runTest)
import Test.Unit.Assert (assert, equal)
import Markup.Examples (raw)

import Parsing (Position(..), ParseError(..), Parser, runParser, parseErrorMessage, parseErrorPosition)
import Parsing.String (parseErrorHuman)

import Markup.Syntax
  ( Inline(..)
  , Markup(..)
  , Block(..)
  , class Pretty
  , pretty
  )

import Markup.Parser
  ( inlines
  , parseMarkup
  , P(..)
  )

import Markup.Pretty (prettyPrintMd)

--parseInline :: String -> Either String Inline
--parseInline i = inlines
--  where
--    inlines = parrse



testDocument :: Either String Markup -> Aff Unit
testDocument mkup = do
  let printed = prettyPrintMd <$> mkup
      parsed = printed >>= parseMarkup
  --log
  --  $ " Original:\n" 
  --  <> show mkup 
  --  <> "Printed:\n"  
  --  <> show printed 
  --  <> "Parsed:\n" 
  --  <> show parsed
  logShow parsed
  equal parsed mkup

failDocument :: Either String Markup -> Aff Unit
failDocument sd = assert "fails" (isLeft sd)

main :: Effect Unit
main = runTest do
  suite "Obtaining Inlines" do
    test "Header" do
      let expected = (Right 
          (Markup 
            (Header 1 (Str "Parse" : Space : Str "this" : Space : Str "Header!" : Nil):Nil
            )
          )
        ) 
      equal expected (parseMarkup "# Parse this Header!") 
      logShow $ (pretty <$> expected)
    test "Paragraph" do
      let expected = (Right 
          (Markup 
            (Paragraph (Str "Parse" : Space : Str "this" : Space : Str "Paragraph" : Nil):Nil
            )
          )
        ) 
      equal expected (parseMarkup "Parse this Paragraph") 
      logShow $ (pretty <$> expected)
    test "Math" do
      let expected = (Right 
          (Markup 
            (Paragraph (Math ("asdf"):Nil):Nil
            )
          )
        ) 
      equal expected (parseMarkup "$asdf$") 
      logShow $ (pretty <$> expected)
    test "Examples" do
      logShow $ parseMarkup raw
  suite "fromRepo" do
    test "" do
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

    test "Headers" do
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

    test "Rule" do
      testDocument $
        parseMarkup
          "Rule:\n\
          \\n\
          \-----"

    test "Blockquote" do
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

    test "Lists" do
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

    test "Code" do
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
unsafeDate y m d = unsafePartial $ M.fromJust $ join $ DT.exactDate <$> toEnum y <*> toEnum m <*> toEnum d

unsafeTime :: Int -> Int -> Int -> DT.Time
unsafeTime h m s = unsafePartial $ M.fromJust $ DT.Time <$> toEnum h <*> toEnum m <*> toEnum s <*> toEnum bottom