module EditItemPage exposing (EditNoteFormMsg(..), editNoteView, update)

import Css exposing (pct)
import Html.Styled exposing (Html, form, input)
import Html.Styled.Attributes exposing (css, id, value)
import Html.Styled.Events exposing (onInput, onSubmit)
import ItemModel exposing (Item, ItemId)
import Model exposing (Model)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (Page(..), editItemAutofocusId)
import Ui.Button exposing (ButtonType(..))
import Utils exposing (dataTestId)


type EditNoteFormMsg
    = InputEditedNoteTitle String
    | EditNote ItemId Item
    | CancelEdit


update : EditNoteFormMsg -> Model -> ( Model, Cmd EditNoteFormMsg )
update msg model =
    case msg of
        EditNote noteId note ->
            ( { model
                | currentPage = ChecklistPage
                , pending = editNote noteId note model.pending
                , done = editNote noteId note model.done
              }
            , Cmd.none
            )

        InputEditedNoteTitle title ->
            ( applyIfEditNotePage model
                (\noteId note originalNote ->
                    { model
                        | currentPage = EditItemPage noteId { note | title = title } originalNote
                    }
                )
            , Cmd.none
            )

        CancelEdit ->
            ( { model | currentPage = ChecklistPage }, Cmd.none )


applyIfEditNotePage : Model -> (ItemId -> Item -> Item -> Model) -> Model
applyIfEditNotePage model fn =
    case model.currentPage of
        EditItemPage noteId note originalNote ->
            fn noteId note originalNote

        _ ->
            model


editNote : ItemId -> Item -> OpaqueDict ItemId Item -> OpaqueDict ItemId Item
editNote id note =
    OpaqueDict.update id (Maybe.map (always note))


editNoteView : ItemId -> Item -> Item -> Html EditNoteFormMsg
editNoteView noteId note originalNote =
    form
        [ dataTestId "EditNote"
        , onSubmit (EditNote noteId note)
        , css [ Css.width (pct 100) ]
        ]
        [ input [ onInput InputEditedNoteTitle, value note.title, id editItemAutofocusId ] []
        , Ui.Button.button
            { buttonType = Submit
            , label = "Desa els canvis"
            , isEnabled =
                not (String.isEmpty note.title)
                    && (note.title /= originalNote.title)
            }
        , Ui.Button.button
            { buttonType = Button CancelEdit
            , label = "Cancel·la"
            , isEnabled = True
            }
        ]
