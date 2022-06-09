module DesignSystem.Colors exposing (..)

import Css exposing (..)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)


type alias ColorPalette =
    { s900 : String
    , s850 : String
    , s800 : String
    , s750 : String
    , s700 : String
    , s650 : String
    , s600 : String
    , s550 : String
    , s500 : String
    , s450 : String
    , s400 : String
    , s350 : String
    , s300 : String
    , s250 : String
    , s200 : String
    , s150 : String
    , s100 : String
    }


white =
    "ffffff"


black =
    "000000"


accentGreen : ColorPalette
accentGreen =
    { s900 = "001a0f"
    , s850 = "00341e"
    , s800 = "004e2e"
    , s750 = "00683d"
    , s700 = "00824c"
    , s650 = "009c5b"
    , s600 = "00b66a"
    , s550 = "00d17a"
    , s500 = "00e886"
    , s450 = "0aff99"
    , s400 = "29ffa6"
    , s350 = "47ffb3"
    , s300 = "66ffbf"
    , s250 = "85ffcc"
    , s200 = "a3ffd9"
    , s150 = "c2ffe6"
    , s100 = "e0fff2"
    }


accentBlue : ColorPalette
accentBlue =
    { s900 = "071514"
    , s850 = "0e2a27"
    , s800 = "143f3b"
    , s750 = "1b544e"
    , s700 = "226962"
    , s650 = "297e75"
    , s600 = "309389"
    , s550 = "36a89c"
    , s500 = "3ebeb2"
    , s450 = "50c6bb"
    , s400 = "66cdc3"
    , s350 = "7cd5cc"
    , s300 = "92dcd4"
    , s250 = "a8e3dd"
    , s200 = "beeae5"
    , s150 = "d3f1ee"
    , s100 = "e9f8f6"
    }


neutral : ColorPalette
neutral =
    { s900 = "190c00"
    , s850 = "321900"
    , s800 = "4b2500"
    , s750 = "643200"
    , s700 = "7d3e00"
    , s650 = "964b00"
    , s600 = "af5700"
    , s550 = "c76400"
    , s500 = "e07000"
    , s450 = "ff8001"
    , s400 = "ff9021"
    , s350 = "ffa041"
    , s300 = "ffb060"
    , s250 = "ffc080"
    , s200 = "ffcfa0"
    , s150 = "ffdfc0"
    , s100 = "ffefdf"
    }


backgroundPurple : ColorPalette
backgroundPurple =
    { s900 = "0b000b"
    , s850 = "160115"
    , s800 = "210120"
    , s750 = "2c022b"
    , s700 = "360236"
    , s650 = "410340"
    , s600 = "4c034b"
    , s550 = "570456"
    , s500 = "61045f"
    , s450 = "8d068b"
    , s400 = "b908b6"
    , s350 = "e40ae1"
    , s300 = "f625f2"
    , s250 = "f851f5"
    , s200 = "fa7cf7"
    , s150 = "fba8fa"
    , s100 = "fdd3fc"
    }


shadeShowcase : Int -> ( String, String ) -> Html msg
shadeShowcase index ( name, shade ) =
    div
        [ css
            [ backgroundColor (hex shade)
            , color
                (hex
                    (if index > 9 then
                        white

                     else
                        black
                    )
                )
            , displayFlex
            , width (px 50)
            , height (px 50)
            , alignItems center
            , justifyContent center

            -- , textShadow4 zero zero (px 5) (hex white)
            ]
        ]
        [ text name ]


colorShowcase : List ( String, String ) -> Html msg
colorShowcase colors =
    div [ css [ displayFlex, flexDirection row ] ]
        (colors |> List.indexedMap shadeShowcase)


paletteShowcase : ColorPalette -> Html msg
paletteShowcase palette =
    colorShowcase
        [ ( "100", palette.s100 )
        , ( "150", palette.s150 )
        , ( "200", palette.s200 )
        , ( "250", palette.s250 )
        , ( "300", palette.s300 )
        , ( "350", palette.s350 )
        , ( "400", palette.s400 )
        , ( "450", palette.s450 )
        , ( "500", palette.s500 )
        , ( "550", palette.s550 )
        , ( "600", palette.s600 )
        , ( "650", palette.s650 )
        , ( "700", palette.s700 )
        , ( "750", palette.s750 )
        , ( "800", palette.s800 )
        , ( "850", palette.s850 )
        , ( "900", palette.s900 )
        ]


docs : Chapter x
docs =
    chapter "Colors"
        |> renderComponentList
            [ ( "neutral", paletteShowcase neutral )
            , ( "accentGreen", paletteShowcase accentGreen )
            , ( "accentBlue", paletteShowcase accentBlue )
            , ( "backgroundPurple", paletteShowcase backgroundPurple )
            ]
