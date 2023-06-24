module Components.MarkdownDemo where

import Prelude

import Components.Icon as Icon
import Data.Either (Either(..))
import Data.Foldable (for_, traverse_)
import Data.Tuple (curry, Tuple(..), fst, snd, uncurry)
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Control (text_, text, (<#~>), (<$~>), blank)
import Deku.Core (Nut, envy)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Hooks (useState, useState', useHot', useDynAtBeginning, useEffect)
import Deku.Listeners (click, click_, keyUp)
import Deku.Toplevel (runInBody)
import Effect.Class.Console (logShow)
import FRP.Event.Class ((<**|>), (<|*>), (<*|>))
import Text.Markdown.SlamDown.Parser (parseMd)
import Text.Markdown.SlamDown.Render (renderMd, renderMdFromString)
import Text.Markdown.SlamDown.Syntax (SlamDownP)
import Web.Event.Event (target)
import Web.HTML.HTMLInputElement (fromEventTarget, value)
import Web.UIEvent.KeyboardEvent (code, toEvent)

formulas :: Nut
formulas = Deku.do
  setInput /\ input <- useHot'
  setItem /\ item <- useState'
  setRemoveAll /\ removeAll <- useState'
  setPos /\ pos <- useState 0
  let
    parsed e = do
      v <- value e
      case (parseMd v :: Either String (SlamDownP String)) of
        Left parseError -> pure unit
        Right markup -> do
          logShow markup
          setItem markup
  D.div
    []
    [ D.input
        [ D.Value !:= ""
        , keyUp $ pure \evt -> do
            when (code evt == "Enter") $
              for_
                ((target >=> fromEventTarget) (toEvent evt))
                parsed
        , D.SelfT !:= setInput
        ]
        []
    , D.button
        [ click $ input <#> parsed
        ]
        [ text_ "Add" ]
    , D.div_
        [ D.button [ click_ (setRemoveAll unit) ]
            [ text_ "Clear Workspace" ]
        , D.div []
            [ Deku.do
                { value: t } <- useDynAtBeginning item
                --useEffect removeAll (const remove)
                D.div_
                  [ D.article [] [ renderMd t ]
                  ]

            ]
        ]
    ]