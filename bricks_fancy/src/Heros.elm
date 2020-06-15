module Heros exposing(teacherConfig,mN,mK,zQ,hSS,teachers,getFirstTeacher,getNextTeacher,getPreviousTeacher,Teacher)

type alias Teacher =
    {
        ballSpeed : Float
    ,   batSpeed : Float
    ,   batWidth : Float
    ,   score : Float
    ,   name : String
    ,   description : String
    ,   url : String
    ,   background : String
    }


teacherConfig : Teacher
teacherConfig = Teacher 1 1 1 1 "" "" "" ""

mN : Teacher
mN = Teacher 1 1 1 1.2 
    "Cyber King" 
    "Exclusive Bonus:\nThe bonus set by Martinez Chevalier  were in fact a sham. Only the teacher himself can get the bonus. So the teacher will get 1.2 times the grade."
    "./images/MN.jpg"
    "Background: Martinez Chevalier mainly teaches computer science. One of his feature is that bonus is appealing to him. He always sets some unreachable bonus for his students."

mK : Teacher
mK = Teacher 1 1 1.2 1 
    "The Sword of Physics" 
    "Buffer Area:\nMatteo Kosacki can buffer the impact from the students. He will have a bat 1.2 times long." 
    "./images/MK.jpg"
    "Background: Matteo Kosacki is teaching physics. He has an excellent capacity to bear. He can bear more pressure from students than other teachers, which gives him a bigger chance to win the game."

zQ : Teacher
zQ = Teacher 1 1.2 1 1 
    "Hand of Ragnaros" 
    "Turbo:\nZhao Qi's powerful core will provide him incomparable speed. His bat will move 1.2 times faster" 
    "./images/ZQ.jpg"
    "Background: Zhao Qi is a Chinese physics teacher. He is teaching thermodynamics right now. What he is teaching provides him a body like a internal combustion engine. He can heaten his core, which makes he move faster than others."

hSS : Teacher
hSS = Teacher 1.2 1 1 1 
      "The Master of Space" 
      "Curvature-Driven:\nHelmut Heinrich is familiar with various spaces in math, making him even familiar with the real space. Thus, he can accelearate the ball. The ball will travel 1.2 times faster." 
      "./images/HSS.jpg"
      "Background: Helmut Heinrich is a math teacher. It seems that he concentrates on some intricate \"spaces\", which gives him a more agile mind than others. He can drive the students away more effectively."

teachers : List Teacher
teachers = [mN,mK,zQ,hSS]

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

