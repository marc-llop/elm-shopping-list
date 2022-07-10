module Ui.ProgressBar exposing (ProgressBarProps, docs, progressBarView)

{-| A neon glow gradient progress bar with transparent body.

CSS does not yet allow border gradients, so the common workaround is to make
an element with gradient background, and cover it with an inner, smaller
element with opaque background.
This, however, does not allow a transparent body.

The solution approached here is to divide the progress bar in 5 elements:

1.  Left end semicircle, with color A.
2.  Top border, a line with gradient A to B.
3.  Progress line, with gradient A to B, offset so it overlaps with left and right ends.
4.  Bottom border, with gradient A to B.
5.  Right end semicircle, with color B.

```
 _______________________
|   |_______2______|   |
| 1 |_______3______| 5 |
|___|_______4______|___|
```

Codepen implementation: <https://codepen.io/kwirke/pen/RwMPpzV>

-}

import Css exposing (..)
import DesignSystem.Colors exposing (ColorPalette, accentBlue, accentGreen, backgroundPurple, neutral)
import ElmBook
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (Html, div)
import Html.Styled.Attributes exposing (css)
import NamedInterpolate exposing (interpolate)
import Utils exposing (transparencyBackground)


type alias ProgressBarProps =
    { progress : Int
    , colorLeft : ColorPalette
    , colorRight : ColorPalette
    }


container : List Style
container =
    [ height (px 60)
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
    [ width (px 30)
    , height (px 60)
    , overflow hidden
    , position relative
    , before
        [ property "content" "\"\""
        , position absolute
        , width (px 30)
        , height (px 30)
        , variables.side (px 10)
        , top (px 10)
        , border3 (px 4) solid (hex color.s250)
        , variables.missingBorder zero
        , variables.borderOneRadius (px 20)
        , variables.borderTwoRadius (px 20)
        , property "box-shadow"
            (interpolate
                "0 0 6px #{color}, inset 0 0 6px #{color}"
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
                    top (px 35)
    in
    [ width (pct 100)
    , height (px 24)
    , position absolute
    , topOffset
    , overflow hidden
    ]


progressContainer : List Style
progressContainer =
    [ width (pct 100)
    , height (px 24)
    , position absolute
    , top (px 17)
    ]


linearGradient : String -> String -> Style
linearGradient shadeLeft shadeRight =
    property "background"
        (interpolate
            "linear-gradient(to right, #{colorLeft}, 30%, #{colorRight})"
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
            "linear-gradient(to right, #{colorLeft}, 30%, #{colorRight} calc(100% * (100 / {progress})))"
            [ ( "colorLeft", shadeLeft )
            , ( "colorRight", shadeRight )
            , ( "progress", String.fromInt progress )
            ]
        )


borderGlow : ProgressBarProps -> List Style
borderGlow { colorLeft, colorRight } =
    [ width (calc (pct 100) plus (px 8))
    , height (px 4.8)
    , position absolute
    , left (px -4)
    , top (px 9.6)
    , linearGradient colorLeft.s350 colorRight.s350
    , property "filter" "blur(2.8px)"
    ]


borderBody : ProgressBarProps -> List Style
borderBody { colorLeft, colorRight } =
    [ width (pct 100)
    , height (px 3)
    , position absolute
    , top (px 10)
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
            10
    in
    [ width (calc (pct (toFloat progress)) plus (px (sideOffset * 2)))
    , height (px 16)
    , position absolute
    , left (px -sideOffset)
    , top (px 4)
    , borderRadius (px 8)
    , partialGradient progress colorLeft.s350 colorRight.s350
    , property "filter" "blur(1.5px)"
    ]


progressBody : ProgressBarProps -> List Style
progressBody { progress, colorLeft, colorRight } =
    let
        sideOffset =
            6
    in
    [ width (calc (pct (toFloat progress)) plus (px (sideOffset * 2)))
    , height (px 12)
    , position absolute
    , left (px -sideOffset)
    , top (px 6)
    , borderRadius (px 8)

    -- Go from dark to brighter so that the full bar stands out more.
    , partialGradient progress colorLeft.s300 colorRight.s150
    ]


progressGauge : ProgressBarProps -> Html msg
progressGauge props =
    div [ css progressContainer ]
        (if props.progress == 0 then
            []

         else
            [ div [ css (progressGlow props) ] []
            , div [ css (progressBody props) ] []
            ]
        )


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

        barWithBackground p =
            transparencyBackground
                { width = 600, height = 60 }
                (progressBarView p)
    in
    chapter "ProgressBar"
        |> renderComponentList
            [ ( "100%", barWithBackground props )
            , ( "Purple-Blue", barWithBackground { props | colorRight = accentBlue } )
            , ( "Neutral-Green", barWithBackground { props | colorRight = accentGreen, colorLeft = neutral } )
            , ( "75%", barWithBackground { props | progress = 75 } )
            , ( "25%", barWithBackground { props | progress = 25 } )
            , ( "1%", barWithBackground { props | progress = 1 } )
            , ( "0%", barWithBackground { props | progress = 0 } )
            ]
