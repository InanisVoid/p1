module Hello.Hello exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Encode
import Browser
import Css.Global exposing (tbody,button)
-- import Css exposing (start)
import Css exposing (..)
import Css.Transitions exposing (easeInOut, transition)
-- import Html
import Html.Styled exposing (styled)
-- import Html.Styled.Attributes exposing (css)



h1CSS : List (Html.Attribute Msg)
h1CSS = 
  [ Html.Attributes.style "background" "linear-gradient(to bottom, #cfc09f 22%,#634f2c 24%, #cfc09f 26%, #cfc09f 27%,#ffecb3 40%,#3a2c0f 78%)" ,
    Html.Attributes.style "-webkit-background-clip" "text",
    Html.Attributes.style "-webkit-text-fill-color" "transparent",
    Html.Attributes.style "color" "#fff",
    Html.Attributes.style "font-family" "'Playfair Display', serif",
    Html.Attributes.style "position" "relative",
    Html.Attributes.style "text-transform" "uppercase",
    Html.Attributes.style "font-size" "250%",
    Html.Attributes.style "margin"  "0",
    Html.Attributes.style "font-weight" "400",
    Html.Attributes.style "text-align" "center"
  -- h1:after {
  --     background: none;
  --     content: attr(data-heading);
  --     left: 0;
  -- 	top: 0;
  --     z-index: -1;
  --     position: absolute;
  -- Html.Attributes.style "text-shadow" "-1px 0 1px #c6bb9f,0 1px 1px #c6bb9f, 5px 5px 10px rgba(0, 0, 0, 0.4), -5px -5px 10px rgba(0, 0, 0, 0.4)"
  -- }
  ]

-- [Html.Attributes.style "text-align" "center",
--                 Html.Attributes.style "font-size" "250%",
--                 Html.Attributes.style "text-shadow" "5px 5px 5px #FF0000",
--                 Html.Attributes.style "color" "white",
--                 Html.Attributes.style "background-color" "black"
--                 ,Html.Attributes.style "width" "100%"
--                ] 


buttonCSS : List (Html.Attribute Msg)
buttonCSS =
    [   Html.Attributes.style "width" "200px",
        Html.Attributes.style "height" "30px",
        Html.Attributes.style "color" "white",
        Html.Attributes.style "background-color" "cornflowerblue",
        Html.Attributes.style "border-radius" "3px",
        Html.Attributes.style "border-width" "0",
        Html.Attributes.style "margin" "0",
        Html.Attributes.style "outline" "none",
        -- Html.Attributes.style "font-family" "KaiTi",
        Html.Attributes.style "font-size" "17px",
        Html.Attributes.style "text-align" "center",
        Html.Attributes.style "cursor" "pointer"
        -- Html.Attributes.style "hover" "color:#FF00FF",  
        -- Html.Attributes.style "active" "color:#0000FF" 
    ]


primaryButton =
    Html.Styled.styled Css.Global.button
        [ backgroundColor (rgb 241 241 241)
        , transform (scaleX 1)
        , hover
            [ backgroundColor (rgb 220 220 220)
            , transform (scaleX 1.2)
            ]
        , transition
            [ Css.Transitions.backgroundColor 1000
            , Css.Transitions.transform3 500 0 easeInOut
            ]
        ]

videoframe model =
  div[Html.Attributes.style "background" "radial-gradient(ellipse at center, #443501 0%,#000000 100%)"][
    --  div [id "img1",Html.Attributes.style "width" "10%",Html.Attributes.style "float" "left",Html.Attributes.style "padding" "0"][img [src "./images/Background.png", style "height" "30%", style "width" "30%"][]],
    --  div [id "img1",Html.Attributes.style "width" "10%",Html.Attributes.style "float" "right",Html.Attributes.style "padding" "0"][img [src "./images/Background.png",style "height" "30%", style "width" "30%" ][]],
     Html.h1 h1CSS [Html.text "Over-Deducted"],
    div[style "text-align" "center",style "background-color" "black",Html.Attributes.style "width" "100%"][

    div[Html.Attributes.style "width" "100%"][iframe
    [ style "width" "100%"
    , style "height" "100%"
    , src "./video/Begin.mp4"
    , Html.Attributes.property "frameborder" (Json.Encode.string "0")
    , Html.Attributes.property "allowfullscreen" (Json.Encode.string "true")
    , style "object-fit" "fill"
    , Html.Attributes.style "border-width" "0",
      Html.Attributes.style "margin" "0"
    ][]]
    ],
    div[Html.Attributes.style "text-align" "center",Html.Attributes.style "padding-top" "10%"][Html.button(buttonCSS ++ [onClick Start]) [Html.text "Start Game"]],
    primaryButton
  ]

type Msg = Start

init =[]
update msg model =
    case msg of 
        Start ->
            model

    
main =
  Browser.sandbox { init = init, update = update , view = videoframe }