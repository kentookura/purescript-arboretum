module Zipper where

-- https://michaeldadams.org/papers/scrap_your_zippers/ScrapYourZippers-2010.pdf
import Lib (css, (|>))
import Prelude
import Data.Maybe (Maybe(..))
import Data.Bifunctor
import Data.List
import Data.Tuple
import Control.Comonad
import Halogen.HTML (HTML, text, span, div, input, button) as HH

--data Zipper t a = Zipper (forall b. Seq b -> t b) Int (Seq a)
type TermZipper = Tuple Term TermContext

data Term
  = Var String
  | Lambda String Term
  | App Term Term
  | If Term Term Term

data TermContext
  = Root
  | Lambda_1 String TermContext
  | App_1 TermContext Term
  | App_2 Term TermContext
  | If_1 TermContext Term Term
  | If_2 Term TermContext Term
  | If_3 Term Term TermContext

viewTerm :: Term -> String
viewTerm t = case t of
  Var s -> s
  Lambda s t -> "\ " <> s <> "( " <> viewTerm t <> " )"
  App f x -> viewTerm f <> viewTerm x
  If b t e -> "if "<> viewTerm b <> " then " <> viewTerm t <> " else " <> viewTerm e

reverse :: forall a. List a -> List a
reverse s = case s of
  Nil -> Nil
  Cons x  xs -> concat (Cons (reverse xs) Nil ) (Cons x Nil)

-- i = list to be reversed
-- o = already reversed
helper :: forall a. List a -> List a -> List a 
helper i o = case i of
  Nil -> o
  Cons x xs -> helper xs (concat o x)

--viewZipper :: TermZipper -> String
--viewZipper z = case z of
--  (Tuple t Root) -> viewTerm t
--  (Tuple t1 (Lambda_1 s c)) -> 
--  (Tuple t1 (App_1 c t2)) -> 
--  (Tuple t2 (App_2 t1 c)) ->
--  (Tuple t1 (If_1 c t2 t3)) ->
--  (Tuple t2 (If_2 t1 c t3)) ->
--  (Tuple t3 (If_3 t1 t2 c)) ->

toZipper :: Term -> TermZipper
toZipper t = Tuple t Root

getHole :: TermZipper -> Term
getHole = fst

getContext :: TermZipper -> TermContext
getContext = snd

setHole :: Term -> TermZipper -> TermZipper
setHole h (Tuple t c) = Tuple h c

fromZipper :: TermZipper -> Term
fromZipper term = case term of
  (Tuple t Root) -> t
  (Tuple t1 (Lambda_1 s c)) -> fromZipper (Tuple (Lambda s t1) c)
  (Tuple t1 (App_1 c t2)) -> fromZipper (Tuple (App t1 t2) c)
  (Tuple t2 (App_2 t1 c)) -> fromZipper (Tuple (App t1 t2) c)
  (Tuple t1 (If_1 c t2 t3)) -> fromZipper (Tuple (If t1 t2 t3) c)
  (Tuple t2 (If_2 t1 c t3)) -> fromZipper (Tuple (If t1 t2 t3) c)
  (Tuple t3 (If_3 t1 t2 c)) -> fromZipper (Tuple (If t1 t2 t3) c)

down :: TermZipper -> Maybe TermZipper
down (Tuple (Var s) c) = Nothing
down (Tuple (Lambda s t) c) = Just (Tuple t (Lambda_1 s c))
down (Tuple (App t1 t2) c) = Just (Tuple t1 (App_1 c t2))
down (Tuple (If b t e) c) = Just (Tuple b (If_1 c t e))

up :: TermZipper -> Maybe TermZipper
up (Tuple t1 (Root)) = Nothing
up (Tuple t1 (Lambda_1 s c)) = Just (Tuple (Lambda s t1) c)
up (Tuple t1 (App_1 c t2)) = Just (Tuple (App t1 t2) c)
up (Tuple t1 (App_2 t2 c)) = Just (Tuple (App t1 t2) c)
up (Tuple t1 (If_1 c t2 t3)) = Just (Tuple (If t1 t2 t3) c)
up (Tuple t2 (If_2 t1 c t3)) = Just (Tuple (If t1 t2 t3) c)
up (Tuple t3 (If_3 t1 t2 c)) = Just (Tuple (If t1 t2 t3) c)

left :: TermZipper -> Maybe TermZipper
left (Tuple t1 (Root)) = Nothing
left (Tuple t1 (Lambda_1 s c)) = Nothing
left (Tuple t1 (App_1 c t2)) = Nothing
left (Tuple t1 (App_2 t2 c)) = Just (Tuple t1 (App_1 c t2))
left (Tuple t1 (If_1 c t2 t3)) = Nothing
left (Tuple t2 (If_2 t1 c t3)) = Just (Tuple t1 (If_1 c t2 t3))
left (Tuple t3 (If_3 t1 t2 c)) = Just (Tuple t2 (If_2 t1 c t2))

right :: TermZipper -> Maybe TermZipper
right (Tuple t1 (Root)) = Nothing
right (Tuple t1 (Lambda_1 s c)) = Nothing
right (Tuple t1 (App_1 c t2)) = Just (Tuple t2 (App_2 t1 c))
right (Tuple t1 (App_2 t2 c)) = Nothing
right (Tuple t1 (If_1 c t2 t3)) = Just (Tuple t2 (If_2 t1 c t3))
right (Tuple t2 (If_2 t1 c t3)) = Just (Tuple t3 (If_3 t1 t2 c))
right (Tuple t3 (If_3 t1 t2 c)) = Nothing
