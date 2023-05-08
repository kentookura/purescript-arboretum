module Main where

import Prelude hiding ((/))

import Data.Either (Either(..), note)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import HTTPurple
import Node.FS.Aff (readFile)

data Route
  = Home
  | Src String
  | Profile String
  | Account String
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
  }

responseHeaders = header "Content-Type" "text/html"

main :: ServerM
main = serve { port: 8080 } { route: api, router: apiRouter }
  where
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
  apiRouter { route: SayHello, method: Post, body } = usingCont do
    { name } :: HelloWorldRequest <- fromJson testDecoder body
    ok' jsonHeaders $ toJson testEncoder $ { hello: name }
  apiRouter { route: SayHello } = notFound