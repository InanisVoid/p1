module Hello.Hello exposing (..)
import Html
import Json.Encode
import Browser
import Browser.Navigation
import Css.Global exposing (tbody)
import Css exposing (..)
import Css.Transitions exposing (..)
import Css.Animations exposing (..)
import Html.Styled exposing(..)
import Html.Styled.Attributes exposing (css, href, src,id,autoplay)
import VirtualDom
import Html.Styled.Attributes exposing (controls)


-- buttonCSS : List (Html.Attribute Msg)
-- buttonCSS =
--     [   Html.Attributes.style "width" "200px",
--         Html.Attributes.style "height" "30px",
--         Html.Attributes.style "color" "white",
--         Html.Attributes.style "background-color" "cornflowerblue",
--         Html.Attributes.style "border-radius" "3px",
--         Html.Attributes.style "border-width" "0",
--         Html.Attributes.style "margin" "0",
--         Html.Attributes.style "outline" "none",
--         -- Html.Attributes.style "font-family" "KaiTi",
--         Html.Attributes.style "font-size" "17px",
--         Html.Attributes.style "text-align" "center",
--         Html.Attributes.style "cursor" "pointer"

--         -- Html.Attributes.style "hover" "color:#FF00FF",  
--         -- Html.Attributes.style "active" "color:#0000FF" 
--     ]




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
  
  div[css[Css.backgroundColor (rgb 0 0 0)]][
    --  div [id "img1",Html.Attributes.style "width" "10%",Html.Attributes.style "float" "left",Html.Attributes.style "padding" "0"][img [src "./images/Background.png", style "height" "30%", style "width" "30%"][]],
    --  div [id "img1",Html.Attributes.style "width" "10%",Html.Attributes.style "float" "right",Html.Attributes.style "padding" "0"][img [src "./images/Background.png",style "height" "30%", style "width" "30%" ][]],
     h1 [css[ Css.margin2 (px 0) auto,
              textAlign center,
                Css.fontSize (px 36),
                textShadow4 (px 5) (px 5) (px 5) (hex "#FF0000") ,
                Css.color (rgb 255 255 255),
                Css.backgroundColor (rgb 50 50 50)
                ,Css.width (vw 50)
               ] ]
            [text "Over-Deducted"],
    div[css[Css.backgroundColor (rgb 0 0 0),Css.width (vw 100) ] ][

    div [css[Css.width (vw 100)]][video[
    src "./video/Begin.mp4",
    controls True,
    autoplay True,
    css[ Css.width (vw 100)
    , Css.height (vw 50)
    ,  Css.margin2 auto auto
    , Css.property "frameborder" "0"
    , Css.property "allowfullscreen" "true",
    Css.property "object-fit" "fill"]
    ][]],
    a[href "index.html"][button
    [ id "a button",css [Css.opacity (num 0.4),Css.backgroundColor (hex "0000ff"), Css.margin2 Css.auto auto,Css.width (vw 10) , Css.height (vw 10) , Css.hover [ Css.backgroundColor (hex "ff0000") ] 
    ,transition
            [  Css.Transitions.background3 1000 0 (cubicBezier 0.075 0.82 0.165 1 )
            ]] ]
    [ text "Whee!" ]]]
  ]

    
main : VirtualDom.Node msg
main =
    toUnstyled <| view initialModel