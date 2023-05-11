module API where

import Prelude hiding ((/))

import Affjax (Error(..))
import Data.Array as A
import Data.Either (Either(..), note)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class.Console (logShow, log)
import Effect.Uncurried (EffectFn2, runEffectFn2)
import HTTPurple
import Markup.Parser (Doc, blockParser, BlockType)
import Parsing (ParseError(..), runParser)
import Node.FS.Aff (readFile)
import Node.FS.Sync (readTextFile)
import Node.Encoding (Encoding(..))
import API.Options
import HTTPurple.Json.Argonaut as Argonaut
import Markup.Namespace
import Markup.Parser (parseMarkup)
import Markup.Syntax (Markup)

type Reference = String

data Route
  = Home
  | Src String
  | Namespace String
  | Doc Reference

derive instance Generic Route _

api :: RouteDuplex' Route
api = mkRoute
  { "Home": noArgs
  , "Src": "src" / string segment
  , "Namespace" : "namespaces" / string segment
  , "Doc" : "doc" / string segment
  }

htmlHeader = header "Content-Type" "text/html"

port :: Int
port = 8080

main :: ServerM
main = serve { port: port } { route: api, router: apiRouter }


apiRouter :: forall r. { route :: Route | r } -> ResponseM
apiRouter { route: Home } = do
  body <- readFile "./webapp/index.html"
  ok' htmlHeader body

apiRouter { route: Src path } = do
  src <- readFile $ "./webapp/" <> path
  ok' (header "Content-Type" "text/javascript") src

apiRouter {route: Namespace s} = do
  ok' jsonHeaders $ toJson Argonaut.jsonEncoder $ getNamespace s

apiRouter { route: Doc ref} = do
  body <- readFile $ "./markdown/" <> ref <> ".md"
  ok' (header "Content-Type" "text/plain") body

getNamespace :: String -> Maybe (Tree Listing)
getNamespace s
  | s == "algebra" = Just algebra
  | s == "analysis" = Just analysis
  | otherwise = Nothing


getDocument :: String -> Effect (Either Error Markup)
getDocument path = do
  res <- readTextFile UTF8 path
  case parseMarkup res of
    Right m -> pure $ Right m
    Left (ParseError s _) -> pure $ Left (RequestContentError s)



watchDirectories :: Options -> (String -> Array String) -> Effect Unit
watchDirectories {sourceDirectories} glob = 
  (runEffectFn2 gazeImpl)
    (A.concatMap glob sourceDirectories)
    (\(d :: String) -> do
      docs <- getDocument d
      log "what to do"
    ) 


fileGlob :: String -> Array String
fileGlob dir = 
  let go x = dir <> "/**/*" <> x
  in go <$> [".md"]

foreign import gazeImpl :: EffectFn2 (Array String) (String -> Effect Unit) Unit