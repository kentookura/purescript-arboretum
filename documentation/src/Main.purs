module Main where

import Prelude

import Components.App (app)
import Control.Alt ((<|>))
import DarkModePreference (OnDark(..), OnLight(..), darkModeListener, prefersDarkMode)
import Data.Compactable (compact)
import Data.Foldable (traverse_)
import Data.Generic.Rep (class Generic)
import Data.Map as Map
import Data.Maybe (Maybe(..), maybe)
import Data.Show.Generic (genericShow)
import Data.Set (empty)
import Data.Tuple (Tuple(..), curry, fst, snd, uncurry)
import Deku.Core (envy)
import Deku.Do as Deku
import Deku.Toplevel (runInBody)
import Effect (Effect)
import Effect.Class.Console (logShow)
import Effect.Ref as Ref
import FRP.Dedup (dedup)
import FRP.Event (create, fold, mailboxed, memoize, subscribe)
import FRP.Lag (lag)
import Router.Route (Route(..), route)
import Router.Page (routeToPage)
import Routing.Duplex (parse)
import Routing.PushState (makeInterface, matchesWith)
import Web.DOM.Element (getBoundingClientRect)
import Web.Event.Event (EventType(..))
import Web.Event.EventTarget (addEventListener, eventListener, removeEventListener)
import Web.HTML (window)
import Web.HTML.Window (toEventTarget)
import Components.Terminal (term)
import Components.FileTree (viewNamespaceListing, testData)

pixelBufferForScroll = 100.0 :: Number
data ScrolledSection
  = ScrolledCandidate Int
  | ScrolledDefinite Int
  | NotScrolled

data ScrollCheckDirection = ScrollCheckStart | ScrollCheckDown | ScrollCheckUp

derive instance Generic ScrolledSection _
instance Show ScrolledSection where
  show = genericShow

getScrolledSection :: Int -> (Int -> Effect ScrolledSection) -> Effect Int
getScrolledSection startingAt f = go ScrollCheckStart startingAt startingAt
  where
  go checkDir n head = do
    scrolledSection <- f head
    case scrolledSection of
      ScrolledDefinite i -> pure i
      ScrolledCandidate i -> case checkDir of
        ScrollCheckDown -> pure i
        _ -> go ScrollCheckUp i (i + 1)
      NotScrolled ->
        if n == 0 then pure 0
        else case checkDir of
          ScrollCheckUp -> pure n
          _ -> go ScrollCheckDown n (head - 1)

main :: Effect Unit
--main = runInBody Deku.do
main = do
  clickedSection <- Ref.new Nothing
  currentRouteMailbox <- create
  previousRouteMailbox <- create
  currentRoute <- create
  headerElement <- create
  rightSideNav <- create
  rightSideNavSelectE <- create
  darkModePreferenceE <- create
  psi <- makeInterface
  initialListener <- eventListener (\_ -> pure unit)
  scrollListenerRef <- Ref.new initialListener
  let scrollType = EventType "scroll"
  let
    removeScroll oldListener = toEventTarget <$> window >>= removeEventListener
      scrollType
      oldListener
      true
  let
    setScroll newListener = toEventTarget <$> window >>= addEventListener
      scrollType
      newListener
      true
  setScroll initialListener
  let
    changeListener newListener = do
      oldListener <- Ref.read scrollListenerRef
      removeScroll oldListener
      setScroll newListener
      Ref.write newListener scrollListenerRef

  let
    makeMap inMap = case _ of
      Nothing -> Map.empty
      Just (Tuple key val) -> Map.insert key val inMap
  void $ subscribe
    ( { header: _, mapOfElts: _ }
        <$> headerElement.event
        <*> fold makeMap
          Map.empty
          rightSideNav.event
    )
    \{ header, mapOfElts } -> do
      currentSectionRef <- Ref.new 0
      newListener <- eventListener \_ -> do
        let
          toVerify ce =
            Map.lookup ce mapOfElts # maybe (pure NotScrolled) \myElt -> do
              boundingRectHeader <- getBoundingClientRect header
              boundingRectElt <- getBoundingClientRect myElt
              let
                minAy = boundingRectHeader.top
                maxAy = boundingRectHeader.bottom
                minBy = boundingRectElt.top - pixelBufferForScroll
                maxBy = boundingRectElt.bottom - pixelBufferForScroll
                aAboveB = minAy > maxBy
                aBelowB = maxAy < minBy

                intersects = not (aAboveB || aBelowB)
              pure case intersects of
                true -> ScrolledDefinite ce
                false ->
                  if maxBy < minAy then ScrolledCandidate ce else NotScrolled
        wasHere <- Ref.read currentSectionRef
        goHere <- Ref.read clickedSection >>= case _ of
          Just goHere -> do
            Ref.write Nothing clickedSection
            pure goHere
          Nothing -> getScrolledSection wasHere toVerify
        Ref.write goHere currentSectionRef
        logShow { goHere }
        rightSideNavSelectE.push goHere
      changeListener newListener
  runInBody
    ( Deku.do
        rightSideLagged <- envy <<< memoize
          (lag (dedup rightSideNavSelectE.event))
        pageWas <- envy <<< mailboxed
          ({ address: _, payload: unit } <$> previousRouteMailbox.event)
        pageIs <- envy <<< mailboxed
          ({ address: _, payload: unit } <$> currentRouteMailbox.event)
        rightSideNavSelect <- envy <<< mailboxed
          ({ address: _, payload: unit } <$> (snd <$> rightSideLagged))
        rightSideNavDeselect <- envy <<< mailboxed
          ({ address: _, payload: unit } <$> compact (fst <$> rightSideLagged))
        app
          { pageIs
          , pageWas
          , rightSideNavSelect
          , rightSideNavDeselect
          , pushState: psi.pushState
          , curPage: routeToPage <$> currentRoute.event
          , setHeaderElement: headerElement.push
          , setRightSideNav: Just >>> rightSideNav.push
          , clickedSection
          , darkModePreference: darkModePreferenceE.event
          }
    )
  dedupRoute <- create
  void $ subscribe (dedup dedupRoute.event) $ uncurry \old new -> do
    rightSideNav.push Nothing
    traverse_ previousRouteMailbox.push old
    currentRouteMailbox.push new
    currentRoute.push new
  void $ matchesWith (map (\e -> e <|> pure FourOhFour) (parse route))
    (curry dedupRoute.push)
    psi
  prefersDarkMode >>= darkModePreferenceE.push
  void $ darkModeListener
    (OnDark (darkModePreferenceE.push true))
    (OnLight (darkModePreferenceE.push false))