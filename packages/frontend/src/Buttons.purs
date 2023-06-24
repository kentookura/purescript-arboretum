module Buttons where

import Prelude
import Deku.Core (Nut)
import Deku.DOM as D

import Deku.Attribute ((!:=))
import Deku.Attributes (klass_, klass)
import Deku.Control (text_, text, (<#~>), (<$~>))
import Deku.Core (Nut, dyn)
import Deku.Core as Core
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Hooks (useDyn, useState, useState', useHot')
import Deku.Listeners (click, click_, keyUp)
import Deku.Toplevel (runInBody)

--        <!--
--          Close button, show/hide based on off-canvas menu state.
--
--          Entering: "ease-in-out duration-300"
--            From: "opacity-0"
--            To: "opacity-100"
--          Leaving: "ease-in-out duration-300"
--            From: "opacity-100"
--            To: "opacity-0"
--        -->

closeButton :: Nut
closeButton = D.div [ klass_ "absolute left-full top-0 flex w-16 justify-center pt-5" ]
  [ D.button
      [ D.Xtype !:= "button"
      , klass_ "-m-2.5 p-2.5"
      ]
      [ D.span
          [ klass_ "sr-only"
          ]
          []
      , D.svg
          [ klass_ "h-6 w-6 text-white"
          , D.Fill !:= "none"
          , D.ViewBox !:= "0 0 24 24"
          , D.StrokeWidth !:= "1.5"
          , D.Stroke !:= "currentColor"
          , D.AriaHidden !:= "true"
          ]
          [ D.path
              [ D.StrokeLinecap !:= "round"
              , D.StrokeLinecap !:= "round"
              , D.StrokeLinejoin !:= "round"
              , D.D !:= "M6 18L18 6M6 6l12 12"
              ]
              []
          ]
      ]
  ]

--        <div class="absolute left-full top-0 flex w-16 justify-center pt-5">
--          <button type="button" class="-m-2.5 p-2.5">
--            <span class="sr-only">Close sidebar</span>
--            <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" aria-hidden="true">
--              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
--            </svg>
--          </button>
--        </div>