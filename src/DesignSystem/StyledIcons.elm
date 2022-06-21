module DesignSystem.StyledIcons exposing (..)

import Css exposing (..)
import DesignSystem.ColorDecisions exposing (neutralTextColor)
import DesignSystem.Colors exposing (accentGreen, neutral)
import DesignSystem.Icons as Icons
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import NamedInterpolate exposing (interpolate)


iconSize =
    Css.batch
        [ width (px 35)
        , height (px 35)
        ]


greenGlow =
    Css.batch
        [ property
            "filter"
            (interpolate
                "drop-shadow(0 0 3px #{color})"
                [ ( "color", accentGreen.s250 ) ]
            )
        , color (hex accentGreen.s500)
        ]


greenPlus =
    Icons.plus [ greenGlow, iconSize ]


neutral3d =
    Css.batch
        [ color (hex neutralTextColor)
        ]


untickedCheck =
    Icons.square [ neutral3d, iconSize ]


tickedCheck =
    Icons.checkSquare [ greenGlow, iconSize ]


docs : Chapter x
docs =
    chapter "StyledIcons"
        |> renderComponentList
            [ ( "greenPlus", greenPlus )
            , ( "untickedCheck", untickedCheck )
            , ( "tickedCheck", tickedCheck )
            ]
