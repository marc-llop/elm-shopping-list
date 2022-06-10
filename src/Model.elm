module Model exposing (..)

import Note exposing (Note, NoteId, NoteIdPair)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (Page)


type alias Model =
    { pending : OpaqueDict NoteId Note
    , done : OpaqueDict NoteId Note
    , idCounter : Int
    , currentPage : Page
    , backgroundTextureUrl : String
    }


allNotes : Model -> List NoteIdPair
allNotes model =
    List.concat
        [ OpaqueDict.toList model.pending
        , OpaqueDict.toList model.done
        ]
