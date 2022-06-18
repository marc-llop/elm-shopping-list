module Ui.ListedNote exposing (..)

import Css exposing (..)
import DesignSystem.Colors exposing (accentBlue, backgroundPurple, neutral)
import ElmBook exposing (Msg)
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, stopPropagationOn)
import Json.Decode
import Note exposing (Note, NoteId)
import Ui.Glassmorphism exposing (glassmorphism)


type NoteState
    = Pending
    | Done


type alias ListedNoteProps msg =
    { noteId : NoteId
    , note : Note
    , state : NoteState
    , onTick : NoteId -> msg
    , onRemove : NoteId -> msg
    , onEdit : NoteId -> Note -> msg
    }


listedNoteView : ListedNoteProps msg -> Html msg
listedNoteView { noteId, note, state, onTick, onRemove, onEdit } =
    li [ css (noteStyle state), onClick (onTick noteId) ]
        [ span [ css noteTitleStyle ] [ text note.title ]
        , button [ onClickStopPropagation (onRemove noteId) ] [ text "🗑️" ]
        , button [ onClickStopPropagation (onEdit noteId note) ] [ text "✏️" ]
        ]


onClickStopPropagation : msg -> Attribute msg
onClickStopPropagation msg =
    stopPropagationOn "click" <| Json.Decode.succeed ( msg, True )


noteStyle : NoteState -> List Style
noteStyle state =
    resetLiStyle
        ++ glassmorphism
            { color =
                case state of
                    Pending ->
                        neutral.s750

                    Done ->
                        backgroundPurple.s750
            , opacityPct = 35
            , blurPx = 6
            , saturationPct = 100
            }
        ++ [ displayFlex
           , alignItems center
           , padding (px 10)
           , margin4 (px 3) (px 7) (px 5) (px 5)
           , borderRadius (px 10)
           , boxShadow3 (px 2)
                (px 2)
                (hex
                    (case state of
                        Pending ->
                            neutral.s750

                        Done ->
                            backgroundPurple.s650
                    )
                )
           , fontSize (rem 1.2)
           , color
                (hex
                    (case state of
                        Pending ->
                            neutral.s450

                        Done ->
                            backgroundPurple.s400
                    )
                )
           , cursor pointer
           ]


resetLiStyle : List Style
resetLiStyle =
    [ listStyle none ]


noteTitleStyle =
    [ flexGrow (int 1) ]


docs : Chapter x
docs =
    let
        props =
            { noteId = Note.intToNoteId 42
            , note = { title = "Milk" }
            , state = Pending
            , onTick = \_ -> logAction "Ticked"
            , onRemove = \_ -> logAction "Removed"
            , onEdit = \_ _ -> logAction "Edit clicked"
            }
    in
    chapter "Note"
        |> renderComponentList
            [ ( "Pending", listedNoteView props )
            , ( "Done", listedNoteView { props | state = Done, onTick = \_ -> logAction "Unticked" } )
            ]
