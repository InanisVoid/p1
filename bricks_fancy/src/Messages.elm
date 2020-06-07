module Messages exposing (Msg(..))
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
    | Noop