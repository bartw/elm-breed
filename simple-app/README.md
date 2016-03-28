# simple app

Install the elm html package.

```shell
elm package install evancz/elm-html
```

Create index.html.

```html
<!DOCTYPE HTML>
<html>

<head>
    <meta charset="UTF-8">
    <title>simple app</title>
    <script type="text/javascript" src="elm.js"></script>
</head>

<body>
</body>

<script type="text/javascript">
var simpleApp = Elm.fullscreen(Elm.SimpleApp);
</script>

</html>
```

Create SimpleApp.elm

```elm
module SimpleApp where

import Html exposing (..)
import Html.Events exposing (onClick)

-- MODEL

type alias Model = String

-- UPDATE

type Action = 
    NoOp
    | Change

update : Action -> Model -> Model
update action model =
    case action of
        NoOp ->
            model
            
        Change ->
            "Bart"

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model = 
    div []
    [ button [ onClick address Change ] [ text "change" ]
    , div [] [ text (model) ]
    ]
    
-- INPUTS

main : Signal Html
main =
    Signal.map (view actions.address) model
  
model : Signal Model
model =
    Signal.foldp update initialModel actions.signal 
  
initialModel : Model
initialModel =
    "Nancy"  
    
actions : Signal.Mailbox Action 

actions =
    Signal.mailbox NoOp
```

Build and run the app

```shell
elm-make SimpleApp.elm --output elm.js
elm-reactor
```