module Components.WorkspaceItem where

import Prelude

import Components.Icon (icon)
import Data.Tuple.Nested ((/\))
import Deku.Attributes (klass_)
import Deku.Core (Nut)
import Deku.Control (text_)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Hooks (useState)

data ItemType = Theorem | Note | Definition

type Item =
  { title :: String
  , itemType :: ItemType
  , fqn :: String
  , content :: Nut
  }

workspaceItem :: Item -> Nut
workspaceItem props = Deku.do
  setToggle /\ toggle <- useState true
  D.div_
    [ D.div
        [ klass_ "border-b border-gray-200 bg-white px-4 py-5 sm:px-6" ]
        [ D.div [ klass_ "flex item-center" ]
            [ ( case props.itemType of
                  Theorem -> icon 6 "M6.429 9.75L2.25 12l4.179 2.25m0-4.5l5.571 3 5.571-3m-11.142 0L2.25 7.5 12 2.25l9.75 5.25-4.179 2.25m0 0L21.75 12l-4.179 2.25m0 0l4.179 2.25L12 21.75 2.25 16.5l4.179-2.25m11.142 0l-5.571 3-5.571-3"
                  Note -> icon 6 "M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"
                  Definition -> icon 6 "M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"
              )
            , D.h3
                [ klass_ "text-base font-semibold leading-6 text-gray-900" ]
                [ text_ props.fqn ]
            ]
        , D.article [ klass_ "prose" ]
            [ props.content ]
        ]
    ]

{-
  D.li []
    [ D.div
        [ klass_ "relative flex justify-between gap-x-6 px-4 py-5 hover:bg-gray-50 sm:px-6 lg:px-8" ]
        [ D.div
            [ klass_ "flex gap-x-4" ]
            [ D.button [ D.Xtype !:= "button", click $ toggle <#> not >>> setToggle ]
                [ D.span [ klass_ "sr-only" ] [ text_ "Toggle content" ]
                , D.svg
                    [ klass_ "h-5 w-5 flex-none text-gray-400"
                    , D.ViewBox !:= "0 0 20 20"
                    , D.Fill !:= "currentColor"
                    , D.AriaHidden !:= "true"
                    ]
                    [ D.path
                        [ D.FillRule !:= "evenodd"
                        , D.D !:= "M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z"
                        , D.ClipRule !:= "evenodd"
                        ]
                        []
                    ]
                ]
            , D.div [ klass_ "min-w-0 flex-auto" ]
                [ D.p [ klass_ "text-sm font-semibold leading-6 text-gray-900" ]
                    [ D.a [ D.Href !:= "#" ]
                        [ --D.span [ klass_ "absolute inset-x-0 -top-px bottom-0" ] []
                          text_ props.title
                        , D.div [ klass_ "mt-1 flex text-xs leading-5 text-gray-500" ]
                            [ D.a
                                [ klass_ "relative truncate hover:underline"
                                --D.Href !:= "mailto:leslie.alexander@example.com"
                                ]
                                [ text_ props.fqn ]
                            ]
                        ]
                    ]
                ]
            ]
        --, D.div [ klass_ "flex items-center gap-x-4" ]
        --    [ D.div
        --        [ klass_ "hidden sm:flex sm:flex-col sm:items-end" ]
        --        [ D.p [ klass_ "text-sm leading-6 text-gray-900" ] [ text_ "Co-Founder / CEO" ]
        --        , D.p [ klass_ "mt-1 text-xs leading-5 text-gray-500" ]
        --            [ text_ "Last seen "
        --            , D.time [ D.Datetime !:= "2023-01-23T13:23Z" ] [ text_ "3h ago" ]
        --            ]
        --        ]
        --    ]
        ]
    , showIf toggle props.content
    ]
-}