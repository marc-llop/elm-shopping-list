module Pages.EditItemPage exposing (EditItemFormMsg(..), editItemView, update)

import Html.Styled exposing (Html)
import Html.Styled.Attributes exposing (id)
import ItemModel exposing (Item, ItemId)
import Model exposing (Model)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (Page(..), editItemAutofocusId)
import Ui.ItemForm exposing (itemFormView)
import Utils exposing (dataTestId)


type EditItemFormMsg
    = InputEditedItemTitle String
    | EditItem ItemId Item
    | CancelEdit


update : EditItemFormMsg -> Model -> ( Model, Cmd EditItemFormMsg )
update msg model =
    case msg of
        EditItem itemId item ->
            ( { model
                | currentPage = ChecklistPage
                , pending = editItem itemId item model.pending
                , done = editItem itemId item model.done
              }
            , Cmd.none
            )

        InputEditedItemTitle title ->
            ( applyIfEditItemPage model
                (\itemId item originalItem ->
                    { model
                        | currentPage = EditItemPage itemId { item | title = title } originalItem
                    }
                )
            , Cmd.none
            )

        CancelEdit ->
            ( { model | currentPage = ChecklistPage }, Cmd.none )


applyIfEditItemPage : Model -> (ItemId -> Item -> Item -> Model) -> Model
applyIfEditItemPage model fn =
    case model.currentPage of
        EditItemPage itemId item originalItem ->
            fn itemId item originalItem

        _ ->
            model


editItemView : ItemId -> { title : String } -> Item -> Html EditItemFormMsg
editItemView itemId { title } originalItem =
    let
        itemExists =
            False

        mapMessage : Ui.ItemForm.Msg -> EditItemFormMsg
        mapMessage msg =
            case msg of
                Ui.ItemForm.Input s ->
                    InputEditedItemTitle s

                Ui.ItemForm.Submit ->
                    EditItem itemId { title = title }

                Ui.ItemForm.Cancel ->
                    CancelEdit

        editItemFormView props =
            Html.Styled.map mapMessage (itemFormView props)
    in
    editItemFormView
        { dataTestId = "EditItem"
        , autoFocusId = editItemAutofocusId
        , value = title
        , formType = Ui.ItemForm.EditItem itemExists (ItemModel.title originalItem)
        }
