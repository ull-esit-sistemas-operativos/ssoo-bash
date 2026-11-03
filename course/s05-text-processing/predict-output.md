Intenta responder sin ejecutar nada; después compruébalo en la terminal.

```quiz
- id: awk-count
  type: choice
  scrambleOrder: true
  content: Con el `notas.csv` de esta lectura, ¿qué imprime `gawk -F, 'NR > 1 && $2 == "FP" { c++ } END { print c }' notas.csv`?
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
      incorrectExplanation: "`&&` exige las dos condiciones, así que solo cuentan las líneas de FP tras la cabecera."
    - id: d
      value: Nada, porque `c` no tiene valor inicial
      incorrectExplanation: En `awk`, una variable sin valor vale 0 al sumar.

- id: awk-locale
  type: choice
  scrambleOrder: true
  content: |
    Con la configuración regional en español, ¿qué imprime `echo '7,5 8,5' | gawk '{ print $1 + $2 }'`?
  options:
    - id: a
      value: "`15`"
      isCorrect: true
      explanation: "`gawk` lee los decimales con punto aunque el equipo esté en español, así que lee `7,5` como 7 y `8,5` como 8."
    - id: b
      value: "`16`"
      incorrectExplanation: "Eso sale con `gawk --use-lc-numeric`, que usa la coma española como separador decimal."
    - id: c
      value: "`16,0`"
      incorrectExplanation: "`gawk` no escribe decimales cuando el resultado es entero, y sin `--use-lc-numeric` lee `7,5` como 7."
    - id: d
      value: Un error, porque `7,5` no es un número
      incorrectExplanation: "`gawk` no da error con un número mal escrito, sino que lee el número hasta donde puede, `7`."

- id: sort-keys
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime `printf 'b 10\na 9\nc 10\n' | sort -k2,2n -k1,1`?
  options:
    - id: a
      value: "`a 9`, `b 10` y `c 10`"
      isCorrect: true
      explanation: Ordena por el segundo campo como número, y los empates por el primero.
    - id: b
      value: "`b 10`, `c 10` y `a 9`"
      incorrectExplanation: "Con `n`, `sort` compara 9 y 10 como números, no como texto, así que el 9 va primero."
    - id: c
      value: "`a 9`, `c 10` y `b 10`"
      incorrectExplanation: "Los empates del segundo campo se resuelven con `-k1,1`, en orden alfabético: `b` antes que `c`."
    - id: d
      value: "`b 10`, `a 9` y `c 10`, como entran"
      incorrectExplanation: "`sort` ordena siempre; `-k` solo dice por qué campos."

- id: printf-width
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `printf '%03d|%-4s|\n' 7 ab`?
  options:
    - id: a
      value: "`007|ab  |`"
      isCorrect: true
      explanation: "`%03d` rellena con ceros hasta 3 cifras, y `%-4s` alinea a la izquierda en 4 columnas."
    - id: b
      value: "`  7|  ab|`"
      incorrectExplanation: "El `0` de `%03d` rellena con ceros, no con espacios, y el `-` de `%-4s` alinea a la izquierda."
    - id: c
      value: "`007|ab|`"
      incorrectExplanation: "`%-4s` ocupa siempre 4 columnas como mínimo, así que añade dos espacios tras `ab`."
    - id: d
      value: "`7|ab|`"
      incorrectExplanation: Los números entre `%` y la letra son anchos mínimos.

- id: comm-common
  type: choice
  scrambleOrder: true
  content: |
    `a.txt` tiene las líneas `ana`, `luis` y `marta`, y `b.txt`, `luis`, `marta` y `pablo`.
    ¿Qué imprime `comm -12 a.txt b.txt`?
  options:
    - id: a
      value: "`luis` y `marta`"
      isCorrect: true
      explanation: "`-1` y `-2` ocultan las líneas que solo están en uno de los ficheros, así que quedan las comunes."
    - id: b
      value: "`ana`"
      incorrectExplanation: "Eso imprime `comm -23`, que deja las líneas que solo están en el primero."
    - id: c
      value: "`pablo`"
      incorrectExplanation: "Eso imprime `comm -13`, que deja las líneas que solo están en el segundo."
    - id: d
      value: "`ana` y `pablo`"
      incorrectExplanation: "Las opciones ocultan columnas: `-12` oculta las de las líneas que solo están en uno de los dos."
```
