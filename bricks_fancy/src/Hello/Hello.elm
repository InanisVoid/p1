module Hello.Hello exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Encode
import Browser
import Css.Global exposing (tbody)
import Css exposing (start)


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

videoframe model =
  div[Html.Attributes.style "background-color" "black"][
    --  div [id "img1",Html.Attributes.style "width" "10%",Html.Attributes.style "float" "left",Html.Attributes.style "padding" "0"][img [src "./images/Background.png", style "height" "30%", style "width" "30%"][]],
    --  div [id "img1",Html.Attributes.style "width" "10%",Html.Attributes.style "float" "right",Html.Attributes.style "padding" "0"][img [src "./images/Background.png",style "height" "30%", style "width" "30%" ][]],
     Html.h1 [Html.Attributes.style "text-align" "center",
                Html.Attributes.style "font-size" "250%",
                Html.Attributes.style "text-shadow" "5px 5px 5px #FF0000",
                Html.Attributes.style "color" "white",
                Html.Attributes.style "background-color" "black"
                ,Html.Attributes.style "width" "100%"
               ] 
            [Html.text "Over-Deducted"],
    div[style "text-align" "center",style "background-color" "black",Html.Attributes.style "width" "100%"][

    div[Html.Attributes.style "width" "100%"][iframe
    [ style "width" "100%"
    , style "height" "100%"
    , src "./video/Begin.mp4"
    , property "frameborder" (Json.Encode.string "0")
    , property "allowfullscreen" (Json.Encode.string "true")
    , style "object-fit" "fill"
    , Html.Attributes.style "border-width" "0",
      Html.Attributes.style "margin" "0"
    ][]]
    ],
    div[Html.Attributes.style "text-align" "center",Html.Attributes.style "padding-top" "10%"][button(buttonCSS ++ [onClick Start]) [Html.text "Start Game"]]
  ]

type Msg = Start

init =[]
update msg model =
    case msg of 
        Start ->
            model

    
main =
  Browser.sandbox { init = init, update = update , view = videoframe }