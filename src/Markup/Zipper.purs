module Zipper
  ( Term(..)
  , TermContext(..)
  , TermZipper
  , down
  , fromZipper
  , getContext
  , getHole
  , left
  , right
  , setHole
  , toZipper
  , up
  , viewTerm
  , viewZipper
  )
  where

-- https://michaeldadams.org/papers/scrap_your_zippers/ScrapYourZippers-2010.pdf
import Data.Foldable
import Prelude
import Data.Maybe (Maybe(..))
import Data.Bifunctor
import Data.List
import Data.Tuple
import Control.Comonad

--data Zipper t a = Zipper (forall b. Seq b -> t b) Int (Seq a)
type TermZipper = { filler :: Term, context :: TermContext }

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
  Lambda s t -> foldl append mempty [ "\\", s, ".", viewTerm t ]
  App f x -> foldl append mempty [ viewTerm f, " (", viewTerm x, ")" ]
  If b t e -> foldl append mempty [ "if ", viewTerm b, " then ", viewTerm t, " else ", viewTerm e ]

--viewHole :: forall w i. Term -> HH.HTML w i
--viewHole = viewTerm >>> HH.text

viewZipper :: TermZipper -> String
viewZipper z = acc (z.context) (viewTerm z.filler)
  where
  acc :: TermContext -> String -> String
  acc i o = case i of
    Root -> foldl append mempty [ "{", o, "}" ]
    (Lambda_1 s c) -> foldl append mempty [ "\\", s, ".", acc c o ]
    (App_1 c t2) -> foldl append mempty [ acc c o, viewTerm t2 ]
    (App_2 t1 c) -> foldl append mempty [ acc c o ]
    (If_1 c t2 t3) -> foldl append mempty [ "if ", acc c o, " then ", viewTerm t2, "else ", viewTerm t3 ]
    (If_2 t1 c t3) -> foldl append mempty [ "if ", viewTerm t1, " then ", acc c o, "else ", viewTerm t3 ]
    (If_3 t1 t2 c) -> foldl append mempty [ "if ", viewTerm t1, " then ", viewTerm t2, "else ", acc c o ]


toZipper :: Term -> TermZipper
toZipper t = { filler: t, context: Root }

getHole :: TermZipper -> Term
getHole z = z.filler

getContext :: TermZipper -> TermContext
getContext z = z.context

setHole :: Term -> TermZipper -> TermZipper
setHole h z = z { filler = h }

fromZipper :: TermZipper -> Term
fromZipper z = case z.context of
  Root -> z.filler
  Lambda_1 s c -> fromZipper { filler: Lambda s z.filler, context: c }
  App_1 c t2 -> fromZipper { filler: App z.filler t2, context: c }
  App_2 t1 c -> fromZipper { filler: App t1 z.filler, context: c }
  If_1 c t2 t3 -> fromZipper { filler: If z.filler t2 t3, context: c }
  If_2 t1 c t3 -> fromZipper { filler: If t1 z.filler t3, context: c }
  If_3 t1 t2 c -> fromZipper { filler: If t1 t2 z.filler, context: c }

down :: TermZipper -> Maybe TermZipper
down z = case z.filler of
  Var s -> Nothing
  Lambda s t -> Just { filler: t, context: Lambda_1 s z.context }
  App t1 t2 -> Just { filler: t1, context: App_1 z.context t2 }
  If b t e -> Just { filler: b, context: If_1 z.context t e }

up :: TermZipper -> Maybe TermZipper
up z = case z.context of
  Root -> Nothing
  Lambda_1 s c -> Just { filler: Lambda s z.filler, context: c }
  App_1 c t2 -> Just { filler: App z.filler t2, context: c }
  App_2 t1 c -> Just { filler: App t1 z.filler, context: c }
  If_1 c t2 t3 -> Just { filler: If z.filler t2 t3, context: c }
  If_2 t1 c t3 -> Just { filler: If t1 z.filler t3, context: c }
  If_3 t1 t2 c -> Just { filler: If t1 t2 z.filler, context: c }

left :: TermZipper -> Maybe TermZipper
left z = case z.context of
  Root -> Nothing
  Lambda_1 s c -> Nothing
  App_1 c t2 -> Nothing
  App_2 t1 c -> Just { filler: t1, context: App_1 c z.filler }
  If_1 c t2 t3 -> Nothing
  If_2 t1 c t3 -> Just { filler: t1, context: If_1 c z.filler t3 }
  If_3 t1 t2 c -> Just { filler: t2, context: If_2 t1 c z.filler }

right :: TermZipper -> Maybe TermZipper
right z = case z.context of
  Root -> Nothing
  Lambda_1 s c -> Nothing
  App_1 c t2 -> Just { filler: t2, context: App_2 z.filler c }
  App_2 t2 c -> Nothing
  If_1 c t2 t3 -> Just { filler: t2, context: If_2 z.filler c t3 }
  If_2 t1 c t3 -> Just { filler: t3, context: If_3 t1 z.filler c }
  If_3 t1 t2 c -> Nothing
