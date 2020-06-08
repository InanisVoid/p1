module View exposing (..)
import Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (style,src)
import Html.Events exposing (..)
import Http
import Svg exposing (..)
import Svg.Attributes exposing (..)
import String
import Update exposing (..)
import Heros exposing (..)
import Messages exposing (Msg(..))
import Html.Styled exposing (h1)
import Css.Global exposing (body)
-- import Debug
ballInit : Ball
ballInit = ballRecUpdate ballConfig
batInit : Bat
batInit =batRecUpdate batConfig
brickListInit : List Brick
brickListInit = generateBricks [] total brickConfig.x brickConfig.y 

initPlayer : Player
initPlayer = Player ballInit batInit brickListInit False False False 0 teachers 0

init : Model 
init = Model (0,0) False initPlayer initPlayer

--type Msg = Increment | Decrement

--update : Msg -> List Model -> List Model

-- setStyle1 : Html.Attribute msg
-- setStyle1 =
--     Html.Attributes.style "padding" "10%"
-- setStyle2 : Html.Attribute msg
-- setStyle2 =
--     Html.Attributes.style "top" "0"
-- setStyle3 : Html.Attribute msg
-- setStyle3 =
--     Html.Attributes.style "postion" "fixed"




pixelWidth : Float
pixelWidth =
    1000


pixelHeight : Float
pixelHeight =
    1000

view : Model -> Html Msg
view model =
    let
        ( w, h ) =
            model.size

        r =
            if w / h > pixelWidth / pixelHeight then
                Basics.min 1 (h / pixelHeight)

            else
                Basics.min 1 (w / pixelWidth)
    in
    div
        [ Html.Attributes.style "width" "100%"
        , Html.Attributes.style "height" "100%"
        , Html.Attributes.style "position" "absolute"
        , Html.Attributes.style "left" "0"
        , Html.Attributes.style "top" "0"
        ]
        [ div
            [ Html.Attributes.style "width" (String.fromFloat pixelWidth ++ "px")
            , Html.Attributes.style "height" (String.fromFloat pixelHeight ++ "px")
            , Html.Attributes.style "position" "absolute"
            , Html.Attributes.style "left" (String.fromFloat ((w - pixelWidth * r) / 2) ++ "px")
            , Html.Attributes.style "top" (String.fromFloat ((h - pixelHeight * r) / 2) ++ "px")
            , Html.Attributes.style "transform-origin" "0 0"
            , Html.Attributes.style "transform" ("scale(" ++ String.fromFloat r ++ ")")
            ]
            [ canvas model
            ]
        ]


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

startButtonCSS : List (Html.Attribute Msg)
startButtonCSS =
    [   Html.Attributes.style "width" "250px",
        Html.Attributes.style "height" "40px",
        Html.Attributes.style "color" "white",
        Html.Attributes.style "background-color" "#347DDB",
        Html.Attributes.style "border-radius" "10px",
        Html.Attributes.style "border-width" "0",
        Html.Attributes.style "margin" "0",
        Html.Attributes.style "outline" "none",
        -- Html.Attributes.style "font-family" "KaiTi",
        Html.Attributes.style "font-size" "30px",
        Html.Attributes.style "text-align" "center",
        Html.Attributes.style "cursor" "pointer"
        -- Html.Attributes.style "hover" "color:#FF00FF",  
        -- Html.Attributes.style "active" "color:#0000FF" 
    ]


nameCSS : List (Html.Attribute Msg)
nameCSS =
    [   Html.Attributes.style "text-align" "center",
        Html.Attributes.style "width" "200px"]


heroCSS : List (Html.Attribute Msg)
heroCSS = 
    -- [ Html.Attributes.style "display" "table-cell",
    --   Html.Attributes.style "vertical-align" "middle",
    --   Html.Attributes.style "text-align" "center"
    [
        width "100", 
        height "100",
        -- Html.Attributes.style "padding-left" "30px",
        -- Html.Attributes.style "padding-top" "20px",
        Html.Attributes.style "border-radius" "20px"
    ]
canvas : Model -> Html Msg
canvas model =
    let
       p1=model.player1
       p1Teachers = p1.teachers
       p1FirstTeacher = getFirstTeacher p1Teachers

       p2=model.player2
       p2Teachers = p2.teachers
       p2FirstTeacher = getFirstTeacher p2Teachers
    in
        Html.tbody[Html.Attributes.style "background-color" "#A4C0D7"][
        div[ ]
        [   Html.h1 [Html.Attributes.style "text-align" "center",
                Html.Attributes.style "font-size" "300%",
                Html.Attributes.style "text-shadow" "5px 5px 5px #FF0000"
               ] 
            [Html.text "Over-Deducted"]],
        div [id  "wrapper"]
        [   
            -- div[][img [src "Logo.png", width "300", height "300"][]],
            Html.h2 [id "score1",Html.Attributes.style "width" "50%",Html.Attributes.style "float" "left",Html.Attributes.style "text-align" "center"][Html.text("Player1 Score: " ++  String.fromFloat p1.score)],
            Html.h2 [id "score2",Html.Attributes.style "width" "50%",Html.Attributes.style "float" "right",Html.Attributes.style "text-align" "center"][Html.text("Player2 Score: " ++  String.fromFloat p2.score)],            
            div [
                id "div1",Html.Attributes.style "width" "45%",
                Html.Attributes.style "float" "left" ,
                Html.Attributes.style "background-image" "url(./images/NULL.png)",
                Html.Attributes.style "background-repeat" "no-repeat",
                Html.Attributes.style "background-size" "100% 100%",
                Html.Attributes.style "-moz-background-size" "100% 100%",
                Html.Attributes.style "margin" "2.5%"
                ][playerDemonstrate model.player1],
           div [
                id "div1",Html.Attributes.style "width" "45%",
                Html.Attributes.style "float" "left" ,
                Html.Attributes.style "background-image" "url(./images/NULL.png)",
                Html.Attributes.style "background-repeat" "no-repeat",
                Html.Attributes.style "background-size" "100% 100%",
                Html.Attributes.style "-moz-background-size" "100% 100%",
                Html.Attributes.style "margin" "2.5%"
                ][playerDemonstrate model.player2],
            div[id "p1",Html.Attributes.style "width" "40%",Html.Attributes.style "float" "left",Html.Attributes.style "padding-right" "2%",Html.Attributes.style "padding-left" "8%"][
                div [id "but1",Html.Attributes.style "width" "50%",Html.Attributes.style "float" "left"][
                    button(buttonCSS ++ [onClick PreviousTeacher1] ) [Html.text "Previous"],
                    Html.h1 nameCSS  [Html.text p1FirstTeacher.name],
                    button(buttonCSS ++ [onClick NextTeacher1]) [Html.text "Next"]
                    
                ],
                div [id "img1",Html.Attributes.style "width" "40%",Html.Attributes.style "float" "right",Html.Attributes.style "padding-left" "2%",Html.Attributes.style "padding-top" "2%"][img (List.append [src p1FirstTeacher.url] heroCSS)[]]
            ],
            div[id "p2",Html.Attributes.style "width" "40%",Html.Attributes.style "float" "right",Html.Attributes.style "padding-right" "2%",Html.Attributes.style "padding-left" "8%"][
                div [id "but2",Html.Attributes.style "width" "50%",Html.Attributes.style "float" "left"][
                    button(buttonCSS ++ [onClick PreviousTeacher2]) [Html.text "Previous"],
                    Html.h1 nameCSS [Html.text p2FirstTeacher.name],                    
                    button(buttonCSS ++ [onClick NextTeacher2]) [Html.text "Next"]
                    
                ],
                 div[id "img2",Html.Attributes.style "width" "40%",Html.Attributes.style "float" "right",Html.Attributes.style "padding-left" "2%",Html.Attributes.style "padding-top" "2%"][img (List.append [src p2FirstTeacher.url] heroCSS) []]
            ],
            h3 [Html.Attributes.style "width" "40%",Html.Attributes.style "float" "left",Html.Attributes.style "padding-left" "8%"] [Html.text p1FirstTeacher.description],
            h3 [Html.Attributes.style "width" "40%",Html.Attributes.style "float" "right",Html.Attributes.style "padding-left" "8%"] [Html.text p2FirstTeacher.description],
            div [id "startbutton", Html.Attributes.style "text-align" "center", Html.Attributes.style "padding-top" "50%"][  button(startButtonCSS ++ [onClick Start]) [Html.text "Start"]]
        ]
        ]

playerDemonstrate : Player -> Html msg
playerDemonstrate model =
    let
       
        gWidth = "100"
        gHeight = "50"
        -- screen = rect [fill "#ffffff", x "0", y "0", width gWidth, height gHeight] []
    in

        div [Html.Attributes.style "postion" "fixed",Html.Attributes.style "padding-right" "20px",Html.Attributes.style "padding-left" "20px"]
            [ svg [width "200%", height "200%", viewBox <| "0 0 " ++ gWidth ++ " " ++ gHeight]
              (List.append [ball model.ball, bat model.bat] <| bricks model.bricks )
            ]

bricks : List Brick -> List (Html msg)
bricks bricksInput =
    let
        createBricksFormat model =
          rect [fill "#685bd1", x <| String.fromFloat model.x, y <| String.fromFloat model.y, width <| String.fromFloat model.width, height <| String.fromFloat model.height, Svg.Attributes.stroke "#A4C0D7",Svg.Attributes.strokeWidth "0.1"] []
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

