module Rope (Rope) where

import Prelude
import Data.String hiding (uncons, null)
import Data.Maybe
import Data.Eq
import Data.Array hiding (drop, take)

data Rope
  = Concat
      { height :: Int
      , length :: Int
      , l :: Rope
      , left_length :: Int
      , r :: Rope
      }
  | Sub
      { contents :: String
      , i0 :: Int
      , length :: Int
      }

instance showRope :: Show Rope where
  show rope = joinWith "" (helper rope)
    where

    helper :: Rope -> Array String
    helper r = case r of
      Sub { contents, i0, length } -> [ subString contents i0 length ]
      Concat { l, r } -> [ mapLeft (helper l), mapRight (helper r) ]

    mapLeft :: Array String -> String
    mapLeft arr = case uncons arr of
      Nothing -> ""
      Just { head: x, tail: xs } ->
        if null xs then
          "/ " <> x
        else
          (" " <> x) <> mapLeft xs

    mapRight :: Array String -> String
    mapRight arr = case uncons arr of
      Nothing -> ""
      Just { head: x, tail: xs } ->
        if null xs then
          "/ " <> x
        else
          ("\\" <> x) <> joinWith "" (map (\t -> " " <> t) xs)

test1 :: Rope
test1 = sub "Hello World!" 0 20

test2 = sub "I am a Rope" 0 20

sub :: String -> Int -> Int -> Rope
sub c i l = Sub { contents: c, i0: i, length: l }

subString :: String -> Int -> Int -> String
subString s i l = drop i s # take l

empty :: Rope
empty = Sub { contents: "", i0: 0, length: 0 }

length :: Rope -> Int
length (Sub t) = t.length
length (Concat t) = t.length

height :: Rope -> Int
height (Sub _) = 0
height (Concat t) = t.height

isempty :: Rope -> Boolean
isempty (Sub t) = t.length == 0
isempty (Concat t) = false

nonempty :: Rope -> Boolean
nonempty (Sub t) = t.length /= 0
nonempty (Concat t) = true

--sub :: String -> Int -> Int -> String
--sub s pos len = drop pos s # take len

--instance showRope :: Show Rope where
--  show rope = case rope of
--    Sub t -> 
--
