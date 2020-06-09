module Hello.Button exposing (main)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import VirtualDom
import Css.Transitions exposing (background3,border3,bottom3,boxShadow3,easeInOut, transition,cubicBezier,top3,transition)
import Css.Animations exposing (backgroundColor)
-- import Element exposing (px)

{-| In this case we are specifying a transition such that:

  - When the backgroundColor changes will interpolate between the current value and
    the new value over 1000 milliseconds with no delay and a default (ease) easing function
  - When the transform changes will interpolate between the current value and the
    new value over 500 milliseconds with no delay and an easeInOut easing function

We are then using the `hover` function to specify that the backgroundColor and transform change on hover

-}
primaryButton =
    styled Html.Styled.button
        [   
          letterSpacing  (Css.em 0.1)
        , cursor pointer
        , fontSize (px 14)
        , fontWeight (int 400)
        , lineHeight (px 45)
        , maxWidth (px 160)
        , position relative
        , textDecoration none
        , textTransform uppercase
        , Css.width (px 100)

        , color (hex "#fff")
        , Css.border3 (px 4) solid (hex "#000")
        , boxShadow6 inset (px 0) (px 0) (px 0) (px 1) (hex "#000") 
        , Css.backgroundColor (hex "#000")
        , overflow Css.hidden
        , position relative
       
        -- , Css.Transitions.transition [all (sec 0.3) easeInOut]
        , hover[
                textDecoration none,
                Css.border3 (px 4) solid (hex "#666"),
                Css.backgroundColor (hex "#fff"),
                boxShadow6 inset (px 0) (px 0) (px 0) (px 4) (hex "#eee"),
                letterSpacing (Css.em 0.13),
                color (hex "#333"),
                after[
                    Css.backgroundColor (hex "#fff"),
                    Css.border3 (px 20) solid (hex "#000"),
                    opacity (num 0),
                    left (pct 120),
                    transform(rotate(deg 40))
                ]
            ]
        , after[Css.backgroundColor (hex "#fff"),
                Css.border3 (px 0) solid (hex "#000"),
                Css.property "content" "\"\"",
                Css.height (px 155),
                left (px -75),
                opacity (Css.num 0.8),
                position absolute,
                top (px -50),
                transform( rotate(deg 35)),
                Css.width (px 50),
                
                -- transition: all 1s cubic-bezier(0.075,0.82,0.165,1);
                zIndex (int 1),
                transition
                [ 
                    --  Css.Transitions.backgroundColor 1000
                    Css.Transitions.background3 1000 0 (cubicBezier 0.075 0.82 0.165 1),
                    Css.Transitions.border3 1000 0 (cubicBezier 0.075 0.82 0.165 1),
                    Css.Transitions.bottom3 1000 0 (cubicBezier 0.075 0.82 0.165 1),
                    Css.Transitions.boxShadow3 1000 0 (cubicBezier 0.075 0.82 0.165 1),
                    Css.Transitions.top3 1000 0 (cubicBezier 0.075 0.82 0.165 1),
                    Css.Transitions.textShadow3 1000 0 (cubicBezier 0.075 0.82 0.165 1),
                    Css.Transitions.right3 1000 0 (cubicBezier 0.075 0.82 0.165 1),
                    Css.Transitions.left3 1000 0 (cubicBezier 0.075 0.82 0.165 1),
                    Css.Transitions.opacity3 1000 0 (cubicBezier 0.075 0.82 0.165 1)
                    -- Css.Transitions.backgroundColor3 1000 0 (cubicBezier 0.075 0.82 0.165 1),
                    -- Css.Transitions.backgroundColor3 1000 0 (cubicBezier 0.075 0.82 0.165 1)
                ]    
            ]
        , transition
           [ 
             Css.Transitions.background3 300 0 easeInOut,
             Css.Transitions.border3 300 0 easeInOut,
             Css.Transitions.bottom3 300 0 easeInOut,
             Css.Transitions.boxShadow3 300 0 easeInOut,
             Css.Transitions.top3 300 0 easeInOut,
             Css.Transitions.textShadow3 300 0 easeInOut,
             Css.Transitions.right3 300 0 easeInOut,
             Css.Transitions.left3 300 0 easeInOut,
             Css.Transitions.opacity3 300 0 easeInOut
            --   Css.Transitions.all 500 0 easeInOut
           ]
        ]
-- buttonTest=
--     [ css [ pseudoClass "-moz-any-link" [ color (hex "f00") ] ] ]
--     [ text "Whee!" ]

type alias User =
    { name : String
    , email : String
    , password : String
    , loggedIn : Bool
    }


initialModel : User
initialModel =
    { name = ""
    , email = ""
    , password = ""
    , loggedIn = False
    }


view : User -> Html msg
view user =
    div []
        [  primaryButton[  ][text "HOVER" ]
                -- buttonTest
         ]

main : VirtualDom.Node msg
main =
    toUnstyled <| view initialModel