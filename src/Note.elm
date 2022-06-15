module Note exposing (..)

import Array exposing (Array)
import Css exposing (..)
import DesignSystem.Colors exposing (backgroundPurple, neutral)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)


type NoteId
    = NoteId String


noteIdToString : NoteId -> String
noteIdToString (NoteId id) =
    id


intToNoteId : Int -> NoteId
intToNoteId n =
    NoteId (String.fromInt n)


type alias Note =
    { title : String
    }


type alias NoteIdPair =
    ( NoteId, Note )


resetLiStyle : List Style
resetLiStyle =
    [ listStyle none ]


type NoteState
    = Pending
    | Done


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


glassmorphism : String -> Int -> Int -> Int -> List Style
glassmorphism color opacityPct blurPx saturationPct =
    let
        -- Color as 8-digit hexadecimal number (#rrggbbaa)
        colorHex =
            color ++ percentToHex opacityPct

        saturation =
            clamp 0 200 saturationPct |> String.fromInt

        blur =
            blurPx |> String.fromInt

        backdropFilter =
            "blur(" ++ blur ++ "px) saturate(" ++ saturation ++ "%)"
    in
    [ backgroundColor (hex colorHex)
    , Css.property "backdrop-filter" backdropFilter
    , Css.property "-webkit-backdrop-filter" backdropFilter
    ]


noteStyle : NoteState -> List Style
noteStyle state =
    resetLiStyle
        ++ [ displayFlex
           , alignItems center
           , padding (px 10)
           , fontSize (rem 1.3)
           , color
                (hex
                    (case state of
                        Pending ->
                            neutral.s450

                        Done ->
                            backgroundPurple.s400
                    )
                )
           , borderBottom3 (px 1) solid (hex neutral.s450)
           , cursor pointer
           ]


noteTitleStyle =
    [ flexGrow (int 1) ]
