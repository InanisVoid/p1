module Hello exposing (..)
import Style.Button exposing (..)
import Html
import Json.Encode
import Browser
import Browser.Navigation
import Css.Global exposing (tbody)
import Css exposing (..)
import Css.Transitions exposing (..)
import Css.Animations exposing (..)
import Html.Styled exposing(..)
import Html.Styled.Attributes exposing (css, href, src,id,autoplay,loop,style)
import VirtualDom
import Html.Styled.Attributes exposing (controls)
import Html.Styled.Events exposing (onClick)
import Html 
import Style.Title exposing (..)


view : Model -> Html Msg
view model =
  let 
    audioornot = 
     if model.beginAudio then
        [audio[src "./audio/success.mp3",   autoplay True][]]
        else[] 


  in
  div [ css[
      
      Css.width (vw 100),
      Css.height (vw 100),
      Css.backgroundColor (rgb 0 0 0)]
  ][div[                
      style "border-color" "silver",
      style "border-width" "15px",
      style "border-style" "outset",
      style "margin" "0 auto",
      style "width" "1000px",
      style "height" "700px",
      style "background" "black"]
    [
        styleTitle [style "width" "100%"][text "Get out of My Class"],
        div [][video[
          src "./video/Begin.mp4",
          controls True,
          autoplay True,
          style "margin-top" "-5%"]
          -- css[ Css.width (vw 100)
          -- , Css.height (vw 50)
          -- ,  Css.margin2 auto auto
          -- -- , Css.property "frameborder" "0"
          -- -- , Css.property "allowfullscreen" "true",
          -- Css.property "object-fit" "fill"]
                    []
        ],
        
        div[style "margin-left" "42%"][a[href "game.html", style "display" "block", style "width"  "150px"][styleButton [onClick BeginAudio,style "width" "100%"][text "Start Game"]]],   
        div[]audioornot
      ]
  ]

main : Program () Model Msg
main =
    Browser.sandbox
        { view = view >> toUnstyled
        , update = update
        , init = initialModel
        }


update : Msg -> Model -> Model
update msg model =
    case msg of
       BeginAudio -> {model|beginAudio = True}

       StopAudio -> {model|beginAudio = False}


type Msg
    = BeginAudio
    | StopAudio


type alias Model =
    {
      beginAudio : Bool
    }


initialModel : Model
initialModel =
    {beginAudio = False}

