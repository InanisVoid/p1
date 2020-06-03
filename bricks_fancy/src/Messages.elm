module Messages exposing (Msg(..))
type Msg
    = Tick Float
    | MoveLeft1 Bool
    | MoveRight1 Bool
    | MoveLeft2 Bool
    | MoveRight2 Bool
    | Noop