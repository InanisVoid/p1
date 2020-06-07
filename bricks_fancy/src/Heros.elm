module Heros exposing(..)

type alias Teacher =
    {
        ballSpeed : Float
    ,   batSpeed : Float
    ,   batWidth : Float
    ,   score : Float
    ,   name : String
    ,   description : String
    }


teacherConfig : Teacher
teacherConfig = Teacher 1 1 1 1 "" ""

mN : Teacher
mN = Teacher 1 1 1 1.2 "MN" "Score*1.2"

mK : Teacher
mK = Teacher 1 1 1.2 1 "MK" "BatLength*1.2"

zQ : Teacher
zQ = Teacher 1 1.2 1 1 "ZQ" "BatSpeed*1.2"

hSS : Teacher
hSS = Teacher 1.2 1 1 1 "HSS" "BallSpeed*1.2"

teachers : List Teacher
teachers = [hSS,mN,mK,zQ]

getFirstTeacher : List Teacher -> Teacher
getFirstTeacher model = 
    let
        first = List.head model
        getT =
            case first of
                Just t ->
                    t
                Nothing ->
                    teacherConfig
    in
        getT
    

getNextTeacher : List Teacher -> List Teacher
getNextTeacher model =
    let
        firstTeacher = List.take 1 model
        teacherTail = List.drop 1 model 
        
        newTeacher = List.append teacherTail firstTeacher

    in 
        newTeacher


getPreviousTeacher : List Teacher -> List Teacher
getPreviousTeacher model =
    let
        teacherHead = List.take 3 model
        teacherTail = List.drop 3 model 

        newTeacher = List.append teacherTail teacherHead
    in
        newTeacher
