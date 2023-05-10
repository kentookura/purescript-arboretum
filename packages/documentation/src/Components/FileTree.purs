module Components.FileTree
  ( main
  ) where

import Prelude

import Components.Icon (icon)
import Data.Array (replicate)
import Data.Generic.Rep (class Generic)
import Data.Tuple.Nested ((/\))
import Deku.Attributes (klass_)
import Deku.Control (text, text_, (<#~>), guard)
import Deku.Core (Nut)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useRef, useMailboxed, useState)
import Deku.Listeners (click, click_, slider_)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Console (log)
import Effect.Class.Console (logShow)

data Tree a
  = Namespace String (Array (Tree a))
  | Node a

data Listing = Theorem String | Markup String | Definition String

instance showListing :: Show Listing where
  show (Theorem s) = s
  show (Markup s) = s
  show (Definition s) = s

derive instance genericListing :: Generic Listing _

--derive instance genericFiletree :: Generic a => Generic (Filetree Listing) _

algebra :: Tree Listing
algebra = Namespace "Algebra"
  [ Namespace "Groups"
      [ Node (Definition "Group")
      ]
  , Namespace "Rings"
      [ Node (Definition "Ring")
      ]
  , Namespace "Fields"
      [ Node (Definition "Field")
      ]
  ]

analysis :: Tree Listing
analysis =
  Namespace "Analysis"
    [ Node (Theorem "The fundamental theorem of calculus")
    , Namespace "Complex"
        [ Node (Theorem "The Cauchy Integral formula")
        , Node (Markup "Notes")
        ]
    ]

viewNamespace :: Tree Listing -> Nut
viewNamespace t = Deku.do
  D.div [ klass_ "flex flex-column" ]
    [ ( case t of
          Node a ->
            Alt.do
              --workspace $> ?hole
              D.a
                [ klass_ "flex flex-row items-center cursor-pointer h-7"
                , click_ $ log $ show a
                ]
                [ D.span [ klass_ "text-center w-4 h-4" ]
                    [ ( case a of
                          Theorem _ -> icon "M6.429 9.75L2.25 12l4.179 2.25m0-4.5l5.571 3 5.571-3m-11.142 0L2.25 7.5 12 2.25l9.75 5.25-4.179 2.25m0 0L21.75 12l-4.179 2.25m0 0l4.179 2.25L12 21.75 2.25 16.5l4.179-2.25m11.142 0l-5.571 3-5.571-3"

                          Markup _ -> icon "M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"

                          Definition _ -> icon "M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z"
                      )
                    ]
                , D.div [ klass_ "ml-1" ] [ text_ $ show a ]
                ]

          Namespace s ts ->
            Deku.do
              toggle /\ isOpen <- useState false
              D.div
                []
                [ D.a
                    [ klass_ "flex flex-row items-center cursor-pointer h-7"
                    , click $ isOpen <#> not >>> toggle
                    ]
                    [ D.span [ klass_ "text-center w-4 h-4" ]
                        [ isOpen <#~>
                            if _ then
                              icon "M19.5 8.25l-7.5 7.5-7.5-7.5"
                            else icon "M8.25 4.5l7.5 7.5-7.5 7.5"
                        ]
                    , D.div [ klass_ "ml-1" ] [ text_ s ]
                    ]
                , D.div [ klass_ "pl-4" ] (((guard isOpen <<< viewNamespace) <$> ts))
                ]
      )
    ]

--app :: {}
type Env =
  { codebase :: Tree Listing
  --, setCodebase :: (CodebaseTree Listing) -> Effect Unit
  }

type App envB = Env -> envB -> Nut

sidenav :: App { namespace :: Tree Listing }
sidenav = do
  pure \{ namespace } ->
    D.button
      [ klass_ ""
      ]
      [ viewNamespace namespace
      ]

workspace :: App { codebase :: Tree Listing }
workspace = do
  pure \{} -> D.td_ [ text_ "Workspace" ]

app :: App {}
app = do
  mkSide <- sidenav
  mkWorkspace <- workspace
  pure \_ ->
    D.div []
      [ mkSide { namespace: analysis }
      , mkWorkspace { codebase: analysis }
      ]

main :: Effect Unit
main = runInBody Deku.do
  let initial = 50.0
  --setMailbox /\ mailbox <- useMailboxed
  setNum /\ num <- useState initial
  intRef <- useRef initial num
  D.div
    []
    [ D.input
        [ slider_ setNum ]
        []
    , D.div []
        ( replicate 10 Deku.do
            setButtonText /\ buttonText <- useState "Waiting..."
            D.button
              [ klass_ ""
              , click_ $ intRef >>= show >>> setButtonText
              ]
              [ text buttonText ]
        )
    ]
--app { codebase: algebra } {}

{-
workspace :: Nut
workspace =
  Deku.do
    setPos /\ pos <- useState 0
    setItem /\ item <- useState'
    setRemoveAll /\ removeAll <- useState'
    setInput /\ input <- useHot'
    let
      guardAgainstEmpty e = do
        v <- value e
        if v == "" then
          window >>= alert "Item cannot be empty"
        else setItem v
      top =
        D.div_
          [ D.input
              [ D.Value !:= "Tasko primo"
              , keyUp $ pure \evt -> do
                  when (code evt == "Enter") $
                    for_
                      ((target >=> fromEventTarget) (toEvent evt))
                      guardAgainstEmpty
              , D.SelfT !:= setInput
              , klass_ ""
              ]
              []
          , D.input
              [ klass_ ""
              , D.Xtype !:= "number"
              , D.OnChange !:= cb \evt ->
                  traverse_ (valueAsNumber >=> floor >>> setPos) $
                    (target >=> fromEventTarget) evt
              ]
              []
          , D.button
              [ klass_ ""
              , click $ input <#> guardAgainstEmpty
              ]
              [ text_ "Add" ]
          ]
    D.div_
      [ top
      , dyn
          $ map
              ( \(Tuple p t) -> Alt.do
                  removeAll $> Core.remove
                  Deku.do
                    { sendTo, remove } <- useDyn p
                    D.div_
                      [ D.button
                          [ klass_ $ "ml-2 "
                          , click_ (sendTo 0)
                          ]
                          [ text_ "Prioritize" ]
                      , D.button
                          [ klass_ $ "ml-2 "
                          , click_ remove
                          ]
                          [ text_ "Delete" ]
                      , D.button
                          [ klass_ $ "ml-2 "
                          , click_ (setRemoveAll unit)
                          ]
                          [ text_ "Remove all" ]
                      ]
              )
              (Tuple <$> pos <|*> item)
      ]
-}
