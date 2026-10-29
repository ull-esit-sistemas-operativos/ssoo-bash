## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `printf 'a\nb' | wc -l`?
  options:
    - id: a
      value: "`1`"
      isCorrect: true
      explanation: "`-l` cuenta saltos de línea, y la `b` no tiene salto detrás."
    - id: b
      value: "`2`"
      incorrectExplanation: "`-l` cuenta saltos de línea, y la `b` no tiene salto detrás."
    - id: c
      value: "`3`"
      incorrectExplanation: Esos son los caracteres, que cuenta `-m`; `-l` cuenta saltos de línea.
    - id: d
      value: "`0`"
      incorrectExplanation: "`printf` interpreta `\\n` como un salto de línea, y hay uno después de la `a`."
```

## Reto 2 · Predice

```quiz
- id: "2"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprimen `echo 'canción' | wc -c` y `echo 'canción' | wc -m`?
  options:
    - id: a
      value: "`9` y `8`"
      isCorrect: true
      explanation: "`echo` añade el salto de línea, y la `ó` ocupa dos bytes en UTF-8: `-c` cuenta bytes y `-m`, caracteres."
    - id: b
      value: "`8` y `7`"
      incorrectExplanation: "`echo` añade un salto de línea, que también se cuenta."
    - id: c
      value: "`8` y `8`"
      incorrectExplanation: La `ó` ocupa dos bytes en UTF-8, así que `-c`, que cuenta bytes, da uno más que `-m`.
    - id: d
      value: "`8` y `9`"
      incorrectExplanation: "Es al revés: `-c` cuenta bytes y `-m`, caracteres, y la `ó` ocupa dos bytes."
```

## Reto 3 · Prueba

```quiz
- id: "3"
  type: string
  content: |
    ¿Cuántos caracteres tiene la línea más larga de `acceso.log`?
  options:
    - id: a
      value: "81"
```

::: details Solución

```bash
wc -L acceso.log
```

```text
81 acceso.log
```

:::

## Reto 4 · Combina

```quiz
- id: "4"
  type: string
  content: |
    ¿Cuántas IP distintas aparecen en el *log*?
  options:
    - id: a
      value: "3"
```

::: details Solución

```bash
cut -d' ' -f1 acceso.log | sort -u | wc -l
```

`3`.

:::
