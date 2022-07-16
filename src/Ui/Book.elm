module Ui.Book exposing (main)

import DesignSystem.ColorDecisions
import DesignSystem.Colors
import DesignSystem.Icons
import DesignSystem.StyledIcons
import ElmBook exposing (withChapterGroups, withStatefulOptions, withThemeOptions)
import ElmBook.ElmCSS exposing (Book, book)
import ElmBook.StatefulOptions
import ElmBook.ThemeOptions
import Ui.Button
import Ui.FloatingActionButton
import Ui.Glassmorphism
import Ui.Item
import Ui.ItemForm
import Ui.ListCard
import Ui.ProgressBar
import Ui.TextInput


type alias SharedState =
    { textInputModel : Ui.TextInput.ChapterModel
    }


initialState : SharedState
initialState =
    { textInputModel = Ui.TextInput.chapterInitialState
    }


main =
    book "Components"
        |> withThemeOptions
            [ ElmBook.ThemeOptions.preferDarkMode
            ]
        |> withStatefulOptions
            [ ElmBook.StatefulOptions.initialState initialState
            ]
        |> withChapterGroups
            [ ( "Design Tokens"
              , [ DesignSystem.Colors.docs
                , DesignSystem.ColorDecisions.docs
                , DesignSystem.Icons.docs
                , DesignSystem.StyledIcons.docs
                ]
              )
            , ( "Components"
              , [ Ui.Button.docs
                , Ui.Item.docs
                , Ui.Glassmorphism.docs
                , Ui.FloatingActionButton.docs
                , Ui.ProgressBar.docs
                , Ui.ListCard.docs
                , Ui.TextInput.docs
                , Ui.ItemForm.docs
                ]
              )
            ]
