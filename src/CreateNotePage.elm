module CreateNotePage exposing (..)

import Css exposing (displayFlex, marginRight, pct, px)
import DesignSystem.StyledIcons as Icons
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import ItemModel exposing (IdItemPair, Item, ItemId, itemIdGenerator)
import Model exposing (..)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (Page(..), createNoteAutofocusId)
import Random
import Search
import String.Deburr exposing (deburr)
import Time
import Ui.Button exposing (ButtonType(..))
import Ui.Checklist exposing (checklistView)
import Ui.Item exposing (itemView)
import Utils exposing (dataTestId)


type CreateNoteFormMsg
    = InputNewNoteTitle String
    | CreateNote Item ItemId
    | RequestId Item
    | RetickNote ItemId
    | CancelCreate


update : CreateNoteFormMsg -> Model -> ( Model, Cmd CreateNoteFormMsg )
update msg model =
    case msg of
        InputNewNoteTitle title ->
            ( applyIfCreateNotePage model
                (\note -> { model | currentPage = CreateNotePage { note | title = title } })
            , Cmd.none
            )

        RequestId note ->
            ( model, Random.generate (CreateNote note) itemIdGenerator )

        CreateNote note noteId ->
            ( { model
                | currentPage = ListPage
                , pending =
                    OpaqueDict.insert
                        noteId
                        note
                        model.pending
              }
            , Cmd.none
            )

        RetickNote noteId ->
            let
                ( newDone, newPending ) =
                    move noteId model.done model.pending
            in
            ( { model
                | currentPage = ListPage
                , pending = newPending
                , done = newDone
              }
            , Cmd.none
            )

        CancelCreate ->
            ( { model | currentPage = ListPage }, Cmd.none )


applyIfCreateNotePage : Model -> (Item -> Model) -> Model
applyIfCreateNotePage model fn =
    case model.currentPage of
        CreateNotePage note ->
            fn note

        _ ->
            model


createNoteView : Model -> Item -> Html CreateNoteFormMsg
createNoteView model newNote =
    Html.Styled.form
        [ onSubmit (RequestId newNote)
        , dataTestId "CreateNote"
        , css [ Css.width (pct 100) ]
        ]
        [ input [ onInput InputNewNoteTitle, value newNote.title, id createNoteAutofocusId ] []
        , Ui.Button.button
            { buttonType = Submit
            , label = "Afegeix l'element"
            , isEnabled = not (String.isEmpty newNote.title)
            }
        , Ui.Button.button
            { buttonType = Button CancelCreate
            , label = "Cancel·la"
            , isEnabled = True
            }
        , matchesListView model newNote
        ]


type alias IndexableNote =
    { id : ItemId
    , content : String
    , title : String
    , dateTime : Time.Posix
    }


noteToDatum : IdItemPair -> IndexableNote
noteToDatum ( noteId, note ) =
    { id = noteId
    , content = deburr note.title
    , title = note.title
    , dateTime = Time.millisToPosix 0
    }


datumToNote : IndexableNote -> IdItemPair
datumToNote { id, content, title, dateTime } =
    ( id, { title = title } )


notesMatching : String -> Model.ItemsInModel a -> List IdItemPair
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
        |> sortNotes


matchesListView : Model -> Item -> Html CreateNoteFormMsg
matchesListView model newNote =
    let
        matches =
            notesMatching newNote.title model
    in
    div [ dataTestId "MatchesList", css [ Css.width (pct 100) ] ]
        [ checklistView
            { pending = matches
            , done = []
            , pendingItemView = matchedItemView
            , doneItemView = matchedItemView
            }
        ]


addIcon : Html msg
addIcon =
    div
        [ css [ marginRight (px 10), displayFlex ] ]
        [ Icons.greenPlus ]


matchedItemView : IdItemPair -> Html CreateNoteFormMsg
matchedItemView ( itemId, item ) =
    itemView
        { itemId = itemId
        , item = item
        , state = Ui.Item.ToAdd
        , onTick = RetickNote
        }
