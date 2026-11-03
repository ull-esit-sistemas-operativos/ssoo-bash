Intenta responder sin ejecutar nada; después compruébalo en la terminal.

```quiz
- id: integer-division
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `echo $(( 7 / 2 * 2 ))`?
  options:
    - id: a
      value: "`6`"
      isCorrect: true
      explanation: La división entera da 3, y 3 por 2 es 6.
    - id: b
      value: "`7`"
      incorrectExplanation: "La aritmética de bash es entera: `7 / 2` da 3, no 3,5."
    - id: c
      value: "`1`"
      incorrectExplanation: "`/` y `*` tienen la misma prioridad y se evalúan de izquierda a derecha: `(7 / 2) * 2`."
    - id: d
      value: Un error, porque 7 no es divisible entre 2
      incorrectExplanation: bash descarta los decimales de la división sin avisar.

- id: brace-product
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `echo {a,b}{1,2}`?
  options:
    - id: a
      value: "`a1 a2 b1 b2`"
      isCorrect: true
      explanation: Cada elemento de la primera llave se combina con cada uno de la segunda.
    - id: b
      value: "`a1 b2`"
      incorrectExplanation: "Las llaves no se emparejan por posición, sino que cada elemento de la primera se combina con cada uno de la segunda."
    - id: c
      value: "`a1 b1 a2 b2`"
      incorrectExplanation: "La primera llave manda, así que primero salen todas las combinaciones con `a` y después las de `b`."
    - id: d
      value: "`{a,b}{1,2}`"
      incorrectExplanation: Las llaves se expanden aunque no haya ficheros con esos nombres; no son un patrón de nombres de fichero.

- id: grep-anchors
  type: choice
  scrambleOrder: true
  content: Con el `notas.csv` de esta lectura, ¿qué imprime `grep -cE '^[a-z]+,SSOO,$' notas.csv`?
  options:
    - id: a
      value: "`1`"
      isCorrect: true
      explanation: Solo la línea de pablo es de SSOO y termina justo después de la segunda coma.
    - id: b
      value: "`2`"
      incorrectExplanation: La línea de luis también termina en coma, pero es de FP.
    - id: c
      value: "`4`"
      incorrectExplanation: "`$` exige que la línea termine justo después de la coma, así que no cuentan las que tienen nota."
    - id: d
      value: "`0`"
      incorrectExplanation: "`$` encaja con el final de la línea, y la de pablo termina justo después de la coma, porque no tiene nota."

- id: quoted-args
  type: choice
  scrambleOrder: true
  content: |
    El *script* `cuenta.sh` contiene estas líneas.
    ¿Qué imprime `./cuenta.sh a "b c"`?

    ```bash
    for f in "$@"; do echo "[$f]"; done
    for f in $@; do echo "<$f>"; done
    ```
  options:
    - id: a
      value: "`[a]` y `[b c]`; después `<a>`, `<b>` y `<c>`"
      isCorrect: true
      explanation: Con comillas, cada argumento llega entero; sin ellas, `$@` se parte por los espacios como cualquier otra expansión.
    - id: b
      value: "`[a]` y `[b c]`; después `<a>` y `<b c>`"
      incorrectExplanation: Sin comillas, `$@` se parte por los espacios como cualquier otra expansión.
    - id: c
      value: "`[a]`, `[b]` y `[c]`; después `<a>`, `<b>` y `<c>`"
      incorrectExplanation: "Con comillas, `\"$@\"` da cada argumento entero, aunque tenga espacios."
    - id: d
      value: "`[a b c]`; después `<a>`, `<b>` y `<c>`"
      incorrectExplanation: "Eso haría `\"$*\"`, que une los argumentos en una sola palabra; `\"$@\"` los mantiene separados."

- id: substring-space
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime el `echo`?

    ```bash
    d=2026-10-31
    echo "${d:-2} ${d: -2}"
    ```
  options:
    - id: a
      value: "`2026-10-31 31`"
      isCorrect: true
      explanation: Sin espacio, `:-` da un valor por defecto, que no se usa porque `d` tiene valor; con el espacio, `-2` es una posición contada desde el final.
    - id: b
      value: "`31 31`"
      incorrectExplanation: Sin espacio, bash lee `:-` como un valor por defecto, que no se usa porque `d` tiene valor.
    - id: c
      value: "`2 31`"
      incorrectExplanation: El valor por defecto de `:-` solo se usa si la variable está vacía o no existe, y `d` tiene valor.
    - id: d
      value: "`2026-10-31 2026-10-31`"
      incorrectExplanation: Con el espacio, `-2` es una posición contada desde el final, así que salen los 2 últimos caracteres.

- id: pipe-subshell
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime el último `echo`?

    ```bash
    n=0
    printf 'a\nb\nc\n' | while read -r l; do n=$(( n + 1 )); done
    echo $n
    ```
  options:
    - id: a
      value: "`0`"
      isCorrect: true
      explanation: El `while` se ejecuta en un proceso aparte por estar al final de la tubería, así que sus cambios a `n` se pierden.
    - id: b
      value: "`3`"
      incorrectExplanation: El bucle da tres vueltas, pero en un proceso aparte por estar al final de la tubería; sus cambios a `n` se pierden.
    - id: c
      value: "`1`"
      incorrectExplanation: El `while` se ejecuta en un proceso aparte, así que el `n` del *script* no cambia nunca.
    - id: d
      value: Una línea vacía
      incorrectExplanation: "`n` sigue existiendo con el valor que se le asignó antes del bucle."

- id: case-sensitive
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime este `case`?

    ```bash
    f=informe.PDF
    case $f in
        *.pdf) echo documento ;;
        *)     echo otro ;;
    esac
    ```
  options:
    - id: a
      value: "`otro`"
      isCorrect: true
      explanation: Los patrones de `case` distinguen mayúsculas, y `*.pdf` no encaja con `.PDF`.
    - id: b
      value: "`documento`"
      incorrectExplanation: Los patrones de `case` distinguen mayúsculas, y `*.pdf` no encaja con `.PDF`.
    - id: c
      value: "`documento` y después `otro`"
      incorrectExplanation: "`case` ejecuta solo la primera rama que encaja; `;;` termina el `case`."
    - id: d
      value: Nada
      incorrectExplanation: "`*` encaja con cualquier valor, así que la última rama se ejecuta cuando no encaja ninguna anterior."
```
