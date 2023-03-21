module Pages.Introduction where

import Prelude

import Contracts (Chapter, chapter)
--import Pages.Introduction.GettingStarted (gettingStarted)
import Pages.Introduction.HelloWorld (helloWorld)
import Pages.Demos (demos)

introduction :: forall lock payload. Chapter lock payload
introduction = chapter
  { title: "Introduction", pages: [ demos, helloWorld ] }