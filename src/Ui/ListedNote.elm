module Ui.ListedNote exposing (..)

import Css exposing (..)
import DesignSystem.ColorDecisions exposing (..)
import DesignSystem.Colors exposing (accentBlue, backgroundPurple, neutral)
import DesignSystem.Sizes exposing (boxShadowOffset, cardBorderRadius, cardBoxShadow)
import DesignSystem.StyledIcons exposing (blueEdit, greenPlus, redTrash, tickedCheck, untickedCheck)
import ElmBook.Actions exposing (logAction)
import ElmBook.Chapter exposing (chapter, renderComponentList)
import ElmBook.ElmCSS exposing (Chapter)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onClick, stopPropagationOn)
import Json.Decode
import Note exposing (Note, NoteId, newFakeNote)
import Ui.Glassmorphism exposing (glassmorphism)
import Utils exposing (dataTestId, transparencyBackground)


type NoteState msg
    = Pending (WriteEvents msg)
    | Done (WriteEvents msg)
    | ToAdd -- Used in CreateNote search


type alias WriteEvents msg =
    { onRemove : NoteId -> msg
    , onEdit : NoteId -> Note -> msg
    }


type alias ListedNoteProps msg =
    { noteId : NoteId
    , note : Note
    , state : NoteState msg
    , onTick : NoteId -> msg
    }


checkboxView : NoteState msg -> Html msg
checkboxView state =
    case state of
        Pending _ ->
            untickedCheck

        Done _ ->
            tickedCheck

        ToAdd ->
            greenPlus


resetButtonStyles : List Style
resetButtonStyles =
    [ borderStyle none
    , backgroundColor transparent
    , cursor pointer
    ]


iconButtonView evt icon =
    button
        [ onClickStopPropagation evt
        , css resetButtonStyles
        ]
        [ icon ]


listedNoteView : ListedNoteProps msg -> Html msg
listedNoteView { noteId, note, state, onTick } =
    let
        writeButtonElems { onEdit, onRemove } =
            [ iconButtonView (onRemove noteId) redTrash
            , iconButtonView (onEdit noteId note) blueEdit
            ]

        writeButtons =
            case state of
                Pending we ->
                    writeButtonElems we

                Done we ->
                    writeButtonElems we

                ToAdd ->
                    []
    in
    li
        [ dataTestId (stateToDataTestId state)
        , css (noteStyle state)
        , onClick (onTick noteId)
        ]
        ([ checkboxView state
         , span [ css [ noteTitleStyle ] ] [ text note.title ]
         ]
            ++ writeButtons
        )


stateToDataTestId : NoteState msg -> String
stateToDataTestId state =
    case state of
        Pending _ ->
            "ListedNotePending"

        Done _ ->
            "ListedNoteDone"

        ToAdd ->
            "MatchedNote"


onClickStopPropagation : msg -> Attribute msg
onClickStopPropagation msg =
    stopPropagationOn "click" <| Json.Decode.succeed ( msg, True )


noteStyle : NoteState msg -> List Style
noteStyle state =
    let
        { glassColor, glassOpacity, glassBlur, boxShadowColor, textColor, textShadowColor } =
            case state of
                Pending _ ->
                    { glassColor = neutralCardColor.color
                    , glassOpacity = neutralCardColor.opacityPct
                    , glassBlur = neutralCardColor.blurPx
                    , boxShadowColor = neutralCardBoxShadowColor
                    , textColor = neutralTextColor
                    , textShadowColor = neutralCardTextShadowColor
                    }

                Done _ ->
                    { glassColor = backgroundPurple.s750
                    , glassOpacity = 30
                    , glassBlur = 10
                    , boxShadowColor = backgroundPurple.s650
                    , textColor = backgroundPurple.s200
                    , textShadowColor = backgroundPurple.s400
                    }

                ToAdd ->
                    { glassColor = glassButtonInertColor.color
                    , glassOpacity = glassButtonInertColor.opacityPct
                    , glassBlur = glassButtonInertColor.blurPx
                    , boxShadowColor = glassButtonInertBoxShadowColor
                    , textColor = accentBlue.s300
                    , textShadowColor = accentBlue.s400
                    }
    in
    [ resetLiStyle
    , glassmorphism
        { color = glassColor
        , opacityPct = glassOpacity
        , blurPx = glassBlur
        , saturationPct = 100
        }
    , displayFlex
    , alignItems center
    , justifyContent spaceBetween
    , Css.height (px 60)
    , paddingLeft (px 15)
    , paddingRight (px 15)
    , margin4 (px 3) (px 7) (px 5) (px 5)
    , borderRadius cardBorderRadius
    , cardBoxShadow (hex boxShadowColor)
    , fontSize (rem 1.2)
    , color (hex textColor)
    , textShadow4 zero zero (px 3) (hex textShadowColor)
    , cursor pointer
    , hover
        (if state == ToAdd then
            [ glassmorphism glassButtonGlowingColor ]

         else
            []
        )
    ]


resetLiStyle : Style
resetLiStyle =
    listStyle none


noteTitleStyle : Style
noteTitleStyle =
    Css.batch
        [ flexGrow (int 1)
        , marginLeft (px 20)
        ]


docs : Chapter x
docs =
    let
        writeEvents =
            { onRemove = \_ -> logAction "Removed"
            , onEdit = \_ _ -> logAction "Edit clicked"
            }

        ( fakeId, fakeNote ) =
            newFakeNote 42 "Milk"

        props =
            { noteId = fakeId
            , note = fakeNote
            , state = Pending writeEvents
            , onTick = \_ -> logAction "Ticked"
            }

        showcaseNote p =
            transparencyBackground
                { width = 650, height = 80 }
                (listedNoteView p)
    in
    chapter "Note"
        |> renderComponentList
            [ ( "Pending", showcaseNote props )
            , ( "Done", showcaseNote { props | state = Done writeEvents, onTick = \_ -> logAction "Unticked" } )
            , ( "ToAdd", showcaseNote { props | state = ToAdd, onTick = \_ -> logAction "Added note" } )
            ]
