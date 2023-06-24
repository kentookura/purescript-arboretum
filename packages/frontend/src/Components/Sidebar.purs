module Components.Sidebar where

import Prelude

import Control.Alt ((<|>))
import Deku.DOM as D
import Deku.Core (Nut)
import Deku.Control (text_, blank)
import Deku.Attributes (klass_, klass)
import Deku.Attribute ((!:=), cb)
import Deku.Listeners (click_)
import Navigation (PushState)
import Route (Route(..), route)
import Routing.Duplex (print)
import FRP.Event (Event)
import Components.Pill (pill)
import Components.Icon as Icon
import Yoga.JSON as JSON
import Web.Event.Event (preventDefault)

sidebarLinks = [ Workspace, About, Courses ]

sidebarMobile opts = D.div [ klass_ "flex grow flex-col gap-y-5 overflow-y-auto bg-gray-900 px-6 pb-4 ring-1 ring-white/10" ]
  [ D.div [ klass_ "flex h-16 shrink-0 items-center" ]
      [ D.img
          [ klass_ "h-8 w-auto"
          , D.Src !:= "https://tailwindui.com/img/logos/mark.svg?color!:=indigo&shade!:=500"
          , D.Alt !:= "Your Company"
          ]
          []
      ]
  , D.nav [ klass_ "flex flex-1 flex-col" ]
      [ D.ul
          [ D.Role !:= "list"
          , klass_ "flex flex-1 flex-col gap-y-7"
          ]
          [ D.li []
              [ D.ul [ D.Role !:= "list", klass_ "-mx-2 space-y-1" ]
                  (nav opts <$> sidebarLinks)
              ]
          ]
      ]
  ]

sidebarDesktop opts =
  -- Static sidebar for desktop -->
  D.div [ klass_ "hidden lg:fixed lg:inset-y-0 lg:z-50 lg:flex lg:w-72 lg:flex-col" ]
    -- Sidebar component, swap this element with another sidebar if you like --]
    [ D.div [ klass_ "flex grow flex-col gap-y-5 overflow-y-auto bg-gray-900 px-6 pb-4" ]
        [ D.div [ klass_ "flex h-16 shrink-0 items-center" ]
            [ D.img
                [ klass_ "h-8 w-auto", D.Src !:= "https://tailwindui.com/img/logos/mark.D.svg?color=indigo&shade=500", D.Alt !:= "Your Company" ]
                []
            ]
        , D.nav
            [ klass_ "flex flex-1 flex-col" ]
            [ D.ul [ D.Role !:= "list", klass_ "flex flex-1 flex-col gap-y-7" ]
                [ D.li []
                    [ D.ul [ D.Role !:= "list", klass_ "-mx-2 space-y-1" ]
                        (nav opts <$> sidebarLinks)
                    ]
                ]
            ]
        ]
    ]

--navigation :: String -> Nut -> Nut
--navigation s i = navigation_ s "" i
--
--navigation_ :: String -> String -> Nut -> Nut
--navigation_ s p i =
--  let
--    notif = if p == "" then blank else pill p
--  in
--    D.a
--      [ D.Href !:= "#"
--      , klass_ "bg-gray-800 text-white group flex gap-x-3 rounded-md p-2 text-sm leading-6 font-semibold"
--      ]
--      [ i
--      , text_ s
--      , notif
--      ]

-- navItems =
--   [ navigation "Dashboard" Icon.home
--   , navigation "Courses" Icon.team
--   , navigation "Calendar" Icon.calendar
--   , navigation "Documents" Icon.documents
--   ]

nav
  :: { pushState :: PushState
     , pageIs :: Route -> Event Unit
     , pageWas :: Route -> Event Unit
     }
  -> Route
  -> Nut
nav { pushState, pageIs, pageWas } r =
  D.a
    [ D.Href !:= url
    , click_ $ cb \e -> do
        preventDefault e
        pushState (JSON.writeImpl {}) url
    , klass $
        (pure false <|> (pageIs r $> true) <|> (pageWas r $> false)) <#>
          ( if _ then "bg-gray-800 text-white group flex gap-x-3 rounded-md p-2 text-sm leading-6 font-semibold"
            else "text-gray-400 hover:text-white hover:bg-gray-800 group flex gap-x-3 rounded-md p-2 text-sm leading-6 font-semibold"
          )

    ]
    [ text_ s
    --, notif
    ]
  where
  url = print route $ r
  s = case r of
    Workspace -> "Workspace"
    About -> "About"
    Revisions -> "Revisions"
    Courses -> "Courses"
    Editor -> "Editor"
    FourOhFour -> ""
