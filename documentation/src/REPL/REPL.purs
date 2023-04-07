module Components.Terminal
  ( repl
  , term
  ) where

import Prelude

import Control.Monad.Reader (ask)
import Data.Array (sort)
import Data.Either (Either(..), hush)
import Data.Filterable (compact)
import Data.Foldable (oneOf)
import Data.Map (lookup, keys)
import Data.Maybe (Maybe(..), maybe)
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested ((/\))
import Deku.Attributes (klass_)
import Deku.Control (text_, text, (<#~>), blank)
import Deku.Core (Nut, NutWith, dyn)
import Deku.DOM as D
import Deku.Hooks (useDyn_, useState', useState)
import Deku.Do as Deku
import Deku.Listeners (click, keyUp, textInput)
import Deku.Toplevel (runInBody)
import Effect (Effect)
import FRP.Event (Event, mapAccum, makeEvent, filterMap)
import FRP.Event.Class (gateBy)
import Web.UIEvent.KeyboardEvent (code)

import Parsing (Position(..), parseErrorPosition, parseErrorMessage, ParseError)

import Components.REPL.PrettyPrint (prettyQuantity)
import Components.REPL.Format (Formatter, format)
import Components.REPL.Format as F
import Components.REPL.Environment (initialEnvironment, Environment(..), StoredValue(..))
import Components.REPL.Parser (Dictionary(..), (==>), normalUnitDict, imperialUnitDict, parseInsect)
import Components.REPL.Interpreter (runInsect, MessageType(..), Message(..), Response)
import Components.REPL.Language (Statement(..))

-- | 
type Env =
  { env :: Event Environment
  , setEnv :: Boolean -> Effect Unit
  }

type REPL = NutWith Env

--history :: REPL
--history = do
--  {env, setEnv } <- ask

-- | Convert a message type to a string.
msgTypeToString :: MessageType -> String
msgTypeToString Info = "info"
msgTypeToString Error = "error"
msgTypeToString Value = "value"
msgTypeToString ValueSet = "value-set"

--repl_ :: Tuple Environment String -> {msg :: String, newEnv :: Environment }
--repl_ (env /\ s) = repl F.fmtPlain env s

data UIAction
  = Quit
  | Copy
  | Clear

--data InputAction
--  = Input
--  | ChangeText String

repl :: Nut
repl = Deku.do
  setEnv /\ env <- useState initialEnvironment
  pushAction /\ action <- useState'
  let
    runInsect_ = \(env /\ stmt) -> runInsect env stmt
    parseInsect_ = \(env /\ str) -> parseInsect env str

    input :: Event String
    input = compact
      ( mapAccum
          ( \a b -> case b of
              Input -> "" /\ Just a
              ChangeText s -> s /\ Nothing
          )
          ""
          action
      )

    response :: Event Response
    response = map runInsect_ (Tuple <$> env <*> parsed)

    parsed :: Event Statement
    parsed = filterMap (parseInsect_ >>> hush)
      (Tuple <$> env <*> input)

  D.div_
    [ D.input
        ( oneOf
            [ textInput $ pure (pushAction <<< ChangeText)
            , klass_ "text-gray-100 bg-gray-800 w-full"
            , keyUp $ pure \evt -> do
                when (code evt == "Enter") $ do
                  pushAction Input
            ]
        )
        []
    , dyn
        $ map
            ( \res -> Deku.do
                { remove, sendTo } <- useDyn_
                viewMessage res.msg
            --setEnv res.newEnv
            --text_ ""
            --res.msg <#> case _ of
            --  Message msgtype m -> text_ ""
            --  _ -> text_ ""
            --res.msg
            )
            response
    ]

viewMessage :: Message -> Nut
viewMessage msg = case msg of
  Message msgType mkup -> text_ (format F.fmtPlain mkup)
  MQuit -> blank
  MCopy -> blank
  MClear -> blank

--repl :: Formatter 
--     -> Environment 
--     -> String 
--     -> { msg ∷ String
--        , newEnv ∷ Environment
--        , msgType ∷ String
--        }
--repl fmt env userInput = 
--  case parseInsect env userInput of
--    Left pErr →
--      let Position rec = parseErrorPosition pErr
--      in
--        { msg: format fmt
--             [ F.optional (F.text "  ")
--             , F.error $ "Parse error at position " <>
--                         show rec.column <> ": "
--             , F.text (parseErrorMessage pErr)
--             ]
--         , msgType: "error"
--         , newEnv: env }
--    Right statement →
--      let ans = runInsect env statement
--      in case ans.msg of
--           Message msgType msg →
--             { msgType: msgTypeToString msgType
--             , msg: format fmt msg
--             , newEnv: ans.newEnv }
--           MQuit →
--              { msgType: "quit"
--              , msg: ""
--              , newEnv: ans.newEnv }
--           MCopy →
--             { msgType: "copy"
--             , msg: value
--             , newEnv: ans.newEnv }
--               where
--                 storedQty (StoredValue _ q) = q
--                 maybeStoredValue = lookup "ans" ans.newEnv.values
--                 value = maybe "" (\sv → format F.fmtPlain (prettyQuantity $ storedQty sv)) maybeStoredValue
--           MClear →
--             { msgType: "clear"
--             , msg: ""
--             , newEnv: ans.newEnv }
data MainUIAction
  = Input
  | ChangeText String

term :: Effect Unit
term = runInBody Deku.do
  pushEnv /\ env <- useState initialEnvironment
  pushAction /\ action <- useState'
  let
    --output :: Event {msg :: String, newEnv :: Environment}
    --output = map repl_ 
    --  (Tuple <$> env <*> accumulateTextAndEmitOnSubmit)

    --setEnv :: Event {msg :: String, msgType :: String, newEnv :: Environment} -> Effect Unit
    setEnv (e :: Event { msg :: String, msgType :: String, newEnv :: Environment }) =
      map pushEnv (_.newEnv <$> e)

    accumulateTextAndEmitOnSubmit :: Event String
    accumulateTextAndEmitOnSubmit = compact
      ( mapAccum
          ( \a b -> case b of
              Input -> a /\ Just a
              ChangeText s -> s /\ Nothing
          )
          ""
          action
      )

    top :: Nut
    top = D.div (klass_ "top mb-2 flex")
      [ D.div (klass_ "h-3 w-3 bg-red-500 rounded-full") []
      , D.div (klass_ "ml-2 h-3 w-3 bg-orange-300 rounded-full") []
      , D.div (klass_ "ml-2 h-3 w-3 bg-green-500 rounded-full") []
      ]

    cmdline :: Nut
    cmdline = D.div (klass_ "text-gra y-100 bg-gray-800")
      [ D.div (klass_ "text-green-300 flex flex-row")
          [ text_ "❯ "
          , D.input
              ( oneOf
                  [ textInput $ pure (pushAction <<< ChangeText)
                  , klass_ "text-gray-100 bg-gray-800 w-full"
                  , keyUp $ pure \evt -> do
                      when (code evt == "Enter") $ do
                        pushAction Input
                  ]
              )
              []
          ]
      ]
  D.div
    ( Alt.do
        klass_ "coding inverse-toggle px-5 pt-4 shadow-lg text-gray-100 text-sm font-mono subpixel-antialiased bg-gray-800  pb-6 pt-4 rounded-lg leading-normal overflow-hidden"
    )
    [ top
    --, dyn
    --    $ map
    --        (\{msg, msgType, newEnv} -> Deku.do
    --          {remove, sendTo } <- useDyn_
    --          D.pre_ [text_ msg]
    --        )
    --        output
    , cmdline
    ]