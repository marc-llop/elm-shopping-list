module DesignSystem.Colors exposing (..)

import Css exposing (..)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)


white =
    "ffffff"


accentGreen900 =
    "001a0f"


accentGreen850 =
    "00341e"


accentGreen800 =
    "004e2e"


accentGreen750 =
    "00683d"


accentGreen700 =
    "00824c"


accentGreen650 =
    "009c5b"


accentGreen600 =
    "00b66a"


accentGreen550 =
    "00d17a"


accentGreen500 =
    "00e886"


accentGreen450 =
    "0aff99"


accentGreen400 =
    "29ffa6"


accentGreen350 =
    "47ffb3"


accentGreen300 =
    "66ffbf"


accentGreen250 =
    "85ffcc"


accentGreen200 =
    "a3ffd9"


accentGreen150 =
    "c2ffe6"


accentGreen100 =
    "e0fff2"


accentBlue900 =
    "071514"


accentBlue850 =
    "0e2a27"


accentBlue800 =
    "143f3b"


accentBlue750 =
    "1b544e"


accentBlue700 =
    "226962"


accentBlue650 =
    "297e75"


accentBlue600 =
    "309389"


accentBlue550 =
    "36a89c"


accentBlue500 =
    "3ebeb2"


accentBlue450 =
    "50c6bb"


accentBlue400 =
    "66cdc3"


accentBlue350 =
    "7cd5cc"


accentBlue300 =
    "92dcd4"


accentBlue250 =
    "a8e3dd"


accentBlue200 =
    "beeae5"


accentBlue150 =
    "d3f1ee"


accentBlue100 =
    "e9f8f6"


neutral900 =
    "190c00"


neutral850 =
    "321900"


neutral800 =
    "4b2500"


neutral750 =
    "643200"


neutral700 =
    "7d3e00"


neutral650 =
    "964b00"


neutral600 =
    "af5700"


neutral550 =
    "c76400"


neutral500 =
    "e07000"


neutral450 =
    "ff8001"


neutral400 =
    "ff9021"


neutral350 =
    "ffa041"


neutral300 =
    "ffb060"


neutral250 =
    "ffc080"


neutral200 =
    "ffcfa0"


neutral150 =
    "ffdfc0"


neutral100 =
    "ffefdf"


backgroundPurple900 =
    "0b000b"


backgroundPurple850 =
    "160115"


backgroundPurple800 =
    "210120"


backgroundPurple750 =
    "2c022b"


backgroundPurple700 =
    "360236"


backgroundPurple650 =
    "410340"


backgroundPurple600 =
    "4c034b"


backgroundPurple550 =
    "570456"


backgroundPurple500 =
    "61045f"


backgroundPurple450 =
    "8d068b"


backgroundPurple400 =
    "b908b6"


backgroundPurple350 =
    "e40ae1"


backgroundPurple300 =
    "f625f2"


backgroundPurple250 =
    "f851f5"


backgroundPurple200 =
    "fa7cf7"


backgroundPurple150 =
    "fba8fa"


backgroundPurple100 =
    "fdd3fc"


shadeShowcase : ( String, String ) -> Html msg
shadeShowcase ( name, color ) =
    div
        [ css
            [ backgroundColor (hex color)
            , displayFlex
            , width (px 50)
            , height (px 50)
            , alignItems center
            , justifyContent center
            , textShadow4 zero zero (px 5) (hex white)
            ]
        ]
        [ text name ]


colorShowcase : List ( String, String ) -> Html msg
colorShowcase colors =
    div [ css [ displayFlex, flexDirection row ] ]
        (colors |> List.map shadeShowcase)


docs : Chapter x
docs =
    chapter "Colors"
        |> renderComponentList
            [ ( "neutral"
              , colorShowcase
                    [ ( "100", neutral100 )
                    , ( "150", neutral150 )
                    , ( "200", neutral200 )
                    , ( "250", neutral250 )
                    , ( "300", neutral300 )
                    , ( "350", neutral350 )
                    , ( "400", neutral400 )
                    , ( "450", neutral450 )
                    , ( "500", neutral500 )
                    , ( "550", neutral550 )
                    , ( "600", neutral600 )
                    , ( "650", neutral650 )
                    , ( "700", neutral700 )
                    , ( "750", neutral750 )
                    , ( "800", neutral800 )
                    , ( "850", neutral850 )
                    , ( "900", neutral900 )
                    ]
              )
            , ( "accentGreen"
              , colorShowcase
                    [ ( "100", accentGreen100 )
                    , ( "150", accentGreen150 )
                    , ( "200", accentGreen200 )
                    , ( "250", accentGreen250 )
                    , ( "300", accentGreen300 )
                    , ( "350", accentGreen350 )
                    , ( "400", accentGreen400 )
                    , ( "450", accentGreen450 )
                    , ( "500", accentGreen500 )
                    , ( "550", accentGreen550 )
                    , ( "600", accentGreen600 )
                    , ( "650", accentGreen650 )
                    , ( "700", accentGreen700 )
                    , ( "750", accentGreen750 )
                    , ( "800", accentGreen800 )
                    , ( "850", accentGreen850 )
                    , ( "900", accentGreen900 )
                    ]
              )
            , ( "accentBlue"
              , colorShowcase
                    [ ( "100", accentBlue100 )
                    , ( "150", accentBlue150 )
                    , ( "200", accentBlue200 )
                    , ( "250", accentBlue250 )
                    , ( "300", accentBlue300 )
                    , ( "350", accentBlue350 )
                    , ( "400", accentBlue400 )
                    , ( "450", accentBlue450 )
                    , ( "500", accentBlue500 )
                    , ( "550", accentBlue550 )
                    , ( "600", accentBlue600 )
                    , ( "650", accentBlue650 )
                    , ( "700", accentBlue700 )
                    , ( "750", accentBlue750 )
                    , ( "800", accentBlue800 )
                    , ( "850", accentBlue850 )
                    , ( "900", accentBlue900 )
                    ]
              )
            , ( "backgroundPurple"
              , colorShowcase
                    [ ( "100", backgroundPurple100 )
                    , ( "150", backgroundPurple150 )
                    , ( "200", backgroundPurple200 )
                    , ( "250", backgroundPurple250 )
                    , ( "300", backgroundPurple300 )
                    , ( "350", backgroundPurple350 )
                    , ( "400", backgroundPurple400 )
                    , ( "450", backgroundPurple450 )
                    , ( "500", backgroundPurple500 )
                    , ( "550", backgroundPurple550 )
                    , ( "600", backgroundPurple600 )
                    , ( "650", backgroundPurple650 )
                    , ( "700", backgroundPurple700 )
                    , ( "750", backgroundPurple750 )
                    , ( "800", backgroundPurple800 )
                    , ( "850", backgroundPurple850 )
                    , ( "900", backgroundPurple900 )
                    ]
              )
            ]
