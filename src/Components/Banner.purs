module Components.Banner where

import Prelude

import Assets (blurCyanURL, blurIndigoURL)
import Control.Alt ((<|>))
import Data.Foldable (oneOf)
import Data.Monoid (guard)
import Data.Tuple.Nested ((/\))
import Deku.Attribute (xdata, (!:=))
import Deku.Attributes (klass, klass_)
import Deku.Control (switcher, text_)
import Deku.Core (Domable)
import Deku.DOM as D
import Deku.Hooks (useMemoized, useState)
import Deku.Do as Deku
import Deku.Listeners (click_)
import Effect (Effect)
import FRP.Dedup (dedup)
import FRP.Event (Event)
import Prism (forceHighlight)

--foreign import addConfetti :: Effect Unit

data BannerExample = CodeExample | ButtonExample

derive instance Eq BannerExample

bannerExampleOuterSelected :: String
bannerExampleOuterSelected =
  "cursor-pointer flex h-6 rounded-full bg-gradient-to-r from-sky-400/30 via-sky-400 to-sky-400/30 p-px font-medium text-sky-300"

bannerExampleInnerSelected :: String
bannerExampleInnerSelected =
  "flex items-center rounded-full px-2.5 bg-slate-800"

bannerExampleOuterNotSelected :: String
bannerExampleOuterNotSelected =
  "cursor-pointer flex h-6 rounded-full text-slate-500"

bannerExampleInnerNotSelected :: String
bannerExampleInnerNotSelected = "flex items-center rounded-full px-2.5"

banner
  :: forall lock payload
   . { showBanner :: Event Boolean }
  -> Domable lock payload
banner { showBanner } = D.div
  ( klass $ showBanner <#> not >>> flip guard "hidden " >>>
      ( _ <>
          "overflow-hidden bg-slate-900 dark:-mb-32 dark:mt-[-4.5rem] dark:pb-32 dark:pt-[4.5rem] dark:lg:mt-[-4.75rem] dark:lg:pt-[4.75rem]"
      )
  )
  [ D.div (D.Class !:= "py-16 sm:px-2 lg:relative lg:py-20 lg:px-0")
      [ D.div
          ( D.Class !:=
              "mx-auto grid max-w-2xl grid-cols-1 items-center gap-y-16 gap-x-8 px-4 lg:max-w-8xl lg:grid-cols-2 lg:px-8 xl:gap-x-16 xl:px-12"
          )
          [ D.div (D.Class !:= "relative z-10 md:text-center lg:text-left")
              [ D.img
                  ( oneOf
                      [ D.Alt !:= ""
                      , D.Src !:= blurCyanURL
                      , D.Width !:= "530"
                      , D.Height !:= "530"
                      , D.Decoding !:= "async"
                      , pure (xdata "nimg" "1")
                      , D.Class !:=
                          "absolute bottom-full right-full -mr-72 -mb-56 opacity-50"
                      , D.Style !:= "color:transparent"
                      ]
                  )
                  []
              , D.div (D.Class !:= "relative")
                  [ D.p
                      ( D.Class !:=
                          "inline bg-gradient-to-r from-indigo-200 via-sky-400 to-indigo-200 bg-clip-text font-display text-5xl tracking-tight text-transparent"
                      )
                      [ text_ "Structure Editing for Mathematical Markup" ]
                  --, D.p
                  --    ( D.Class !:=
                  --        "mt-3 text-2xl tracking-tight text-slate-400"
                  --    )
                  --    [ text_
                  --        "A PureScript UI framework for building reactive games and web apps."
                  --    ]
                  ]
              ]
          ]
      ]
  ]