## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `printf '%s=%s\n' a 1 b 2 c`?
  options:
    - id: a
      value: "`a=1`, `b=2` y `c=`, en tres líneas"
      isCorrect: true
      explanation: El formato se repite mientras queden argumentos. En la última vuelta falta el valor de `c`, y el `%s` que sobra se rellena con la cadena vacía.
    - id: b
      value: Solo `a=1`
      incorrectExplanation: El formato se repite mientras queden argumentos.
    - id: c
      value: "`a=1`, `b=2` y `c`, en tres líneas"
      incorrectExplanation: "El formato entero se repite: el `%s` que sobra se rellena con la cadena vacía, pero el `=` se escribe igual."
    - id: d
      value: "`a=1`, `b=2` y un error"
      incorrectExplanation: Si faltan argumentos, `printf` rellena los `%s` que sobran con la cadena vacía, sin error.
```

## Reto 2 · Predice

```quiz
- id: "2"
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime `printf '%.3s|%5s|\n' abcdef ab`?
    En las opciones, cada `␣` es un espacio.
  options:
    - id: a
      value: "`abc|␣␣␣ab|`"
      isCorrect: true
      explanation: "`%.3s` corta el texto a tres caracteres y `%5s` lo alinea a la derecha en cinco."
    - id: b
      value: "`abc|ab␣␣␣|`"
      incorrectExplanation: "`%5s` alinea a la derecha; a la izquierda alinearía `%-5s`."
    - id: c
      value: "`abcdef|␣␣␣ab|`"
      incorrectExplanation: "`%.3s` corta el texto a tres caracteres."
    - id: d
      value: "`abc|ab|`"
      incorrectExplanation: "`%5s` rellena con espacios hasta cinco caracteres."
```

## Reto 3 · Prueba

Imprime los números 1, 2 y 3 con dos cifras (`01`, `02`, `03`), uno por línea, con una sola orden.

::: details Solución

```bash
printf '%02d\n' 1 2 3
```

:::

## Reto 4 · Combina

Imprime una línea de 20 guiones sin escribirlos uno a uno.

::: details Solución

```bash
printf -- '-%.0s' {1..20}; echo
```

`{1..20}` da 20 argumentos, y `%.0s` los consume sin imprimir nada de ellos: cada vuelta solo deja el guion.
El `--` evita que `printf` tome el formato por una opción, y el `echo` final pone el salto de línea.

:::

## Reto 5 · Combina

Recorre `proyecto/*` e imprime solo las entradas que son directorios, cada una con una `/` al final.

::: details Solución

```bash
for f in proyecto/*; do
    [[ -d $f ]] && printf '%s/\n' "$f"
done
```

```text
proyecto/docs/
proyecto/src/
```

`proyecto/*` no incluye `.oculto`, pero tampoco haría falta: es un fichero.

:::
