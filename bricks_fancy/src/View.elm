module View exposing (..)
import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (style)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import String
import Update exposing (..)
ballInit : Ball
ballInit = ballRecUpdate ballConfig
batInit : Bat
batInit =batRecUpdate batConfig
brickListInit : List Brick
brickListInit = generateBricks [] total brickConfig.x brickConfig.y 

initPlayer : Player
initPlayer = Player ballInit batInit brickListInit False False False 0

init : Model 
init = Model initPlayer initPlayer

--type Msg = Increment | Decrement

--update : Msg -> List Model -> List Model

setStyle1 : Html.Attribute msg
setStyle1 =
    Html.Attributes.style "padding" "10%"
setStyle2 : Html.Attribute msg
setStyle2 =
    Html.Attributes.style "top" "0"
setStyle3 : Html.Attribute msg
setStyle3 =
    Html.Attributes.style "postion" "fixed"


view : Model -> Html msg
view model =
    div [][playerDemonstrate model.player1,playerDemonstrate model.player2]



playerDemonstrate : Player -> Html msg
playerDemonstrate model =
    let
        gWidth = "100"
        gHeight = "77"
        screen = rect [fill "#ffffff", x "0", y "0", width gWidth, height gHeight] []
    in

        div [setStyle1,setStyle2,setStyle3]
            [ svg [width "100%", height "100%", viewBox <| "0 0 " ++ gWidth ++ " " ++ gHeight]
              (List.append [screen] <| List.append [ball model.ball, bat model.bat] <| bricks model.bricks )
            ]

bricks : List Brick -> List (Html msg)
bricks bricksInput =
    let
        createBricksFormat model =
          rect [fill "#685bd1", x <| String.fromFloat model.x, y <| String.fromFloat model.y, width <| String.fromFloat model.width, height <| String.fromFloat model.height, stroke <| "#ffffff 0.1"] []
    in
        List.map createBricksFormat bricksInput

ball : Ball -> Html msg 
ball ballInput =
    let 
        createBallFormat model =
          circle [fill "#002c5a", cx <| String.fromFloat model.x, cy <| String.fromFloat model.y, r <| String.fromFloat model.r][]
    in
        createBallFormat ballInput

bat : Bat -> Html msg
bat batInput =
    let 
        createBatFormat model =
          rect [fill "#ffcb0b", x <| String.fromFloat model.x, y <| String.fromFloat model.y, width <| String.fromFloat model.width, height <| String.fromFloat model.height] []
    in
        createBatFormat batInput

