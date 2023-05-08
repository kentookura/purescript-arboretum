module String where

import Prelude

main :: Effect Unit
main = do
  runInBody Deku.do
    D.div
      []
      [ text_ "Click below to start editing:"
      , editor (StringZipper " olleH" "World!")
      , text_ ""
      ]