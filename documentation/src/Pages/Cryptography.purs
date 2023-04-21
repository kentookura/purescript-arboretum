module Pages.Cryptography where

import Prelude
import Contracts (Chapter, chapter)
import Pages.Cryptography.Intro (intro)

cryptography :: Chapter
cryptography = chapter
  { title: "Cryptography", pages: [ intro ] }