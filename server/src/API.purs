module API where

import Prelude hiding ((/))

import Affjax (Error(..))
import Data.Array as A
import Data.Either (Either(..), note)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Class.Console (logShow, log)
import Effect.Uncurried (EffectFn2, runEffectFn2)
import HTTPurple
import Markup.Parser (Doc, blockParser, BlockType)
import Parsing (ParseError(..), runParser)
import Node.FS.Aff (readFile)
import Node.FS.Sync (readTextFile)
import Node.Encoding (Encoding(..))
import API.Options

data Route
  = Home
  | Src String
  | Profile String
  | Account String
  | Doc String
  | Search { q :: String, sorting :: Maybe Sort }
  | SayHello

derive instance Generic Route _

data Sort = Asc | Desc

derive instance Generic Sort _

sortToString :: Sort -> String
sortToString = case _ of
  Asc -> "asc"
  Desc -> "desc"

sortFromString :: String -> Either String Sort
sortFromString = case _ of
  "asc" -> Right Asc
  "desc" -> Right Desc
  val -> Left $ "Not a sort: " <> val

sort :: RouteDuplex' String -> RouteDuplex' Sort
sort = as sortToString sortFromString

foreign import data Json :: Type

foreign import parseJson :: String -> Maybe Json

foreign import getName :: Json -> Maybe String

type HelloWorldRequest = { name :: String }
type HelloWorldResponse = { hello :: String }

testDecoder :: JsonDecoder String HelloWorldRequest
testDecoder = JsonDecoder fromJsonString
  where
  fromJsonString :: String -> Either String HelloWorldRequest
  fromJsonString = (parseJson >=> getName) >>> map { name: _ } >>> note "Invalid json"

testEncoder :: JsonEncoder HelloWorldResponse
testEncoder = JsonEncoder $ \{ hello } -> "{\"hello\": \"" <> hello <> "\" }"

api :: RouteDuplex' Route
api = mkRoute
  { "Home": noArgs
  , "Src": "src" / string segment
  , "Profile": "profile" / string segment
  , "Account": "account" / string segment
  , "Search": "search" ? { q: string, sorting: optional <<< sort }
  , "SayHello": "hello" / noArgs
  , "Doc" : "doc" / string segment
  }

responseHeaders = header "Content-Type" "text/html"

main :: ServerM
main = serve { port: 8080 } { route: api, router: apiRouter }

apiRouter { route: Home } = do
  body <- readFile "./webapp/index.html"
  ok' responseHeaders body
apiRouter { route: Src path } = do
  src <- readFile $ "./webapp/" <> path
  ok' (header "Content-Type" "text/javascript") src
apiRouter { route: Profile profile } = ok $ "hello " <> profile <> "!"
apiRouter { route: Account account } = found' redirect ""
  where
  reverseRoute = print api $ Profile account
  redirect = headers { "Location": reverseRoute }
apiRouter { route: Search { q, sorting } } = ok $ "searching for query " <> q <> " " <> case sorting of
  Just Asc -> "ascending"
  Just Desc -> "descending"
  Nothing -> "defaulting to ascending"
apiRouter {route: Doc string} = do
  ok "asdf"
apiRouter { route: SayHello, method: Post, body } = usingCont do
  { name } :: HelloWorldRequest <- fromJson testDecoder body
  ok' jsonHeaders $ toJson testEncoder $ { hello: name }
apiRouter { route: SayHello } = notFound

getDocument :: String -> Effect (Either Error (Doc BlockType))
getDocument path = do
  res <- readTextFile UTF8 path
  case runParser res blockParser of
    Right m -> pure $ Right m
    Left (ParseError s _) -> pure $ Left (RequestContentError s)

watchDirectories :: Options -> (String -> Array String) -> Effect Unit
watchDirectories {sourceDirectories} glob = 
    (runEffectFn2 gazeImpl)
      (A.concatMap glob sourceDirectories)
      (\(d :: String) -> do
        docs <- getDocument d
        case docs of 
          Left l -> pure unit
          Right r -> logShow r
      ) 


fileGlob :: String -> Array String
fileGlob dir = 
  let go x = dir <> "/**/*" <> x
  in go <$> [".md"]

foreign import gazeImpl :: EffectFn2 (Array String) (String -> Effect Unit) Unit