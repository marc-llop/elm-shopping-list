module Page exposing (..)

import ItemModel exposing (Item, ItemId)


type Page
    = ListPage
    | CreateNotePage Item
    | EditNotePage ItemId Item Item


createNoteAutofocusId =
    "create-note-autofocus"


editNoteAutofocusId =
    "edit-note-autofocus"
