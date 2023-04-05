module Markup.Editor
  ( editor
  , main
  )
  where

import Prelude
import Data.List (List(..), (:), snoc)
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Data.String (take, length)
import Deku.Attribute ((!:=))
import Deku.Core (Nut)
import Deku.Control (text, text_, (<#~>))
import Deku.Listeners (keyDown)
import Deku.Hooks (useState)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Toplevel (runInBody)
import FRP.Event (Event)
import Effect (Effect)
import Markup.Render (renderMarkup, renderMarkup_)
import Markup.Syntax (syntaxExample, Markup(..), Block(..), Inline(..), pretty)
import QualifiedDo.Alt as Alt
import Web.UIEvent.KeyboardEvent (toEvent, KeyboardEvent, key, code, shiftKey, ctrlKey)
import Web.Event.Event (preventDefault)

type State = String

data Key
  = SpaceKey
  | Left
  | Right
  | Up
  | Down
  | Shift 
  | Control 
  | Alt
  | Tab
  | ShiftTab
  | CapsLock
  | Escape
  | Enter
  | ShiftEnter
  | PageUp
  | PageDown
  | GoToStartOfLine
  | GoToEndOfLine
  | GoToStartOfWord
  | GoToEndOfWord
  | Undo
  | Redo
  | SelectAll
  | CommandPalette
  | Backspace
  | Unhandled String 

keyAction :: KeyboardEvent -> Key
keyAction e
  | (code e == "Space" ) = SpaceKey
  | (key e == "ArrowLeft") = Left
  | (key e == "ArrowRight") = Right
  | (key e == "ArrowUp") = Up
  | (key e == "ArrowDown") = Down
  | (key e == "Shift") = Shift 
  | (key e == "Control") = Control 
  | (key e == "Alt") = Alt
  | (key e == "Tab") = Tab
  | (key e == "Escape") = Escape
  | (key e == "Enter") = Enter
  | (key e == "") = ShiftEnter
  | (key e == "PageUp") = PageUp
  | (key e == "") = PageDown
  | (key e == "") = GoToStartOfLine
  | (key e == "") = GoToEndOfLine
  | (key e == "") = GoToStartOfWord
  | (key e == "") = GoToEndOfWord
  | (key e == "") = ShiftTab -- TODO
  | (key e == "") = CapsLock -- TODO
  | (key e == "") = Undo
  | (key e == "") = Redo
  | (key e == "") = SelectAll
  | (key e == "") = CommandPalette
  | (key e == "") = Backspace
  | (key e == "backspace") = Backspace
  | (key e == "Enter") = Enter
  | otherwise = Unhandled (key e)

edit :: Key -> Markup -> Markup
edit key (Markup m) = case key of
  Enter -> Markup (snoc m (Paragraph (Str "Appended via Edit":Nil)))
  SpaceKey -> Markup (snoc m (Paragraph (Str "Appended via Edit":Nil)))
  _ -> Markup m

editor :: Nut
editor = Deku.do
  setState /\ state <- useState "Hello World"
  setMarkup /\ markup <- useState syntaxExample
  D.div_
    [ D.div
        (Alt.do
          D.Contenteditable !:= "true"
          --keyDown $ state <#> (\currentString -> 
          --  \event -> case keyAction event of
          --    Unhandled s -> pure unit
          --    _ -> pure unit
          --)
          keyDown $ markup <#> (\currentState ->
            \event -> case keyAction event of
              Enter -> setMarkup (edit Enter currentState)
              Enter -> pure unit
              Unhandled s -> pure unit
              _ -> pure unit
          )
        )
        [ markup <#~> renderMarkup_
        ]
      , markup <#~> (text_ <<< pretty)
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