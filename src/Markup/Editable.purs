module Markup.Editable where

import Markup.Keyboard
import Prelude

import Deku.Core (Domable, Nut)
import FRP.Event (Event)

class Editable a where
  view :: forall lock payload. a -> Domable lock payload
  edit :: Key -> a -> a