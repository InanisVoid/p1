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

type alias Model =
    { ball : Ball
    , bat  : Bat
    , bricks : List Brick
    , lose : Bool
    }


brickConfig : Brick
brickConfig = Brick 0 0 (10*3) (4*3) recInit False

batConfig : Bat
batConfig = Bat (45*3) (70*3) (20*3) (2.5*3) recInit 0

ballConfig: Ball
ballConfig = Ball (25*3) (70*3) (1.5*3) recInit 1 -1

total : Int
total = 50

canvasWidth : Float
canvasWidth = 100*3
canvasHeight : Float
canvasHeight = 77*3
halfHeight : Float
halfHeight = 38.5*3
halfWidth : Float
halfWidth = 50*3

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
