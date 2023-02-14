module Main where

import Data.Maybe (Maybe(..))
import Lib (css, (|>))
import Prelude
import Effect (Effect)
import Zipper
  ( TermZipper
  , TermContext(..)
  , Term(..)
  , up
  , down
  , left
  , right
  , toZipper
  , setHole
  , fromZipper
  , getHole
  , getContext
  )
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.HTML.Events (onClick) as HE
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI component unit body

data Message = Down | Up | Left | Right

type State = TermZipper

component :: forall q i o m. H.Component q i o m
component = H.mkComponent
  { initialState
  , render
  , eval: H.mkEval H.defaultEval { handleAction = handleAction }
  }

initialState :: forall input. input -> State
initialState _ =
  Var "x"
    |> toZipper
    |> try down
    |> try down
    |> try right
    |> try right
    |> try down
    |> try down
    |> setHole (Var "*")
    |> fromZipper
    |> toZipper

try :: forall a. (a -> Maybe a) -> a -> a
try f val = case f val of
  Nothing -> val
  Just x -> x

handleAction :: forall output m. Message -> H.HalogenM State Message () output m Unit
handleAction = case _ of
  Up ->
    H.modify_ \state -> (state |> try up)
  Down ->
    H.modify_ \state -> (state |> try down)
  Left ->
    H.modify_ \state -> (state |> try left)
  Right ->
    H.modify_ \state -> (state |> try right)

render :: forall m. State -> H.ComponentHTML Message () m
render state = HH.div [ css "p-4" ] [ controls, content ]
  where
  buttonStyle = css "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
  controls = HH.div [ css "flex flex-row" ]
    [ HH.button [ buttonStyle, HE.onClick \_ -> Up ] [ HH.text "Up" ]
    , HH.button [ buttonStyle, HE.onClick \_ -> Down ] [ HH.text "Down" ]
    , HH.button [ buttonStyle, HE.onClick \_ -> Left ] [ HH.text "Left" ]
    , HH.button [ buttonStyle, HE.onClick \_ -> Right ] [ HH.text "Right" ]
    ]
  content = HH.div []
    [ HH.div [ css "" ]
        [ HH.span_ [ HH.text "State: " ]
        --, state
        --    |> fromZipper
        --    |> show
        --    |> HH.text
        ]
    --, HH.div [ css "" ]
    --    [ HH.span_ [ HH.text "Hole: " ]
    --    , state
    --        |> getHole
    --        |> show
    --        |> HH.text
    --    ]
    --, HH.div [ css "" ] [ HH.span_ [ HH.text "Context: " ], state |> getContext |> viewContext ]
    ]
