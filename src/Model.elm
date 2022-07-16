module Model exposing (..)

import ChecklistModel exposing (Checklist, decodeChecklist, encodeChecklist, fromList)
import ItemModel exposing (Item, title)
import Json.Decode as D
import Json.Encode as E
import Page exposing (Page(..))
import Ui.Item exposing (ItemState(..))


type alias Model =
    { checklist : Checklist
    , currentPage : Page
    , backgroundTextureUrl : String
    }


initModel : String -> Checklist -> Model
initModel backgroundTextureUrl checklist =
    { checklist = checklist
    , currentPage = ChecklistPage
    , backgroundTextureUrl = backgroundTextureUrl
    }


encodeModel : Model -> E.Value
encodeModel model =
    E.object
        [ ( "checklist", encodeChecklist model.checklist )
        ]


decodeModel : Checklist -> D.Decoder Model
decodeModel initialChecklist =
    let
        checklistField =
            D.field "checklist" decodeChecklist

        decodeWithDefaultFrom decoder =
            D.maybe decoder
                |> D.map (Maybe.withDefault initialChecklist)
    in
    D.map2 initModel
        (D.field "backgroundTextureUrl" D.string)
        (decodeWithDefaultFrom checklistField)


sortItems : List Item -> List Item
sortItems =
    List.sortBy (title >> String.toLower)



-- FOR TESTS


newFakeModel : Page -> List Item -> Model
newFakeModel currentPage itemList =
    { checklist = fromList itemList
    , currentPage = currentPage
    , backgroundTextureUrl = ""
    }
