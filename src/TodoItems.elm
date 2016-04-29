module TodoItems (..) where

import TodoItem.View
import TodoItem.Model
import TodoItem.Update
import Html exposing (..)
import Html.Events exposing (..)
import Html.CssHelpers
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Util


-- CSS


cssNamespace : String
cssNamespace =
  "TodoItems"


{ class, classList, id } =
  Html.CssHelpers.withNamespace cssNamespace


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



-- Model


type alias Model =
  { items : List ( ID, TodoItem.Model.Model )
  , nextId : ID
  }


type alias ID =
  Int


init : Model
init =
  { items = []
  , nextId = 0
  }



-- Update


type Action
  = Insert
  | Remove ID
  | Modify ID TodoItem.Update.Action


update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      { model
        | items = ( model.nextId, TodoItem.Model.init ) :: model.items
        , nextId = model.nextId + 1
      }

    Remove id ->
      { model
        | items = List.filter (\( itemId, _ ) -> itemId /= id) model.items
      }

    Modify id itemAction ->
      let
        updateItem ( itemId, item ) =
          if itemId == id then
            ( itemId, TodoItem.Update.update itemAction item )
          else
            ( itemId, item )
      in
        { model
          | items = List.map updateItem model.items
        }


view : Signal.Address Action -> Model -> Html
view address model =
  let
    insert =
      button [ onClick address Insert ] [ text "Add" ]

    stylesheet =
      Util.stylesheetLink "../css/styles.css"
  in
    div
      []
      [ stylesheet
      , div
          [ class [ Container ] ]
          (insert :: List.map (viewItem address) model.items)
      ]


viewItem : Signal.Address Action -> ( ID, TodoItem.Model.Model ) -> Html
viewItem address ( id, model ) =
  let
    context =
      TodoItem.View.Context
        (Signal.forwardTo address (Modify id))
        (Signal.forwardTo address (always (Remove id)))
  in
    TodoItem.View.view context model
