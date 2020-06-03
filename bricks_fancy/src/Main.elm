module Main exposing (..)
--import Browser.Dom exposing (getViewport)
import Browser
import Browser.Events exposing (onAnimationFrameDelta,onKeyDown,onKeyUp) 
import Html.Events exposing (keyCode)
import Json.Decode as Decode
import Json.Encode exposing (Value)
import Messages exposing (Msg(..))
--import Task
import View exposing (..)
import Update
import Model exposing (Model)
-- import Debug
-- import Model exposing (Model)
main : Program Value Model Msg
main =
    Browser.element
        { init = \value -> (init, Cmd.none)
        , update = Update.update
        , view = View.view
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
        [ if (not p1.lose) || (p1.lose) then
            onAnimationFrameDelta Tick

          else
            Sub.none
        , onKeyUp (Decode.map (key False) keyCode)
        , onKeyDown (Decode.map (key True) keyCode)
        -- , onResize Resize
        ]


key : Bool -> Int -> Msg
key on keycode =
    case keycode of
        37 ->
            MoveLeft1 on

        39 ->
            MoveRight1 on

        65 ->
            MoveLeft2 on

        68 ->
            MoveRight2 on
        _ ->
            Noop