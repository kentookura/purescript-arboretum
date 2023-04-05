module Markup.Math.Groups where

import Prelude
import Data.Array (range)
import Prim.Int (class Add, class Mul, class Compare)
import Deku.Attribute ((!:=))
import Deku.Core (Domable, Nut)
import Deku.DOM as D
import Data.Maybe (Maybe)
import Effect (Effect)
import QualifiedDo.Alt as Do


--data Group = Cyclic Int | Dihedral | Symmetric

--data Group :: forall k. k -> Type
--data Group n = Proxy

newtype Mod = Mod Int


compose :: Int -> Int -> Mod -> Int
compose i j (Mod m) = i + j `mod` m

--table :: Int -> Array (Array Int)
--table n = range 0 n

--brute :: (Int -> Array (Array Int)
--brute :: (?T)
--brute n = map (\i k -> ( i + k `mod` n))(tilN) 
--  where tilN = range 0 n


--roteateBy :: Int -> Array Int -> ArrayInt
