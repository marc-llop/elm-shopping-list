module DesignSystem.Sizes exposing (..)

import Css exposing (boxShadow3, px)


cardBorderRadius =
    px 10


boxShadowOffset =
    px 2


cardBoxShadow color =
    boxShadow3 boxShadowOffset boxShadowOffset color
