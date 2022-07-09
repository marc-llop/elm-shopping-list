module DesignSystem.StyledIcons exposing (..)

import Css exposing (..)
import DesignSystem.ColorDecisions exposing (deleteIconColor, inputTextColor, inputTextColorGlow, neutralTextColor)
import DesignSystem.Colors exposing (accentBlue, accentGreen, red)
import DesignSystem.Icons as Icons
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (Html)
import NamedInterpolate exposing (interpolate)


iconSize =
    Css.batch
        [ width (px 35)
        , height (px 35)
        ]


svgGlow : String -> Style
svgGlow color =
    property
        "filter"
        (interpolate
            "drop-shadow(0 0 3px #{color})"
            [ ( "color", color ) ]
        )


greenGlow =
    Css.batch
        [ svgGlow accentGreen.s250
        , color (hex accentGreen.s500)
        ]


redGlow =
    Css.batch
        [ svgGlow deleteIconColor
        , color (hex deleteIconColor)
        ]


blueGlow =
    Css.batch
        [ svgGlow accentBlue.s550
        , color (hex accentBlue.s450)
        ]


shiningBlueGlow =
    Css.batch
        [ svgGlow inputTextColorGlow
        , color (hex inputTextColor)
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


redTrash =
    Icons.trash2 [ redGlow, iconSize ]


blueEdit =
    Icons.edit2 [ blueGlow, iconSize ]


blueChevron : Style -> Html msg
blueChevron style =
    Icons.chevronRight [ shiningBlueGlow, iconSize, style ]



-- DOCS


docs : Chapter x
docs =
    chapter "StyledIcons"
        |> renderComponentList
            [ ( "greenPlus", greenPlus )
            , ( "untickedCheck", untickedCheck )
            , ( "tickedCheck", tickedCheck )
            , ( "redTrash", redTrash )
            , ( "blueEdit", blueEdit )
            , ( "blueChevron", blueChevron (Css.batch []) )
            ]
