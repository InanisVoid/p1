module Model exposing (..)
type alias Rec =
    { cx : Float
    , cy : Float
    , halfWidth : Float
    , halfHeight : Float
    }

recCollisionTest : Rec -> Rec -> Bool
recCollisionTest rec1 rec2 =
    if (abs(rec1.cx - rec2.cx) < rec1.halfWidth + rec2.halfWidth) && (abs(rec1.cy - rec2.cy) < rec1.halfHeight + rec2.halfHeight) then
        True
    else
        False

recInit : Rec
recInit = Rec 0 0 0 0

type alias Brick = 
    { x : Float
    , y : Float
    , width : Float
    , height : Float
    , edge : Rec
    , collision : Bool
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
    -- , canvasWidth : Int
    -- , canvasHeight : Int
    }

type alias Model = 
    { player1 : Player
    , player2 : Player
    }

brickConfig : Brick
brickConfig = Brick 0 0 (10/2) (4/2) recInit False

-- batConfig : Bat
-- batConfig = Bat (45/2) (70/2) (20/2) (2.5/2) recInit 0
batConfig : Bat
batConfig = Bat (45/2) (70/2) (1000/2) (2.5/2) recInit 0

ballConfig: Ball
ballConfig = Ball (25/2) (70/2) (1.5/2) recInit (1/2) (-1/2)

total : Int
total = 50

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
        halfx = model.width / 2 
        halfy = model.height /2 
        newx = model.x + halfx
        newy = model.y + halfy
        newRec = Rec newx newy halfx halfy
    in 
        { model| edge = newRec}

batRecUpdate : Bat -> Bat
batRecUpdate model = 
    let
        halfx = model.width / 2 
        halfy = model.height /2 
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


genearateOneBrick : Float -> Float -> Brick
genearateOneBrick x y =
    let
        bricktemp = Brick x y brickConfig.width brickConfig.height recInit brickConfig.collision
    in
        brickRecUpdate bricktemp

generateBricks : List Brick -> Int -> Float -> Float -> List Brick
generateBricks bricklist number x y =
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
    in
        if number == 0 then
            bricklist
        else
            generateBricks ( (genearateOneBrick x y) :: bricklist ) (number - 1) (nextx x) (ytemp) 
