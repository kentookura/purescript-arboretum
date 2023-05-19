module Pages.Docs
  ( book
  ) where

import Prelude

import Contracts (Book(..))
--import Pages.AdvancedUsage (advancedUsage)
--import Pages.CoreConcepts (coreConcepts)
--import Pages.FRP (frp)
import Pages.Overview (overview)
import Pages.Cryptography (cryptography)

book :: Book
book = Book [ overview, cryptography ]