module Update exposing (update)
import Messages exposing (Msg(..))
import Model exposing (Model, Ball, Brick, Bat, Player, canvasHeight, canvasWidth,recInit, recCollisionTest,ballRecUpdate,batRecUpdate)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of

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
                newPlayer1 = checkLose <| updateBricks <| updateBall <| updateBat  player1
                newPlayer2 = checkLose <| updateBricks <| updateBall <| updateBat  player2
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
    { model | bat = generateNewBat  model.direction model.bat }

generateNewBat : Float -> Bat -> Bat 
generateNewBat  direction model =
    let
        dt = 1.0
        xSpeed = dt*direction
        xNew =  model.x + xSpeed
        batTemp = Bat xNew model.y model.width model.height recInit xSpeed
    in
        batRecUpdate batTemp




--Ball
updateBall : Player -> Player
updateBall model =
    let 
        newball =
            generateNewBall  <| wallCollision  <| batCollision model.bat  model.ball
    in
        { model | ball = newball }

generateNewBall : Ball -> Ball
generateNewBall model =
     let
        xNew = model.x + model.xSpeed
        yNew = model.y + model.ySpeed
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
            if recCollisionTest rec1 rec2 then
                -speed
            else
                speed
        newYSpeed = changeSpeed ball.ySpeed bat.edge ball.edge
    in
        {ball |  ySpeed=newYSpeed }

--Brick
updateBricks : Player -> Player
updateBricks model =
    let 
        changeSpeed flagship system =
            if flagship then
               {system | ySpeed=-system.ySpeed}
            else
                system
        flag=allBricksCollision model.ball model.bricks
        newball = changeSpeed flag model.ball
        newbricks = generateNewBricks flag model.ball model.bricks
    in
        { model 
        | ball= newball
        , bricks=newbricks
        }

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

