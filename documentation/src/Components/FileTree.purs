module Components.FileTree
  ( DefinitionListing
  , NamespaceListing
  , NamespaceListingChild
  , NamespaceListingContent(..)
  , viewDefinitionListing
  , viewNamespaceListing
  , testData
  )
  where

import Prelude

import Data.List (List)
import Data.Set (member, Set, empty)
import Data.Set as Set
import Data.Tuple.Nested ((/\))
import Deku.Core (Nut)
import Deku.Control (text_, text, (<#~>), blank)
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Hooks (useState)
import Deku.Listeners (click)

--type Model = 
--  { expanded :: Set String
--  , 
--  }

type NamespaceListingContent = Array NamespaceListingChild

data NamespaceListingChild 
  = SubNamespace NamespaceListing
  | SubDefinition DefinitionListing

data NamespaceListing = NamespaceListing String NamespaceListingContent

instance showNamespaceListing :: Show NamespaceListing where 
  show (NamespaceListing s content) = s

data DefinitionListing 
  = MarkupListing String
  | TheoremListing String

derive instance ordNamespaceListingChild :: Ord NamespaceListingChild
derive instance eqNamespaceListingChild :: Eq NamespaceListingChild
derive instance ordNamespaceListing :: Ord NamespaceListing
derive instance eqNamespaceListing :: Eq NamespaceListing
derive instance ordDefinitionListing :: Ord DefinitionListing
derive instance eqDefinitionListingChild :: Eq DefinitionListing
testData :: NamespaceListing
testData = 
  NamespaceListing "Name" 
    [ SubDefinition (MarkupListing "markup")
    , SubNamespace   
      (NamespaceListing "Sub"
        [ SubDefinition (MarkupListing "asdf")
        , SubDefinition (TheoremListing "theorem")
        ]
      )
    ]

viewDefinitionListing :: DefinitionListing -> Nut
viewDefinitionListing =
  case _ of
    MarkupListing s -> text_ s
    TheoremListing s -> text_ s


viewNamespaceListing :: Set String -> NamespaceListing -> Nut
viewNamespaceListing expandedListings (NamespaceListing name content) = Deku.do
  toggle /\ isToggled <- useState false
  updateOpens /\ opens <- useState (empty :: Set String)
  D.div_ [
    D.a
      Alt.do
        --click $ isToggled <#> not >>> toggle
        click $ opens <#> Set.toggle name >>> updateOpens
      [ isToggled  <#~>
          if _ then 
            text_ ">"
          else 
            text_ "v"
      , text_ name
      --, namespaceContent
      --if name `member` expandedListings then
        --D.div_ [viewNameSpaceListingContent expandedListings content]
      --else
        --blank
      ]
    , D.div_ 
      [ D.h1_ [text_"Debug: "]
      , text_ $ show expandedListings
      , text $ opens <#> show
      ]
  ]

viewNameSpaceListingContent :: Set String -> NamespaceListingContent -> Nut
viewNameSpaceListingContent expanded content =
  D.div_ (viewChild <$> content)
  where
    viewChild :: NamespaceListingChild -> Nut
    viewChild content = 
      case content of
        SubNamespace nl -> viewNamespaceListing expanded nl
        SubDefinition dl -> viewDefinitionListing dl