module Markup.Math
  ( Location
  , definedIn
  , differentialEqn
  , inline
  , display
  , typeahead
  , editor
  ) where

import Prelude

import Data.Foldable (for_, oneOf)
import Data.String (Pattern(..), Replacement(..), replaceAll)
import Data.Time.Duration (Seconds(..))
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=), (:=), cb)
import Deku.Attributes (klass_)
import Deku.Control (guard, text, text_, (<$~>), (<#~>))
import Deku.Core (dyn, Nut)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useDyn, useState, useState', useHot')
import Deku.Listeners (click_, click, keyUp)
import Effect.Class.Console (logShow)
import FRP.Behavior (sample_, solve2')
import FRP.Behavior.Time (seconds)
import FRP.Event (Event, keepLatest)
import FRP.Event.AnimationFrame (animationFrame)
import FRP.Event.Class ((<|*>))
import Markup.Katex (Accent, KatexSettings, Operator(..), defaultOptions, toggleDisplay, viewKatex)
import QualifiedDo.Alt as Alt
import Web.DOM (Element)
import Web.Event.Event (target)
import Web.HTML (window)
import Web.HTML.HTMLInputElement (fromEventTarget, value)
import Web.HTML.Window (alert)
import Web.UIEvent.KeyboardEvent (code, toEvent)

accentuate :: String -> Accent -> String
accentuate s a = show a <> wrapBraces s

wrapBraces :: String -> String
wrapBraces s = "{" <> s <> "}"

inputKls :: String
inputKls =
  """rounded-md
border-gray-300 shadow-sm
border-2 mr-2
border-solid
focus:border-indigo-500 focus:ring-indigo-500
sm:text-sm"""

completionItem :: String -> String
completionItem color =
  replaceAll (Pattern "COLOR") (Replacement color)
    """mb-3 inline-flex items-center rounded-md
border border-transparent bg-COLOR-600 px-3 py-2
text-sm font-medium leading-4 text-white shadow-sm
hover:bg-COLOR-700 focus:outline-none focus:ring-2
focus:ring-COLOR-500 focus:ring-offset-2"""

typeahead :: Nut
typeahead = Deku.do
  setPos /\ pos <- useState 0
  setItem /\ item <- useState'
  setInput /\ input <- useHot'
  let
    guardAgainstEmpty e = do
      v <- value e
      if v == "" then
        window >>= alert "Item cannot be empty"
      else setItem v
    top =
      D.div_
        [ D.input
            [ D.Value !:= "Tasko primo"
            , keyUp $ pure \evt -> do
                when (code evt == "Enter") $
                  for_
                    ((target >=> fromEventTarget) (toEvent evt))
                    guardAgainstEmpty
            , D.SelfT !:= setInput
            , klass_ inputKls
            ]
            []
        , D.button
            [ click $ input <#> guardAgainstEmpty
            , klass_ $ completionItem "green"
            ]
            [ text_ "Add" ]
        ]
  D.div_
    [ top
    , dyn
        $ map
            ( \(Tuple p t) -> Deku.do
                { sendTo, remove } <- useDyn p
                D.div_
                  [ text_ t
                  , D.button
                      [ klass_ $ "ml-2 " <> completionItem "indigo"
                      , click_ (sendTo 0)
                      ]
                      [ text_ "Prioritize" ]
                  , D.button
                      [ klass_ $ "ml-2 " <> completionItem "pink"
                      , click_ remove
                      ]
                      [ text_ "Delete" ]
                  ]
            )
            (Tuple <$> pos <|*> item)
    ]

data Location = Location

instance showLoc :: Show Location where
  show l = "Location"

class Katex a where
  operatorName :: a -> String
  katex :: KatexSettings -> Array Macro -> a -> Nut

type Macro = { define :: String, toBe :: String }

macro :: Macro
macro = { define: "\\Spec", toBe: "\\text{Spec}" }

definedIn :: { define :: String, toBe :: String } -> Location -> Nut
definedIn m l =
  D.div_
    [ render_ defaultOptions macro.toBe
    , text_ ", defined in "
    , text_ $ show l
    ]

--definedIn :: Katex a => KatexSettings -> Location -> Array ({define :: String, toBe :: String}) -> Nut
--definedIn config l macro = 
--  D.div_ [katex (config {macros = macro})macro,]

editor :: Nut
editor =
  Deku.do
    --setContent /\ content <- useState testZipper
    setConfig /\ config <- useState defaultOptions
    setString /\ math <- useState "abc"
    setControls /\ controls <- useState false
    D.div_
      [ render { config, katex: math }
      , D.button
          [ click $ config <#> toggleDisplay >>> setConfig
          , klass_ "cursor-pointer"
          ]
          [ text_ "Toggle Display" ]
      , D.div
          --D.OnMouseover !:= cb \e -> do
          --  c <- controls
          --do
          --setControls c
          [ D.OnMouseleave !:= cb \e -> do
              logShow "mouseleave"
          ]
          [ D.div_ [ guard controls (text_ "click clack") ]
          , display defaultOptions "a^2 + b^2 = c^2"
          ]
      , D.ul_
          $ map
              ( \op ->
                  D.li
                    [ D.Self !:= \(e :: Element) -> do
                        viewKatex (show op) e (defaultOptions { displayMode = true })
                    ]
                    []
              )
              [ Sum
              , Integral
              , Bigotimes
              , Bigoplus
              , Product
              ]
      ]

inline :: KatexSettings -> String -> Nut
inline config s =
  D.span
    [ D.Self !:= \(e :: Element) -> do
        viewKatex s e (config { displayMode = false })
    ]
    []

display :: KatexSettings -> String -> Nut
display config s =
  D.span
    [ D.Self !:= \(e :: Element) -> do
        viewKatex s e (config { displayMode = true })
    ]
    []

buttonClass :: String
buttonClass =
  """inline-flex items-center rounded-md
border border-transparent bg-indigo-600 px-3 py-2
text-sm font-medium leading-4 text-white shadow-sm
hover:bg-indigo-700 focus:outline-none focus:ring-2
focus:ring-indigo-500 focus:ring-offset-2 mr-6"""

differentialEqn :: Nut
differentialEqn = Deku.do
  setThunk /\ thunk <- useState unit
  let
    motion = keepLatest $ thunk $>
      ( show >>> (D.Value := _) <$>
          ( sample_
              ( solve2' 1.0 0.0
                  ( seconds <#>
                      (\(Seconds s) -> s)
                  )
                  ( \x dx'dt -> pure (-0.5) * x -
                      (pure 0.1) * dx'dt
                  )
              )
              animationFrame
          )
      )
  D.div_
    [ D.div_
        [ D.button
            [ klass_ buttonClass, click_ (setThunk unit) ]
            [ text_ "Restart simulation" ]
        ]
    , D.div_
        [ D.input
            [ D.Xtype !:= "range"
            , klass_ "w-full"
            , D.Min !:= "-1.0"
            , D.Max !:= "1.0"
            , D.Step !:= "0.01"
            , motion
            ]
            []
        ]
    ]

--render
--  :: forall n r 
--   . Newtype n
--      { render ::
--        { katex :: String
--        , config  :: KatexSettings
--        , cont :: n -> Nut
--        }
--      | r
--      }
--  => n
--  -> Nut
--render = do

render
  :: { config :: Event KatexSettings
     , katex :: Event String
     }
  -> Nut
render { config, katex } =
  (Tuple <$> config <*> katex) <#~>
    \(cfg /\ ktx) ->
      D.span
        [ D.Self !:= \elt -> do
            viewKatex ktx elt cfg
        ]
        []

render_
  :: KatexSettings
  -> String
  -> Nut
render_ config katex =
  D.span
    [ D.Self !:= \elt -> do
        viewKatex katex elt config
    ]
    []
