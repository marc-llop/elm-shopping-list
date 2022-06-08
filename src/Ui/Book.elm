module Ui.Book exposing (main)

import ElmBook exposing (withChapters)
import ElmBook.ElmCSS exposing (Book, Chapter, book)
import Ui.Button


main =
    book "Components"
        |> withChapters
            [ Ui.Button.docs
            ]
