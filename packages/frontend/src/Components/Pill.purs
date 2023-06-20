module Components.Pill where

import Prelude
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Core (Nut)
import Deku.DOM as D
import Deku.Control (text_)

pill :: String -> Nut
pill s = D.span
  [ klass_ "ml-auto w-9 min-w-max whitespace-nowrap rounded-full bg-gray-900 px-2.5 py-0.5 text-center text-xs font-medium leading-5 text-white ring-1 ring-inset ring-gray-700"
  ]
  [ text_ s ]