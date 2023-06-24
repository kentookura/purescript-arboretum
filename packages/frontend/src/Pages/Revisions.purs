module Components.Revisions where

import Prelude

import Components.FlashCard (flashCard, part1)
import Deku.Core (Nut)
import Deku.Do as Deku
import Deku.DOM as D

revisions :: Nut
revisions = Deku.do
  D.ul [] (flashCard <$> part1)