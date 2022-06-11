module Note exposing (..)

import Css exposing (..)
import DesignSystem.Colors exposing (neutral)
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


noteStyle : List Style
noteStyle =
    resetLiStyle
        ++ [ displayFlex
           , alignItems center
           , padding (px 10)
           , fontSize (rem 1.3)
           , color (hex neutral.s450)
           , borderBottom3 (px 1) solid (hex neutral.s450)
           ]


noteTitleStyle =
    [ flexGrow (int 1) ]
