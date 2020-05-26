module Messages exposing (Msg(..))
type Msg
    = Tick Float
    | MoveLeft Bool
    | MoveRight Bool
    | Noop