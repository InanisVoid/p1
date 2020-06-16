module Style.Text exposing (styleText)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import VirtualDom
import Css.Transitions exposing (background3, border3, bottom3, boxShadow3, ease, transition, top3, transition)
import Css.Animations exposing (backgroundColor)

-- import Internal.Flag exposing (hover)

-- import Element exposing (px)

{-| In this case we are specifying a transition such that:

  - When the backgroundColor changes will interpolate between the current value and
    the new value over 1000 milliseconds with no delay and a default (ease) easing function
  - When the transform changes will interpolate between the current value and the
    new value over 500 milliseconds with no delay and an easeInOut easing function

We are then using the `hover` function to specify that the backgroundColor and transform change on hover

-}
styleText =
    styled Html.Styled.div
        [
         Css.border3 (px 1) solid (rgba 241 6 6 0.81),
         Css.backgroundColor (rgba 220  17 1 0.16),
         boxShadow4 (px 0) (px 0) (px 2) (hex "#ff0303"),
         color (hex "#FFFFFF"),
        --  textShadow3 (px 2) (px 1) (hex "#FFFFFF"),
         cursor pointer,
         fontSize (px 13),
         fontFamily serif,
        --  textAlign left!important,
        --  color (hex "#721c24"),
        --  Css.backgroundColor (hex "#f8d7da"),
         borderColor (hex "#f5c6cb"),
        --  opacity (Css.num 0.6), 
         hover[
                  Css.backgroundColor (rgba 220 17 1 0.6)
                  -- color (hex "#000000") 
               ],
         transition
           [ 
             Css.Transitions.background3 500 0 ease,
             Css.Transitions.border3 500 0 ease,
             Css.Transitions.bottom3 500 0 ease,
             Css.Transitions.boxShadow3 500 0 ease,
             Css.Transitions.top3 500 0 ease,
             Css.Transitions.textShadow3 500 0 ease,
             Css.Transitions.right3 500 0 ease,
             Css.Transitions.left3 500 0 ease,
             Css.Transitions.opacity3 500 0 ease
            --   Css.Transitions.all 500 0 easeInOut
           ]
        ]
-- buttonTest=
--     [ css [ pseudoClass "-moz-any-link" [ color (hex "f00") ] ] ]
--     [ text "Whee!" ]

-- type alias User =
--     { name : String
--     , email : String
--     , password : String
--     , loggedIn : Bool
--     }


-- initialModel : User
-- initialModel =
--     { name = ""
--     , email = ""
--     , password = ""
--     , loggedIn = False
--     }


-- --css [Css.backgroundColor (hex "#000000")]
-- view : User -> Html msg
-- view user =
--     div []
--         [  primarydiv[][text "HOVER" ]
--                 -- buttonTest
--          ]

-- main : VirtualDom.Node msg
-- main =
--     toUnstyled <| view initialModel