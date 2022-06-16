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


type alias NotesInModel a =
    { a | pending : OpaqueDict NoteId Note, done : OpaqueDict NoteId Note }


allNotes : NotesInModel a -> List NoteIdPair
allNotes { pending, done } =
    List.concat
        [ OpaqueDict.toList pending
        , OpaqueDict.toList done
        ]


move : k -> OpaqueDict k v -> OpaqueDict k v -> ( OpaqueDict k v, OpaqueDict k v )
move k dictFrom dictTo =
    let
        elem =
            OpaqueDict.get k dictFrom

        newFrom =
            OpaqueDict.remove k dictFrom

        newTo =
            elem
                |> Maybe.map (\e -> OpaqueDict.insert k e dictTo)
                |> Maybe.withDefault dictTo
    in
    ( newFrom, newTo )
