module Test.Rope where

import Prelude
import Effect (Effect)
import Rope
import Test.Unit (suite, test)
import Test.Unit.Main (runTest)
import Test.Unit.Console (print)
import Test.Unit.Assert as Assert

--main :: Effect Unit
--main = runTest do
--  suite "Rope" do
--    test "view" do
