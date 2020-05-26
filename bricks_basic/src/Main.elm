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
    Sub.batch
        [ if not model.lose then
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
            MoveLeft on

        39 ->
            MoveRight on

        _ ->
            Noop