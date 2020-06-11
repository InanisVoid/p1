module View exposing (..)
import Model exposing (..)
import Update exposing (..)
import Heros exposing (..)
import Messages exposing (Msg(..))
import Style.Button exposing (styleButton)
import Style.Title exposing (styleTitle)
import Style.Text exposing (styleText)


import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src)
import Html.Styled.Events exposing (onClick)

import Svg exposing (..)
import Svg.Styled exposing (..)
import Svg.Styled.Attributes exposing (..)



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
--     Html.Styled.Attributes.style "padding" "10%"
-- setStyle2 : Html.Attribute msg
-- setStyle2 =
--     Html.Styled.Attributes.style "top" "0"
-- setStyle3 : Html.Attribute msg
-- setStyle3 =
--     Html.Styled.Attributes.style "postion" "fixed"




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
    Html.Styled.div
        [ Html.Styled.Attributes.style "width" "100%"
        , Html.Styled.Attributes.style "height" "100%"
        , Html.Styled.Attributes.style "position" "absolute"
        , Html.Styled.Attributes.style "left" "0"
        , Html.Styled.Attributes.style "top" "0"
        ]
        [ Html.Styled.div
            [ Html.Styled.Attributes.style "width" (String.fromFloat pixelWidth ++ "px")
            , Html.Styled.Attributes.style "height" (String.fromFloat pixelHeight ++ "px")
            , Html.Styled.Attributes.style "position" "absolute"
            , Html.Styled.Attributes.style "left" (String.fromFloat ((w - pixelWidth * r) / 2) ++ "px")
            , Html.Styled.Attributes.style "top" (String.fromFloat ((h - pixelHeight * r) / 2) ++ "px")
            , Html.Styled.Attributes.style "transform-origin" "0 0"
            , Html.Styled.Attributes.style "transform" ("scale(" ++ String.fromFloat r ++ ")")
            ]
            [ canvas model
            ]
        ]


--buttonCSS : List (Html.Attribute Msg)
--buttonCSS =
--    [   Html.Styled.Attributes.style "width" "200px",
--        Html.Styled.Attributes.style "height" "30px",
--        Html.Styled.Attributes.style "color" "white",
--        Html.Styled.Attributes.style "background-color" "cornflowerblue",
--        Html.Styled.Attributes.style "border-radius" "3px",
--        Html.Styled.Attributes.style "border-width" "0",
--        Html.Styled.Attributes.style "margin" "0",
--        Html.Styled.Attributes.style "outline" "none",
--        -- Html.Styled.Attributes.style "font-family" "KaiTi",
--        Html.Styled.Attributes.style "font-size" "17px",
--        Html.Styled.Attributes.style "text-align" "center",
--        Html.Styled.Attributes.style "cursor" "pointer"
--        -- Html.Styled.Attributes.style "hover" "color:#FF00FF",  
--        -- Html.Styled.Attributes.style "active" "color:#0000FF" 
--    ]

--startButtonCSS : List (Html.Attribute Msg)
--startButtonCSS =
--    [   Html.Styled.Attributes.style "width" "250px",
--        Html.Styled.Attributes.style "height" "40px",
--        Html.Styled.Attributes.style "color" "white",
--        Html.Styled.Attributes.style "background-color" "#347DDB",
--        Html.Styled.Attributes.style "border-radius" "10px",
--        Html.Styled.Attributes.style "border-width" "0",
--        Html.Styled.Attributes.style "margin" "0",
--        Html.Styled.Attributes.style "outline" "none",
--        -- Html.Styled.Attributes.style "font-family" "KaiTi",
--        Html.Styled.Attributes.style "font-size" "30px",
--        Html.Styled.Attributes.style "text-align" "center",
--        Html.Styled.Attributes.style "cursor" "pointer"
--        -- Html.Styled.Attributes.style "hover" "color:#FF00FF",  
--        -- Html.Styled.Attributes.style "active" "color:#0000FF" 
--    ]


-- nameCSS : List (Html.Attribute Msg)
-- nameCSS =
--     [   Html.Styled.Attributes.style "text-align" "center",
--         Html.Styled.Attributes.style "width" "200px",
--         Html.Styled.Attributes.style "color" "white"]


-- heroCSS : List (Html.Attribute Msg)
heroCSS = 
    -- [ Html.Styled.Attributes.style "display" "table-cell",
    --   Html.Styled.Attributes.style "vertical-align" "middle",
    --   Html.Styled.Attributes.style "text-align" "center"
    [
        Html.Styled.Attributes.width 100, 
        Html.Styled.Attributes.height 100,
        -- Html.Styled.Attributes.style "padding-left" "30px",
        -- Html.Styled.Attributes.style "padding-top" "20px",
        Html.Styled.Attributes.style "border-radius" "20px"
    ]
-- canvas : Model -> Html Msg
canvas model =
    let
       p1=model.player1
       p1Teachers = p1.teachers
       p1FirstTeacher = getFirstTeacher p1Teachers

       p2=model.player2
       p2Teachers = p2.teachers
       p2FirstTeacher = getFirstTeacher p2Teachers
    in
    --"#A4C0D7"
        Html.Styled.nav[
                        --Html.Styled.Attributes.style "background-color" "black",
                        Html.Styled.Attributes.style "background-image" "url(./images/Background.jpg)",
                        Html.Styled.Attributes.style "background-repeat" "no-repeat",
                        Html.Styled.Attributes.style "background-size" "100% 100%",
                        Html.Styled.Attributes.style "-moz-background-size" "100% 100%"
        ][
        styleTitle[ Html.Styled.Attributes.style "width" "100%",Html.Styled.Attributes.style "font-size" "300%"][Html.Styled.text "Over-Deducted"],
        Html.Styled.div []
        [   
            -- Html.Styled.Attributes.Html.Styled.Html.Styled.div[][img [src "Logo.png", width "300", height "300"][]],
            styleTitle [Html.Styled.Attributes.style "width" "50%",Html.Styled.Attributes.style "float" "left",Html.Styled.Attributes.style "text-align" "center",Html.Styled.Attributes.style "color" "white"][Html.Styled.text("Player1 Score: " ++  String.fromFloat p1.score)],
            styleTitle [Html.Styled.Attributes.style "width" "50%",Html.Styled.Attributes.style "float" "right",Html.Styled.Attributes.style "text-align" "center",Html.Styled.Attributes.style "color" "white"][Html.Styled.text("Player2 Score: " ++  String.fromFloat p2.score)],            
            Html.Styled.div [
                Html.Styled.Attributes.style "width" "45%",
                Html.Styled.Attributes.style "float" "left" ,
                -- Html.Styled.Attributes.style "background-image" "url(./images/Background.png)",
                -- Html.Styled.Attributes.style "background-repeat" "no-repeat",
                -- Html.Styled.Attributes.style "background-size" "100% 100%",
                -- Html.Styled.Attributes.style "-moz-background-size" "100% 100%",
                Html.Styled.Attributes.style "margin" "2.5%"
                ][playerDemonstrate model.player1],
           Html.Styled.div [
                Html.Styled.Attributes.style "width" "45%",
                Html.Styled.Attributes.style "float" "left" ,
                -- Html.Styled.Attributes.style "background-image" "url(./images/Background.png)",
                -- Html.Styled.Attributes.style "background-repeat" "no-repeat",
                -- Html.Styled.Attributes.style "background-size" "100% 100%",
                -- Html.Styled.Attributes.style "-moz-background-size" "100% 100%",
                Html.Styled.Attributes.style "margin" "2.5%"
                ][playerDemonstrate model.player2],
            Html.Styled.div[Html.Styled.Attributes.style "width" "40%",Html.Styled.Attributes.style "float" "left",Html.Styled.Attributes.style "padding-right" "2%",Html.Styled.Attributes.style "padding-left" "8%"][
                Html.Styled.div [Html.Styled.Attributes.style "width" "50%",Html.Styled.Attributes.style "float" "left"][
                    styleButton[onClick PreviousTeacher1][Html.Styled.text "Previous"],
                    styleText[]  [Html.Styled.text p1FirstTeacher.name],
                    styleButton[onClick NextTeacher1][Html.Styled.text "Next"]
                    
                ],
                Html.Styled.div [Html.Styled.Attributes.style "width" "40%",Html.Styled.Attributes.style "float" "right",Html.Styled.Attributes.style "padding-left" "2%",Html.Styled.Attributes.style "padding-top" "2%"][img (List.append [src p1FirstTeacher.url] heroCSS)[]]
            ],
            Html.Styled.div[Html.Styled.Attributes.style "width" "40%",Html.Styled.Attributes.style "float" "right",Html.Styled.Attributes.style "padding-right" "2%",Html.Styled.Attributes.style "padding-left" "8%"][
                Html.Styled.div [Html.Styled.Attributes.style "width" "50%",Html.Styled.Attributes.style "float" "left"][
                    styleButton[onClick PreviousTeacher2][Html.Styled.text "Previous"],
                    styleText[][Html.Styled.text p2FirstTeacher.name],                    
                    styleButton [onClick NextTeacher2][Html.Styled.text "Next"]
                ],
                 Html.Styled.div[Html.Styled.Attributes.style "width" "40%",Html.Styled.Attributes.style "float" "right",Html.Styled.Attributes.style "padding-left" "2%",Html.Styled.Attributes.style "padding-top" "2%"][img (List.append [src p2FirstTeacher.url] heroCSS) []]
            ],
            div[Html.Styled.Attributes.style "width" "30%",Html.Styled.Attributes.style "float" "left",Html.Styled.Attributes.style "padding-left" "8%"][styleText [] [Html.Styled.text p1FirstTeacher.description]],
            div[Html.Styled.Attributes.style "width" "30%",Html.Styled.Attributes.style "float" "right",Html.Styled.Attributes.style "padding-right" "12%"][styleText [] [Html.Styled.text p2FirstTeacher.description]],
            Html.Styled.div [Html.Styled.Attributes.style "text-align" "center", Html.Styled.Attributes.style "padding-top" "75%"][ styleButton[Html.Styled.Attributes.style "width" "200%",onClick Start][Html.Styled.text "Start"]]
            -- audio [ Html.Attributes.controls True, Html.Attributes.autoplay True, loop True ,src "./audio/success.mp3"][]
        ]
        ]

playerDemonstrate : Player -> Html msg
playerDemonstrate model =
    let
        gWidth = "100"
        gHeight = "50"
        -- screen = rect [fill "#ffffff", x "0", y "0", width gWidth, height gHeight] []
    in

        Html.Styled.div [Html.Styled.Attributes.style "postion" "fixed",Html.Styled.Attributes.style "padding-right" "20px",Html.Styled.Attributes.style "padding-left" "20px"]
            [ Svg.Styled.svg [Svg.Styled.Attributes.width "200%", Svg.Styled.Attributes.width "200%", Svg.Styled.Attributes.viewBox <| "0 0 " ++ gWidth ++ " " ++ gHeight]
              (List.append [ball model.ball, bat model.bat] <| bricks model.bricks )
            ]

bricks : List Brick -> List (Svg.Styled.Svg msg)
bricks bricksInput =
    let
        createBricksFormat model =
           Svg.Styled.image [ xlinkHref "./images/brickBlack.png", preserveAspectRatio "none meet",  x <| String.fromFloat model.x, y <| String.fromFloat model.y, 
           Svg.Styled.Attributes.width <| String.fromFloat model.width, Svg.Styled.Attributes.height <| String.fromFloat model.height, Svg.Styled.Attributes.stroke "#A4C0D7",Svg.Styled.Attributes.strokeWidth "0.1"]
           []
    in
        List.map createBricksFormat bricksInput

ball : Ball -> Svg.Styled.Svg msg 
ball ballInput =
    let 
        createBallFormat model =
        --"#002c5a"
          Svg.Styled.circle [Svg.Styled.Attributes.fill "black", cx <| String.fromFloat model.x, cy <| String.fromFloat model.y, r <| String.fromFloat model.r][]
    in
        createBallFormat ballInput

bat : Bat -> Svg.Styled.Svg msg
bat batInput =
    let 
        createBatFormat model =
          Svg.Styled.rect [Svg.Styled.Attributes.fill "#ffcb0b", x <| String.fromFloat model.x, y <| String.fromFloat model.y, Svg.Styled.Attributes.width <| String.fromFloat model.width, Svg.Styled.Attributes.height <| String.fromFloat model.height] []
    in
        createBatFormat batInput

