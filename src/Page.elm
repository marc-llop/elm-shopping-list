module Page exposing (..)

import ItemModel exposing (Item, ItemId)


type Page
    = ChecklistPage
    | CreateItemPage { title : String }
    | EditItemPage Item { title : String }


createItemAutofocusId =
    "create-item-autofocus"


editItemAutofocusId =
    "edit-item-autofocus"
