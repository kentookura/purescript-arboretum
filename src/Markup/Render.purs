module Markup.Render
  ( renderMarkup
  , renderMarkup_
  , renderTheorem
  ) where

import Prelude
import Data.Array as A
import Data.Either (Either(..))
import Data.List (List)
import Data.Foldable (foldl)
import Data.Tuple.Nested ((/\))
import Markup.Syntax (Markup(..), Block(..), Inline(..), LinkTarget(..), ListType(..))
import Markup.Parser (parseMarkup)
import Deku.Attributes (href, klass_)
import Deku.Core (Nut)
import Deku.Control (text_, blank, guard, (<#~>))
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Hooks (useState)
import Deku.Listeners (click)
import Parsing (parseErrorMessage)
import Markup.Contracts (Theorem(..))
import Markup.Math (inline)
import Markup.Katex (defaultOptions)
import QualifiedDo.Alt as Alt

renderInline :: Inline -> Nut
renderInline =
  case _ of
    Str s -> text_ s
    Space -> text_ " "
    LineBreak -> D.br_ []
    SoftBreak -> D.br_ []
    Emph is -> D.i_ $ A.fromFoldable (map renderInline is)
    Strong is -> D.strong_ $ A.fromFoldable (map renderInline is)
    Code bool str -> D.code_ [ text_ str ]
    Link is (InlineLink tgt) -> D.a [href (pure tgt)] $ A.fromFoldable (map renderInline is)
    Link is (ReferenceLink tgt) -> D.a_ $ A.fromFoldable (map renderInline is)
    Math s -> inline defaultOptions s

renderBlock :: Block -> Nut
renderBlock =
  case _ of
    Paragraph is -> D.div_ $ A.fromFoldable (map renderInline is)
    Header lvl is ->
      let
        h
          | lvl == 1 = D.h1_
          | lvl == 2 = D.h2_
          | lvl == 3 = D.h3_
          | lvl == 4 = D.h4_
          | lvl == 5 = D.h5_
          | otherwise = D.h2_
      in
        h $ A.fromFoldable (map renderInline is)

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
renderListBlock bs = D.li_ [ foldl ((<>)) blank (map renderBlock bs) ]

renderMarkup_ :: Markup -> Nut
renderMarkup_ (Markup bs) = D.div_ $ A.fromFoldable (map renderBlock bs)

renderMarkup :: String -> Nut
renderMarkup mkup = case parseMarkup mkup of
  Right m -> renderMarkup_ m
  Left c -> text_ $ parseErrorMessage c

renderTheorem :: forall r. { title :: String, statement :: Nut, proof :: Nut | r } -> Nut
renderTheorem t = Deku.do
  setVisible /\ visible <- useState false
  D.div_
    [ D.h2_ $ [ text_ t.title ]
    , t.statement
    , D.a
        [ klass_ "cursor-pointer"
        , click $ visible <#> not >>> setVisible
        ]
        [ text_ "toggle theorem" ]
    , D.div_
        [ visible <#~>
            if _ then
              t.proof
            else
              blank
        ]
    ]