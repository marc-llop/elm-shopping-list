module Page exposing (..)

import Note exposing (Note, NoteId)


type Page
    = ListPage
    | CreateNotePage Note
    | EditNotePage NoteId Note Note


createNoteAutofocusId =
    "create-note-autofocus"


editNoteAutofocusId =
    "edit-note-autofocus"
