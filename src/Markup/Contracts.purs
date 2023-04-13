module Markup.Contracts (Theorem(..), theorem) where

import Prelude

import Deku.Core (Nut)

--data TheoremType 
--  = Theorem
--  | Lemma
--  | Proposition
--  | Remark
--  | Custom String

newtype Theorem = Theorem
  { title :: String
  , statement :: Nut
  , proof :: Nut
  }

theorem
  :: { title :: String
     , statement :: Nut
     , proof :: Nut
     }
  -> Theorem
theorem i = Theorem i

newtype Tooltip = Tooltip
  { title :: String
  , matter :: Nut
  }

tooltip
  :: { title :: String
     , matter :: Nut
     }
  -> Tooltip
tooltip i = Tooltip i

