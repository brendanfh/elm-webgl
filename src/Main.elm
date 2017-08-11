module Main exposing (..)

import Html exposing (Html)
import Html.Attributes as HA
import WebGL as GL


type alias Model =
    {}


type Msg
    = NoOp
    | Test


init : {} -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    GL.toHtmlWith
        [ GL.clearColor 1 0 0 1 ]
        [ HA.width 640
        , HA.height 480
        ]
        []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program {} Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
