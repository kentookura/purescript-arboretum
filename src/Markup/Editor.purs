module Markup.Editor
  ( editor
  , main
  )
  where

import Prelude

import Markup.Render (renderMarkup, renderMarkup_)
import Markup.Parser (parseMarkup)
import Markup.Syntax (Markup(..), Block(..), Inline(..), pretty)
import Markup.Examples (raw)
import Markup.Keyboard (Key(..), keyAction, showKeyboardEvent) 

import Data.Either (Either(..)) as Either
import Data.Foldable (for_)
import Data.List (List(..), (:), snoc)
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Data.String (take, length)
import Data.String.Utils (lines)
import Deku.Attribute ((!:=), cb)
import Deku.Attributes (klass_)
import Deku.Core (Nut)
import Deku.Control (blank, guard, text, text_, (<#~>))
import Deku.Listeners (keyDown, textInput_)
import Deku.Hooks (useState, useState', useRef, useMailboxed)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Toplevel (runInBody)
import FRP.Event (Event)
import Effect (Effect)
import Effect.Class.Console (logShow, log)
import Modal (modalClick)
import QualifiedDo.Alt as Alt
import Web.HTML (window)
import Web.HTML.HTMLInputElement (fromEventTarget, value)
import Web.HTML.Navigator (platform)
import Web.HTML.Window (navigator)
import Web.Event.Event (preventDefault, target)
import Web.UIEvent.MouseEvent (screenX, screenY)
import Web.UIEvent.KeyboardEvent (toEvent, key, ctrlKey)

data PlatForm 
  = Mac
  | Linux
  | Windows
  | UnknownPlatform

edit :: Key -> Markup -> Markup
edit key (Markup m) = case key of
  Enter -> Markup (snoc m (Paragraph (Str "Appended via Edit":Nil)))
  SpaceKey -> Markup (snoc m (Paragraph (Str " ":Nil)))
  _ -> Markup m

data Focus 
  = Command
  | AutoComplete
  | Editor



editor :: Nut
editor = Deku.do
  setMarkup /\ markup <- useState'
  setPalette /\ paletteOpen <- useState  false
  setFocus /\ currentFocus <- useState Command
  D.div_
    [ D.pre
        (Alt.do
          D.Contenteditable !:= "true"
          D.OnAuxclick !:= cb \e -> do
            preventDefault e
            log "TODO: Wire up context menu"
          keyDown $ markup <#> (\currentState ->
            \event -> 
            case keyAction event of
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
                    | otherwise = logShow $ showKeyboardEvent e
                in 
                  k
              a  -> logShow $ show a
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
  window >>= navigator >>= platform >>= logShow 
  runInBody Deku.do
    editor 