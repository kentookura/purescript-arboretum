module Markup.Parser.References where

import Prelude

import Data.Array as A
import Data.Either as E
import Data.Maybe as M
import Data.String (trim) as S
import Data.String.CodeUnits (fromCharArray) as S

import Parsing as P
import Parsing.Combinators as PC
import Parsing.String as PS

import Markup.Syntax as SD
import Markup.Parser.Utils as PU

parseLinkReference ∷ ∀ a. String → M.Maybe SD.Block
parseLinkReference = E.either (const M.Nothing) M.Just <<< flip P.runParser linkReference

linkReference ∷ ∀ a. P.Parser String SD.Block
linkReference = do
  l ←
    charsToString <$> do
      _ ← PS.string "["
      PU.skipSpaces
      PC.manyTill PS.anyChar (PS.string "]")
  _ ← PS.string ":"
  PU.skipSpaces
  uri ← charsToString <$> PC.manyTill PS.anyChar PS.eof
  pure $ SD.LinkReference l uri

  where
    charsToString =
      S.trim
        <<< S.fromCharArray
        <<< A.fromFoldable