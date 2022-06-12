module Background exposing (..)

import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr exposing (css)
import Svg.Styled exposing (..)
import Svg.Styled.Attributes as SvgAttr exposing (..)


hexPattern imgUrl =
    svg
        [ SvgAttr.width "100%"
        , SvgAttr.height "100%"
        ]
        [ image
            [ SvgAttr.width "660"
            , SvgAttr.height "660"
            , x "50%"
            , y "50%"
            , SvgAttr.transform "translate(-330, -330)"
            , xlinkHref imgUrl
            ]
            []
        ]


background imgUrl =
    div
        [ Attr.css
            [ position fixed
            , zIndex (int -1)
            , Css.width (pct 100)
            , Css.height (pct 100)
            , property "background"
                ("radial-gradient(ellipse 110% 40% at bottom right, #3b023a, 50%, transparent),"
                    ++ "radial-gradient(ellipse 180% 160% at -80% -80%, #f57a00, transparent),"
                    ++ "#100210"
                )
            ]
        ]
        [ hexPattern imgUrl ]
