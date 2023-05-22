module Example.StringEditor.Main where

import Prelude
import Effect (Effect)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Control (text_)
import Deku.Toplevel (runInBody)
import Zipper.String (StringZipper(..))
import Editor (editor)

main :: Effect Unit
main = do
  runInBody Deku.do
    D.div
      []
      [ text_ "Click below to start editing:"
      , editor (StringZipper " olleH" "World!")
      , text_ "You can use the arrow keys to move the cursor. Need to figure out how to properly style the caret."
      , D.h1_ [text_ "Bugs:"]
      , D.ul_ [D.li_ [text_ "Enter to create newlines don't work"]]
      ]