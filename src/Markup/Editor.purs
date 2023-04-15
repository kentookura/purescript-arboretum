module Markup.Editor
  ( main
  ) where

import Prelude

import Data.Array (reverse)
import Data.List (List(..), (:), snoc)
import Data.String (codePointFromChar, take)
import Data.String.CodeUnits (toCharArray, fromCharArray)
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=), cb)
import Deku.Attributes (klass_)
import Deku.Control (guard, text, text_, (<$~>))
import Deku.Core (Nut)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useRef, useState, useState')
import Deku.Listeners (keyDown, keyDown_)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Class.Console (logShow, log)
import FRP.Event.Keyboard (Keyboard)
import Markup.Editable (class Editable, edit, view)
import Markup.Examples (theorems)
import Markup.Keyboard (Key(..), keyAction, showKeyboardEvent)
import Markup.Render (renderMarkup_, renderTheorem)
import Markup.Syntax (Markup(..), Block(..), Inline(..))
import Modal (modalClick)
import QualifiedDo.Alt as Alt
import Web.Event.Event (preventDefault)
import Web.Event.Internal.Types (Event)
import Web.UIEvent.KeyboardEvent (KeyboardEvent, ctrlKey, key, toEvent)
import Zipper.String (StringZipper(..), fst, snd)

editor :: forall a. Editable a => a -> Nut
editor a = Deku.do
  setZipper /\ zipper <- useState a
  D.div_
    [ D.pre
        ( Alt.do
            D.Class !:= "editor"
            D.Contenteditable !:= "true"
            D.OnAuxclick !:= cb \e -> do
              preventDefault e
              log "TODO: Wire up context menu"
            keyDown $ zipper <#>
              ( \z -> \event -> do
                  preventDefault $ toEvent event
                  logShow $ keyAction event
                  setZipper (edit (keyAction event) z)
              )
        )
        [ view <$~> zipper
        ]
    ]

main :: Effect Unit
main = do
  --window >>= navigator >>= platform >>= logShow
  runInBody Deku.do
    editor (Z " olleH" "World!")