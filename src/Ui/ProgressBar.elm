module Ui.ProgressBar exposing (..)

import Css exposing (..)
import DesignSystem.Colors exposing (ColorPalette, backgroundPurple, neutral)
import ElmBook
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (Html, div)
import Html.Styled.Attributes exposing (css)
import NamedInterpolate exposing (interpolate)


type alias ProgressBarProps =
    { progress : Int
    , colorLeft : ColorPalette
    , colorRight : ColorPalette
    }


container : List Style
container =
    [ height (px 30)
    , displayFlex
    ]


type EdgePosition
    = LeftEdge
    | RightEdge


edge : EdgePosition -> ColorPalette -> List Style
edge edgePosition color =
    let
        variables =
            case edgePosition of
                LeftEdge ->
                    { side = left
                    , missingBorder = borderRight
                    , borderOneRadius = borderTopLeftRadius
                    , borderTwoRadius = borderBottomLeftRadius
                    }

                RightEdge ->
                    { side = right
                    , missingBorder = borderLeft
                    , borderOneRadius = borderTopRightRadius
                    , borderTwoRadius = borderBottomRightRadius
                    }
    in
    [ width (px 15)
    , height (px 30)
    , overflow hidden
    , position relative
    , before
        [ property "content" "\"\""
        , position absolute
        , width (px 15)
        , height (px 15)
        , variables.side (px 5)
        , top (px 5)
        , border3 (px 2) solid (hex color.s250)
        , variables.missingBorder zero
        , variables.borderOneRadius (px 10)
        , variables.borderTwoRadius (px 10)
        , property "box-shadow"
            (interpolate
                "0 0 3px #{color}, inset 0 0 3px #{color}"
                [ ( "color", color.s350 ) ]
            )
        ]
    ]


middle : List Style
middle =
    [ flexGrow (int 1)
    , position relative
    ]


type Border
    = TopBorder
    | BottomBorder


barContainer : Border -> List Style
barContainer borderPos =
    let
        topOffset =
            case borderPos of
                TopBorder ->
                    top zero

                BottomBorder ->
                    top (px 17)
    in
    [ width (pct 100)
    , height (px 12)
    , position absolute
    , topOffset
    , overflow hidden
    ]


progressContainer : List Style
progressContainer =
    [ width (pct 100)
    , height (px 12)
    , position absolute
    , top (px 8.5)
    ]


linearGradient : String -> String -> Style
linearGradient shadeLeft shadeRight =
    property "background"
        (interpolate
            "linear-gradient(to right, #{colorLeft}, #{colorRight})"
            [ ( "colorLeft", shadeLeft )
            , ( "colorRight", shadeRight )
            ]
        )



{- Renders a gradient background assuming the width is "progress %" of the width of the total gradient.
   Example: If progress is 20%, the gradient should finish at 500% the width of the element for it to show just the 20% of the gradient.
   If this wasn't proportional, the gradient would just be scaled down:
   full progress:   [aaabbbcccddd]
   linearGradient:  [abcd        ]
   partialGradient: [aaab        ]
-}


partialGradient : Int -> String -> String -> Style
partialGradient progress shadeLeft shadeRight =
    property "background"
        (interpolate
            "linear-gradient(to right, #{colorLeft}, #{colorRight} calc(100% * (100 / {progress})))"
            [ ( "colorLeft", shadeLeft )
            , ( "colorRight", shadeRight )
            , ( "progress", String.fromInt progress )
            ]
        )


borderGlow : ProgressBarProps -> List Style
borderGlow { colorLeft, colorRight } =
    [ width (calc (pct 100) plus (px 4))
    , height (px 2.4)
    , position absolute
    , left (px -2)
    , top (px 4.8)
    , linearGradient colorLeft.s350 colorRight.s350
    , property "filter" "blur(1.4px)"
    ]


borderBody : ProgressBarProps -> List Style
borderBody { colorLeft, colorRight } =
    [ width (pct 100)
    , height (px 2)
    , position absolute
    , top (px 5)
    , linearGradient colorLeft.s250 colorRight.s250
    ]


progressBarBorder : Border -> ProgressBarProps -> Html msg
progressBarBorder borderPos props =
    div [ css (barContainer borderPos) ]
        [ div [ css (borderGlow props) ] []
        , div [ css (borderBody props) ] []
        ]


progressGlow : ProgressBarProps -> List Style
progressGlow { progress, colorLeft, colorRight } =
    let
        sideOffset =
            6
    in
    [ width (calc (pct (toFloat progress)) plus (px (sideOffset * 2)))
    , height (px 8)
    , position absolute
    , left (px -sideOffset)
    , top (px 2)
    , borderRadius (px 4)
    , partialGradient progress colorLeft.s350 colorRight.s350
    , property "filter" "blur(1.5px)"
    ]


progressBody : ProgressBarProps -> List Style
progressBody { progress, colorLeft, colorRight } =
    let
        sideOffset =
            4
    in
    [ width (calc (pct (toFloat progress)) plus (px (sideOffset * 2)))
    , height (px 6)
    , position absolute
    , left (px -sideOffset)
    , top (px 3)
    , borderRadius (px 4)

    -- Go from dark to brighter so that the full bar stands out more.
    , partialGradient progress colorLeft.s300 colorRight.s150
    ]


progressGauge : ProgressBarProps -> Html msg
progressGauge props =
    div [ css progressContainer ]
        [ div [ css (progressGlow props) ] []
        , div [ css (progressBody props) ] []
        ]


progressBarMiddle : ProgressBarProps -> Html msg
progressBarMiddle props =
    div [ css middle ]
        [ progressBarBorder TopBorder props
        , progressGauge props
        , progressBarBorder BottomBorder props
        ]


progressBarView : ProgressBarProps -> Html msg
progressBarView props =
    let
        clampedProgress =
            clamp 0 100 props.progress

        sanitizedProps =
            { props | progress = clampedProgress }
    in
    div [ css container ]
        [ div [ css (edge LeftEdge props.colorLeft) ] []
        , progressBarMiddle sanitizedProps
        , div [ css (edge RightEdge props.colorRight) ] []
        ]



-- DOCS


docs : Chapter x
docs =
    let
        props =
            { progress = 100
            , colorLeft = backgroundPurple
            , colorRight = neutral
            }
    in
    chapter "ProgressBar"
        |> renderComponentList
            [ ( "Full", progressBarView props )
            , ( "3/4", progressBarView { props | progress = 75 } )
            , ( "2/5", progressBarView { props | progress = 40 } )
            , ( "1/4", progressBarView { props | progress = 25 } )
            , ( "Empty", progressBarView { props | progress = 0 } )
            ]
