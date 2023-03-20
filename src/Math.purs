module Math
  ( contextKatex
  , editor
  , OperatorContext
  , inline
  , display
  ) where

import Prelude
import Katex (toggleDisplay, defaultOptions, viewKatex, KatexSettings)
import Data.Maybe
import Deku.Attribute ((!:=), cb)
import Deku.Attributes (klass_)
import Deku.Core (dyn, Nut, Domable, DOMInterpret(..))
import Deku.Control (text, text_, (<$~>), (<#~>))
import Deku.Do as Deku
import Deku.Listeners (slider_, click_, click)
import Deku.DOM as D
import Deku.Hooks (useDyn_, useState)
import Deku.Toplevel (runInBody)
import FRP.Event (Event)
import FRP.Event.Class ((<|*>))
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Web.DOM (Element)
import QualifiedDo.Alt as Alt
import Effect.Class.Console (logShow)

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

data Accent a
  = Prime a
  | DoublePrime a
  | Acute a
  | Bar a
  | Dot a
  | DDot a
  | Grave a
  | Hat a
  | WideHat a
  | Tilde a
  | WideTilde a
  | UTilde a
  | Vec a
  | OverLeftArrow a
  | UnderLeftArrow a
  | OverRightArrow a
  | UnderRightArrow a
  | OverLeftHarpoon a
  | OverRightHarpoon a
  | OverRightArrowBig a
  | Overline a
  | Underline a
  | WideCheck a
  | Mathring a
  | Overgroup a
  | Undergroup a
  | Overbrace a
  | Underbrace a
  | Overlinesegment a
  | Underlinesegment a
  | Underbar a

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

type Expression
  = { operator :: Operator, limits :: Limits, expr :: Expr }

testExpression =
  { operator: Integral
  , limits: Boundary "\\Omega"
  , expr: Var "\\nabla f(\\xi) d \\xi"
  }

constructKatex :: Expression -> String
constructKatex expr = show expr.operator <> show expr.limits <> show expr.expr

contextKatex :: OperatorContext -> String
contextKatex ctx = case ctx of
  Top -> ""
  SelectOperator op _ -> "\\htmlStyle{color:grey;}{ " <> show op <> "}"
  ConstructUpperLimit op s -> show op <> "_{" <> s <> "}^\\box"
  ConstructLowerLimit op s -> show op <> "_{\\box}^{" <> s <> "}"

data OperatorContext
  = Top
  | SelectOperator Operator String
  | ConstructUpperLimit Operator String
  | ConstructLowerLimit Operator String

instance showOperatorContext :: Show OperatorContext where
  show Top = ""
  show (SelectOperator op s) = s
  show (ConstructUpperLimit op s) = show op <> "_{" <> s <> "}^\\box"
  show (ConstructLowerLimit op s) = show op <> "_{\\box}^{" <> s <> "}"

type ExpressionZipper
  = { filler :: Expression, context :: OperatorContext }

toZipper :: Expression -> ExpressionZipper
toZipper e = { filler: e, context: Top }

testZipper :: ExpressionZipper
testZipper = toZipper testExpression

--testZipper2 = toZipper (Op Integral (Raw "0") (Raw "t"))
--fromZipper :: OperatorZipper -> Markup
--fromZipper z = case z.context of
--  Top -> z.filler
--  Op_1 op m1 m2 -> Op op m1 m2
--  Op_2 op c m -> fromZipper { filler: Op z.filler m, context: c}
--  Op_3 op m c -> fromZipper { filler: Op m z.filler, context: c}
--type StringContext = {head:: String, }
--down :: OperatorZipper -> Maybe MarkupZipper
--down z = case z.context of
--  Top -> Nothing
--  Op_1 op m1 m2 -> Nothing
--  Op_2 op c m -> Just { filler: op, context: c }
--  Op_3 op m c -> Just { filler: op, context: c }
--data Markup = Op Operator Markup Markup | Raw String

editor :: Nut
editor =
     Deku.do
        setContent /\ content <- useState testZipper
        setConfig /\ config <- useState defaultOptions
        setString /\ math <- useState "abc"
        D.div_
          [ render {config, katex: math}
          , D.button Alt.do
              click $ config <#> toggleDisplay >>> setConfig
              klass_ "cursor-pointer"
            [ text_ "Toggle Display" ]
          , D.ul_
              $ map
                  ( \op ->
                      D.li
                        ( Alt.do
                            D.Self
                              !:= \(e :: Element) -> do
                                  viewKatex (show op) e (defaultOptions {displayMode = true})
                        --D.OnClick !:= cb \e -> 
                        --click_ (setOperator op)
                        )
                        []
                  )
                  [ Sum
                  , Integral
                  , Bigotimes
                  , Bigoplus
                  , Product
                  ]
          ]

inline :: String -> KatexSettings -> Nut
inline s config =
  D.span Alt.do
    D.Self !:= \(e :: Element) -> do
      viewKatex s e (config {displayMode = false})
  []


display :: String -> KatexSettings -> Nut
display s config =
  D.span Alt.do
    D.Self !:= \(e :: Element) -> do
      viewKatex s e (config { displayMode = true })
  []

render ::
  forall lock payload.
  { config :: Event KatexSettings
  , katex :: Event String
  } ->
  Domable lock payload
render { config, katex } = 
  (Tuple <$> config <*> katex ) <#~>
    \(cfg /\ ktx) ->
      D.span Alt.do
        D.Self !:= \elt -> do
          viewKatex ktx elt cfg
      []

