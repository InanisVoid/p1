module View exposing (..)
import Model exposing (..)
import Update exposing (..)
import Heros exposing (..)
import Messages exposing (Msg(..))
import Style.Button exposing (styleButton)
import Style.Title exposing (styleTitle)
import Style.Text exposing (styleText)
import Style.Card exposing (styledCard,styledCardFront,styledCardBack)
import Json.Encode

import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src,autoplay,loop)
import Html.Styled.Events exposing (onClick)

import Svg exposing (..)
import Svg.Styled exposing (..)
import Svg.Styled.Attributes exposing (..)

import Random

-- import Debug


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






view : Model -> Html Msg
view model =
    let
        ( w, h ) =
            model.size
        
        configheight =1000
        configwidth = 1000
        r =
            if w / h > 1 then
                Basics.min 1 (h / configwidth)

            else
                Basics.min 1 (w / configheight)

        audioornot = 
            if model.bgmon then
                [audio[src "./audio/bgm.mp3",   autoplay True,loop True][]]
            else[] 
    in
    Html.Styled.div
        [ 
            Html.Styled.Attributes.style "width" "100%"
        , Html.Styled.Attributes.style "height" "100%"
        , Html.Styled.Attributes.style "position" "absolute"
        , Html.Styled.Attributes.style "left" "0"
        , Html.Styled.Attributes.style "top" "0"
        , Html.Styled.Attributes.style "background" "linear-gradient(135deg, rgba(206,188,155,1) 0%, rgba(85,63,50,1) 51%, rgba(42,31,25,1) 100%)"
        , Html.Styled.Attributes.style "overflow" "scroll"
        , Html.Styled.Attributes.style "overflow-x" "hidden"
        ]
        [ Html.Styled.div
            [ 
                Html.Styled.Attributes.style "width" (String.fromFloat configwidth ++ "px")
                , Html.Styled.Attributes.style "height" (String.fromFloat configheight ++ "px")
                , Html.Styled.Attributes.style "position" "absolute"
                , Html.Styled.Attributes.style "left" (String.fromFloat ((w - configwidth*r) / 2) ++ "px")
                , Html.Styled.Attributes.style "top" (String.fromFloat ((h - configheight*r) / 2) ++ "px")
                , Html.Styled.Attributes.style "transform-origin" "0 0"
                , Html.Styled.Attributes.style "transform" ("scale(" ++ String.fromFloat r ++ ")")
            ]
            [ canvas model
            ]
            ,
        div[]audioornot
            -- audio[src "./audio/success.mp3",   autoplay True]
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

        aitext1 = 
            if p1.isAI then 
                "AI"

            else 
                "human" 
        
        aitext2 = 
            if p2.isAI then 
                "AI"
            else 
                "human"

        getstatusmessage = 
         case model.status of 
            NotStarted ->
                Start
            _ ->
                Reset

        getstatustext = 
         case model.status of 
            NotStarted ->
                "Start"
            _ ->
                "Reset"

        toaudio audsrc = 
            audio[src audsrc,   autoplay True][]
        audiolist1 = 
            List.map toaudio p1.audio

        audiolist2 = 
            List.map toaudio p2.audio
        
         

    in
    --"#A4C0D7"
        Html.Styled.div[
                        --Html.Styled.Attributes.style "background-color" "black",
                        Html.Styled.Attributes.style "background-image" "url(./images/Background.jpg)",
                        Html.Styled.Attributes.style "background-repeat" "no-repeat",
                        Html.Styled.Attributes.style "background-size" "100% 100%",
                        Html.Styled.Attributes.style "-moz-background-size" "100% 100%",
                        Html.Styled.Attributes.style "border-color" "silver",
                        Html.Styled.Attributes.style "border-width" "15px",
                        Html.Styled.Attributes.style "border-style" "outset"
        ][
        styleTitle[ Html.Styled.Attributes.style "width" "100%",Html.Styled.Attributes.style "font-size" "300%"][Html.Styled.text "Get out of My Class"],
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
            

            --Html.Styled.Attributes.style "float" "left",Html.Styled.Attributes.style "padding-right" "2%",Html.Styled.Attributes.style "padding-left" "8%"

            styledCard[    Html.Styled.Attributes.style "width" "300px",Html.Styled.Attributes.style "height" "200px",
                            Html.Styled.Attributes.style "top" "440px",Html.Styled.Attributes.style "left" "10px",Html.Styled.Attributes.style "border" "inset silver 10px"][
               styledCardFront[Html.Styled.Attributes.style "width" "300px",Html.Styled.Attributes.style "height" "200px",Html.Styled.Attributes.style "top" "500 px"][
                    Html.Styled.div [Html.Styled.Attributes.style "padding-top" "10%",Html.Styled.Attributes.style "padding-left" "10%",Html.Styled.Attributes.style "float" "left"][img (List.append [src p1FirstTeacher.url] heroCSS)[]],
                    
                    styleText [ 
                                Html.Styled.Attributes.style "margin-top" "10%",
                                Html.Styled.Attributes.style "margin-bottom" "10%",
                                Html.Styled.Attributes.style "margin-right" "7%",
                                Html.Styled.Attributes.style "width" "135px",
                                Html.Styled.Attributes.style "height" "150px",
                                Html.Styled.Attributes.style "float" "right"] 
                                [div[Html.Styled.Attributes.style "margin-top" "10px",Html.Styled.Attributes.style "margin-left" "5px"]
                                    [Html.Styled.p[] [Html.Styled.text p1FirstTeacher.description1],Html.Styled.p[] [Html.Styled.text p1FirstTeacher.description2]]
                                ],

                    styleText[  Html.Styled.Attributes.style "margin-bottom" "5%",
                                Html.Styled.Attributes.style "margin-left" "8%",
                                Html.Styled.Attributes.style "height" "23%",
                                Html.Styled.Attributes.style "width" "110px",
                                Html.Styled.Attributes.style "float" "left"]  
                                [div[Html.Styled.Attributes.style "margin-top" "3px",Html.Styled.Attributes.style "text-align" "center",Html.Styled.Attributes.style "font-size" "120%",Html.Styled.Attributes.style "font-width" "bold"][Html.Styled.text p1FirstTeacher.name]]
                ],
                styledCardBack[Html.Styled.Attributes.style "width" "300px",Html.Styled.Attributes.style "height" "200px",Html.Styled.Attributes.style "top" "500 px",Html.Styled.Attributes.style "color" "white"] 
                               [Html.Styled.div[Html.Styled.Attributes.style "margin-top" "30px",Html.Styled.Attributes.style "margin-left" "20px",Html.Styled.Attributes.style "margin-right" "8px",Html.Styled.Attributes.style "font-family" "serif"][Html.Styled.text p1FirstTeacher.background] ]
            ],
            
            Html.Styled.div[Html.Styled.Attributes.style "float" "left",Html.Styled.Attributes.style "margin-left" "35%",Html.Styled.Attributes.style "margin-top" "-70px",Html.Styled.Attributes.style "margin-top" "-90px",Html.Styled.Attributes.style "width" "50px"][
                styleButton[onClick PreviousTeacher1][Html.Styled.text "Previous"],   
                styleButton[onClick (Changeidentity 1),Html.Styled.Attributes.style "margin-top" "20px"][Html.Styled.text aitext1],               
                styleButton[onClick NextTeacher1,Html.Styled.Attributes.style "margin-top" "20px"][Html.Styled.text "Next"]
            ],
            
            
            styledCard[Html.Styled.Attributes.style "width" "300px",Html.Styled.Attributes.style "height" "200px",
                            Html.Styled.Attributes.style "top" "220px",Html.Styled.Attributes.style "left" "520px",Html.Styled.Attributes.style "border" "inset silver 10px"][
               styledCardFront[Html.Styled.Attributes.style "width" "300px",Html.Styled.Attributes.style "height" "200px",Html.Styled.Attributes.style "top" "500 px"][
                    Html.Styled.div [Html.Styled.Attributes.style "padding-top" "10%",Html.Styled.Attributes.style "padding-left" "10%",Html.Styled.Attributes.style "float" "left"][img (List.append [src p2FirstTeacher.url] heroCSS)[]],
                    
                    styleText [ 
                                Html.Styled.Attributes.style "margin-top" "10%",
                                Html.Styled.Attributes.style "margin-bottom" "10%",
                                Html.Styled.Attributes.style "margin-right" "7%",
                                Html.Styled.Attributes.style "width" "135px",
                                Html.Styled.Attributes.style "height" "150px",
                                Html.Styled.Attributes.style "float" "right"]
                                [div[Html.Styled.Attributes.style "margin-top" "10px",Html.Styled.Attributes.style "margin-left" "5px"]
                                    [Html.Styled.p[] [Html.Styled.text p2FirstTeacher.description1],Html.Styled.p[] [Html.Styled.text p2FirstTeacher.description2]]
                                ],


                    styleText[  Html.Styled.Attributes.style "margin-bottom" "5%",
                                Html.Styled.Attributes.style "margin-left" "8%",
                                Html.Styled.Attributes.style "height" "23%",
                                Html.Styled.Attributes.style "width" "110px",
                                Html.Styled.Attributes.style "float" "left"]
                                [div[Html.Styled.Attributes.style "text-align" "center",Html.Styled.Attributes.style "font-size" "120%",Html.Styled.Attributes.style "font-width" "bold"][Html.Styled.text p2FirstTeacher.name]]
                ],
                styledCardBack[Html.Styled.Attributes.style "width" "300px",Html.Styled.Attributes.style "height" "200px",Html.Styled.Attributes.style "top" "500 px",Html.Styled.Attributes.style "color" "white"]
                                 [Html.Styled.div[Html.Styled.Attributes.style "margin-top" "30px",Html.Styled.Attributes.style "margin-left" "20px",Html.Styled.Attributes.style "margin-right" "8px",Html.Styled.Attributes.style "font-family" "serif"][Html.Styled.text p2FirstTeacher.background] ]
            ],
            
            Html.Styled.div[Html.Styled.Attributes.style "float" "right",Html.Styled.Attributes.style "margin-right" "7%",Html.Styled.Attributes.style "margin-top" "-70px",Html.Styled.Attributes.style "margin-top" "-90px",Html.Styled.Attributes.style "width" "50px"][
                styleButton[onClick PreviousTeacher2][Html.Styled.text "Previous"],            
                styleButton[onClick (Changeidentity 2),Html.Styled.Attributes.style "margin-top" "20px"][Html.Styled.text aitext2],      
                styleButton[onClick NextTeacher2,Html.Styled.Attributes.style "margin-top" "20px"][Html.Styled.text "Next"]
            ],



            -- Html.Styled.div[Html.Styled.Attributes.style "width" "40%",Html.Styled.Attributes.style "float" "right",Html.Styled.Attributes.style "padding-right" "2%",Html.Styled.Attributes.style "padding-left" "8%"][
            --     Html.Styled.div [Html.Styled.Attributes.style "width" "50%",Html.Styled.Attributes.style "float" "left"][
            --         styleButton[onClick PreviousTeacher2][Html.Styled.text "Previous"],
            --         styleText[][Html.Styled.text p2FirstTeacher.name],                    
            --         styleButton [onClick NextTeacher2][Html.Styled.text "Next"]
            --     ],
            --      Html.Styled.div[Html.Styled.Attributes.style "width" "40%",Html.Styled.Attributes.style "float" "right",Html.Styled.Attributes.style "padding-left" "2%",Html.Styled.Attributes.style "padding-top" "2%"][img (List.append [src p2FirstTeacher.url] heroCSS) []]
            -- ],
            

            -- div[Html.Styled.Attributes.style "width" "30%",Html.Styled.Attributes.style "float" "right",Html.Styled.Attributes.style "padding-right" "12%"][styleText [] [Html.Styled.text p2FirstTeacher.description]],
            Html.Styled.div [Html.Styled.Attributes.style "text-align" "center", Html.Styled.Attributes.style "margin-top" "30%"][ styleButton[Html.Styled.Attributes.style "width" "200%",onClick getstatusmessage][Html.Styled.text getstatustext]]
            -- -- audio [ Html.Attributes.controls True, Html.Attributes.autoplay True, loop True ,src "./audio/success.mp3"][]
        ],
        div[]audiolist1,
        div[]audiolist2
    ]

playerDemonstrate : Player -> Html msg
playerDemonstrate model =
    let
        gWidth = "100"
        gHeight = "50"
        -- screen = rect [fill "#ffffff", x "0", y "0", width gWidth, height gHeight] []
    in

        Html.Styled.div [Html.Styled.Attributes.style "postion" "fixed",Html.Styled.Attributes.style "margin-right" "20px",Html.Styled.Attributes.style "margin-left" "20px"]
            [ Svg.Styled.svg [Svg.Styled.Attributes.width "200%", Svg.Styled.Attributes.width "200%", Svg.Styled.Attributes.viewBox <| "0 0 " ++ gWidth ++ " " ++ gHeight]
              (List.append [ball model.ball, bat model.bat] <| bricks model.bricks )
            ]

bricks : List Brick -> List (Svg.Styled.Svg msg)
bricks bricksInput =
    let
        createBricksFormat model =
           Svg.Styled.image [ xlinkHref model.imageurl, preserveAspectRatio "none meet",  x <| String.fromFloat model.x, y <| String.fromFloat model.y, 
           Svg.Styled.Attributes.width <| String.fromFloat model.width, Svg.Styled.Attributes.height <| String.fromFloat model.height, Svg.Styled.Attributes.stroke "white",Svg.Styled.Attributes.strokeWidth "0.2"]
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

