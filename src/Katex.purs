module Katex
  ( viewKatex
  , KatexSettings
  , defaultOptions
  , toggleDisplay
  , Macros
  ) where

import Prelude (($), Unit)
import Effect (Effect)
import Data.Set
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Type.Data.Boolean (not)
import Web.DOM (Element)

type KatexSettings =
  { displayMode :: Boolean
  , output :: String
  , leqno :: Boolean
  , fleqn :: Boolean
  , throwOnError :: Boolean
  , errorColor :: String
  , minRuleThickens :: Number
  , colorIsTextColor :: Boolean
  --, maxSize :: Number
  --, maxExpand :: Number
  , strict :: Boolean
  , trust :: Boolean
  }

defaultOptions :: KatexSettings
defaultOptions = 
  { displayMode : false
  , output : "htmlAndMathMl"
  , leqno : false
  , fleqn : false
  , throwOnError : true
  , errorColor : "#cc0000"
  , minRuleThickens : 0.04
  , colorIsTextColor : true
  --, maxSize : Number
  -- , maxExpand : Number
  , strict : false
  , trust : false
  }


toggleDisplay :: KatexSettings -> KatexSettings
toggleDisplay ops = case ops.displayMode of
  true ->( ops { displayMode = false})
  false -> ( ops { displayMode = true})
data Macros = Object

foreign import viewKatex :: String -> Element -> KatexSettings -> Effect Unit
