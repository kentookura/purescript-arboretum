module Zipper.Markdown
  ( InlineZipper(..)
  , State
  ) where

import Prelude

import Deku.Attribute ((!:=))
import Deku.Control (text_)
import Deku.Core (Nut)
import Deku.DOM (kbd)
import Deku.DOM as D
import Dissect.Generic (Const(..), Id(..), Product(..), Sum(..), (:*:))
import Editor.Keyboard (Key(..))
import Editor (class Editable)
import Web.UIEvent.KeyboardEvent (key, ctrlKey)
import Web.Util.TextCursor (TextCursor)

a = SumR (Id 0) :: Sum Id Id Int

--heading = Product (Id 0) (Const "Hello") :: ?T

data InlineZipper = Inline String String State

type State = { selection :: TextCursor }

state :: InlineZipper -> State
state (Inline _ _ s) = s

instance editableStringZipper :: Editable InlineZipper where
  view :: InlineZipper -> Nut
  view (Inline x y z) =
    D.div [ D.Class !:= "zipper-view" ]
      [ text_ x
      , text_ y
      ]
  edit :: Key -> InlineZipper -> InlineZipper
  edit kevent z =
    case kevent of
      Enter -> z
      SpaceKey -> z
      Left -> z
      Right -> z
      Up -> z
      Down -> z
      Shift -> z
      Control -> z
      Alt -> z
      Tab -> z
      ShiftTab -> z
      CapsLock -> z
      ShiftEnter -> z
      PageUp -> z
      PageDown -> z
      GoToStartOfLine -> z
      GoToEndOfLine -> z
      GoToStartOfWord -> z
      GoToEndOfWord -> z
      Undo -> z
      Redo -> z
      SelectAll -> z
      Backspace -> z
      Copy -> z
      Paste -> z
      Save -> z
      Yank -> z
      Escape -> z
      Unhandled e ->
        let
          k
            | (key e == "p" && ctrlKey e) = do
                z
            -- | length (key e) > 1 = do
            --    z
            | otherwise = do
                z
        in
          k