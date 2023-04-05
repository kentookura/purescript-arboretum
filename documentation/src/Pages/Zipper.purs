module Pages.Zipper where

import Contracts (Chapter, chapter)
--import Pages.Introduction.GettingStarted (gettingStarted)

zipper :: forall lock payload. Chapter lock payload
zipper = chapter
  { title: "Introduction", pages: [ ] }