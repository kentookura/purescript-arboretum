module Markup.Keyboard where

import Prelude
import Web.UIEvent.KeyboardEvent (toEvent, KeyboardEvent, key, code, shiftKey, ctrlKey)

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
  | Backspace
  | Copy
  | Paste
  | Save
  | Yank
  | Unhandled KeyboardEvent

instance showKey :: Show Key where
  show SpaceKey = "Space"
  show Left = "Left"
  show Right = "Right"
  show Up = "Up"
  show Down = "Down"
  show Shift = "Shift "
  show Control = "Control "
  show Alt = "Alt"
  show Tab = "Tab"
  show ShiftTab = "ShiftTab"
  show CapsLock = "CapsLock"
  show Escape = "Escape"
  show Enter = "Enter"
  show ShiftEnter = "ShiftEnter"
  show PageUp = "PageUp"
  show PageDown = "PageDown"
  show GoToStartOfLine = "GoToStartOfLine"
  show GoToEndOfLine = "GoToEndOfLine"
  show GoToStartOfWord = "GoToStartOfWord"
  show GoToEndOfWord = "GoToEndOfWord"
  show Undo = "Undo"
  show Redo = "Redo"
  show SelectAll = "SelectAll"
  show Backspace = "Backspace"
  show Copy = "Copy"
  show Paste = "Paste"
  show Save = "Save"
  show Yank = "Yank"
  show (Unhandled e) = "Unhandled"

showKeyboardEvent :: KeyboardEvent -> String
showKeyboardEvent k =
  let
    isCtrl = ctrlKey k
    isShift = shiftKey k
  in
    "{ " <> key k <> ", ctrlKey: " <> show isCtrl <> ", isShift: " <> show isShift <> "}"

keyAction :: KeyboardEvent -> Key
keyAction e =
  let
    isShift = shiftKey e
    isCtrl = ctrlKey e
    k
      | (key e == "backspace") = Backspace
      | (key e == "Enter") = Enter
      | isCtrl || (isShift && isCtrl) =
          let
            k2
              | key e == "a" = SelectAll
              | key e == "y" = Redo
              | key e == "z" = Undo
              | key e == "s" = Save
              | key e == "x" = Yank
              | key e == "c" = Copy
              | key e == "v" = Paste
              | otherwise = Unhandled e
          in
            k2
      | (key e == "Tab" && isShift) = ShiftTab
      | (key e == "Enter" && isShift) = ShiftEnter
      | (code e == "Space") = SpaceKey
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
      | (key e == "PageUp") = PageUp
      | (key e == "") = PageDown
      | (key e == "") = GoToStartOfLine
      | (key e == "") = GoToEndOfLine
      | (key e == "") = GoToStartOfWord
      | (key e == "") = GoToEndOfWord
      | (key e == "") = CapsLock -- TODO
      | (key e == "Backspace") = Backspace
      | otherwise = Unhandled e
  in
    k
