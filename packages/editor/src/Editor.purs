module Editor
  ( editor
  , edit
  , view
  , class Editable
  ) where

import Prelude

import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=), cb)
import Deku.Control (text_, (<$~>))
import Deku.Core (Nut)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useState)
import Deku.Listeners (keyDown)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Class.Console (logShow, log)
import Editor.Keyboard (Key, keyAction)
import Web.Event.Event (preventDefault)
import Web.UIEvent.KeyboardEvent (toEvent)

class Editable a where
  view :: a -> Nut
  edit :: Key -> a -> a

editor :: forall a. Editable a => a -> Nut
editor a = Deku.do
  setZipper /\ zipper <- useState a
  D.div_
    [ D.pre
        [ D.Class !:= "editor"
        , D.Contenteditable !:= "true"
        , D.OnAuxclick !:= cb \e -> do
            preventDefault e
            log "TODO: Wire up context menu"
        , keyDown $ zipper <#>
            ( \z -> \event -> do
                setZipper (edit (keyAction event) z)
            )
        --, D.OnClick
        ]
        [ view <$~> zipper
        ]
    ]
