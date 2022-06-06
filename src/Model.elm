module Model exposing (..)

import Note exposing (Note, NoteId)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (Page)


type alias Model =
    { pending : OpaqueDict NoteId Note
    , done : OpaqueDict NoteId Note
    , idCounter : Int
    , currentPage : Page
    }
