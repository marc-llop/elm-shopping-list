module Ui.ItemForm exposing (..)

import Css exposing (displayFlex, pct, px)
import DesignSystem.Sizes exposing (formHeight)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onSubmit)
import Ui.Button exposing (ButtonType(..))
import Ui.TextInput exposing (TextInputProps, textInputView)
import Utils exposing (dataTestId)


itemFormView :
    { submit : msg
    , cancel : msg
    , dataTestId : String
    , inputProps : TextInputProps msg
    , cancelButtonLabel : String
    , submitButtonLabel : String
    , isSubmitEnabled : Bool
    }
    -> Html msg
itemFormView config =
    Html.Styled.form
        [ onSubmit config.submit
        , dataTestId config.dataTestId
        , css formStyles
        ]
        [ textInputView config.inputProps
        , div
            [ css buttonRowStyles ]
            [ Ui.Button.button
                { buttonType = Button config.cancel
                , label = config.cancelButtonLabel
                , isEnabled = True
                }
            , Ui.Button.button
                { buttonType = Submit
                , label = config.submitButtonLabel
                , isEnabled = config.isSubmitEnabled
                }
            ]
        ]


formStyles =
    [ Css.width (pct 100)
    , Css.height formHeight
    , displayFlex
    , Css.flexDirection Css.column
    ]


buttonRowStyles =
    [ displayFlex
    , Css.height (pct 100)
    , Css.property "column-gap" "10%"
    , Css.justifyContent Css.center
    , Css.paddingTop (px 25)
    , Css.paddingBottom (px 30)
    ]
