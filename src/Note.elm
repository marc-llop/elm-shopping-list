module Note exposing (Note, NoteId, NoteIdPair, intToNoteId, noteIdToString, stringToNoteId)


type NoteId
    = NoteId String


noteIdToString : NoteId -> String
noteIdToString (NoteId id) =
    id


stringToNoteId : String -> NoteId
stringToNoteId id =
    NoteId id


intToNoteId : Int -> NoteId
intToNoteId n =
    NoteId (String.fromInt n)


type alias Note =
    { title : String
    }


type alias NoteIdPair =
    ( NoteId, Note )
