module BrickGenerator exposing (..)
import Model exposing (..)

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