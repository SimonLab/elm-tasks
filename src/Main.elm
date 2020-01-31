module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode as JD



-- MAIN


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type Item
    = Item String Bool


type Model
    = Loading
    | Success (List Item)
    | Failure


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getItems )



-- UPDATE


type Msg
    = None
    | Ready
    | GotItems (Result Http.Error (List Item))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            ( model, Cmd.none )

        Ready ->
            ( model, Cmd.none )

        GotItems result ->
            case result of
                Ok items ->
                    ( Success items, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )


getItems : Cmd Msg
getItems =
    Http.get
        { url = "https://goalsandtasks.herokuapp.com/api/tasks"
        , expect = Http.expectJson GotItems itemsDecoder
        }


itemsDecoder : JD.Decoder (List Item)
itemsDecoder =
    JD.field "data" (JD.list itemDecoder)


itemDecoder : JD.Decoder Item
itemDecoder =
    JD.map2 Item
        (JD.field "text" JD.string)
        (JD.field "complete" JD.bool)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Tasks"
    , body =
        case model of
            Loading ->
                [ text "Loading tasks..." ]

            Success items ->
                [ text "List of tasks:"
                , ul [] (List.map (\i -> viewLink i) items)
                ]

            Failure ->
                [ text "Sorry something wrong happend" ]
    }


viewLink : Item -> Html msg
viewLink (Item txt complete) =
        li []
            [ input [ type_ "checkbox", checked complete] []
            , text txt
            ]
