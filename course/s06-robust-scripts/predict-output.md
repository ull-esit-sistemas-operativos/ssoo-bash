Intenta responder sin ejecutar nada; después compruébalo en la terminal.

```quiz
- id: local-var
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprimen los dos `echo`?

    ```bash
    x=1
    f() { local x=2; echo "$x"; }
    f
    echo "$x"
    ```
  options:
    - id: a
      value: "`2` y `1`"
      isCorrect: true
      explanation: La `x` de la función es local; la global no cambia.
    - id: b
      value: "`2` y `2`"
      incorrectExplanation: "`local` crea una `x` propia de la función; la global no cambia."
    - id: c
      value: "`1` y `1`"
      incorrectExplanation: Dentro de la función, la `x` local tapa a la global.
    - id: d
      value: "`2` y una línea vacía"
      incorrectExplanation: La `x` global sigue existiendo después de la función y vale 1.

- id: default-values
  type: choice
  scrambleOrder: true
  content: |
    Con `NOMBRE` sin definir, ¿qué imprime cada línea?

    ```bash
    echo "${NOMBRE:-anónimo}"
    echo "[$NOMBRE]"
    echo "${NOMBRE:=anónimo}"
    echo "[$NOMBRE]"
    ```
  options:
    - id: a
      value: "`anónimo`, `[]`, `anónimo` y `[anónimo]`"
      isCorrect: true
      explanation: "`:-` solo sustituye; `:=` además asigna."
    - id: b
      value: "`anónimo`, `[anónimo]`, `anónimo` y `[anónimo]`"
      incorrectExplanation: "`:-` solo sustituye el valor en esa expansión; no asigna la variable."
    - id: c
      value: "`anónimo`, `[]`, `anónimo` y `[]`"
      incorrectExplanation: "`:=`, además de sustituir, asigna el valor a la variable."
    - id: d
      value: Una línea vacía, `[]`, una línea vacía y `[]`
      incorrectExplanation: Las dos formas sustituyen una variable vacía o sin definir por el valor que sigue.

- id: unknown-option
  type: choice
  scrambleOrder: true
  content: ¿Qué ocurre al ejecutar `./resumen_log.sh acceso.log -c 500 -x`, con la versión completa de esta lectura?
  options:
    - id: a
      value: Imprime «opción desconocida» y cómo ver la ayuda en el error estándar, y termina con estado 1
      isCorrect: true
      explanation: "`-c` toma `500` como código y se detiene en `-x`, que no es un número. Después, `-x` cae en el caso `-*`: el *script* imprime «opción desconocida: -x» y la línea que dice cómo ver la ayuda, y termina con estado 1."
    - id: b
      value: Ignora `-x` y resume el *log* con el código 500
      incorrectExplanation: "`-x` cae en el caso `-*`, que trata cualquier opción desconocida como un error."
    - id: c
      value: Da un error porque `acceso.log` va antes de las opciones
      incorrectExplanation: El bucle acepta el fichero en cualquier posición; el error viene de `-x`.
    - id: d
      value: Toma `-x` como otro código de `-c`
      incorrectExplanation: "`-c` solo toma argumentos que son números, y se detiene en `-x`."

- id: set-u
  type: choice
  scrambleOrder: true
  content: |
    Un *script* empieza con `set -eu` y contiene `echo "Hola, $nombe"`, con una errata en el nombre de la variable.
    ¿Qué pasa al llegar a esa línea?
  options:
    - id: a
      value: bash avisa de que `nombe` no está definida y el *script* termina sin ejecutar el `echo`
      isCorrect: true
      explanation: Lo hace por `set -u`; sin esa opción, habría impreso «Hola, » sin avisar.
    - id: b
      value: Imprime «Hola, » y sigue
      incorrectExplanation: Eso pasaría sin `set -u`; con `-u`, usar una variable sin definir es un error.
    - id: c
      value: Imprime «Hola, » y después termina por `set -e`
      incorrectExplanation: El error ocurre al expandir la variable, antes de ejecutar el `echo`, así que no llega a imprimir nada.
    - id: d
      value: Imprime «Hola, $nombe»
      incorrectExplanation: Dentro de comillas dobles `$` sí se expande; solo las comillas simples lo impiden.
```
