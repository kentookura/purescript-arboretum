module Markup.Katex
  ( viewKatex
  , KatexSettings
  , defaultOptions
  , toggleDisplay
  , Macros
  , Operator(..)
  , Accent(..)
  ) where

import Prelude 
import Effect (Effect)
import Data.Set
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Type.Data.Boolean (not)
import Web.DOM (Element)

data Operator
  = Sum
  | Product
  | Integral
  | IInt
  | IIInt
  | OInt
  | OOInt
  | OOOInt
  | Bigotimes
  | Bigoplus
  | Bigodot
  | Biguplus
  | Bigvee
  | Bigwedge
  | Bigcap
  | Bigcup
  | Bigsqcup

instance showOperator :: Show Operator where
  show Sum = "\\sum"
  show Product = "\\prod"
  show Integral = "\\int"
  show IInt = "\\iint"
  show IIInt = "\\iiint"
  show OInt = "\\oint"
  show OOInt = "\\ooint"
  show OOOInt = "\\oooint"
  show Bigotimes = "\\bigotimes"
  show Bigoplus = "\\bigoplus"
  show Bigodot = "\\bigodot"
  show Biguplus = "\\biguplus"
  show Bigvee = "\\bigvee"
  show Bigwedge = "\\bigwedge"
  show Bigcap = "\\bigcap"
  show Bigcup = "\\bigcup"
  show Bigsqcup = "\\bigsqcup"

data Accent
  = Prime
  | DoublePrime
  | Acute
  | Bar
  | Dot
  | DDot
  | Grave
  | Hat
  | WideHat
  | Tilde
  | WideTilde
  | UTilde
  | Vec
  | OverLeftArrow
  | UnderLeftArrow
  | OverRightArrow
  | UnderRightArrow
  | OverLeftHarpoon
  | OverRightHarpoon
  | OverRightArrowBig
  | Overline
  | Underline
  | WideCheck
  | Mathring
  | Overgroup
  | Undergroup
  | Overbrace
  | Underbrace
  | Overlinesegment
  | Underlinesegment
  | Underbar

data Limits
  = UpperLimit String
  | LowerLimit String
  | Open String
  | Boundary String
  | Interval String String

instance showLimits :: Show Limits where
  show (UpperLimit s) = "^{" <> s <> "}"
  show (LowerLimit s) = "_{" <> s <> "}"
  show (Open s) = s
  show (Boundary s) = "_{\\partial " <> s <> "}"
  show (Interval a b) = "[" <> a <> ", " <> b <> "]"

data Expr
  = Var String
  | Num Int
  | Plus Expr Expr
  | Minus Expr Expr
  | Times Expr Expr
  | By Expr Expr
  | Equals Expr Expr
  | Custom Binop Expr Expr

data Binop
  = Binop String


instance showBinop :: Show Binop where
  show (Binop s) = s

instance showExpr :: Show Expr where
  show (Var s) = " " <> s
  show (Num i) = show i
  show (Plus e1 e2) = show e1 <> "+" <> show e2
  show (Minus e1 e2) = show e1 <> "-" <> show e2
  show (Times e1 e2) = show e1 <> "\\cdot" <> show e2
  show (By e1 e2) = show e1 <> "/" <> show e2
  show (Equals e1 e2) = show e1 <> "=" <> show e2
  show (Custom op e1 e2) = show e1 <> show op <> show e2
  
instance showAccent :: Show Accent where
  show Prime = "'"
  show DoublePrime = "''"
  show Acute = "\\acute"
  show Bar = "\\bar"
  show Dot = "\\dot"
  show DDot = "\\ddot"
  show Grave = "\\grave"
  show Hat= "\\hat"
  show WideHat= "\\widehat"
  show Tilde = "\\tilde"
  show WideTilde = "\\widetilde"
  show UTilde = "\\utilde"
  show Vec = "\\vec"
  show OverLeftArrow = "\\overleftarrow"
  show UnderLeftArrow = "\\underleftarrow"
  show OverRightArrow = "\\overrightarrow"
  show UnderRightArrow = "\\underrightarrow"
  show OverLeftHarpoon = "\\overleftharppon"
  show OverRightHarpoon = "\\overrightharpoon"
  show OverRightArrowBig = "\\Overrightarrow"
  show Overline = "\\overline"
  show Underline = "\\underline"
  show WideCheck = "\\widecheck"
  show Mathring = "\\mathring"
  show Overgroup = "\\overgroup"
  show Undergroup = "\\undergroup"
  show Overbrace = "\\overbrace"
  show Underbrace = "\\underbrace"
  show Overlinesegment = "\\overlinesegment"
  show Underlinesegment = "\\underlinesegment"
  show Underbar = "\\underbar"
type KatexSettings =
  { displayMode :: Boolean
  , output :: String
  , leqno :: Boolean
  , fleqn :: Boolean
  , throwOnError :: Boolean
  , errorColor :: String
  , minRuleThickens :: Number
  , colorIsTextColor :: Boolean
  , macros :: Array ({define:: String, toBe :: String})
  --, maxSize :: Number
  --, maxExpand :: Number
  , strict :: Boolean
  , trust :: Boolean
  }

defaultOptions :: KatexSettings
defaultOptions = 
  { displayMode : false
  , output : "htmlAndMathMl"
  , leqno : false
  , fleqn : false
  , throwOnError : true
  , errorColor : "#cc0000"
  , minRuleThickens : 0.04
  , colorIsTextColor : true
  , macros : []
  --, maxSize : Number
  -- , maxExpand : Number
  , strict : false
  , trust : false
  }

toggleDisplay :: KatexSettings -> KatexSettings
toggleDisplay ops = case ops.displayMode of
  true ->( ops { displayMode = false})
  false -> ( ops { displayMode = true})
data Macros = Object

foreign import viewKatex :: String -> Element -> KatexSettings -> Effect Unit
foreign import _renderToStringNullable :: String -> { displayMode :: Boolean} -> Effect Unit