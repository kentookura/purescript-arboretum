module Markup.Render
  ( renderMarkup
  , renderMarkup_
  , renderTheorem
  )
  where

import Prelude
import Data.Array as A
import Data.Either (Either(..))
import Data.List (List)
import Data.String as S
import Data.Foldable (foldl)
import Markup.Syntax (Markup(..), Block(..), Inline(..), ListType(..))
import Markup.Parser (parseMarkup)
import Markup.Pretty (prettyPrintMd)
import Deku.Core (Nut, Domable)
import Deku.Control (text_, blank)
import Deku.DOM as D
import Parsing (runParser)
import Markup.Contracts (Theorem(..), theorem)
import Markup.Math (inline)
import Markup.Katex (defaultOptions)


renderInline :: Inline -> Nut
renderInline = 
  case _ of
    Str s -> text_ s
    Space -> text_ " "
    LineBreak -> D.br_ []
    SoftBreak -> D.br_ []
    Emph is -> D.i_ $ A.fromFoldable (map renderInline is)
    Strong is -> D.strong_ $ A.fromFoldable (map renderInline is)
    Code bool str -> D.code_ [text_ str]
    Link is tgt -> D.a_ $ A.fromFoldable (map renderInline is)
    Math s -> inline defaultOptions s

renderBlock :: Block -> Nut
renderBlock = 
  case _ of
    Paragraph is -> D.div_ $ A.fromFoldable (map renderInline is)
    Header lvl is -> D.h3_ $ A.fromFoldable (map renderInline is)
    Blockquote bs -> D.blockquote_ $ A.fromFoldable (map renderBlock bs)
    Lst listType listElems -> case listType of
      Bullet s ->
        D.ul_ $ A.fromFoldable (map renderListBlock listElems)
      Ordered s ->
        D.ol_ $ A.fromFoldable (map renderListBlock listElems)

    CodeBlock blockType lines -> D.code_ $ A.fromFoldable (map text_ lines)
    LinkReference s1 s2 -> blank
    Rule -> D.br_ [] 

renderListBlock :: List Block -> Nut
renderListBlock bs = D.li_ [foldl ((<>)) blank (map renderBlock bs)]

renderMarkup_ :: Markup -> Nut
renderMarkup_ (Markup bs) = D.div_ $ A.fromFoldable (map renderBlock bs)

renderMarkup :: String -> Nut
renderMarkup mkup = case parseMarkup mkup of
  Right m -> renderMarkup_ m
  Left c -> text_ ("parse error: " <> c)

renderTheorem :: forall lock payload. Theorem lock payload -> Domable lock payload
renderTheorem (Theorem t) =
  D.div_ 
    [ D.h2_ $ [text_ t.title]
    , t.statement
    , t.proof 
    ]