module Style.Title exposing (styleTitle)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import VirtualDom
import Css.Transitions exposing (background3,border3,bottom3,boxShadow3,easeInOut,ease,transition,cubicBezier,top3,transition)
import Css.Animations exposing (backgroundColor,keyframes)
import Css.Global exposing (global)
-- import Element.Font exposing (center)
-- import Internal.Model exposing (unstyled)
-- import DEPRECATED.Css.File exposing (CssFileStructure)
-- import Element exposing (px)

{-| In this case we are specifying a transition such that:

  - When the backgroundColor changes will interpolate between the current value and
    the new value over 1000 milliseconds with no delay and a default (ease) easing function
  - When the transform changes will interpolate between the current value and the
    new value over 500 milliseconds with no delay and an easeInOut easing function

We are then using the `hover` function to specify that the backgroundColor and transform change on hover

-}
styleTitle =

        styled Html.Styled.h1
        [          
 
        --    left (pct 50),
           position relative,
           display block,
           Css.width (px 150),
           overflow Css.hidden,
           textAlign Css.center,
           Css.color (hex "#FFFFFF"),
           Css.backgroundColor (hex "#000000"),
           after [
                Css.property "content" "\"\"",
                position absolute,
                Css.left (pct -200),
                Css.height (pct 100),
                Css.width (pct 250),
                -- top (px 0),
                overflow Css.hidden,
                Css.property "background" "linear-gradient(45deg, rgba(255,255,255,0) 45%,rgba(255,255,255,0.8) 50%,rgba(255,255,255,0) 55%,rgba(255,255,255,0) 100%)",
                transform(skewX(deg -25)),
                Css.property "animation" "_7d0c44e5 1.5s infinite"
           ],           
           hover[
               after[
                left (pct 150),
                transition
                [ 
                    Css.Transitions.background3 3000 0 ease,
                    Css.Transitions.border3 3000 0 ease,
                    Css.Transitions.bottom3 3000 0 ease,
                    Css.Transitions.boxShadow3 3000 0 ease,
                    Css.Transitions.top3 3000 0 ease,
                    Css.Transitions.textShadow3 3000 0 ease,
                    Css.Transitions.right3 3000 0 ease,
                    Css.Transitions.left3 3000 0 ease,
                    Css.Transitions.opacity3 3000 0 ease
                    --   Css.Transitions.all 500 0 easeInOut
                ]
               ]
           ],
          Css.animationName ( keyframes [
              (0, [Css.Animations.property "left" "-150%"]),
              (100, [Css.Animations.property  "left" "150%"])])
        ]
-- test =Css.Global.selector "@keyframes shine" [ Css.property "0% {background-position" "-100%}",Css.property"100% {background-position" "100%}" ]


-- -- buttonTest=
-- --     [ css [ pseudoClass "-moz-any-link" [ color (hex "f00") ] ] ]
-- --     [ text "Whee!" ]

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


-- view : User -> Html msg
-- view user =
--     -- let
--     --     -- temp1=Css.Global.global [styleTilte]
--     --     -- temp2=Css.Global.global [test]
--     --     -- divtemp =div[] [temp2,div[] [temp1,h1[][text "Hover"]]]
--     -- in  
--         div[][styleTilte[][text "Hover"]]
-- main : VirtualDom.Node msg
-- main =
--     toUnstyled <| view initialModel