module Update exposing (update, skillReset)
import Messages exposing (Msg(..))
import Model exposing (Model, Ball, Brick, Bat, Player, canvasHeight, canvasWidth,recInit, recCollisionTest,ballRecUpdate,batRecUpdate,brickConfig,generateBricks,brickRecUpdate,init)
import Heros exposing (getPreviousTeacher,getNextTeacher,getFirstTeacher,Teacher)
import Debug
import Model exposing (batConfig,initPlayer)
import Css exposing (true)
import Model exposing (Status(..))
import Random
import Model exposing (ballInit,brickListInit)
import Model exposing (batInit)
import Heros exposing (Skills(..))
import Model exposing (ballConfig)
--import View exposing (init)
-- import View exposing (initPlayer)
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
           ({model | status=Playing,bgmon=True},Cmd.none)
        
        Reset ->
            let
                p1=model.player1
                p2=model.player2
            in
                ({model | player1={p1|ball=ballInit,bat=batInit,bricks=brickListInit,moveRight=False,moveLeft=False,lose=False,score=0,direction=0,audio = [],bonusSkill=False,chances=(1*2)}
                        , player2={p2|ball=ballInit,bat=batInit,bricks=brickListInit,moveRight=False,moveLeft=False,lose=False,score=0,direction=0,audio = [],bonusSkill=False,chances=(1*2)}
                        , status=NotStarted,bgmon=False},Cmd.none)

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
        
        Player1Skill ->
            let
                -- d= Debug.log "BeforeME" (model.player1).chances
                (p1,p2)  = usingSkills model.player1 model.player2
                -- d2= Debug.log "AfterME" p1.chances
                -- d =Debug.log "P1" "True"
            in
            
                 ({model| player1=p1,player2=p2}, Cmd.none)

        Player2Skill ->
            let
                (p2,p1)  = usingSkills model.player2 model.player1
                -- d =Debug.log "P2" "True"
            in
                ({model| player1=p1,player2=p2}, Cmd.none)


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

        Changeidentity no ->
            let
                ptemp = 
                    if (no == 1) then 
                        model.player1
                    else model.player2
                p = {ptemp| isAI = not ptemp.isAI}
            in
                if (no == 1) then 
                    ({model| player1 = p},Cmd.none)
                else 
                    ({model|player2 = p},Cmd.none)

checkDirection : Player -> Player
checkDirection model =
    let 
        batTemp=model.bat
        batSpeedReset ={batTemp|xSpeed=batConfig.xSpeed}
    in
        if model.moveLeft then
                {model | direction = -1,bat=batSpeedReset}
        else if model.moveRight then
                {model | direction = 1,bat=batSpeedReset}
            else
                {model | direction = 0,bat=batSpeedReset}


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
        checkbrick brick =
            if List.member 36 (List.map (\value->(round value.y) ) brick) then
                True
            else
                False

    in
        { model | lose = (checkball model.ball) || (checkbrick model.bricks) }




--Playground
-- Bat
updateBat : Player -> Player
updateBat  model=
    let 
        ballx = model.ball.x
        batx = model.bat.x+0.5* model.bat.width
        direction = 
            if (model.isAI) then
                if (ballx>batx) then
                    1
                else if (ballx<batx) then
                    -1
                else 
                    0

            else 
                model.direction
    in
        { model | bat = generateNewBat (getFirstTeacher model.teachers) direction model.bat }

generateNewBat : Teacher-> Float -> Bat -> Bat 
generateNewBat teacher direction model =
    let
        dt = teacher.batSpeed
        xSpeed = dt*direction*1.005
        
        getbatTemp =
            if (model.x + xSpeed + batConfig.width*teacher.batWidth) > canvasWidth then 
                Bat (canvasWidth - batConfig.width*teacher.batWidth) model.y (batConfig.width*teacher.batWidth) model.height recInit 0   
            else if (model.x + xSpeed) < 0 then 
                Bat 0 model.y (batConfig.width*teacher.batWidth) model.height recInit 0   
            else
                Bat (model.x + xSpeed) model.y (batConfig.width*teacher.batWidth) model.height recInit xSpeed
        -- d = Debug.log "bat" (batRecUpdate batTemp)
    in
        batRecUpdate getbatTemp




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
            let
                changeByBat =
                    if bat.xSpeed > 0 then
                        (bat.xSpeed - 1)/2
                    else
                        if bat.xSpeed == 0 then 
                            0
                        else
                            (bat.xSpeed + 1)/2

                modifiedChangeByBat = 
                    if ((Tuple.first speed) + changeByBat > 1) then
                        1
                    else if ((Tuple.first speed) + changeByBat < -1) then
                        -1
                    else (Tuple.first speed) + changeByBat
                
                -- d2=Debug.log "batChangeSpeed" changeByBat
            in 
            
            case recCollisionTest rec1 rec2 of
                Model.Horizon -> 
                    ((modifiedChangeByBat) ,-(Tuple.second speed))

                Model.Vertical ->
                    ((modifiedChangeByBat),-(Tuple.second speed))
                
                Model.Nocollision ->speed
            
        -- d1=Debug.log "ballOrignialSpeed" newSpeed        
        
        newSpeed = changeSpeed (ball.xSpeed,ball.ySpeed) bat.edge ball.edge
        
        -- d=Debug.log "ballNewSpeed" newSpeed
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
        
        getBonusSkill =
            if me.bonusSkill && flag == Model.Nocollision then 
                True
            else 
                False


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

        newaudio = 
            if (flag /= Model.Nocollision) then 
                List.append me.audio ["./audio/success.mp3"]
            else
                me.audio 
        
        teacher= getFirstTeacher me.teachers
        getScore =
            if not me.bonusSkill then
                toFloat(round (me.score + (brickScore + getClearLineBonus)*teacher.score))
            else
                -- let
                --     d=Debug.log "getScore" "True"
                -- in
                    (me.score + ((brickScore + getClearLineBonus)*5))
        
        getMe = 
            if not me.bonusSkill then
                 {me| ball= newball, bricks=newBricks,score = getScore,audio = newaudio}
            else
                 {me| ball= newball, bricks=newBricks,score = getScore,bonusSkill=getBonusSkill,audio = newaudio}
    in
        (getMe, getNewOtherPlayer )

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
        number = 5
        seedBrick = Maybe.withDefault brickConfig (List.head <| List.reverse model)
    in
        generateBricks model number brickConfig.x brickConfig.y seedBrick.seed


--HeroSkills

usingSkills : Player ->Player -> (Player,Player)
usingSkills me other = 
    let
        
        myHero=getFirstTeacher me.teachers
        
        (newPlayer1,newPlayer2) = updateSkill myHero me other  

    in 
    --    if me.skill then
    --         (me,other)
    --    else
        ({newPlayer1|chances=(newPlayer1.chances-1)} ,newPlayer2)


updateSkill : Teacher -> Player-> Player -> (Player,Player)
updateSkill hero me other =
    let
        skillAvailable =
            case hero.skill of 
                Bomb ->
                    skillBomb me other
                Bonus -> 
                    (skillBonus me, other)
                ResetBall ->
                    (skillReset me, other)
                Addline ->
                    (me,addOneLineBricks other)
    in
        if me.chances > 0 then
            skillAvailable
        else 
            (me,other)

skillBonus : Player -> Player
skillBonus model =
    {model | bonusSkill = True} 


skillBomb : Player -> Player -> (Player,Player)
skillBomb me other =
    let 
        ballOriginal = me.ball
        ballTemp = {ballOriginal| r=ballOriginal.r*5}
        ballRec = ballRecUpdate ballTemp
        meTemp = {me| ball = ballRec}
        -- d2 = Debug.log "Before" meTemp.score
        (newMe,newOther)=updateBricks other meTemp
        -- d1 = Debug.log "AfterBomb" newMe.score
    in
        ({newMe| ball=ballOriginal},newOther)

skillReset : Player -> Player
skillReset model =
    let
        batTemp = model.bat
        ballOriginal=model.ball
        ballTemp ={ballOriginal|x=(batTemp.x+batConfig.width/2),y=(batTemp.y - 2*ballConfig.r)}
    in 
        {model| ball=ballRecUpdate ballTemp}

 


--Score
clearBrickScore : Float -> Float -> Float
clearBrickScore  model scorenow =
    -- let
    --     sn =Debug.log "sn" scorenow
    --     m = Debug.log "in" (round model)
    -- in
    
    case (round model) of 
        0 ->
            scorenow + 10
        4 ->
            scorenow + 8
        8 ->
            scorenow + 6
        12 ->
            scorenow + 4
        16 ->
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
        4 ->
            200
        8 ->
            100
        12 ->
            50
        16 ->
            50
        _ ->
            25