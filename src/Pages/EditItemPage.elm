module Pages.EditItemPage exposing (EditItemFormMsg(..), editItemView, update)

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


editItem : ItemId -> Item -> OpaqueDict ItemId Item -> OpaqueDict ItemId Item
editItem id item =
    OpaqueDict.update id (Maybe.map (always item))


editItemView : ItemId -> Item -> Item -> Html EditItemFormMsg
editItemView itemId item originalItem =
    form
        [ dataTestId "EditItem"
        , onSubmit (EditItem itemId item)
        , css [ Css.width (pct 100) ]
        ]
        [ input [ onInput InputEditedItemTitle, value item.title, id editItemAutofocusId ] []
        , Ui.Button.button
            { buttonType = Submit
            , label = "Desa els canvis"
            , isEnabled =
                not (String.isEmpty item.title)
                    && (item.title /= originalItem.title)
            }
        , Ui.Button.button
            { buttonType = Button CancelEdit
            , label = "Cancel·la"
            , isEnabled = True
            }
        ]
