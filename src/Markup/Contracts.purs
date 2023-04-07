module Markup.Contracts (Theorem(..), theorem) where

import Prelude

import Deku.Core (Domable)

--data TheoremType 
--  = Theorem
--  | Lemma
--  | Proposition
--  | Remark
--  | Custom String

newtype Theorem lock payload = Theorem
  { title :: String
  , statement :: Domable lock payload
  , proof :: Domable lock payload
  }

theorem
  :: forall lock payload
   . { title :: String
     , statement :: Domable lock payload
     , proof :: Domable lock payload
     }
  -> Theorem lock payload
theorem i = Theorem i

newtype Tooltip lock payload = Tooltip
  { title :: String
  , matter :: Domable lock payload
  }

tooltip
  :: forall lock payload
   . { title :: String
     , matter :: Domable lock payload
     }
  -> Tooltip lock payload
tooltip i = Tooltip i

