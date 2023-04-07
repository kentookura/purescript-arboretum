module Markup.Editor
  ( editor
  , main
  ) where

import Prelude

import Data.Either (Either(..)) as Either
import Data.Foldable (for_)
import Data.List (List(..), (:), snoc)
import Data.String (take, length)
import Data.String.Utils (lines)
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=), cb)
import Deku.Attributes (klass_)
import Deku.Control (blank, guard, text, text_, (<#~>))
import Deku.Core (Nut)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useState, useState', useRef, useMailboxed)
import Deku.Listeners (keyDown, textInput_)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Class.Console (logShow, log)
import FRP.Event (Event)
import Markup.Examples (raw)
import Markup.Keyboard (Key(..), keyAction, showKeyboardEvent)
import Markup.Parser (parseMarkup)
import Markup.Render (renderMarkup, renderMarkup_)
import Markup.Syntax (Markup(..), Block(..), Inline(..), pretty)
import Modal (modalClick)
import QualifiedDo.Alt as Alt
import Web.Event.Event (preventDefault, target)
import Web.HTML (window)
import Web.HTML.HTMLInputElement (fromEventTarget, value)
import Web.HTML.Navigator (platform)
import Web.HTML.Window (navigator)
import Web.UIEvent.KeyboardEvent (toEvent, key, ctrlKey)
import Web.UIEvent.MouseEvent (screenX, screenY)

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

editor :: Nut
editor = Deku.do
  setMarkup /\ markup <- useState'
  setPalette /\ paletteOpen <- useState false
  D.div_
    [ D.pre
        ( Alt.do
            D.Contenteditable !:= "true"
            D.OnAuxclick !:= cb \e -> do
              preventDefault e
              log "TODO: Wire up context menu"
            keyDown $ markup <#>
              ( \currentState ->
                  \event ->
                    let
                      def :: Effect Unit
                      def = do
                        log $ showKeyboardEvent event
                    in
                      case keyAction event of
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
                        Backspace -> def
                        Copy -> def
                        Paste -> def
                        Save -> def
                        Yank -> def
                        Enter -> do
                          setMarkup (edit Enter currentState)
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
                                  def
                          in
                            k
              )
        )
        [ markup <#~> renderMarkup_
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