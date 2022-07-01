module Ui.ListCard exposing (..)

import Css exposing (..)
import DesignSystem.ColorDecisions exposing (neutralCardBoxShadowColor, neutralCardColor, neutralCardTextShadowColor, neutralTextColor)
import DesignSystem.Sizes exposing (cardBorderRadius, cardBoxShadow)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick)
import Ui.Glassmorphism exposing (glassmorphism)


listCardStyle : List Style
listCardStyle =
    [ listStyle none
    , glassmorphism neutralCardColor
    , displayFlex
    , Css.height (px 140)
    , paddingLeft (px 15)
    , paddingRight (px 15)
    , margin4 (px 3) (px 7) (px 5) (px 5)
    , borderRadius cardBorderRadius
    , cardBoxShadow (hex neutralCardBoxShadowColor)
    , color (hex neutralTextColor)
    , textShadow4 zero zero (px 3) (hex neutralCardTextShadowColor)
    , cursor pointer
    ]
