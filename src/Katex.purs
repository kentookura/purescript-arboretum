module Katex
  ( render
  , Option
  )
  where

import Prelude (($), Unit)
import Effect (Effect)
import Data.Set
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Web.DOM (Element)

data Option = DisplayMode | Output | FlushLeft | ThrowOnError | ErrorColor  

data Macros = Object


foreign import render :: String ->  Element -> Set Option -> Effect Unit
