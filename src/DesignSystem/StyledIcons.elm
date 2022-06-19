module DesignSystem.StyledIcons exposing (..)

import Css exposing (..)
import DesignSystem.Colors exposing (accentGreen)
import DesignSystem.Icons as Icons
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import NamedInterpolate exposing (interpolate)


iconStyles =
    [ property
        "filter"
        (interpolate
            "drop-shadow(0 0 3px #{color})"
            [ ( "color", accentGreen.s250 ) ]
        )
    , color (hex accentGreen.s500)
    , width (px 35)
    , height (px 35)
    ]


greenPlus =
    Icons.plus iconStyles


docs : Chapter x
docs =
    chapter "StyledIcons"
        |> renderComponentList
            [ ( "Green Plus Icon", greenPlus )
            ]
