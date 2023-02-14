module Lib where

import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Prelude

pipeForwards :: forall a b. a -> (a -> b) -> b
pipeForwards x f = f x

infixl 1 pipeForwards as |>

css :: forall r i. String -> HH.IProp (class :: String | r) i
css = HP.class_ <<< HH.ClassName
