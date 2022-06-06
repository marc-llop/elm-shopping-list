module Page exposing (..)

import Note exposing (Note, NoteId)


type Page
    = ListPage
    | CreateNotePage Note
    | EditNotePage NoteId Note
