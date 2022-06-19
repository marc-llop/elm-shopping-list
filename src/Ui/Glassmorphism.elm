module Ui.Glassmorphism exposing (..)

import Array exposing (Array)
import Css exposing (..)
import DesignSystem.Colors exposing (backgroundPurple, neutral)
import ElmBook exposing (Msg)
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import NamedInterpolate exposing (interpolate)


type alias GlassmorphismProps =
    { color : String
    , opacityPct : Int
    , blurPx : Int
    , saturationPct : Int
    }


hexDigits : Array Char
hexDigits =
    "0123456789abcdef" |> String.toList |> Array.fromList



-- Returns the hex character for value's lower bits


getHex : Int -> Char
getHex value =
    Array.get (modBy 16 value) hexDigits |> Maybe.withDefault '0'



-- Transforms a number between 0 and 100 into a proportional
-- number between 0 and 255 as a 2-digit hex string.


percentToHex : Int -> String
percentToHex pct =
    let
        clamped =
            clamp 0 100 pct

        pctTo255 =
            clamped * 255 // 100

        ( a, b ) =
            ( pctTo255 // 16, pctTo255 )
    in
    String.fromList [ getHex a, getHex b ]



-- Produces a translucent blurred background style.
-- Base CSS source https://ui.glass/generator/


glassmorphism : GlassmorphismProps -> Style
glassmorphism { color, opacityPct, blurPx, saturationPct } =
    let
        -- Color as 8-digit hexadecimal number (#rrggbbaa)
        colorHex =
            color ++ percentToHex opacityPct

        saturation =
            clamp 0 200 saturationPct |> String.fromInt

        backdropFilter =
            interpolate
                "blur({blur}px) saturate({saturation}%)"
                [ ( "blur", String.fromInt blurPx ), ( "saturation", saturation ) ]
    in
    Css.batch
        [ backgroundColor (hex colorHex)
        , Css.property "backdrop-filter" backdropFilter
        , Css.property "-webkit-backdrop-filter" backdropFilter
        ]


glassCard : GlassmorphismProps -> Html msg
glassCard props =
    div
        [ css
            [ glassmorphism props
            , Css.width (px 150)
            , Css.height (px 150)
            , margin (px 50)
            ]
        ]
        []


docs : Chapter x
docs =
    let
        background component =
            div []
                [ div
                    [ css
                        [ Css.property "background" "repeating-conic-gradient(#808080 0% 25%, transparent 0% 50%) 50% / 20px 20px"
                        , Css.width (px 250)
                        , Css.height (px 250)
                        , position absolute
                        , top zero
                        ]
                    ]
                    []
                , component
                ]

        showcaseGlass p =
            background (glassCard p)

        props =
            { color = "7B4A23"
            , opacityPct = 50
            , blurPx = 4
            , saturationPct = 0
            }
    in
    chapter "Glassmorphism"
        |> renderComponentList
            [ ( "Block (opacity=50, blur=4, saturation=0)", showcaseGlass props )
            , ( "With max saturation (200)", showcaseGlass { props | saturationPct = 200 } )
            , ( "With other color", showcaseGlass { props | color = "111928" } )
            , ( "With less opacity (10)", showcaseGlass { props | opacityPct = 10 } )
            , ( "With less blur (1)", showcaseGlass { props | blurPx = 1 } )
            ]
