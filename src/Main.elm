module Main exposing (..)

import AnimationFrame
import Html exposing (Html)
import Html.Attributes as HA
import Math.Vector4 as Vec4 exposing (vec4, Vec4)
import Math.Vector3 as Vec3 exposing (vec3, Vec3)
import Math.Vector2 as Vec2 exposing (vec2, Vec2)
import WebGL as GL


type alias Model =
    {}


type Msg
    = NoOp
    | Tick Float


init : {} -> ( Model, Cmd Msg )
init _ =
    ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Html Msg
view model =
    GL.toHtmlWith
        [ GL.clearColor 0 0 0 1 ]
        [ HA.width 640
        , HA.height 480
        ]
        [ render (drawEntities sampleScene)
        ]


type alias Entity =
    { x : Float
    , y : Float
    , w : Float
    , h : Float
    , r : Float
    , g : Float
    , b : Float
    , a : Float
    }


sampleScene : List Entity
sampleScene =
    let
        func i =
            let
                x =
                    (toFloat <| i % 50) * 2 - 50

                y =
                    (toFloat <| i // 50) * 2 - 50
            in
                Entity (x / 50) (y / 50) (1 / 51) (1 / 51) 1 0 0 1
    in
        List.map func (List.range 0 2500)


type alias Vertex =
    { position : Vec2
    , color : Vec4
    }


type alias Triangle v =
    ( v, v, v )


drawEntity : Entity -> List (Triangle Vertex)
drawEntity { x, y, w, h, r, g, b, a } =
    let
        color =
            vec4 r g b a
    in
        [ ( Vertex (vec2 x y) color
          , Vertex (vec2 x (y + h)) color
          , Vertex (vec2 (x + w) (y + h)) color
          )
        , ( Vertex (vec2 x y) color
          , Vertex (vec2 (x + w) (y + h)) color
          , Vertex (vec2 (x + w) y) color
          )
        ]


drawEntities : List Entity -> List (Triangle Vertex)
drawEntities entities =
    List.concatMap drawEntity entities


render : List (Triangle Vertex) -> GL.Entity
render triangles =
    GL.entity vertexShader fragmentShader (GL.triangles triangles) {}


type alias Varyings =
    { vColor : Vec4
    }


vertexShader : GL.Shader Vertex {} Varyings
vertexShader =
    [glsl|
        attribute vec2 position;
        attribute vec4 color;

        varying vec4 vColor;

        void main() {
            vColor = color;
            gl_Position = vec4(position, 0.0, 1.0);
        }
    |]


fragmentShader : GL.Shader {} {} Varyings
fragmentShader =
    [glsl|
        precision mediump float;

        varying vec4 vColor;

        void main() {
            gl_FragColor = vColor;
        }
    |]


subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.diffs Tick


main : Program {} Model Msg
main =
    Html.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
