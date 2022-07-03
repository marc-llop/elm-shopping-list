module Page exposing (..)

import ItemModel exposing (Item, ItemId)


type Page
    = ChecklistPage
    | CreateItemPage Item
    | EditItemPage ItemId Item Item


createItemAutofocusId =
    "create-item-autofocus"


editItemAutofocusId =
    "edit-item-autofocus"
