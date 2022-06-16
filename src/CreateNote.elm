module CreateNote exposing (..)

import Css exposing (fixed, fullWidth, height, int, pct, position, property, width, zIndex)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import Model exposing (..)
import Note exposing (Note, NoteId, NoteIdPair)
import Page exposing (createNoteAutofocusId)
import Search
import String.Deburr exposing (deburr)
import Time
import Ui.Button exposing (ButtonType(..))
import Ui.ListedNote exposing (noteStyle, noteTitleStyle)


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
        , matchesListView model newNote
        ]


type alias IndexableNote =
    { id : NoteId
    , content : String
    , title : String
    , dateTime : Time.Posix
    }


noteToDatum : NoteIdPair -> IndexableNote
noteToDatum ( noteId, note ) =
    { id = noteId
    , content = deburr note.title
    , title = note.title
    , dateTime = Time.millisToPosix 0
    }


datumToNote : IndexableNote -> NoteIdPair
datumToNote { id, content, title, dateTime } =
    ( id, { title = title } )


notesMatching : String -> Model.NotesInModel a -> List NoteIdPair
notesMatching newNoteTitle model =
    let
        notesList =
            allNotes model |> List.map noteToDatum

        allMatchedNotes =
            Search.search
                Search.NotCaseSensitive
                (deburr newNoteTitle)
                notesList
    in
    List.map datumToNote allMatchedNotes


matchesListView : Model -> Note -> Html CreateNoteFormMsg
matchesListView model newNote =
    let
        matches =
            notesMatching newNote.title model
    in
    div [ css [ Css.width (pct 100) ] ]
        [ ul [ css [ Css.margin Css.zero, Css.padding Css.zero ] ]
            (List.map noteView matches)
        ]


noteView : NoteIdPair -> Html CreateNoteFormMsg
noteView ( noteId, note ) =
    li [ css (noteStyle Ui.ListedNote.Pending), onClick (RetickNote noteId) ]
        [ span [ css noteTitleStyle ] [ text note.title ]
        ]
