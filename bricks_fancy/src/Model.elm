module Model exposing (..)
import Heros exposing (Teacher,teachers)
import Random
--import Heros exposing (Teacher) 




type alias Rec =
    { cx : Float
    , cy : Float
    , halfWidth : Float
    , halfHeight : Float
    }

type Collisiontype 
    = Horizon
    | Vertical
    | Nocollision

type Status 
    = NotStarted
    | Playing
    
recCollisionTest : Rec -> Rec -> Collisiontype
recCollisionTest rec1 rec2 =
    if (abs(rec1.cx - rec2.cx) < rec1.halfWidth + rec2.halfWidth) && (abs(rec1.cy - rec2.cy) < rec1.halfHeight + rec2.halfHeight) && (abs(rec1.cx - rec2.cx) - rec1.halfWidth >= abs(rec1.cy - rec2.cy) - rec1.halfHeight) then
        Horizon
    else if (abs(rec1.cx - rec2.cx) < rec1.halfWidth + rec2.halfWidth) && (abs(rec1.cy - rec2.cy) < rec1.halfHeight + rec2.halfHeight) then
        Vertical
    else
        Nocollision

recInit : Rec
recInit = Rec 0 0 0 0

type alias Brick = 
    { x : Float
    , y : Float
    , width : Float
    , height : Float
    , edge : Rec
    , collision : Bool
    , seed : Random.Seed
    , imageurl : String
    }

type alias Bat = 
    { x : Float
    , y : Float
    , width : Float
    , height : Float
    , edge : Rec
    , xSpeed : Float
    }

type alias Ball = 
    { x : Float
    , y : Float
    , r : Float
    , edge : Rec
    , xSpeed : Float
    , ySpeed : Float
    }

type alias Player =
    { 
    --size : ( Float, Float )
      ball : Ball
    , bat  : Bat
    , bricks : List Brick
    , moveLeft : Bool
    , moveRight : Bool
    , lose : Bool
    , direction : Float
    , teachers : List Teacher
    , score : Float
    , isAI : Bool
    -- , canvasWidth : Int
    -- , canvasHeight : Int
    }

type alias Model = 
    { size : (Float,Float)
    -- , start : Bool
    , player1 : Player
    , player2 : Player
    , status : Status
    }

brickConfig : Brick
brickConfig = Brick 0 0  10  4 recInit False (Random.initialSeed 0) ""

-- batConfig : Bat
-- batConfig = Bat (45/2) (70/2) (20/2) (2.5/2) recInit 0
batConfig : Bat
batConfig = Bat (45/2) (75/2) (20/2) (2.5/2) recInit 0

ballConfig: Ball
ballConfig = Ball (20/2) (70/2) (1.5/2) recInit (1/2) (-1/2)

total : Int
total = 25

canvasWidth : Float
canvasWidth = 100/2
canvasHeight : Float
canvasHeight = 77/2
halfHeight : Float
halfHeight = 38.5/2
halfWidth : Float
halfWidth = 50/2


brickRecUpdate : Brick -> Brick
brickRecUpdate model = 
    let
        halfx = model.width / 2 - 0.2 
        halfy = model.height /2 - 0.2
        newx = model.x + halfx
        newy = model.y + halfy
        newRec = Rec newx newy halfx halfy
    in 
        { model| edge = newRec}

batRecUpdate : Bat -> Bat
batRecUpdate model = 
    let
        halfx = model.width / 2 
        halfy = model.height /2 +0.5
        newx = model.x + halfx
        newy = model.y + halfy
        newRec = Rec newx newy halfx halfy
    in 
        { model| edge = newRec}

ballRecUpdate : Ball -> Ball
ballRecUpdate model = 
    let
        newRec = Rec model.x model.y model.r model.r
    in 
        { model| edge = newRec}


genearateOneBrick : Float -> Float -> Random.Seed-> String -> Brick
genearateOneBrick x y seed url =
    let
        bricktemp = Brick x y brickConfig.width brickConfig.height recInit brickConfig.collision seed url
    in
        brickRecUpdate bricktemp

generateBricks : List Brick -> Int -> Float -> Float -> Random.Seed -> List Brick
generateBricks bricklist number x y seed =
    let
        nexty xinput yinput =
            if (xinput+brickConfig.width) >= canvasWidth then
                yinput + brickConfig.height
            else
                yinput
        nextx xinput = 
            if (xinput+brickConfig.width) < canvasWidth then
                xinput + brickConfig.width
            else
                0 
        ytemp = nexty x y
        ( urlString, seed0 ) =
            randomImages seed
    in
        if number == 0 then
            bricklist
        else
            generateBricks (  genearateOneBrick x y seed0 urlString :: bricklist ) (number - 1) (nextx x) ytemp seed0 


images : List String
images = ["./images/brick1.png","./images/brick2.png","./images/brick3.png","./images/brick4.png"]

getImages : Int -> String
getImages num =
    Maybe.withDefault "" (List.head ( List.drop num images))

randomImages : Random.Seed -> (String, Random.Seed)
randomImages seed0 =
    let
        num = Random.int 0 3
    in
        Random.step (Random.map getImages num) seed0









ballInit : Ball
ballInit = ballRecUpdate ballConfig
batInit : Bat
batInit =batRecUpdate batConfig
brickListInit : List Brick
brickListInit = generateBricks [] total brickConfig.x brickConfig.y (Random.initialSeed 40)

initPlayer : Player
initPlayer = Player ballInit batInit brickListInit False False False 0 teachers 0 False

init : Model 
init = Model (0,0) initPlayer initPlayer NotStarted