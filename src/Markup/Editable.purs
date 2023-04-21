module Markup.Editable where

import Markup.Keyboard
import Prelude

import Deku.Core (Nut)
import FRP.Event (Event)

class Editable a where
  view :: a -> Nut
  edit :: Key -> a -> a