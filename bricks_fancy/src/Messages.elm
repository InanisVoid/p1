module Messages exposing (Msg(..))
import Browser.Dom exposing (Viewport)
type Msg
    = Tick Float
    | MoveLeft1 Bool
    | MoveRight1 Bool
    | MoveLeft2 Bool
    | MoveRight2 Bool
    | NextTeacher1
    | PreviousTeacher1
    | NextTeacher2
    | PreviousTeacher2
    | Resize Int Int
    | GetViewport Viewport
    | Start
    | Reset
    | Noop
    | Changeidentity Int