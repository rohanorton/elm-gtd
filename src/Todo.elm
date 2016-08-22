module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (style, type', value)
import Html.Events exposing (onClick)
import Html.App
import Json.Decode as Json


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }



-- MODEL


type alias Model =
    { todos : Todos
    , isOver : Maybe String
    , isDragging : Maybe String
    }


type alias Todos =
    List Todo


type alias Todo =
    { id : String
    , action : String
    , done : Bool
    , tags : List String
    , context : List String
    , priority : Int
    , due : Maybe Float
    , delegated : Maybe String
    , isDragging : Bool
    }


defaultTodo : Todo
defaultTodo =
    { id = ""
    , action = ""
    , done = False
    , tags = []
    , context = []
    , priority = 0
    , due = Nothing
    , delegated = Nothing
    , isDragging = False
    }


initialTodos : Todos
initialTodos =
    [ { defaultTodo | id = "1", action = "Buy train ticket" }
    , { defaultTodo | id = "2", action = "Buy sandwiches" }
    , { defaultTodo | id = "3", action = "Lookup directions" }
    ]


init : ( Model, Cmd Msg )
init =
    { todos = initialTodos
    , isOver = Nothing
    , isDragging = Nothing
    }
        ! []



-- UPDATE


type Msg
    = Toggle String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Current Message" msg of
        Toggle id ->
            let
                newTodos =
                    toggleDone id model.todos
            in
                { model | todos = newTodos } ! []


findNextAction : Todos -> String
findNextAction todos =
    todos
        |> find nextActionCandidate
        |> Maybe.withDefault defaultTodo
        |> .id


nextActionCandidate : Todo -> Bool
nextActionCandidate { done, delegated } =
    not done && delegated == Nothing


toggleDone : String -> Todos -> Todos
toggleDone id todos =
    List.map
        (\todo ->
            if todo.id == id then
                { todo | done = not todo.done }
            else
                todo
        )
        todos


find : (a -> Bool) -> List a -> Maybe a
find cond list =
    case list of
        [] ->
            Nothing

        x :: xs ->
            if cond x then
                Just x
            else
                find cond xs



-- VIEW


view : Model -> Html Msg
view { todos } =
    todosView todos


todosView : Todos -> Html Msg
todosView todos =
    div [] <| List.map (todoView <| findNextAction todos) todos


todoView : String -> Todo -> Html Msg
todoView nextActionId { id, action, done } =
    div []
        [ input [ type' "checkbox", value <| toString done, onClick <| Toggle id ] []
        , input [ type' "text", value action ] []
        , nextActionView <| nextActionId == id
        ]


nextActionView : Bool -> Html Msg
nextActionView active =
    if active then
        span
            [ style
                [ "color" => "red"
                ]
            ]
            [ text "Next Action!" ]
    else
        text ""


(=>) : String -> String -> ( String, String )
(=>) =
    (,)
