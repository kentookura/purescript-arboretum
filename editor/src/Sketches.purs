module Sketch where

import Prelude
import Data.Either (Either(..))
import Data.List (List(..), (:))

data Expr = Val Int | Add Expr Expr
type Stack = List (Either Expr Int)

eval :: Expr -> Int
eval e = load e Nil

load :: Expr -> Stack -> Int
load (Val i) stk = unload i stk
load (Add e1 e2) stk = load e1 ((Left e2) : stk)

unload :: Int -> Stack -> Int
unload v Nil = v
unload v1 (Left e2 : stk) = load e2 (Right v1 : stk)
unload v2 (Right v1 : stk) = unload (v1 + v2) stk
