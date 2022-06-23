module Note exposing (Note, NoteId, NoteIdPair, decodeNoteId, encodeNote, newFakeNote, noteIdGenerator, noteIdToString)

import Json.Decode as D
import Json.Encode as E
import Random
import Random.Char
import Random.String


type NoteId
    = NoteId String


noteIdToString : NoteId -> String
noteIdToString (NoteId id) =
    id


noteIdGenerator : Random.Generator NoteId
noteIdGenerator =
    Random.String.string 5 Random.Char.english
        |> Random.map NoteId


decodeNoteId : D.Decoder NoteId
decodeNoteId =
    D.map NoteId D.string


newFakeNote : Int -> String -> NoteIdPair
newFakeNote id title =
    ( NoteId (String.fromInt id), { title = title } )


type alias Note =
    { title : String
    }


encodeNote : Note -> E.Value
encodeNote { title } =
    E.string title


decodeNote : D.Decoder Note
decodeNote =
    D.map Note D.string


type alias NoteIdPair =
    ( NoteId, Note )
