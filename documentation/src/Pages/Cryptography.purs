module Pages.Cryptography where

import Prelude
import Contracts (Chapter, chapter)
import Pages.Cryptography.Intro (intro)

cryptography :: forall lock payload. Chapter lock payload
cryptography = chapter
  { title: "Cryptography", pages: [ intro ] }