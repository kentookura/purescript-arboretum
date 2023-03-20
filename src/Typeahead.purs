module Typeahead where

import Prelude
import Halogen.HTML.Events as HE
import Effect.Aff.Class (class MonadAff)
import Data.Const (Const)
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH

data Query a = NoOp a

type State = Unit
type Input = Unit

type Message = Void

type ChildSlot = Unit
type ChildQuery = Const Void

data Action = Increment | Decrement

component :: forall query input output m. H.Component query input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval H.defaultEval { handleAction = handleAction }
    }

initialState :: forall input. input -> State
initialState _ = unit

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div_
    [ HH.button [ HE.onClick \_ -> Decrement ] [ HH.text "-" ]
    , HH.text (show state)
    , HH.button [ HE.onClick \_ -> Increment ] [ HH.text "+" ]
    ]

handleAction :: forall output m. Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  Decrement ->
    H.modify_ \state -> state

  Increment ->
    H.modify_ \state -> state
