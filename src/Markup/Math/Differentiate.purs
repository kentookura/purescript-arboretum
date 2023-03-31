module Markup.Math.Differentiate where

import Prelude

import Data.Tuple (Tuple(..))

--class (Linear a b) <= D a b where
  --d :: a -> Tuple b (Linear a b)

class Linear a b where
  lin :: (a -> b)