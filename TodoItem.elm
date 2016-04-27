module TodoItem (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode
import Html.CssHelpers
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Css.Elements as Css
import Util


-- CSS


{ class, classList, id } =
  Html.CssHelpers.withNamespace cssNamespace


cssNamespace =
  "TodoItem"


type CssClasses
  = Item


blue =
  rgb 9 69 162


white =
  rgb 255 255 255


css =
  (stylesheet << namespace cssNamespace)
    [ Css.body
        [ backgroundColor blue ]
    , (.)
        Item
        [ backgroundColor white
        , maxWidth (px 100)
        , color blue
        ]
    ]



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
    [ class [ Item ] ]
    [ Util.stylesheetLink "./styles.css"
    , div
        []
        [ input
            [ type' "checkbox"
            , Html.Attributes.checked model.done
            , onClick address Check
            ]
            []
        ]
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