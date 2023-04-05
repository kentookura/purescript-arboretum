module Markup.Editor
  ( editor
  , main
  )
  where

import Prelude
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Data.String (take, length)
import Deku.Attribute ((!:=))
import Deku.Core (Nut)
import Deku.Control (text)
import Deku.Listeners (keyDown)
import Deku.Hooks (useState)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Toplevel (runInBody)
import FRP.Event (Event)
import Effect (Effect)
import QualifiedDo.Alt as Alt
import Web.UIEvent.KeyboardEvent (KeyboardEvent, key, shiftKey, ctrlKey )

type State = String

data Edit
  = Insert String 
  | Backspace
  | Header
  | NoOp
  
keyAction :: KeyboardEvent -> Edit
keyAction e
  | (key e == "backspace") = Backspace
  | (key e == "#") = Header
  | not (shiftKey e || ctrlKey e) = NoOp
  | otherwise = NoOp

--keyEffect :: KeyboardEvent -> String
--keyEffect e = e 
--
--setState :: String -> Effect Unit


editor :: Nut
editor = Deku.do
  (setState /\ state :: Tuple (String -> Effect Unit)
                        (Event String))
                        <- useState "Hello World"
  D.div
    (Alt.do
      D.Contenteditable !:= "true"
      keyDown $ state <#> (\currentString -> 
        \event -> case keyAction event of
          NoOp -> pure unit
          Insert doIt -> setState (currentString <> doIt)
          Backspace -> setState (take ((length currentString) - 1) currentString)
          Header -> setState "Header"

        --(\v -> setState v) <$> ((edit (toEditEvent evt)) <$> (state :: Event String))
        --setState <$> (pure (updateContent <$> state) <|**>(toEditEvent evt))
        --setState newContent

      )
    )
    [ text state
    ]

main :: Effect Unit
main = do
  runInBody Deku.do
    editor 


--data BlockTypes = MarkupBlocks | Custom String
--type Spec = { blocks :: Array BlockTypes}
--type Config = {spec :: Spec}
--type Editor = { content :: Markup }
--
--isInputCode  :: String -> Boolean
--isInputCode = case _ of
--  "a" -> true
--  "b" -> true
--  _ -> false
--
--data Edit
--  = Insert String 
--  | Backspace
--  | Undefined
--
--toEditEvent :: KeyboardEvent -> Edit
--toEditEvent e 
--  | key e == "backspace" = Backspace
--  | not (shiftKey e || ctrlKey e) = Undefined
--  | otherwise = Undefined
--
--updateContent :: Editor -> Edit -> Editor
--updateContent e k = e
--
--editor :: Config -> Editor -> Nut
--editor cfg init = Deku.do
--  setState /\ state <- useState init
-- -- toCommand e do
-- --   v <- value e
-- --   case v of
--  D.div_
--    [ D.div
--        (Alt.do
--          D.Contenteditable !:= "true"
--        -- keyDown $ pure \evt -> do
--        --   state <#> \{set -> updateContent s (toEditEvent evt)
--        )
--        []
--    ,  D.div_
--        [ D.div__ "rendered"
--        , state <#~> (renderMarkup_ <<<  _.content )
--        , D.div__ "debug"
--        , state <#~> (text_ <<< pretty <<< _.content)
--        ]
--    ]
--
--main :: Effect Unit
--main = do
--  { push, event } <- create
--  runInBody Deku.do
--    editor {spec : {blocks : []}} { content : Markup Nil}