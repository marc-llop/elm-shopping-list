module Pages.ChecklistPage exposing (ChecklistMsg(..), checklistPageView, update)

import Browser.Dom
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import ItemModel exposing (..)
import Model exposing (Model, sortItems)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (..)
import Task
import Ui.Checklist exposing (checklistView)
import Ui.FloatingActionButton exposing (floatingActionButtonView)
import Ui.Item exposing (itemView)
import Utils exposing (dataTestId)


type ChecklistMsg
    = Tick ItemId
    | Untick ItemId
    | OpenCreateItem
    | OpenEditItem ItemId Item
    | RemoveItem ItemId
    | NoOp


update : ChecklistMsg -> Model -> ( Model, Cmd ChecklistMsg )
update msg model =
    case ( msg, model.currentPage ) of
        ( Tick itemId, ChecklistPage ) ->
            let
                ( newPending, newDone ) =
                    Model.move itemId model.pending model.done
            in
            ( { model
                | pending = newPending
                , done = newDone
              }
            , Cmd.none
            )

        ( Untick itemId, ChecklistPage ) ->
            let
                ( newDone, newPending ) =
                    Model.move itemId model.done model.pending
            in
            ( { model
                | pending = newPending
                , done = newDone
              }
            , Cmd.none
            )

        ( OpenCreateItem, ChecklistPage ) ->
            ( { model
                | currentPage = CreateItemPage resetItemForm
              }
            , Task.attempt (\_ -> NoOp) (Browser.Dom.focus createItemAutofocusId)
            )

        ( OpenEditItem itemId item, ChecklistPage ) ->
            ( { model | currentPage = EditItemPage itemId item item }
            , Task.attempt (\_ -> NoOp) (Browser.Dom.focus editItemAutofocusId)
            )

        ( RemoveItem itemId, ChecklistPage ) ->
            ( { model
                | pending = OpaqueDict.remove itemId model.pending
                , done = OpaqueDict.remove itemId model.done
              }
            , Cmd.none
            )

        ( _, _ ) ->
            ( model, Cmd.none )


resetItemForm : Item
resetItemForm =
    { title = "" }


checklistPageView : Model -> Html ChecklistMsg
checklistPageView { pending, done } =
    let
        pendingItems =
            itemDictToList pending

        doneItems =
            itemDictToList done
    in
    div [ dataTestId "ChecklistPage", css [ Css.width (pct 100) ] ]
        [ checklistView
            { pending = pendingItems
            , done = doneItems
            , pendingItemView = pendingItemView
            , doneItemView = doneItemView
            }
        , createItemButtonView
        ]


{-| Returns the (id, item) pairs alphabetically sorted by item title
-}
itemDictToList : OpaqueDict ItemId Item -> List IdItemPair
itemDictToList dict =
    OpaqueDict.toList dict
        |> sortItems


pendingItemView : ( ItemId, Item ) -> Html ChecklistMsg
pendingItemView ( itemId, item ) =
    itemView
        { itemId = itemId
        , item = item
        , state =
            Ui.Item.Pending
                { onRemove = RemoveItem
                , onEdit = OpenEditItem
                }
        , onTick = Tick
        }


doneItemView : ( ItemId, Item ) -> Html ChecklistMsg
doneItemView ( itemId, item ) =
    itemView
        { itemId = itemId
        , item = item
        , state =
            Ui.Item.Done
                { onRemove = RemoveItem
                , onEdit = OpenEditItem
                }
        , onTick = Untick
        }


createItemButtonView : Html ChecklistMsg
createItemButtonView =
    floatingActionButtonView { onClick = OpenCreateItem, styles = [] }
