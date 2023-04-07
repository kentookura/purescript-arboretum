module Pages.Docs
  ( docs
  ) where

import Prelude

import Contracts (Docs(..))
import Data.Maybe (Maybe(..))
--import Pages.AdvancedUsage (advancedUsage)
--import Pages.CoreConcepts (coreConcepts)
--import Pages.FRP (frp)
import Pages.Introduction (introduction)
import Pages.Cryptography (cryptography)

docs :: forall lock payload. Docs lock payload
docs = Docs [ introduction, cryptography ]