module Pages.Overview where

import Prelude

import Contracts (Chapter, chapter)
--import Pages.Introduction.GettingStarted (gettingStarted)
import Pages.Notes (notes)
import Pages.Demos (demos)

overview :: forall lock payload. Chapter lock payload
overview = chapter
  { title: "Overview", pages: [ demos, notes ] }