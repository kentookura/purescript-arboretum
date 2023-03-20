module Katex
  ( viewKatex
  , KatexOptions
  , defaultOptions
  , asDisplay
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

type KatexOptions =
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

defaultOptions :: KatexOptions
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

asDisplay :: KatexOptions -> KatexOptions
asDisplay ops = ( ops { displayMode = true})

toggleDisplay :: KatexOptions -> KatexOptions
toggleDisplay ops = case ops.displayMode of
  true ->( ops { displayMode = false})
  false -> ( ops { displayMode = true})
data Macros = Object

foreign import viewKatex :: String -> Element -> KatexOptions -> Effect Unit
