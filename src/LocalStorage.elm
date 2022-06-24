port module LocalStorage exposing (..)

import ElmBook exposing (Msg)
import Json.Encode
import Model exposing (Model, encodeModel)


port storeModel : Json.Encode.Value -> Cmd msg


encodeAndStoreModel : Model -> Cmd msg
encodeAndStoreModel model =
    storeModel (encodeModel model)
