module Model exposing (..)

import Json.Decode as D
import Json.Encode as E
import Note exposing (..)
import OpaqueDict exposing (OpaqueDict)
import Page exposing (Page(..))


type alias Model =
    { pending : OpaqueDict NoteId Note
    , done : OpaqueDict NoteId Note
    , currentPage : Page
    , constants : Constants
    }


type alias Constants =
    { backgroundTextureUrl : String
    }


encodeModel : Model -> E.Value
encodeModel model =
    let
        encodeDict =
            OpaqueDict.encode noteIdToString encodeNote
    in
    E.object
        [ ( "pending", encodeDict model.pending )
        , ( "done", encodeDict model.done )
        ]


decodeModel : Constants -> D.Decoder Model
decodeModel c =
    let
        instantiateModel pending done =
            { pending = pending
            , done = done
            , currentPage = ListPage
            , constants = c
            }

        decodeDict =
            OpaqueDict.decode decodeNoteIdFromString noteIdToString decodeNote
    in
    D.map2 instantiateModel
        decodeDict
        decodeDict


type alias NotesInModel a =
    { a | pending : OpaqueDict NoteId Note, done : OpaqueDict NoteId Note }


allNotes : NotesInModel a -> List NoteIdPair
allNotes { pending, done } =
    List.concat
        [ OpaqueDict.toList pending
        , OpaqueDict.toList done
        ]


sortNotes : List NoteIdPair -> List NoteIdPair
sortNotes =
    List.sortBy (Tuple.second >> .title >> String.toLower)


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
