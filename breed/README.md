# breed

## setup the basic app

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
    <title>Breed</title>
    <script type="text/javascript" src="elm.js"></script>
</head>

<body>
</body>

<script type="text/javascript">
var breed = Elm.fullscreen(Elm.Breed);
</script>

</html>
```

Create Breed.elm

```elm
module Breed where

-- MODEL   

-- UPDATE

-- VIEW

-- INPUTS
```

## dependencies

```elm
module Breed where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy, lazy2, lazy3)
import Signal exposing (Signal, Address)
import String
```

## model

```elm
-- MODEL

type alias Model = 
    { people : List Person
    , firstNameField : String
    , lastNameField : String
    , uid : Int
    }
    
type alias Person =
    { firstName : String
    , lastName : String
    , father : Maybe Parent
    , mother : Maybe Parent
    , children : List Child
    , id : Int
    }
    
type Parent = Parent (Person)
    
type Child = Child (Person)
    
emptyModel : Model
emptyModel =
    { people = []
    , firstNameField = ""
    , lastNameField = ""
    , uid = 0
    }
    
newPerson : String -> String -> Int -> Person
newPerson firstName lastName id =
    { firstName = firstName
    , lastName = lastName
    , father = Nothing
    , mother = Nothing
    , children = []
    , id = id
    }   
```

## update

```elm
-- UPDATE

type Action
    = NoOp
    | UpdateFirstNameField String
    | UpdateLastNameField String
    | AddPerson
    
update : Action -> Model -> Model
update action model =
    case action of
        NoOp -> model
        
        UpdateFirstNameField firstName ->
            { model | firstNameField = firstName }
            
        UpdateLastNameField lastName ->
            { model | lastNameField = lastName }
        
        AddPerson ->
            { model |
                uid = model.uid + 1,
                firstNameField = "",
                lastNameField = "",
                people =
                    if String.isEmpty model.firstNameField || String.isEmpty model.lastNameField
                    then model.people
                    else model.people ++ [ newPerson model.firstNameField model.lastNameField model.uid ]
            }
```

## view

```elm
-- VIEW

view : Address Action -> Model -> Html
view address model =
    div
        [ class "breed-wrapper" ]
        [ div 
            [ id "breedapp" ] 
            [ lazy3 personEntry address model.firstNameField model.lastNameField
            , lazy2 personList address model.people
            ]
        ]

personEntry : Address Action -> String -> String -> Html
personEntry address firstName lastName = 
    header
        [ id "header" ]
        [ h1 [] [ text "people" ]
        , input 
            [ id "newFirstName"
            , placeholder "Firstname"
            , autofocus True
            , value firstName
            , name "newFirstName"
            , on "input" targetValue (Signal.message address << UpdateFirstNameField)
            ]
            []
        , input 
            [ id "newLastName"
            , placeholder "Lastname"
            , autofocus True
            , value lastName
            , name "newLastName"
            , on "input" targetValue (Signal.message address << UpdateLastNameField)
            ]
            []
        , button
            [ id "addPerson"
            , onClick address AddPerson ]
            [ text "Add" ]
        ]
        
personList : Address Action -> List Person -> Html
personList address people =
    ul
        [ id "people-list" ]
        (List.map (personItem address) (people))  
        
personItem : Address Action -> Person -> Html
personItem address person =
    li
        [ class "person-item" ]
        [ input [ type' "checkbox" ] []
        , span [] [text (person.firstName ++ " " ++ person.lastName) ] ]
```

## inputs

```elm
-- INPUTS

main : Signal Html
main =
    Signal.map (view actions.address) model

model : Signal Model
model =
    Signal.foldp update initialModel actions.signal 

initialModel : Model
initialModel = emptyModel  

actions : Signal.Mailbox Action 

actions =
    Signal.mailbox NoOp
```

## Build and run the app

```shell
elm-make SimpleApp.elm --output elm.js
elm-reactor
```