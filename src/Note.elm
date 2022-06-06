module Note exposing (..)


type NoteId
    = NoteId String


noteIdToString : NoteId -> String
noteIdToString (NoteId id) =
    id


intToNoteId : Int -> NoteId
intToNoteId n =
    NoteId (String.fromInt n)


type alias Note =
    { title : String
    }
