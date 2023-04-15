module Zipper.String
  ( left
  , right
  , backspace
  , insert
  , insertString
  , StringZipper(..)
  , fst
  , snd
  ) where

import Data.Maybe
import Prelude

import Data.Array (reverse)
import Data.String (codePointFromChar, CodePoint, singleton, uncons, length)
import Data.String.CodeUnits (toCharArray, fromCharArray)
import Data.Tuple (Tuple(..))
import Deku.Attribute ((!:=))
import Deku.Control (text, text_, switcher)
import Deku.Core (Domable(..), Nut)
import Deku.DOM as D
import FRP.Event (Event)
import Markup.Editable (class Editable)
import Markup.Keyboard (Key(..))
import Web.UIEvent.KeyboardEvent (toEvent, KeyboardEvent, key, code, shiftKey, ctrlKey)

data StringZipper = Z String String

infixr 6 Z as /\

fst :: StringZipper -> String
fst (Z s _) = s

snd :: StringZipper -> String
snd (Z _ s) = s

end :: StringZipper -> StringZipper
end (j /\ k) = (j <> (toCharArray >>> reverse >>> fromCharArray) k) /\ ""

start :: StringZipper -> StringZipper
start (j /\ k) = "" /\ ((toCharArray >>> reverse >>> fromCharArray) j <> k)

insertString :: String -> StringZipper -> StringZipper
insertString s (j /\ k) = (s <> j) /\ k

insert :: CodePoint -> StringZipper -> StringZipper
insert s (j /\ k) = (singleton s <> j) /\ k

backspace :: StringZipper -> StringZipper
backspace (j /\ k) = case uncons j of
  Nothing -> j /\ k
  Just { head, tail } -> tail /\ k

left :: StringZipper -> StringZipper
left (j /\ k) = case uncons j of
  Nothing -> j /\ k
  Just { head, tail } -> tail /\ (singleton head <> k)

right :: StringZipper -> StringZipper
right (j /\ k) = case uncons k of
  Nothing -> j /\ k
  Just { head, tail } -> (singleton head <> j) /\ tail

instance editableStringZipper :: Editable StringZipper where
  view :: forall lock payload. StringZipper -> Domable lock payload
  view zipper =
    D.div (D.Class !:= "zipper-view")
      [ text_ $ (fst >>> toCharArray >>> reverse >>> fromCharArray) zipper
      , D.div (D.Id !:= "fake-caret") []
      , text_ $ snd zipper
      ]
  edit :: Key -> StringZipper -> StringZipper
  edit kevent =
    case kevent of
      Enter -> \x -> x
      SpaceKey -> insert $ codePointFromChar ' '
      Left -> left
      Right -> right
      Up -> \x -> x
      Down -> \x -> x
      Shift -> \x -> x
      Control -> \x -> x
      Alt -> \x -> x
      Tab -> \x -> x
      ShiftTab -> \x -> x
      CapsLock -> \x -> x
      ShiftEnter -> \x -> x
      PageUp -> \x -> x
      PageDown -> \x -> x
      GoToStartOfLine -> start
      GoToEndOfLine -> end
      GoToStartOfWord -> \x -> x
      GoToEndOfWord -> \x -> x
      Undo -> \x -> x
      Redo -> \x -> x
      SelectAll -> \x -> x
      Backspace -> do
        backspace
      Copy -> \x -> x
      Paste -> \x -> x
      Save -> \x -> x
      Yank -> \x -> x
      Escape -> do
        \x -> x
      --setPalette false
      Unhandled e ->
        let
          k
            | (key e == "p" && ctrlKey e) = do
                \x -> x
            | length (key e) > 1 = do
                \x -> x
            | otherwise = do
                insertString (key e)
        in
          k