module Pages.ChecklistPage exposing (ChecklistMsg(..), checklistPageView, update)

import Browser.Dom
import ChecklistModel exposing (Checklist, remove, tick, untick)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import ItemModel exposing (Item, ItemId)
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
    | OpenEditItem Item
    | RemoveItem ItemId
    | NoOp


update : ChecklistMsg -> Model -> ( Model, Cmd ChecklistMsg )
update msg model =
    case ( msg, model.currentPage ) of
        ( Tick itemId, ChecklistPage ) ->
            ( { model
                | checklist = tick itemId model.checklist
              }
            , Cmd.none
            )

        ( Untick itemId, ChecklistPage ) ->
            ( { model
                | checklist = untick itemId model.checklist
              }
            , Cmd.none
            )

        ( OpenCreateItem, ChecklistPage ) ->
            ( { model
                | currentPage = CreateItemPage resetItemForm
              }
            , Task.attempt (\_ -> NoOp) (Browser.Dom.focus createItemAutofocusId)
            )

        ( OpenEditItem item, ChecklistPage ) ->
            ( { model | currentPage = EditItemPage item { title = ItemModel.title item } }
            , Task.attempt (\_ -> NoOp) (Browser.Dom.focus editItemAutofocusId)
            )

        ( RemoveItem itemId, ChecklistPage ) ->
            ( { model
                | checklist = remove itemId model.checklist
              }
            , Cmd.none
            )

        ( _, _ ) ->
            ( model, Cmd.none )


resetItemForm : { title : String }
resetItemForm =
    { title = "" }


checklistPageView : Checklist -> Html ChecklistMsg
checklistPageView checklist =
    div [ dataTestId "ChecklistPage", css [ Css.width (pct 100) ] ]
        [ checklistView
            { checklist = checklist
            , pendingItemView = pendingItemView
            , doneItemView = doneItemView
            }
        , createItemButtonView
        ]


pendingItemView : Item -> Html ChecklistMsg
pendingItemView item =
    itemView
        { item = item
        , state =
            Ui.Item.Pending
                { onRemove = RemoveItem
                , onEdit = OpenEditItem
                }
        , onTick = Tick
        }


doneItemView : Item -> Html ChecklistMsg
doneItemView item =
    itemView
        { item = item
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
