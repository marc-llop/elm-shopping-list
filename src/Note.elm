module Note exposing (..)

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
