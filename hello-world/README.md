# hello world

Install the elm html package, this command also creates an elm-package.json file 
and installs any dependencies.

```shell
elm package install evancz/elm-html
```

Create a new file HelloWorld.elm.

```elm
import Html exposing (text)

main =
  text "Hello, World!"
```

Test the app starting the elm reactor and browsing to http://localhost:8000/.

```shell
elm-reactor
```
