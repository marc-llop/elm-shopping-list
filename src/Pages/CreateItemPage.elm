module Pages.CreateItemPage exposing (..)

import Css exposing (displayFlex, marginRight, pct, px)
import DesignSystem.StyledIcons as Icons
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, onInput, onSubmit)
import ItemModel exposing (IdItemPair, Item, ItemId, itemIdGenerator)
import Maybe.Extra
import Model exposing (..)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (Page(..), createItemAutofocusId)
import Random
import Search
import String.Deburr exposing (deburr)
import Svg.Styled exposing (title)
import Time
import Ui.Button exposing (ButtonType(..))
import Ui.Checklist exposing (checklistView)
import Ui.Item exposing (itemView)
import Utils exposing (dataTestId)


type CreateItemFormMsg
    = InputNewItemTitle String
    | CreateItem ItemId
    | SubmitItem
    | RetickItem ItemId
    | CancelCreate


findItemByTitle : String -> List IdItemPair -> Maybe ItemId
findItemByTitle title list =
    let
        normalize =
            String.toLower
    in
    case list of
        [] ->
            Nothing

        ( id, item ) :: rest ->
            if normalize item.title == normalize title then
                Just id

            else
                findItemByTitle title rest


findItemByTitleInChecklist : String -> PendingDict -> DoneDict -> Maybe ItemId
findItemByTitleInChecklist title pending done =
    let
        findIn =
            findItemByTitle title

        maybePendingItem =
            findIn (OpaqueDict.toList pending)

        maybeDoneItem =
            findIn (OpaqueDict.toList done)
    in
    Maybe.Extra.or maybePendingItem maybeDoneItem


untickOrAddAsPending :
    IdItemPair
    -> { a | pending : PendingDict, done : DoneDict }
    -> { a | pending : PendingDict, done : DoneDict }
untickOrAddAsPending ( id, item ) ({ pending, done } as model) =
    case findItemByTitleInChecklist item.title pending done of
        Nothing ->
            { model
                | pending = OpaqueDict.insert id item pending
                , done = done
            }

        Just previousId ->
            move previousId done pending
                |> (\( newDone, newPending ) ->
                        { model
                            | pending = newPending
                            , done = newDone
                        }
                   )


update : CreateItemFormMsg -> Model -> ( Model, Cmd CreateItemFormMsg )
update msg model =
    case msg of
        InputNewItemTitle title ->
            ( applyIfCreateItemPage model
                (\item -> { model | currentPage = CreateItemPage { item | title = title } })
            , Cmd.none
            )

        SubmitItem ->
            ( model, Random.generate CreateItem itemIdGenerator )

        CreateItem itemId ->
            ( applyIfCreateItemPage model
                (\item ->
                    let
                        newModel =
                            untickOrAddAsPending ( itemId, item ) model
                    in
                    { newModel
                        | currentPage = ChecklistPage
                    }
                )
            , Cmd.none
            )

        RetickItem itemId ->
            let
                ( newDone, newPending ) =
                    move itemId model.done model.pending
            in
            ( { model
                | currentPage = ChecklistPage
                , pending = newPending
                , done = newDone
              }
            , Cmd.none
            )

        CancelCreate ->
            ( { model | currentPage = ChecklistPage }, Cmd.none )


applyIfCreateItemPage : Model -> (Item -> Model) -> Model
applyIfCreateItemPage model fn =
    case model.currentPage of
        CreateItemPage item ->
            fn item

        _ ->
            model


createItemView : Model -> Item -> Html CreateItemFormMsg
createItemView model newItem =
    Html.Styled.form
        [ onSubmit SubmitItem
        , dataTestId "CreateItem"
        , css [ Css.width (pct 100) ]
        ]
        [ input [ onInput InputNewItemTitle, value newItem.title, id createItemAutofocusId ] []
        , Ui.Button.button
            { buttonType = Submit
            , label = "Afegeix l'element"
            , isEnabled = not (String.isEmpty newItem.title)
            }
        , Ui.Button.button
            { buttonType = Button CancelCreate
            , label = "Cancel·la"
            , isEnabled = True
            }
        , matchesListView model newItem
        ]


type alias IndexableItem =
    { id : ItemId
    , content : String
    , title : String
    , dateTime : Time.Posix
    }


itemToDatum : IdItemPair -> IndexableItem
itemToDatum ( itemId, item ) =
    { id = itemId
    , content = deburr item.title
    , title = item.title
    , dateTime = Time.millisToPosix 0
    }


datumToItem : IndexableItem -> IdItemPair
datumToItem { id, content, title, dateTime } =
    ( id, { title = title } )


itemsMatching : String -> Model.ItemsInModel a -> List IdItemPair
itemsMatching newItemTitle model =
    let
        items =
            allItems model |> List.map itemToDatum

        allMatchedItems =
            Search.search
                Search.NotCaseSensitive
                (deburr newItemTitle)
                items
    in
    List.map datumToItem allMatchedItems
        |> sortItems


matchesListView : Model -> Item -> Html CreateItemFormMsg
matchesListView model newItem =
    let
        matches =
            itemsMatching newItem.title model
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


matchedItemView : IdItemPair -> Html CreateItemFormMsg
matchedItemView ( itemId, item ) =
    itemView
        { itemId = itemId
        , item = item
        , state = Ui.Item.ToAdd
        , onTick = RetickItem
        }
