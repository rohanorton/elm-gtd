module TodoItem.View (..) where

import TodoItem.Update exposing (..)
import TodoItem.Styles exposing (..)
import TodoItem.Model exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.CssHelpers
import Json.Decode


{ class, classList, id } =
  Html.CssHelpers.withNamespace cssNamespace


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
