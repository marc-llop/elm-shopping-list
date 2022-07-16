module Ui.Checklist exposing (..)

import ChecklistModel exposing (Checklist, doneItems, pendingItems)
import Css exposing (..)
import Html.Styled exposing (Html)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Keyed exposing (ul)
import ItemModel exposing (Item, isTicked, isUnticked, title)
import Model exposing (sortItems)
import Utils exposing (dataTestId)


type alias ChecklistProps msg =
    { checklist : Checklist
    , pendingItemView : Item -> Html msg
    , doneItemView : Item -> Html msg
    }


resetUlStyle : List Style
resetUlStyle =
    [ margin zero
    , padding zero
    ]


checklistStyle : List Style
checklistStyle =
    resetUlStyle
        ++ [ displayFlex
           , flexDirection column
           , marginBottom (px 120)
           ]


keyedItemView : (Item -> Html msg) -> Item -> ( String, Html msg )
keyedItemView mapper item =
    ( title item, mapper item )


checklistView : ChecklistProps msg -> Html msg
checklistView { checklist, pendingItemView, doneItemView } =
    let
        pending =
            pendingItems checklist |> sortItems

        done =
            doneItems checklist |> sortItems
    in
    ul
        [ dataTestId "Checklist"
        , css checklistStyle
        ]
        (List.concat
            [ List.map (keyedItemView pendingItemView) pending
            , List.map (keyedItemView doneItemView) done
            ]
        )
