module Main
  ( main
  ) where

import Prelude hiding ((/))

import Frontend.Components.Sidebar (viewNamespace)

--import Backend (Route(..), api)
import Control.Monad.Reader
import Data.Either (Either)
import Deku.Attributes (klass_)
import Deku.Core (Nut)
import Deku.Control (text_)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Hooks (useState)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Class.Console (logShow)
import Fetch (Method(..), fetch, RequestMode(..))
import Routing.Duplex (print)
import Fetch.Argonaut.Json (fromJson)
import Markup.Namespace (Tree, Listing)
import Markup.Parser (parseMarkup)
import Markup.Syntax (Markup)
import Parsing (ParseError)
import Data.Generic.Rep (class Generic)
import Routing.Duplex (RouteDuplex', string, segment)
import Routing.Duplex.Generic (noArgs)
import Routing.Duplex.Generic.Syntax ((/))
import HTTPurple (mkRoute)

type Reference = String

data Route
  = Home
  | Src String
  | Namespaces String
  | Docs Reference

api :: RouteDuplex' Route
api = mkRoute
  { "Home": noArgs
  , "Src": "src" / string segment
  , "Namespaces" : "namespaces" / string segment
  , "Docs" : "doc" / string segment
  }

derive instance Generic Route _

main :: Effect Unit
main = launchAff_ do
  { json } <- get $ Namespaces "analysis"
  namespace :: Tree Listing <- fromJson json
  markdown <- get_ $ Docs "index"
  logShow namespace
  logShow markdown
  liftEffect $
    runInBody
      ( Deku.do
          viewNamespace namespace 
      )

apiURL :: String
apiURL = "http://127.0.0.1"

jsonHeaders = { "Content-Type": "application/json" }

get :: Route -> Aff _
get route = do
  fetch (apiURL <> ":8080" <> (print api $ route))
    { method: GET
    , mode: Cors
    , headers: jsonHeaders
    }

get_ :: Route -> Aff (Either ParseError Markup)
get_ route = do
  { text } <- fetch (apiURL <> ":8080" <> (print api $ route))
    { method: GET
    , headers: jsonHeaders
    }
  content <- text
  pure $ parseMarkup content
{-
type Env =
  { codebase :: Tree Listing
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

app :: Nut
app = Deku.do
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