module Pages.EditItemPage exposing (EditItemFormMsg(..), editItemView, update)

import ChecklistModel exposing (Checklist)
import Html.Styled exposing (Html)
import Html.Styled.Attributes exposing (id)
import ItemModel exposing (Item, ItemId)
import Model exposing (Model)
import Page exposing (Page(..), editItemAutofocusId)
import Ui.ItemForm exposing (itemFormView)


type EditItemFormMsg
    = InputEditedItemTitle String
    | EditItem
    | CancelEdit


update : EditItemFormMsg -> Model -> ( Model, Cmd EditItemFormMsg )
update msg model =
    case msg of
        EditItem ->
            let
                updateModel itemId newItem =
                    { model
                        | currentPage = ChecklistPage
                        , checklist = ChecklistModel.replace itemId newItem model.checklist
                    }
            in
            ( applyIfEditItemPage model
                (\originalItem { title } ->
                    ItemModel.editItem originalItem title
                        |> updateModel (ItemModel.itemId originalItem)
                )
            , Cmd.none
            )

        InputEditedItemTitle newTitle ->
            ( applyIfEditItemPage model
                (\originalItem _ ->
                    { model
                        | currentPage = EditItemPage originalItem { title = newTitle }
                    }
                )
            , Cmd.none
            )

        CancelEdit ->
            ( { model | currentPage = ChecklistPage }, Cmd.none )


applyIfEditItemPage : Model -> (Item -> { title : String } -> Model) -> Model
applyIfEditItemPage model fn =
    case model.currentPage of
        EditItemPage originalItem item ->
            fn originalItem item

        _ ->
            model


editItemView : Item -> { title : String } -> Checklist -> Html EditItemFormMsg
editItemView originalItem { title } checklist =
    let
        editedItem =
            ItemModel.editItem originalItem title

        itemExists =
            ChecklistModel.member editedItem checklist

        mapMessage : Ui.ItemForm.Msg -> EditItemFormMsg
        mapMessage msg =
            case msg of
                Ui.ItemForm.Input s ->
                    InputEditedItemTitle s

                Ui.ItemForm.Submit ->
                    EditItem

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
