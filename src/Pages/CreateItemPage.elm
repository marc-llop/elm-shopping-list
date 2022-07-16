module Pages.CreateItemPage exposing (..)

import ChecklistModel exposing (Checklist)
import Css exposing (displayFlex, marginRight, pct, px, vh)
import DesignSystem.Sizes exposing (formHeight)
import DesignSystem.StyledIcons as Icons
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import ItemModel exposing (Item, ItemId)
import Model exposing (..)
import Page exposing (Page(..), createItemAutofocusId)
import Search
import String.Deburr exposing (deburr)
import Svg.Styled exposing (title)
import Time
import Ui.Checklist exposing (checklistView)
import Ui.Item exposing (itemView)
import Ui.ItemForm exposing (itemFormView)
import Utils exposing (dataTestId)


type CreateItemFormMsg
    = InputNewItemTitle String
    | CreateItem
    | RetickItem ItemId
    | CancelCreate


update : CreateItemFormMsg -> Model -> ( Model, Cmd CreateItemFormMsg )
update msg model =
    case msg of
        InputNewItemTitle newTitle ->
            ( applyIfCreateItemPage model
                (\_ -> { model | currentPage = CreateItemPage { title = newTitle } })
            , Cmd.none
            )

        CreateItem ->
            ( applyIfCreateItemPage model
                (\{ title } ->
                    let
                        newChecklist =
                            ChecklistModel.insert
                                (ItemModel.newItem title)
                                model.checklist
                    in
                    { model
                        | currentPage = ChecklistPage
                        , checklist = newChecklist
                    }
                )
            , Cmd.none
            )

        RetickItem itemId ->
            ( { model
                | currentPage = ChecklistPage
                , checklist = ChecklistModel.tick itemId model.checklist
              }
            , Cmd.none
            )

        CancelCreate ->
            ( { model | currentPage = ChecklistPage }, Cmd.none )


applyIfCreateItemPage : Model -> ({ title : String } -> Model) -> Model
applyIfCreateItemPage model fn =
    case model.currentPage of
        CreateItemPage item ->
            fn item

        _ ->
            model


pageStyles =
    [ Css.width (pct 100)
    , Css.height (vh 100)
    ]


matchesListStyles =
    [ Css.width (pct 100)
    , Css.height (Css.calc (vh 100) Css.minus formHeight)
    , Css.overflow Css.scroll
    ]


createItemView : Model -> { title : String } -> Html CreateItemFormMsg
createItemView model { title } =
    let
        mapMessage : Ui.ItemForm.Msg -> CreateItemFormMsg
        mapMessage msg =
            case msg of
                Ui.ItemForm.Input s ->
                    InputNewItemTitle s

                Ui.ItemForm.Submit ->
                    CreateItem

                Ui.ItemForm.Cancel ->
                    CancelCreate

        createItemFormMsg props =
            Html.Styled.map mapMessage (itemFormView props)
    in
    Html.Styled.div
        [ css pageStyles ]
        [ createItemFormMsg
            { dataTestId = "CreateItem"
            , autoFocusId = createItemAutofocusId
            , value = title
            , formType = Ui.ItemForm.CreateItem
            }
        , matchesListView model title
        ]


type alias IndexableItem =
    { id : ItemId
    , content : String
    , title : String
    , dateTime : Time.Posix
    }


itemToDatum : Item -> IndexableItem
itemToDatum item =
    { id = ItemModel.itemId item
    , content = deburr (ItemModel.title item)
    , title = ItemModel.title item
    , dateTime = Time.millisToPosix 0
    }


datumToItem : IndexableItem -> Item
datumToItem { id, content, title, dateTime } =
    ItemModel.newItem title


itemsMatching : String -> Checklist -> Checklist
itemsMatching newItemTitle checklist =
    let
        items =
            ChecklistModel.toList checklist
                |> List.map itemToDatum

        allMatchedItems =
            Search.search
                Search.NotCaseSensitive
                (deburr newItemTitle)
                items
    in
    List.map datumToItem allMatchedItems
        |> ChecklistModel.fromList


matchesListView : Model -> String -> Html CreateItemFormMsg
matchesListView model title =
    let
        matches =
            itemsMatching title model.checklist
    in
    div [ dataTestId "MatchesList", css matchesListStyles ]
        [ checklistView
            { checklist = matches
            , pendingItemView = matchedItemView
            , doneItemView = matchedItemView
            }
        ]


addIcon : Html msg
addIcon =
    div
        [ css [ marginRight (px 10), displayFlex ] ]
        [ Icons.greenPlus ]


matchedItemView : Item -> Html CreateItemFormMsg
matchedItemView item =
    itemView
        { item = item
        , state = Ui.Item.ToAdd
        , onTick = RetickItem
        }
