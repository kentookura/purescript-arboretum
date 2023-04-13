module Markup.Editor
  ( editor
  , main
  ) where

import Prelude

import Data.List (List(..), (:), snoc)
import Data.Tuple.Nested ((/\))
import Data.String (length, take)
import Deku.Attribute ((!:=), cb)
import Deku.Control (guard, text, text_, (<#~>))
import Deku.Core (Nut)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useRef, useState, useState')
import Deku.Listeners (keyDown)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Class.Console (logShow, log)
import Markup.Examples (theorems)
import Markup.Keyboard (Key(..), keyAction, showKeyboardEvent)
import Markup.Render (renderMarkup_, renderTheorem)
import Markup.Syntax (Markup(..), Block(..), Inline(..))
import Modal (modalClick)
import QualifiedDo.Alt as Alt
import Web.Event.Event (preventDefault)
import Web.UIEvent.KeyboardEvent (toEvent, key, ctrlKey)

data PlatForm
  = Mac
  | Linux
  | Windows
  | UnknownPlatform

edit :: Key -> Markup -> Markup
edit key (Markup m) = case key of
  Enter -> Markup (snoc m (Paragraph (Str "Appended via Edit" : Nil)))
  SpaceKey -> Markup (snoc m (Paragraph (Str " " : Nil)))
  _ -> Markup m

data Focus
  = Command
  | AutoComplete
  | Editor

data EditorState
  = AwaitBlockType
  | AwaitChars

editor :: Nut
editor = Deku.do
  setString /\ string <- useState ""
  stringRef <- useRef "" string
  setMarkup /\ markup <- useState'
  setState /\ editorState <- useState AwaitChars
  setPalette /\ paletteOpen <- useState false
  D.div_
    [ D.pre
        ( Alt.do
            D.Contenteditable !:= "true"
            D.OnAuxclick !:= cb \e -> do
              preventDefault e
              log "TODO: Wire up context menu"
            keyDown $ editorState <#>
              ( \currentState -> case currentState of
                  AwaitBlockType -> \event -> do
                    pure unit
                  AwaitChars ->
                    \event ->
                      let
                        def :: Effect Unit
                        def = do
                          preventDefault $ toEvent event
                      in
                        case keyAction event of
                          Enter -> def
                          SpaceKey -> def
                          Left -> def
                          Right -> def
                          Up -> def
                          Down -> def
                          Shift -> def
                          Control -> def
                          Alt -> def
                          Tab -> def
                          ShiftTab -> def
                          CapsLock -> def
                          ShiftEnter -> def
                          PageUp -> def
                          PageDown -> def
                          GoToStartOfLine -> def
                          GoToEndOfLine -> def
                          GoToStartOfWord -> def
                          GoToEndOfWord -> def
                          Undo -> def
                          Redo -> def
                          SelectAll -> def
                          Backspace -> do
                            currentString <- stringRef
                            setString (take ((length currentString) - 1) currentString)
                          Copy -> def
                          Paste -> def
                          Save -> def
                          Yank -> def
                          Escape -> do
                            setPalette false
                          Unhandled e ->
                            let
                              k
                                | (key e == "p" && ctrlKey e) = do
                                    preventDefault (toEvent e)
                                    logShow $ showKeyboardEvent e
                                    setPalette true
                                    modalClick (setPalette false)
                                | otherwise = do 
                                    currentString <- stringRef
                                    preventDefault (toEvent e)
                                    setString (currentString <> key e)
                            in
                              k
              )
        )
        [ text string
          --markup <#~> renderMarkup_
        ]
    , D.div_
        [ text_ "Debug: "
        ]
    , guard paletteOpen (text_ "command palette")
    ]

main :: Effect Unit
main = do
  --window >>= navigator >>= platform >>= logShow
  runInBody Deku.do
    editor