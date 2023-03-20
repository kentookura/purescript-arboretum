module Test.Main where

import Prelude
import Effect (Effect)
import Zipper (Term(..), TermZipper, TermContext(..), viewTerm, viewZipper)
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Console (print)
import Test.Unit.Assert as Assert

test0 :: TermZipper
test0 =
  { filler: Lambda "s" (Var "x")
  , context: Root
  }

test1 :: TermZipper
test1 =
  { filler: Lambda "s" (Var "x")
  , context: Lambda_1 "t" Root
  }

test2 :: TermZipper
test2 =
  { filler: Lambda "s" (Var "x")
  , context: App_1 (Lambda_1 "t" Root) (Var "test2")
  }

test3 :: TermZipper
test3 =
  { filler: Lambda "s" (Var "x")
  , context: App_2 (Var "test3") Root
  }

test4 :: TermZipper
test4 =
  { filler: Lambda "s" (Var "x")
  , context: If_1 Root (Var "then_4") (Var "else_4")
  }

test5 :: TermZipper
test5 =
  { filler: Lambda "s" (Var "x")
  , context: If_2 (Var "bool_5") Root (Var "else_5")
  }

test6 :: TermZipper
test6 =
  { filler: Lambda "s" (Var "x")
  , context: If_3 (Var "bool_6") (Var "then_6") Root
  }

main :: Effect Unit
main = runTest do
  suite "terms" do
    test "view" do
      Assert.equal "x" (viewTerm $ Var "x")
      Assert.equal "\\s.f(s)" (viewTerm $ Lambda "s" (Var "f(s)"))
      Assert.equal "\\s.f(s) (x)" (viewTerm $ App (Lambda "s" (Var "f(s)")) (Var "x"))
      Assert.equal "if b then t else e" (viewTerm $ If (Var "b") (Var "t") (Var "e"))
  suite "zippers" do
    test "view" do
      Assert.equal ("{" <> (viewTerm test0.filler) <> "}") (viewZipper test0)
      Assert.equal "\\t.{\\s.x}" (viewZipper test1)
      Assert.equal "\\t.{\\s.x}test2" (viewZipper test2)
      Assert.equal "" (viewZipper test3)
      Assert.equal "" (viewZipper test4)
      Assert.equal "" (viewZipper test5)
      Assert.equal "" (viewZipper test6)
