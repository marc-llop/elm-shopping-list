module Ui.Background exposing (..)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import NamedInterpolate exposing (interpolate)
import Svg.Styled exposing (..)
import Svg.Styled.Attributes as SvgAttr exposing (..)
import Utils exposing (dataTestId)


whitePolygon pointList =
    polygon [ SvgAttr.fill "white", points pointList ] []



{- An hexagonal repeatable pattern in X and Y, with the hexagons
   aligned vertically (two sides in parallel with the viewport's right side),
   and 11% of horizontal margin between each hexagon (2px if the hex side is 10px).
   The required shape for the pattern to be repeatable is that of a full
   hexagon surrounded by two quarters of hexagon at the top, and two at the bottom,
   as seen in this bad ASCII art:
       |   |
      / /\ \
    / /   \ \
     |    |
     |    |
    \\   /  /
     \\/  /
     |   |
-}


hexPattern =
    pattern
        [ id patternId
        , SvgAttr.viewBox "0 0 19.2 32"
        , SvgAttr.width "76.8" --"38.4"
        , SvgAttr.height "128"
        , patternUnits "userSpaceOnUse"
        ]
        -- top quarters
        [ whitePolygon "0,0 0,10 8.6,5 8.6,0"
        , whitePolygon "10.6,0 10.6,5 19.2,10 19.2,0"

        -- full hexagon
        , whitePolygon "1,11 1,21 9.6,26 18.2,21 18.2,11 9.6,6"

        -- bottom quarters
        , whitePolygon "0,22 0,32 8.6,32 8.6,27"
        , whitePolygon "10.6,27 10.6,32 19.2,32 19.2,22"
        ]



-- A mask that repeats the hexPattern, making the hexagons
-- opaque and the gaps transparent.


hexMask =
    Svg.Styled.mask [ id maskId ]
        [ rect
            [ x "0"
            , y "0"
            , SvgAttr.width "660"
            , SvgAttr.height "660"
            , SvgAttr.fill (idRef patternId)
            ]
            []
        ]


patternId =
    "hexpattern"


maskId =
    "hexmask"


idRef id =
    interpolate "url(#{id})" [ ( "id", id ) ]



-- A background of a textured grid of hexagons separated
-- by transparent gaps.


backgroundSvg imgUrl =
    svg
        [ SvgAttr.height "100%"
        , SvgAttr.viewBox "0 0 660 660"
        ]
        [ defs []
            [ hexPattern
            , hexMask
            ]
        , image
            [ SvgAttr.width "660"
            , SvgAttr.height "660"
            , x "0"
            , y "0"

            --, xlinkHref "https://images.unsplash.com/photo-1546453667-8a8d2d07bc20?w=1080"
            , xlinkHref imgUrl
            , SvgAttr.mask (idRef maskId)
            ]
            []
        ]



-- An artistic gradient background under a hexagon grid textured
-- with imgUrl that fills the screen in all resolutions.


background imgUrl =
    div
        [ dataTestId "Background"
        , Attr.css
            [ Css.display Css.table
            , position fixed
            , zIndex (int -1)
            , Css.width (pct 100)
            , Css.height (pct 100)
            , property "background"
                (interpolate
                    ("radial-gradient(ellipse 110% 40% at bottom right, #3b023a, 50%, transparent),"
                        ++ "radial-gradient(ellipse 180% 160% at -80% -80%, #f57a00, transparent),"
                        ++ "#{backgroundColor}"
                    )
                    [ ( "backgroundColor", "100210" ) ]
                )
            ]
        ]
        [ backgroundSvg imgUrl ]
