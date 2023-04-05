module Markup.Penrose
  ( homotopyStyle
  , myProgram
  , penroseExample
  , tabButton
  , viewSources
  )
  where

import Prelude
import Web.DOM (Element)
import Data.List (List)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested ((/\))
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)
import Deku.Core (Domable, Nut)
import Deku.Control (text_, (<#~>), blank)
import Deku.Do as Deku
import Deku.DOM as D
import Deku.Hooks (useState)
import Deku.Listeners (click_, textInput_)
import Data.Maybe (Maybe)
import Effect (Effect)
import Effect.Class.Console (logShow)
import FRP.Event (Event, makeEvent)
import QualifiedDo.Alt as Alt
import Markup.Syntax (Markup)

type Path = String

--class Render a where
--  render :: a -> Nut

type Substance = String
type Style = String
type Domain = String

myProgram =
  { domain: myDomain
  , style: myStyle
  , substance: mySubstance
  , variation: myVariation
  }

homotopyExample :: Nut
homotopyExample = render { domain: homotopyDomain, style: homotopyStyle, substance: homotopySubstance, variation: "" }

penroseExample :: Nut
penroseExample = render myProgram

--render :: forall a. Diagram a => a -> Nut

render
  :: { domain :: String
     , style :: String
     , substance :: String
     , variation :: String
     }
  -> Nut
render p =
  D.span
    Alt.do
      D.Self !:= \(elt :: Element) -> do
        diagram p elt "pathresolver" (Just "Hello World!")
    []

data File = Substance | Style | Domain

extension :: File -> String
extension Substance = ".sub"
extension Style = ".sty"
extension Domain = ".dom"

tabButton :: String
tabButton = "font-mono mb-0 flex w-full cursor-pointer items-center justify-center rounded-lg border-0 px-0 py-1 transition-all ease-in-out"
viewSources
  :: { domain :: String
     , style :: String
     , substance :: String
     , variation :: String
     }
  -> Nut
viewSources p = Deku.do
  viewFile /\ filetype <- useState Substance
  D.div
    Alt.do
      klass_ "relative right-0"
    [ D.ul
        Alt.do
          klass_ "relative flex list-none flex-wrap rounded-lg p-1 mt-0"
      $
        map
          ( \(Tuple ft ext) ->
              D.li
                Alt.do
                  let base = "flex-auto text-center"
                  klass_ ""
                [ D.a
                    Alt.do
                      klass_ tabButton
                      click_ $ viewFile ft
                    [ text_ ext ]
                ]
          )
          [ (Substance /\ ".sub")
          , (Domain /\ ".dom")
          , (Style /\ ".sty")
          ]
    , D.pre
        (D.Class !:= ("prism-code"))
        [ D.code_
            [ filetype <#~>
                case _ of
                  Substance -> text_ p.substance
                  Style -> text_ p.style
                  Domain -> text_ p.domain
            ]
        ]
    ]

foreign import diagram
  :: { domain :: String
     , style :: String
     , substance :: String
     , variation :: String
     }
  -> Element
  -> Path
  -> Maybe String
  -> Effect Unit

mySubstance =
  """Set A, B, C, D
IsSubset(A, B)
IsSubset(B, C)
AutoLabel All
"""

homotopyStyle =
  """
canvas {
    width = 600
    height = 400
}

forall Curve c {
    vec2 c.p1 = (?, ?)
    vec2 c.p2 = (?, ?)
    vec2 c.p3 = (?, ?)
    vec2 c.p4 = (?, ?)

    points = [c.p1, c.p2, c.p3, c.p4]
    shape curve = Path {
        d: cubicCurveFromPoints("open", points)
        strokeWidth: 2.5
        ensureOnCanvas: true
        strokeColor: rgba(0, 0, 0, 1)
    }
    
    ensure equal(vdist(c.p1, c.p2), vdist(c.p2, c.p3))
    ensure equal(vdist(c.p2, c.p3), vdist(c.p3, c.p4))
    ensure equal(perimeter(points), 500)
}

forall Point p {
    vec2 p.p = (?, ?) 
}


forall Point p; Point p1; Point p2 
where p := Lerp(p1, p2) {
    vec2 p3 = 0.5 * (p1.p + p2.p)
    override p.p = p3
    ensure lessThan(vdist(p1.p, p2.p), 200)
}

forall Curve c; Point p1; Point p2; Point p3; Point p4
where c := CurveFromPoints(p1, p2, p3, p4) {
    override p1.p = c.p1
    override p2.p = c.p2
    override p3.p = c.p3
    override p4.p = c.p4
}
"""

myStyle =
  """
canvas {
  width = 800
  height = 700
}

forall Set x {
  x.icon = Circle {
    strokeWidth : 0
  }

  x.text = Equation {
    string : x.label
    fontSize : "25px"
  }

  ensure contains(x.icon, x.text)
  encourage sameCenter(x.text, x.icon)
  x.textLayering = x.text above x.icon
}

forall Set x; Set y
where IsSubset(x, y) {
  ensure smallerThan(x.icon, y.icon)
  ensure disjoint(y.text, x.icon, 10)
  ensure contains(y.icon, x.icon, 5)
  x.icon above y.icon
}

forall Set x; Set y
where Not(Intersecting(x, y)) {
  ensure disjoint(x.icon, y.icon)
}

forall Set x; Set y
where Intersecting(x, y) {
  ensure overlapping(x.icon, y.icon)
  ensure disjoint(y.text, x.icon)
  ensure disjoint(x.text, y.icon)
}

"""

homotopySubstance =
  """
Point a1, b1, d1
Point a2, b2, d2

Point c1 := Lerp( b1, d1 )
Point c2 := Lerp( b2, d2 )

Curve curve1 := CurveFromPoints( a1, b1, c1, d1 )
Curve curve2 := CurveFromPoints( a2, b2, c2, d2 )

Point a12 := Lerp( a1, a2 )
Point b12 := Lerp( b1, b2 )
Point c12 := Lerp( c1, c2 )
Point d12 := Lerp( d1, d2 )

Curve curve12 := CurveFromPoints( a12, b12, c12, d12 )

Point a112 := Lerp( a1, a12 )
Point b112 := Lerp( b1, b12 )
Point c112 := Lerp( c1, c12 )
Point d112 := Lerp( d1, d12 )

Curve curve112 := CurveFromPoints( a112, b112, c112, d112 )

Point a122 := Lerp( a12, a2 )
Point b122 := Lerp( b12, b2 )
Point c122 := Lerp( c12, c2 )
Point d122 := Lerp( d12, d2 )

Curve curve122 := CurveFromPoints( a122, b122, c122, d122 )

Label curve1 $\gamma_1$
Label curve2 $\gamma_2$
"""

myDomain =
  """
type Set
predicate Not(Prop p1)
predicate Intersecting( Set s1, Set s2)
predicate IsSubset(Set, Set)
"""

homotopyDomain =
  """
type Curve
type Point

constructor CurveFromPoints( Point p1, Point p2, Point p3, Point p4 ) -> Curve
constructor Lerp( Point p1, Point p2 ) -> Point
"""

myVariation = ""