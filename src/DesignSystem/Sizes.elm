module DesignSystem.Sizes exposing (..)

import Css exposing (boxShadow3, margin4, px, rem, textShadow4, zero)


cardBorderRadius =
    px 10


boxShadowOffset =
    px 2


cardBoxShadow color =
    boxShadow3 boxShadowOffset boxShadowOffset color


cardTextShadow color =
    textShadow4 zero zero (px 3) color


itemFontSize =
    rem 1.2


listFontSize =
    rem 1.5


cardMargins =
    margin4 (px 3) (px 7) (px 5) (px 5)


formHeight =
    px 150
