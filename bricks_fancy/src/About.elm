module About exposing (..)
import Css exposing (..)
import Css.Transitions exposing (..)
import Css.Animations exposing (..)
import Html.Styled exposing(..)
import Html.Styled.Attributes exposing (href, style)
import VirtualDom

import Style.Button exposing(styleButton)
import Style.Title  exposing (styleTitle)

view : Html msg
view =
    div[
          style "width" "100vw", 
          style "height" "100vw", 
          style "background" "black",        
          style "overflow" "scroll",
          style "margin" "0 auto",
          style "overflow-x" "hidden",
          style "overflow-y" "hidden"]
      [div[                
      style "border-color" "silver",
      style "border-width" "15px",
      style "border-style" "outset",
      style "margin" "0 auto",
      style "width" "1000px",
      style "height" "500px",
      style "background" "linear-gradient(135deg, rgba(206,188,155,1) 0%, rgba(85,63,50,1) 51%, rgba(42,31,25,1) 100%)"]
    [
      styleTitle[style "width" "100%"][text "About Us"],
      div[style "margin-left" "20%",style "margin-right" "20%"][h1[style "color" "white"][text "TeamName: NULL"]],
      div[style "margin-left" "20%",style "margin-right" "20%"][h1[style "color" "white"][text "TeamMember: Zihao Wei, Yidong Huang, Zhehao Zhu, Bokai HU"]],
      div[style "margin-left" "20%",style "margin-right" "20%"][h1[style "color" "white"][text "CopyRight: All the materials used are authorized or original"]],
      a[href "index.html"][styleButton[style "margin-left" "43%",style "width" "120%"][text "Back to Menu" ]]
    ]]

    
main : VirtualDom.Node msg
main =
    toUnstyled <| view 