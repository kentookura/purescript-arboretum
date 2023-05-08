module Markup.Parser.Utils
  ( isWhitespace
  , isEmailAddress
  , parens
  , braces
  , squares
  , skipSpaces
  ) where

import Prelude

import Prelude

import Data.Either (fromRight)
import Data.String.CodeUnits (singleton)
import Data.String.Regex as R
import Data.String.Regex.Unsafe as RU
import Data.String.Regex.Flags as RF

import Partial.Unsafe (unsafePartial)

import Parsing (Parser)
import Parsing.Combinators (skipMany)
import Parsing.String (string, satisfy)

isWhitespace :: Char -> Boolean
isWhitespace = R.test wsRegex <<< singleton
  where
  wsRegex :: R.Regex
  wsRegex = RU.unsafeRegex "^\\s$" RF.noFlags

isEmailAddress :: String -> Boolean
isEmailAddress = R.test wsEmail
  where
  wsEmail :: R.Regex
  wsEmail = RU.unsafeRegex """^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$""" RF.noFlags

parens :: forall a. Parser String a -> Parser String a
parens p = string "(" *> skipSpaces *> p <* skipSpaces <* string ")"

braces :: forall a. Parser String a -> Parser String a
braces p = string "{" *> skipSpaces *> p <* skipSpaces <* string "}"

squares :: forall a. Parser String a -> Parser String a
squares p = string "[" *> skipSpaces *> p <* skipSpaces <* string "]"

skipSpaces :: Parser String Unit
skipSpaces = skipMany (satisfy isWhitespace)