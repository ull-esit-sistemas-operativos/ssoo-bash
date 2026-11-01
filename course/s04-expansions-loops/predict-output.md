Intenta responder sin ejecutar nada; después compruébalo en la terminal.

```quiz
- id: word-splitting
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprimen los dos `echo`?

    ```bash
    x="a   b"
    echo $x
    echo "$x"
    ```
  options:
    - id: a
      value: "`a b` y después `a   b`"
      isCorrect: true
      explanation: Sin comillas, el valor se parte en dos palabras y `echo` las une con un solo espacio; con comillas, llega intacto.
    - id: b
      value: "`a   b` las dos veces"
      incorrectExplanation: Sin comillas, el valor se parte en dos palabras y `echo` las une con un solo espacio.
    - id: c
      value: "`a b` las dos veces"
      incorrectExplanation: Con comillas, el valor llega intacto a `echo`, con sus tres espacios.
    - id: d
      value: "`a` y `b` en dos líneas, y después `a   b`"
      incorrectExplanation: "`echo` recibe dos argumentos y los escribe en la misma línea, separados por un espacio."

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
      incorrectExplanation: "Las llaves no se emparejan por posición: cada elemento de la primera se combina con cada uno de la segunda."
    - id: c
      value: "`a1 b1 a2 b2`"
      incorrectExplanation: "La primera llave manda: primero salen todas las combinaciones con `a` y después las de `b`."
    - id: d
      value: "`{a,b}{1,2}`"
      incorrectExplanation: Las llaves se expanden aunque no haya ficheros con esos nombres; no son un patrón de nombres de fichero.

- id: awk-count
  type: choice
  scrambleOrder: true
  content: Con el `notas.csv` de esta lectura, ¿qué imprime `awk -F, 'NR > 1 && $2 == "FP" { c++ } END { print c }' notas.csv`?
  options:
    - id: a
      value: "`3`"
      isCorrect: true
      explanation: Hay tres líneas de FP (ana, luis y marta); la condición no mira si la nota está vacía.
    - id: b
      value: "`2`"
      incorrectExplanation: La condición no mira la nota, así que también cuenta la línea de luis, que la tiene vacía.
    - id: c
      value: "`7`"
      incorrectExplanation: "`&&` exige las dos condiciones: solo cuentan las líneas de FP tras la cabecera."
    - id: d
      value: Nada, porque `c` no tiene valor inicial
      incorrectExplanation: En `awk`, una variable sin valor vale 0 al sumar.

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

- id: brace-range
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `echo foto{08..10}.jpg`?
  options:
    - id: a
      value: "`foto08.jpg foto09.jpg foto10.jpg`"
      isCorrect: true
      explanation: Como el principio del rango lleva un cero a la izquierda, todos los números se escriben con dos cifras.
    - id: b
      value: "`foto8.jpg foto9.jpg foto10.jpg`"
      incorrectExplanation: El cero a la izquierda del principio del rango hace que todos los números se escriban con dos cifras.
    - id: c
      value: "`foto08.jpg foto10.jpg`"
      incorrectExplanation: "`..` indica un rango, así que también incluye `09`."
    - id: d
      value: "`foto{08..10}.jpg`"
      incorrectExplanation: Los rangos con ceros a la izquierda también se expanden.

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

- id: replace-once-all
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime el `echo`?

    ```bash
    s=banana
    echo "${s/a/o} ${s//a/o}"
    ```
  options:
    - id: a
      value: "`bonana bonono`"
      isCorrect: true
      explanation: Con una barra se cambia solo la primera `a`; con dos, todas.
    - id: b
      value: "`bonono bonono`"
      incorrectExplanation: Con una sola barra, solo se cambia la primera `a`.
    - id: c
      value: "`banano bonono`"
      incorrectExplanation: Con una barra se cambia la primera `a` que aparece, empezando por la izquierda.
    - id: d
      value: "`bonana bonana`"
      incorrectExplanation: Con dos barras, se cambian todas las `a`, no solo la primera.

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
```
