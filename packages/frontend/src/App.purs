module Layout where

import Prelude

import Pages.About (about)
import Pages.Courses (courses)
import Components.Icon as Icon
import Components.Pill (pill)
import Components.Workspace (workspace)
import Components.Revisions (revisions)
import Components.Sidebar (sidebarMobile, sidebarDesktop)
import Components.Editor (editor)
import Control.Alt ((<|>))
import Data.Maybe (fromMaybe, Maybe(..))
import Data.Maybe (fromMaybe, Maybe(..))
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_, klass)
import Deku.Control (blank, (<#~>))
import Deku.Control (text_)
import Deku.Core (Nut)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Hooks (useState)
import Deku.Listeners (click, click_)
import Effect.Console (log)
import FRP.Event (Event)
import Navigation (PushState)
import Route (Route(..))
import Text.Markdown.SlamDown.Render (renderMdFromString)

-- !--
--   This example requires some changes to your config:
-- 
--   ```
--   // tailwind.config.js
--   module.exports = {

--     // ...
--     plugins: [

--       // ...
--       require('@tailwindcss/forms'),
--     ],
--   }
--   ```
-- --]
-- !--
--   This example requires updating your template:
--   ```
--   html klass_ "h-full bg-white"]
--   body klass_ "h-full"]
--   ```
-- --]

showIf :: Event Boolean -> Nut -> Nut
showIf e n = e <#~> if _ then n else blank

app
  :: { currentPage :: Event Route
     , pushState :: PushState
     , pageIs :: Route -> Event Unit
     , pageWas :: Route -> Event Unit
     }
  -> Nut
app { currentPage, pushState, pageIs, pageWas } = Deku.do
  setSidebar /\ showSidebar <- useState false
  D.div []
    [ -- ! Off-canvas menu for mobile, show/hide based on off-canvas menu state. --  
      showIf showSidebar
        ( D.div
            [ klass_ "relative z-50 lg:hidden"
            , D.Role !:= "dialog"
            ]
            -- !
            --  Off-canvas menu backdrop, show/hide based on off-canvas menu state.

            --  Entering: "transition-opacity ease-linear duration-300"
            --    From: "opacity-0"
            --    To: "opacity-100"
            --  Leaving: "transition-opacity ease-linear duration-300"
            --    From: "opacity-100"
            --    To: "opacity-0"
            --
            [ D.div [ klass_ "fixed inset-0 bg-gray-900/80" ] []

            , D.div [ klass_ "fixed inset-0 flex" ]
                [ --  Off-canvas menu, show/hide based on off-canvas menu state.
                  --  Entering: "transition ease-in-out duration-300 transform"
                  --    From: "-translate-x-full"
                  --    To: "translate-x-0"
                  --  Leaving: "transition ease-in-out duration-300 transform"
                  --    From: "translate-x-0"
                  --    To: "-translate-x-full"

                  D.div [ klass_ "relative mr-16 flex w-full max-w-xs flex-1" ]
                    [ --  Close button, show/hide based on off-canvas menu state.
                      --  Entering: "ease-in-out duration-300"
                      --    From: "opacity-0"
                      --    To: "opacity-100"
                      --  Leaving: "ease-in-out duration-300"
                      --    From: "opacity-100"
                      --    To: "opacity-0"

                      D.div [ klass_ "absolute left-full top-0 flex w-16 justify-center pt-5" ]
                        [ D.button
                            [ D.Xtype !:= "button"
                            , klass_ "-m-2.5 p-2.5"
                            , click_ $ setSidebar false
                            ]
                            [ D.span [ klass_ "sr-only" ] [ text_ "Close sidebar" ]
                            , Icon.xmark
                            ]
                        ]
                    , sidebarMobile { pushState, pageIs, pageWas }
                    ]
                ]
            ]
        )
    , sidebarDesktop { pushState, pageIs, pageWas }
    , D.div [ klass_ "lg:pl-72" ]
        [ D.div [ klass_ "sticky top-0 z-40 flex h-16 shrink-0 items-center gap-x-4 border-b border-gray-200 bg-white px-4 shadow-sm sm:gap-x-6 sm:px-6 lg:px-8" ]
            [ D.button
                [ D.Xtype !:= "button"
                , klass_ "-m-2.5 p-2.5 text-gray-700 lg:hidden"
                , click_ $ setSidebar true
                ]

                [ D.span [ klass_ "sr-only" ] [ text_ "Open sidebar" ]
                , D.svg [ klass_ "h-6 w-6", D.Fill !:= "none", D.ViewBox !:= "0 0 24 24", D.StrokeWidth !:= "1.5", D.Stroke !:= "currentColor", D.AriaHidden !:= "true" ]
                    [ D.path
                        [ D.StrokeLinecap !:= "round"
                        , D.StrokeLinejoin !:= "round"
                        , D.D !:= "M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"
                        ]
                        []
                    ]
                ]
            , separator
            ]
        , D.main []
            [ D.div
                [ klass_ "px-4 sm:px-6 lg:px-8" ]
                [ D.div [ klass_ "prose" ]
                    [ currentPage <#~> case _ of
                        FourOhFour -> D.div_ [ text_ "Oh No" ]
                        Workspace -> workspace
                        Revisions -> revisions
                        Courses -> courses
                        Editor -> editor
                        About -> about
                    ]
                ]
            ]
        ]
    ]

separator = D.div [ klass_ "h-6 w-px bg-gray-900/10 lg:hidden" ] []