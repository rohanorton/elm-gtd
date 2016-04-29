module TodoItem (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Html.CssHelpers
import Css exposing (..)
import Css.Namespace exposing (namespace)


-- CSS


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


{ class, classList, id } =
  Html.CssHelpers.withNamespace cssNamespace


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



-- Model


type alias Model =
  { content : String
  , done : Bool
  }


init : Model
init =
  { content = ""
  , done = False
  }



-- Update


type Action
  = Update String
  | Check


update : Action -> Model -> Model
update action model =
  case action of
    Update content ->
      { model | content = content }

    Check ->
      { model | done = (not model.done) }



-- View


type alias Context =
  { actions : Signal.Address Action
  , remove : Signal.Address ()
  }


targetText : Json.Decode.Decoder String
targetText =
  Json.Decode.at [ "target", "innerText" ] Json.Decode.string


view : Context -> Model -> Html
view ctx model =
  let
    classes =
      if model.done then
        [ Done, Input ]
      else
        [ Input ]
  in
    div
      [ class [ Item ] ]
      [ div
          []
          [ input
              [ type' "checkbox"
              , class [ Checkbox ]
              , Html.Attributes.checked model.done
              , onClick ctx.actions Check
              ]
              []
          ]
      , div
          [ contenteditable True
          , class classes
          , on "blur" targetText (Signal.message ctx.actions << Update)
          ]
          [ text model.content ]
      , button
          [ onClick ctx.remove () ]
          [ text "x" ]
      ]
