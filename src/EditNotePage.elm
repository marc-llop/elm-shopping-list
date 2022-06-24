module EditNotePage exposing (EditNoteFormMsg(..), editNoteView, update)

import Css exposing (pct)
import Html.Styled exposing (Html, form, input)
import Html.Styled.Attributes exposing (css, id, value)
import Html.Styled.Events exposing (onInput, onSubmit)
import Model exposing (Model)
import Note exposing (Note, NoteId)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (Page(..), editNoteAutofocusId)
import Ui.Button exposing (ButtonType(..))
import Utils exposing (dataTestId)


type EditNoteFormMsg
    = InputEditedNoteTitle String
    | EditNote NoteId Note
    | CancelEdit


update : EditNoteFormMsg -> Model -> ( Model, Cmd EditNoteFormMsg )
update msg model =
    case msg of
        EditNote noteId note ->
            ( { model
                | currentPage = ListPage
                , pending = editNote noteId note model.pending
                , done = editNote noteId note model.done
              }
            , Cmd.none
            )

        InputEditedNoteTitle title ->
            ( applyIfEditNotePage model
                (\noteId note -> { model | currentPage = EditNotePage noteId { note | title = title } })
            , Cmd.none
            )

        CancelEdit ->
            ( { model | currentPage = ListPage }, Cmd.none )


applyIfEditNotePage : Model -> (NoteId -> Note -> Model) -> Model
applyIfEditNotePage model fn =
    case model.currentPage of
        EditNotePage noteId note ->
            fn noteId note

        _ ->
            model


editNote : NoteId -> Note -> OpaqueDict NoteId Note -> OpaqueDict NoteId Note
editNote id note =
    OpaqueDict.update id (Maybe.map (always note))


editNoteView : NoteId -> Note -> Html EditNoteFormMsg
editNoteView noteId note =
    form
        [ dataTestId "EditNote"
        , onSubmit (EditNote noteId note)
        , css [ Css.width (pct 100) ]
        ]
        [ input [ onInput InputEditedNoteTitle, value note.title, id editNoteAutofocusId ] []
        , Ui.Button.button
            { buttonType = Submit
            , label = "Save note"
            , isEnabled = not (String.isEmpty note.title)
            }
        , Ui.Button.button
            { buttonType = Button CancelEdit
            , label = "Cancel edit"
            , isEnabled = True
            }
        ]
