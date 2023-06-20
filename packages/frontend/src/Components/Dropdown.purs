module Components.Dropdown where

import Prelude
import Deku.DOM as D
import Deku.Do as Deku
import Deku.Core (Nut)
import Deku.Control (text_)
import Deku.Attribute ((!:=))
import Deku.Attributes (klass_)

--
-- Dropdown menu, show/hide based on menu state.
-- 
-- Entering: "transition ease-out duration-100"
--   From: "transform opacity-0 scale-95"
--   To: "transform opacity-100 scale-100"
-- Leaving: "transition ease-in duration-75"
--   From: "transform opacity-100 scale-100"
--   To: "transform opacity-0 scale-95"
dropdown =
  D.div [ klass_ "absolute right-0 z-10 mt-2 w-56 origin-top-right rounded-md bg-white shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none", D.Role !:= "menu", D.Tabindex !:= "-1" ]
    [ D.div [ klass_ "py-1", D.Role !:= "none" ]
        [
          -- <!-- Active: "bg-gray-100 text-gray-900", Not Active: "text-gray-700" -->
          D.a [ D.Href !:= "#", klass_ "text-gray-700 flex px-4 py-2 text-sm", D.Role !:= "menuitem", D.Tabindex !:= "-1", D.Hidden !:= "menu-0-item-0" ]
            [ D.svg [ klass_ "mr-3 h-5 w-5 text-gray-400", D.ViewBox !:= "0 0 20 20", D.Fill !:= "currentColor", D.AriaHidden !:= "true" ]
                [ D.path [ D.FillRule !:= "evenodd", D.D !:= "M10.868 2.884c-.321-.772-1.415-.772-1.736 0l-1.83 4.401-4.753.381c-.833.067-1.171 1.107-.536 1.651l3.62 3.102-1.106 4.637c-.194.813.691 1.456 1.405 1.02L10 15.591l4.069 2.485c.713.436 1.598-.207 1.404-1.02l-1.106-4.637 3.62-3.102c.635-.544.297-1.584-.536-1.65l-4.752-.382-1.831-4.401z", D.ClipRule !:= "evenodd" ] []
                ]
            , D.span
                []
                [ text_ "Add to favorites" ]
            ]
        , D.a [ D.Href !:= "#", klass_ "text-gray-700 flex px-4 py-2 text-sm", D.Role !:= "menuitem", D.Tabindex !:= "-1", D.Hidden !:= "menu-0-item-1" ]
            [ D.svg
                [ klass_ "mr-3 h-5 w-5 text-gray-400", D.ViewBox !:= "0 0 20 20", D.Fill !:= "currentColor", D.AriaHidden !:= "true" ]
                [ D.path [ D.FillRule !:= "evenodd", D.D !:= "M6.28 5.22a.75.75 0 010 1.06L2.56 10l3.72 3.72a.75.75 0 01-1.06 1.06L.97 10.53a.75.75 0 010-1.06l4.25-4.25a.75.75 0 011.06 0zm7.44 0a.75.75 0 011.06 0l4.25 4.25a.75.75 0 010 1.06l-4.25 4.25a.75.75 0 01-1.06-1.06L17.44 10l-3.72-3.72a.75.75 0 010-1.06zM11.377 2.011a.75.75 0 01.612.867l-2.5 14.5a.75.75 0 01-1.478-.255l2.5-14.5a.75.75 0 01.866-.612z", D.ClipRule !:= "evenodd" ] []
                ]
            ]
        , D.span [] [ text_ "Embed" ]
        , D.a [ D.Href !:= "#", klass_ "text-gray-700 flex px-4 py-2 text-sm", D.Role !:= "menuitem", D.Tabindex !:= "-1", D.Hidden !:= "menu-0-item-2" ]
            [ D.svg [ klass_ "mr-3 h-5 w-5 text-gray-400", D.ViewBox !:= "0 0 20 20", D.Fill !:= "currentColor", D.AriaHidden !:= "true" ]
                [ D.path [ D.D !:= "M3.5 2.75a.75.75 0 00-1.5 0v14.5a.75.75 0 001.5 0v-4.392l1.657-.348a6.449 6.449 0 014.271.572 7.948 7.948 0 005.965.524l2.078-.64A.75.75 0 0018 12.25v-8.5a.75.75 0 00-.904-.734l-2.38.501a7.25 7.25 0 01-4.186-.363l-.502-.2a8.75 8.75 0 00-5.053-.439l-1.475.31V2.75z" ] []
                ]
            , D.span
                []
                [ text_ "Report content" ]
            ]
        ]
    ]