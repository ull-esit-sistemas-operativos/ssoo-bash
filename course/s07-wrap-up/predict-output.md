Cada pregunta combina piezas de varias semanas.
Intenta responder sin ejecutar nada; después compruébalo en la terminal.

```quiz
- id: most-frequent
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `printf '%s\n' b a b c | sort | uniq -c | sort -nr | head -n 1`?
  options:
    - id: a
      value: "`2 b`, con el número alineado a la derecha"
      isCorrect: true
      explanation: "`b` es la única línea repetida."
    - id: b
      value: "`1 a`"
      incorrectExplanation: "`sort -nr` pone primero los números mayores."
    - id: c
      value: "`b`"
      incorrectExplanation: "`uniq -c` antepone a cada línea el número de veces que aparece."
    - id: d
      value: "`2 b`, `1 a` y `1 c`"
      incorrectExplanation: "`head -n 1` deja solo la primera línea."

- id: awk-sum
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime este programa?

    ```bash
    printf '%s\n' a,3 b,4 a,4 |
        awk -F, '{ s[$1] += $2 } END { for (k in s) if (s[k] > 5) print k }'
    ```
  options:
    - id: a
      value: "`a`"
      isCorrect: true
      explanation: Sus valores suman 7; los de `b`, 4.
    - id: b
      value: "`a` y `b`"
      incorrectExplanation: "Los valores se suman por clave: `a` suma 7, pero `b` solo 4."
    - id: c
      value: Nada
      incorrectExplanation: "`a` aparece dos veces y sus valores se acumulan: 3 + 4 = 7."
    - id: d
      value: "`7`"
      incorrectExplanation: "`print k` imprime la clave, no la suma."

- id: comm-common
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `comm -12 <(printf '%s\n' ana luis) <(printf '%s\n' luis marta)`?
  options:
    - id: a
      value: "`luis`"
      isCorrect: true
      explanation: "`-12` oculta las columnas de líneas exclusivas y deja solo las comunes."
    - id: b
      value: "`ana` y `marta`"
      incorrectExplanation: "Esas son las líneas exclusivas; `-12` oculta sus columnas y deja la de las comunes."
    - id: c
      value: "`ana`, `luis` y `marta`"
      incorrectExplanation: "`-1` y `-2` ocultan las columnas de las líneas exclusivas de cada entrada."
    - id: d
      value: Nada, porque `comm` necesita ficheros
      incorrectExplanation: "`<( )` da a `comm` un nombre de fichero del que leer la salida de la orden."

- id: octal
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime `echo 08:30 | awk -F: '{ print $1 * 60 + $2 }'`?
    ¿Y `echo $(( 08 * 60 + 30 ))`?
  options:
    - id: a
      value: "`awk` imprime `510` y bash da un error"
      isCorrect: true
      explanation: En bash, `08` empieza por cero, se interpreta en octal y 8 no es una cifra octal.
    - id: b
      value: Los dos imprimen `510`
      incorrectExplanation: En bash, un número que empieza por cero está en octal, y 8 no es una cifra octal.
    - id: c
      value: Los dos dan un error
      incorrectExplanation: "`awk` lee `08` como un número decimal."
    - id: d
      value: "`awk` da un error y bash imprime `510`"
      incorrectExplanation: "Es al revés: `awk` lee `08` en decimal, y bash, en octal."
```
