module Stylesheets (..) where

import Css exposing (Stylesheet)
import Css.File exposing (CssFileStructure)
import TodoItem.Styles
import TodoItems.Styles


compileStylesheets : List Stylesheet -> { css : String, warnings : List String }
compileStylesheets =
  let
    concatStylesheets memo new =
      { css = memo.css ++ new.css
      , warnings = memo.warnings ++ new.warnings
      }
  in
    List.foldl concatStylesheets { css = "", warnings = [] } << List.map Css.compile


port files : CssFileStructure
port files =
  Css.File.toFileStructure
    [ ( "css/styles.css"
      , compileStylesheets
          [ TodoItem.Styles.css
          , TodoItems.Styles.css
          ]
      )
    ]
