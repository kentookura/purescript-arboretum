module Components.LeftMatterMobile where

import Prelude

import Components.Link (link, link')
import Contracts (Chapter(..), Page(..))
import Control.Alt ((<|>))
import Control.Plus (empty)
import Data.Foldable (oneOf)
import Data.Newtype (unwrap)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass, klass_)
import Deku.Control (text_)
import Deku.Core (Domable)
import Deku.DOM as D
import FRP.Event (Event)
import Navigation (PushState)
import Pages.Docs (book)
import Router.Route (Route(..))

pageLi
  :: forall lock payload
   . { pageIs :: Route -> Event Unit
     , pageWas :: Route -> Event Unit
     , pushState :: PushState
     }
  -> Page lock payload
  -> Domable lock payload
pageLi { pushState, pageIs, pageWas } (Page { route }) = D.li
  (D.Class !:= "relative")
  [ link pushState route
      ( oneOf
          [ klass $
              ( pure false <|> (pageIs route $> true) <|>
                  (pageWas route $> false)
              ) <#>
                ( if _ then
                    "block w-full pl-3.5 before:pointer-events-none before:absolute before:-left-1 before:top-1/2 before:h-1.5 before:w-1.5 before:-translate-y-1/2 before:rounded-full font-semibold text-sky-500 before:bg-sky-500"
                  else
                    "block w-full pl-3.5 before:pointer-events-none before:absolute before:-left-1 before:top-1/2 before:h-1.5 before:w-1.5 before:-translate-y-1/2 before:rounded-full text-slate-500 before:hidden before:bg-slate-300 hover:text-slate-600 hover:before:block dark:text-slate-400 dark:before:bg-slate-700 dark:hover:text-slate-300"
                )
          ]
      )
  ]

chapterLi
  :: forall lock payload
   . { pageIs :: Route -> Event Unit
     , pageWas :: Route -> Event Unit
     , pushState :: PushState
     }
  -> Chapter lock payload
  -> Domable lock payload
chapterLi opts (Chapter { title, pages }) = D.li_
  [ D.h2
      ( D.Class !:=
          "font-display font-medium text-slate-900 dark:text-white"
      )
      [ text_ title ]
  , D.ul
      ( oneOf
          [ D.Role !:= "list"
          , D.Class !:=
              "mt-2 space-y-2 border-l-2 border-slate-100 dark:border-slate-800 lg:mt-4 lg:space-y-4 lg:border-slate-200"
          ]
      )
      (pageLi opts <$> pages)
  ]

leftMatterMobile
  :: forall lock payload
   . { navModalOpen :: Event Boolean
     , pageIs :: Route -> Event Unit
     , pageWas :: Route -> Event Unit
     , pushState :: PushState
     , darkBoolean :: Event Boolean
     }
  -> Domable lock payload
leftMatterMobile
  { navModalOpen, pushState, darkBoolean, pageIs, pageWas } =
  do
    let opts = { pageIs, pageWas, pushState }
    D.div
      ( oneOf
          [ klass $ navModalOpen <#> (if _ then "" else "hidden ") >>>
              ( _ <>
                  "fixed inset-0 z-50 flex items-start overflow-y-auto bg-slate-900/50 pr-10 backdrop-blur lg:hidden"
              )
          -- , D.AriaLabel !:= "Navigation"
          , D.Id !:= "headlessui-dialog-:R4b6:"
          , D.Role !:= "dialog"
          -- , D.AriaModal !:= "true"
          ]
      )
      [ D.div
          ( oneOf
              [ D.Class !:=
                  "min-h-full w-full max-w-xs bg-white px-4 pt-5 pb-12 dark:bg-slate-900 sm:px-6"
              , D.Id !:= "headlessui-dialog-panel-:r9:"
              ]
          )
          [ D.div (D.Class !:= "flex items-center")
              [ D.button
                  ( oneOf
                      [ D.Xtype !:= "button"
                      -- , D.AriaLabel !:= "Close navigation"
                      , D.Tabindex !:= "0"
                      ]
                  )
                  [ D.svg
                      ( oneOf
                          [ -- D.AriaHidden !:= "true"
                            D.ViewBox !:= "0 0 24 24"
                          , D.Fill !:= "none"
                          , D.StrokeWidth !:= "2"
                          , D.StrokeLinecap !:= "round"
                          , D.Class !:= "h-6 w-6 stroke-slate-500"
                          ]
                      )
                      [ D.path (D.D !:= "M5 5l14 14M19 5l-14 14") [] ]
                  ]
              , link' pushState Home empty
                  [ D.img
                      ( oneOf
                          [
                            --darkBoolean <#> \dk -> D.Src :=
                            --  if dk then dekulogodarkURL else dekulogoURL
                            klass_ "mb-2 ml-6 w-20 object-contain"
                          ]
                      )
                      []
                  ]
              ]
          , D.nav (D.Class !:= "text-base lg:text-sm mt-5 px-1")
              [ D.ul (oneOf [ D.Role !:= "list", D.Class !:= "space-y-9" ])
                  (chapterLi opts <$> unwrap book)
              ]
          ]
      ]