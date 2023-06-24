module Pages.Courses where

import Data.Tuple.Nested ((/\))
import Deku.Control (text_)
import Deku.Core (Nut)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Hooks (useState)

courses :: Nut
courses = D.div_ [ text_ "Courses" ]