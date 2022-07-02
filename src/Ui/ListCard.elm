module Ui.ListCard exposing (..)

import Css exposing (..)
import DesignSystem.ColorDecisions exposing (neutralCardBoxShadowColor, neutralCardColor, neutralCardTextShadowColor, neutralTextColor)
import DesignSystem.Colors exposing (accentGreen, neutral)
import DesignSystem.Sizes exposing (cardBorderRadius, cardBoxShadow, listFontSize)
import ElmBook
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)
import NamedInterpolate exposing (interpolate)
import Ui.Glassmorphism exposing (glassmorphism)
import Ui.ProgressBar exposing (progressBarView)


listCardStyle : List Style
listCardStyle =
    [ listStyle none
    , glassmorphism neutralCardColor
    , displayFlex
    , flexDirection column
    , property "justify-content" "space-evenly"
    , Css.height (px 110)
    , paddingLeft (px 15)
    , paddingRight (px 15)
    , paddingTop (px 10)
    , margin4 (px 3) (px 7) (px 5) (px 5)
    , borderRadius cardBorderRadius
    , cardBoxShadow (hex neutralCardBoxShadowColor)
    , cursor pointer
    ]


listTitleStyle : List Style
listTitleStyle =
    [ marginLeft (px 10)
    , fontSize listFontSize
    , color (hex neutralTextColor)
    , property "text-shadow"
        (interpolate
            "0px 0px 5px #{color}, 0px 0px 7px #{color}"
            [ ( "color", neutralCardTextShadowColor ) ]
        )
    ]


listCardView : String -> Int -> Html msg
listCardView listName progress =
    div [ css listCardStyle ]
        [ span
            [ css listTitleStyle ]
            [ text listName ]
        , progressBarView
            { progress = progress
            , colorLeft = neutral
            , colorRight = accentGreen
            }
        ]


docs : Chapter x
docs =
    chapter "ListCard"
        |> renderComponentList
            [ ( "Complete", listCardView "Groceries" 100 )
            , ( "Partial", listCardView "Materials" 23 )
            ]
