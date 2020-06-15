module Background exposing (..)
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
      style "height" "630px",
      style "background" "linear-gradient(135deg, rgba(206,188,155,1) 0%, rgba(85,63,50,1) 51%, rgba(42,31,25,1) 100%)"]
    [
      styleTitle[style "width" "100%"][text "Background"],
      div[style "margin-left" "20%",style "margin-right" "20%"]
      [  h3[style "color" "white"][text """TThe new semester begins. In order to reduce the workload, professors in universities are trying their best to reduce the number of students in their class. So they come up with a wonderful idea to drive away students -- giving more deductions. In this game, two players each choose one professor as their hero. Every time one professor successfully eliminates a line of students, the students in this line will give up the course and choose the opponent’s course. And of course, the teachers’ bearing capacity is limited. If you cannot handle the pressure, namely, do not catch the ball, you will immediately breakdown. Then you will lose your job and fail the game. Therefore, keep careful and try not to let your ball fall off the board and lose the job. In addition, every professor has his or her unique skill. Professors! Use your wisdom to add more students for your opponent and make them lose their jobs by using your superb skill. Defeat your opponent and become the best professor in the university! """]],
      
      a[href "index.html"][styleButton[style "margin-left" "43%",style "width" "120%"][text "Back to Menu" ]]
    ]]

main : VirtualDom.Node msg
main =
    toUnstyled <| view 