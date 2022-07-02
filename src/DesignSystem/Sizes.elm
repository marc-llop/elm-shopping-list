module DesignSystem.Sizes exposing (..)

import Css exposing (boxShadow3, px, rem)


cardBorderRadius =
    px 10


boxShadowOffset =
    px 2


cardBoxShadow color =
    boxShadow3 boxShadowOffset boxShadowOffset color


noteFontSize =
    rem 1.2


listFontSize =
    rem 1.5
