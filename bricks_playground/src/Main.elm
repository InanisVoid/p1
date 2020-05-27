module Main exposing (main,update,view)
import Playground exposing (game,rectangle,circle,move,Computer,Shape,blue,yellow,black,toX)
import Model exposing (Model, Ball, Brick, Bat,recCollisionTest,recInit,halfWidth,halfHeight,canvasHeight,canvasWidth,ballRecUpdate,batRecUpdate,ballConfig,batConfig,total,brickConfig)
import BrickGenerator exposing (generateBricks)
-- Main

-- main : Program () (Game memory) Msg
main =
    game view update
    { ball=ballInit
    , bat=batInit
    , bricks=brickListInit
    , lose = False
    }

ballInit : Ball
ballInit = ballRecUpdate ballConfig
batInit : Bat
batInit =batRecUpdate batConfig
brickListInit : List Brick
brickListInit = generateBricks [] total brickConfig.x brickConfig.y 

-- init : Model
-- init = Model ballInit batInit brickListInit False

view : Computer -> Model ->List Shape
view computer system =
    List.append [createBatFormat system.bat]
        <| List.append [createBallFormat system.ball] 
          (List.map createBricksFormat system.bricks)

createBricksFormat : Brick -> Shape
createBricksFormat model =
   let
       getMoveX brickRec=
           -halfWidth + brickRec.cx
       getMoveY brickRec=
           halfHeight - brickRec.cy
   in
       rectangle blue (model.width-0.2) (model.height- 0.2) |> move (getMoveX model.edge) (getMoveY model.edge) 


createBatFormat : Bat -> Shape
createBatFormat model =
   let
       getMoveX batRec=
           -halfWidth + batRec.cx
       getMoveY batRec=
           halfHeight - batRec.cy
   in
       rectangle yellow model.width model.height |> move (getMoveX model.edge) (getMoveY model.edge)

createBallFormat : Ball -> Shape
createBallFormat model =
   let
       getMoveX ballRec=
           -halfWidth + ballRec.cx
       getMoveY ballRec=
           halfHeight - ballRec.cy
   in
       circle black model.r |> move (getMoveX model.edge) (getMoveY model.edge)

update : Computer -> Model ->Model
update computer system =
   if system.lose then
       system
   else
       checklose <| updatebricks <| updateball <| updatebat computer system

checklose : Model -> Model
checklose system =
   let
       checkball ball =
           if ball.y>=canvasHeight then
               True
           else
               False
   in
       { ball=system.ball
       , bat = system.bat
       , bricks=system.bricks
       , lose = checkball system.ball
       }
        
updatebat : Computer -> Model -> Model
updatebat computer system =
   { ball=system.ball
   , bat= generateNewBat computer system.bat
   , bricks=system.bricks
   , lose =system.lose
   }

updateball : Model -> Model
updateball system =
   let 
       newball =
           generateNewBall <| wallCollision  <| batCollision system.bat  system.ball 
           --<| allBricksCollision system.ball system.bricks 
   in
       { ball= newball
       , bat= system.bat
       , bricks=system.bricks
       , lose = system.lose
       }

updatebricks : Model -> Model
updatebricks system =
    let 
        changeSpeed flagship model =
            if flagship then
                --let 
                --    tellBall= Debug.log "changeSpeed" model    
                --in
               {model| ySpeed=-model.ySpeed}
            else
                model
        flag=allBricksCollision system.ball system.bricks
        newball = changeSpeed flag system.ball
        newbricks = generateNewBricks flag system.ball system.bricks
    in
        { ball= newball
        , bat= system.bat
        , bricks=newbricks
        , lose=system.lose
        }


generateNewBat : Computer -> Bat -> Bat
generateNewBat computer model =
    let
        xSpeed = toX computer.keyboard
        xNew =  model.x + xSpeed
        batTemp = Bat xNew model.y model.width model.height recInit xSpeed
    in
        batRecUpdate batTemp

generateNewBall : Ball -> Ball
generateNewBall model =
     let
        xNew = model.x + model.xSpeed
        yNew = model.y + model.ySpeed
        ballTemp = Ball xNew yNew model.r recInit model.xSpeed model.ySpeed
    in
        ballRecUpdate ballTemp

wallCollision : Ball -> Ball
wallCollision ball=
    let
        changeSpeed speed pos maxpos= 
            if pos <= 0 ||  pos >= maxpos then
                -speed
            else
                speed

        newXSpeed = changeSpeed ball.xSpeed ball.x canvasWidth
        newYSpeed = changeSpeed ball.ySpeed ball.y canvasHeight
    in
        {ball | xSpeed=newXSpeed, ySpeed=newYSpeed}

batCollision : Bat -> Ball -> Ball
batCollision bat ball=
    let
        changeSpeed speed rec1 rec2= 
            if recCollisionTest rec1 rec2 then
                -speed
            else
                speed

--        newXSpeed = changeSpeed ball.xSpeed bat.edge ball.edge
        newYSpeed = changeSpeed ball.ySpeed bat.edge ball.edge
    in
        {ball |  ySpeed=newYSpeed}

oneBricksCollision : Ball -> Brick -> Brick
oneBricksCollision ball onebrick =
    {onebrick | collision = recCollisionTest onebrick.edge ball.edge}


allBricksCollision : Ball -> List Brick -> Bool
allBricksCollision ball bricks=
    let
        bricksTemp = List.map (oneBricksCollision ball)  bricks
        filterFunction model =
            model.collision
        filterBricks=List.filter filterFunction bricksTemp
        length= List.length filterBricks
--        tellLength=Debug.log "length collision" length 
    in
        if length >0 then
            True
        else
            False

generateNewBricks : Bool -> Ball -> List Brick -> List Brick
generateNewBricks flag ball bricks =
    let 
        bricksTemp = List.map (oneBricksCollision ball)  bricks
        filterFunction model =
            not model.collision
    in
        if flag then
            List.filter filterFunction bricksTemp
        else
            bricks

