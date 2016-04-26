module TodoItem (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode


-- Model


type alias Model =
  { id : Int
  , content : String
  , done : Bool
  }


init : Model
init =
  { id = 1
  , content = ""
  , done = False
  }



-- Update


type Action
  = Update String
  | Check


update : Action -> Model -> Model
update action model =
  case Debug.log "actionType" action of
    Update content ->
      { model | content = content }

    Check ->
      { model | done = (not model.done) }



-- View


targetText : Json.Decode.Decoder String
targetText =
  Json.Decode.at [ "target", "innerText" ] Json.Decode.string


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ input
        [ type' "checkbox"
        , checked model.done
        , onClick address Check
        ]
        []
    , div
        [ contenteditable True
        , getStyle model.done
        , on "blur" targetText (Signal.message address << Update)
        ]
        [ text model.content ]
    ]


getStyle : Bool -> Attribute
getStyle done =
  if done then
    doneStyle
  else
    style []


doneStyle : Attribute
doneStyle =
  style
    [ ( "text-decoration", "line-through" )
    , ( "color", "#989898" )
    ]
