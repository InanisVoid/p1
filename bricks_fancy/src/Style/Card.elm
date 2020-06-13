module Style.Card exposing (styledCardFront,styledCardBack, styledCard)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)

import VirtualDom

import Css.Animations exposing (backgroundColor)



    -- height: 100vh;
    -- color: white;
    -- display: flex;
    -- justify-content: center;
    -- align-items: center;
    -- -webkit-perspective: 150rem;
    --         perspective: 150rem;
    -- height: 20rem;
    -- width: 30rem;
    -- position: relative;
    -- }


styledCard =
  styled Html.Styled.div[
    Css.property "perspective" "150rem",
    -- Css.height (rem 20),
    -- Css.width (rem 30),
    Css.position relative,
    Css.property "transform-style" "preserve-3d", 
    Css.property "transition" "all 0.8s ease",
    pseudoClass "hover ._b7c2e4e0"[
       Css.zIndex (int 99),
       Css.transform (rotateY (deg -180) )
      --  Css.width (px 0),
      --  Css.height (px 0)
      ],
    pseudoClass "hover ._6883c43c"[
       Css.zIndex (int 100),
       Css.transform (rotateY (deg 0) )
      ],
    hover [ Css.zIndex (int 7)]
    -- Css.property "transition" "1.5s ease-in-out"
  ]

--     pseudoElement "hover ._eafa5e1b"[
--        Css.zIndex (int 99),
--        Css.transform (rotateY (deg -180) )
--       --  Css.width (px 0),
--       --  Css.height (px 0)
--       ],
--     pseudoElement "hover ._461fd7a7"[
--        Css.zIndex (int 100),
--        Css.transform (rotateY (deg 0) )
--       ]

styledCardFront =
  styled Html.Styled.div[
    Css.display block,
    -- Css.height (rem 15),
    Css.property "transition" "all 0.8s ease",
    Css.position absolute,
    Css.top (px 0),
    Css.left (px 0),
    Css.margin auto,
    -- Css.width (rem 30),
    Css.property "backface-visibility" "hidden",
    borderRadius (px 3),
    Css.overflow Css.hidden,
    Css.property "box-shadow" "0 1.5rem 4rem rgba(0, 0, 0, 0.4)",
    Css.zIndex (int 100),
    Css.property "perspective" "150rem",

    Css.backgroundColor (hex "#1c1c1c")
  ]
styledCardBack =  
  styled Html.Styled.div[
    Css.display block,
    -- Css.height (rem 15),
    Css.property "transition" "all 0.8s ease",
    Css.position absolute,
    Css.top (px 0),
    Css.left (px 0),
    Css.margin auto,
    -- Css.width (rem 30),
    Css.property "backface-visibility" "hidden",
    borderRadius (px 3),
    Css.overflow Css.hidden,
    Css.property "box-shadow" "0 1.5rem 4rem rgba(0, 0, 0, 0.4)",
    
    Css.backgroundColor (hex "#1c1c1c"),
    transform (rotateY(deg -180)),
    -- transform (translate2 (pct -50) (pct -50)),
    Css.zIndex (int 99)

  ]



-- type alias User =
--     { name : String
--     , email : String
--     , password : String
--     , loggedIn : Bool
--     }


-- initialModel : User
-- initialModel =
--     { name = ""
--     , email = ""
--     , password = ""
--     , loggedIn = False
--     }


-- view : User -> Html msg
-- view user =
--   div[][styledCard1[][
--     styledCardFront1[Html.Styled.Attributes.style "color" "white"][Html.Styled.text "Front"],
--     styledCardBack1[Html.Styled.Attributes.style "color" "white" ][Html.Styled.text "Back"]
--   ]]

    
-- main : VirtualDom.Node msg
-- main =
--     toUnstyled <| view initialModel