module Update exposing (update)
import Messages exposing (Msg(..))
import Model exposing (Model, Ball, Brick, Bat, Player, canvasHeight, canvasWidth,recInit, recCollisionTest,ballRecUpdate,batRecUpdate,brickConfig,generateBricks,brickRecUpdate)
import Heros exposing (getPreviousTeacher,getNextTeacher,getFirstTeacher,Teacher)
import Debug
import Model exposing (batConfig)
import Css exposing (true)
-- import View exposing (initPlayer)
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
            ({model | start = True},Cmd.none)

        Resize width height ->
            ( { model | size = ( toFloat width, toFloat height ) }
            , Cmd.none
            )

        GetViewport { viewport } ->
            ( { model
                | size =
                    ( viewport.width
                    , viewport.height
                    )
              }
            , Cmd.none
            )

        MoveLeft1 on ->
            let 
                pTemp =  model.player1 
                p= {pTemp | moveLeft = on, moveRight =  False}
            in
                ( {model| player1=checkDirection p}
                , Cmd.none
                )

        MoveRight1 on ->
            let 
                pTemp =  model.player1 
                p= {pTemp | moveRight = on, moveLeft = False}
            in
                ( {model| player1=checkDirection p}
                , Cmd.none
                )

        MoveLeft2 on ->
            let 
                pTemp =  model.player2 
                p= {pTemp | moveLeft = on, moveRight =  False}
            in
                ( {model| player2=checkDirection p}
                , Cmd.none
                )

        MoveRight2 on ->
            let 
                pTemp =  model.player2 
                p= {pTemp | moveRight = on, moveLeft = False}
            in
                ( {model| player2=checkDirection p}
                , Cmd.none
                )
        PreviousTeacher1 ->
            let     
                pTemp = model.player1
                p = {pTemp | teachers = getPreviousTeacher pTemp.teachers}
            in
                ( {model| player1=p}
                , Cmd.none
                )

        NextTeacher1 ->
            let     
                pTemp = model.player1
                p = {pTemp | teachers = getNextTeacher pTemp.teachers}
            in
                ( {model| player1=p}
                , Cmd.none
                )

        PreviousTeacher2 ->
            let     
                pTemp = model.player2
                p = {pTemp | teachers = getPreviousTeacher pTemp.teachers}
            in
                ( {model| player2=p}
                , Cmd.none
                )

        NextTeacher2 ->
            let     
                pTemp = model.player2
                p = {pTemp | teachers = getNextTeacher pTemp.teachers}
            in
                ( {model| player2=p}
                , Cmd.none
                )

        Tick time ->
            model |> animate 

        Noop ->
            ( model , Cmd.none )


checkDirection : Player -> Player
checkDirection model =
    if model.moveLeft then
            {model | direction = -1}
    else if model.moveRight then
            {model | direction = 1}
        else
            {model | direction = 0}


-- startMove : Model -> Model
-- startMove model =
--     if direction model /= 0 then
--         { model | direction = Just { active = True, elapsed = 0 } }

--     else
--         { model | direction = Nothing }



animate :  Model -> (Model, Cmd Msg)
animate  model =
    let 
        player1=model.player1
        player2=model.player2
    in
        if player1.lose then
           (model, Cmd.none)
        else
            let 
                (nPlayer1Temp1, nPlayer2Temp1) = updateBricks player2 <| updateBall <| updateBat  player1
                (nPlayer2Temp2, nPlayer1Temp2) = updateBricks nPlayer1Temp1 <| updateBall <| updateBat  nPlayer2Temp1
                newPlayer1 = checkLose nPlayer1Temp2
                newPlayer2 = checkLose nPlayer2Temp2
            in
                ( {model| player1 = newPlayer1, player2 = newPlayer2}, Cmd.none)


checkLose : Player -> Player
checkLose model =
    let
        checkball ball =
            if ball.y>=canvasHeight then
                True
            else
                False
    in
        { model | lose = checkball model.ball }


-- Bat
updateBat : Player -> Player
updateBat  model=
    { model | bat = generateNewBat (getFirstTeacher model.teachers) model.direction model.bat }

generateNewBat : Teacher-> Float -> Bat -> Bat 
generateNewBat teacher direction model =
    let
        dt = teacher.batSpeed
        xSpeed = dt*direction
        xNew =  model.x + xSpeed
        batTemp = Bat xNew model.y (batConfig.width*teacher.batWidth) model.height recInit xSpeed
        -- d = Debug.log "bat" (batRecUpdate batTemp)
    in
        batRecUpdate batTemp




--Ball
updateBall : Player -> Player
updateBall model =
    let 
        teachernow = getFirstTeacher model.teachers
        newball =
            generateNewBall teachernow <| wallCollision  <| batCollision model.bat  model.ball
    in
        { model | ball = newball }

generateNewBall : Teacher -> Ball -> Ball
generateNewBall teacher model =
     let
        xNew = model.x + model.xSpeed*teacher.ballSpeed
        yNew = model.y + model.ySpeed*teacher.ballSpeed
        ballTemp = Ball xNew yNew model.r recInit model.xSpeed model.ySpeed
    in
        ballRecUpdate ballTemp

wallCollision : Ball-> Ball
wallCollision ball=
    let
        changeSpeed speed pos maxpos= 
            if  pos <= 0 ||  pos >= maxpos  then
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
            case recCollisionTest rec1 rec2 of
                Model.Horizon -> 
                    ((Tuple.first speed),-(Tuple.second speed))

                Model.Vertical ->
                    ((Tuple.first speed),-(Tuple.second speed))
                
                Model.Nocollision ->speed
            
                
        newSpeed = changeSpeed (ball.xSpeed,ball.ySpeed) bat.edge ball.edge
    in
        {ball |  xSpeed=(Tuple.first newSpeed), ySpeed=(Tuple.second newSpeed) }

--Brick
updateBricks : Player -> Player -> (Player,Player)
updateBricks otherPlayer me =
    let 
        changeSpeed flagship system =
            case flagship of
                Model.Horizon -> 
                    {system | xSpeed=-system.xSpeed}

                Model.Vertical ->
                    {system | ySpeed=-system.ySpeed}
                
                Model.Nocollision ->system
        
       

        (flag, filteredY, brickScore)=allBricksCollision me.ball me.bricks
        newball = changeSpeed flag me.ball
        newBricks = generateNewBricks (flag /= Model.Nocollision) me.ball me.bricks
        
        getNewOtherPlayer =
            if ((flag /= Model.Nocollision) && not (clearLines newBricks filteredY)) then
                addOneLineBricks otherPlayer
            else
                otherPlayer

        getClearLineBonus =
            if ((flag /= Model.Nocollision) && not (clearLines newBricks filteredY)) then
                clearLineBonus filteredY
            else
                0
        
        teacher= getFirstTeacher me.teachers
    in
        ({me| ball= newball, bricks=newBricks,score = toFloat (round (me.score + (brickScore + getClearLineBonus)*teacher.score)) }, getNewOtherPlayer )

oneBricksCollision : Ball -> Brick -> (Brick,Model.Collisiontype) 
oneBricksCollision ball onebrick =
    ({onebrick | collision = ((recCollisionTest onebrick.edge ball.edge) /= Model.Nocollision)},recCollisionTest onebrick.edge ball.edge)


allBricksCollision : Ball -> List Brick -> (Model.Collisiontype,Float,Float)
allBricksCollision ball bricks=
    let
        bricksTemp = List.map (oneBricksCollision ball)  bricks
        filterFunction model =
            (Tuple.first model).collision
        
        filterBricks=List.filter filterFunction bricksTemp
        -- d=Debug.log "Filter" filterBricks
        length= List.length filterBricks
        headBrick=List.head filterBricks
        
        getY =  
            case headBrick of 
                Just b ->
                    (Tuple.first b).y
                Nothing -> 
                    0
        getCollision =
            case headBrick of 
                Just b ->
                    Tuple.second b
                Nothing -> 
                    Model.Nocollision

        getYList =
            let
                filterBricksList = List.map (\value-> (Tuple.first value)) filterBricks
            in
                 List.map (\value->value.y) filterBricksList

        brickscore = List.foldl clearBrickScore 0 getYList
        -- ys= Debug.log "Y" getYList
        -- br = Debug.log "brickscore" brickscore
    in
        (getCollision,getY,brickscore)


generateNewBricks : Bool -> Ball -> List Brick -> List Brick
generateNewBricks flag ball bricks =
    let 
        (bricksTemp,collision) = List.unzip (List.map (oneBricksCollision ball)  bricks)
        filterFunction model =
            not model.collision
    in
        if flag then
            List.filter filterFunction bricksTemp
        else
            bricks

clearLines : List Brick -> Float -> Bool
clearLines model filteredY =
    let 
        getYList bricksTemp =
            bricksTemp.y
        yList = List.map getYList model
    in
        List.member filteredY yList

addOneLineBricks : Player -> Player
addOneLineBricks onePlayer =
    let 
        brickList = onePlayer.bricks
        newBricks = addNewBricks <| updateOriginalBricks brickList
    in
        {onePlayer | bricks =  newBricks } 

updateOriginalBricks : List Brick -> List Brick
updateOriginalBricks model =
    let 
        adding brickTemp1 = 
            {brickTemp1 | y = brickTemp1.y + brickConfig.height}
        updatingEdge brickTemp2 =
            brickRecUpdate brickTemp2
    in
        List.map updatingEdge <| List.map adding model

addNewBricks : List Brick -> List Brick
addNewBricks model =
    let 
        number = 10
    in
        generateBricks model number brickConfig.x brickConfig.y


clearBrickScore : Float -> Float -> Float
clearBrickScore  model scorenow =
    -- let
    --     sn =Debug.log "sn" scorenow
    --     m = Debug.log "in" (round model)
    -- in
    
    case (round model) of 
        0 ->
            scorenow + 10
        2 ->
            scorenow + 8
        4 ->
            scorenow + 6
        6 ->
            scorenow + 4
        8 ->
            scorenow + 2
        _ ->
            scorenow + 1



clearLineBonus : Float -> Float
clearLineBonus model =
    -- let
    --     m = Debug.log "in" (round model)
    -- in
    case (round model) of 
        0 ->
            300
        2 ->
            200
        4 ->
            100
        6 ->
            50
        8 ->
            50
        _ ->
            25