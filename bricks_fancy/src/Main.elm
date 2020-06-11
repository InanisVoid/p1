module Main exposing (..)
import Browser
import Browser.Dom exposing (getViewport)
import Browser.Events exposing (onAnimationFrameDelta,onKeyDown,onKeyUp,onResize) 
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Json.Encode exposing (..)
import Messages exposing (Msg(..))
import Task
import View exposing (..)
import Update
import Model exposing (Model,init)



import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Model exposing (Status(..))



-- import Debug
-- import Model exposing (Model)
main : Program Json.Encode.Value Model Msg
main =
    Browser.element
        { view =  View.view >> toUnstyled
        , init = \value -> (init, Task.perform GetViewport getViewport)
        , update = Update.update
        
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    let 
        p1 = model.player1
        p2 = model.player2
        -- tell=Debug.log "p1,p2" ((not p1.lose) && (not p2.lose))
    in
    Sub.batch
        [ if (not p1.lose && not p2.lose && p1.score<1000 && p2.score < 1000) && (model.status == Model.Playing )then
            onAnimationFrameDelta Tick

          else
            Sub.none
        , onKeyUp (Decode.map (key False) keyCode)
        , onKeyDown (Decode.map (key True) keyCode)
        , onResize Resize
        ]


key : Bool -> Int -> Msg
key on keycode =
    case keycode of
        37 ->
            MoveLeft2 on

        39 ->
            MoveRight2 on
            
        65 ->
            MoveLeft1 on
          
        68 ->
            MoveRight1 on
            
        _ ->
            Noop