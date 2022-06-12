module CreateNote exposing (..)

import Css exposing (fixed, fullWidth, height, int, pct, position, property, width, zIndex)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import Model exposing (..)
import Note exposing (Note, NoteId, NoteIdPair, noteStyle, noteTitleStyle)
import Page exposing (createNoteAutofocusId)
import Search
import Time
import Ui.Button exposing (ButtonType(..))


type CreateNoteFormMsg
    = InputNewNoteTitle String
    | CreateNote Note
    | RetickNote NoteId
    | CancelCreate


createNoteView : Model -> Note -> Html CreateNoteFormMsg
createNoteView model newNote =
    Html.Styled.form [ onSubmit (CreateNote newNote), css [ Css.width (pct 100) ] ]
        [ input [ onInput InputNewNoteTitle, value newNote.title, id createNoteAutofocusId ] []
        , Ui.Button.button { buttonType = Submit, label = "Add note" }
        , Ui.Button.button { buttonType = Button CancelCreate, label = "Cancel" }
        , matchesList model newNote
        ]


type alias IndexableNote =
    { id : NoteId
    , content : String
    , dateTime : Time.Posix
    }


noteToDatum : NoteIdPair -> IndexableNote
noteToDatum ( noteId, note ) =
    { id = noteId
    , content = note.title
    , dateTime = Time.millisToPosix 0
    }


datumToNote : IndexableNote -> NoteIdPair
datumToNote { id, content, dateTime } =
    ( id, { title = content } )


matchesList : Model -> Note -> Html CreateNoteFormMsg
matchesList model newNote =
    let
        notesList =
            allNotes model |> List.map noteToDatum

        allMatchedNotes =
            Search.search
                Search.NotCaseSensitive
                newNote.title
                notesList
                |> List.map datumToNote
    in
    div [ css [ Css.width (pct 100) ] ]
        [ ul [ css [ Css.margin Css.zero, Css.padding Css.zero ] ]
            (List.map noteView allMatchedNotes)
        ]


noteView : NoteIdPair -> Html CreateNoteFormMsg
noteView ( noteId, note ) =
    li [ css (noteStyle Note.Pending), onClick (RetickNote noteId) ]
        [ span [ css noteTitleStyle ] [ text note.title ]
        ]
