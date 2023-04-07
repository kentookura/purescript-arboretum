module Pages.Docs
  ( book
  ) where

import Prelude

import Contracts (Book(..))
import Data.Maybe (Maybe(..))
--import Pages.AdvancedUsage (advancedUsage)
--import Pages.CoreConcepts (coreConcepts)
--import Pages.FRP (frp)
import Pages.Overview (overview)
import Pages.Cryptography (cryptography)

book :: forall lock payload. Book lock payload
book = Book [ overview, cryptography ]