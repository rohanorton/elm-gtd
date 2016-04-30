module TodoItems.Styles (..) where

import Css exposing (..)
import Css.Namespace exposing (namespace)


-- CSS


cssNamespace : String
cssNamespace =
  "TodoItems"


type CssClasses
  = Container


blue : Color
blue =
  rgb 9 69 162


css : Stylesheet
css =
  (stylesheet << namespace cssNamespace)
    [ (.)
        Container
        [ backgroundColor blue
        , margin auto
        , maxWidth (px 300)
        , padding (px 25)
        ]
    ]
