module TodoItem.Styles (..) where

import Css exposing (..)
import Css.Namespace exposing (namespace)


cssNamespace : String
cssNamespace =
  "TodoItem"


white : Color
white =
  rgb 255 255 255


blue : Color
blue =
  rgb 9 69 162


gray : Color
gray =
  rgb 98 98 98


type CssClasses
  = Item
  | Checkbox
  | Input
  | Done


css : Stylesheet
css =
  (stylesheet << namespace cssNamespace)
    [ (.)
        Item
        [ displayFlex
        , margin (px 10)
        , borderRadius (px 3)
        , maxWidth (pct 100)
        , backgroundColor white
        ]
    , (.)
        Done
        [ textDecoration lineThrough
        , color gray
        ]
    , (.)
        Input
        [ Css.width (pct 100)
        ]
    , (.)
        Checkbox
        [ marginLeft (px 5)
        , marginRight (px 10)
        ]
    ]
