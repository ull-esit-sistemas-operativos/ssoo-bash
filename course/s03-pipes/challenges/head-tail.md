## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `head -n 3 notas.csv | tail -n 1`?
  options:
    - id: a
      value: "`ana,FP,6`"
      isCorrect: true
      explanation: Es la tercera línea del fichero, contando la cabecera.
    - id: b
      value: "`ana,SSOO,7.5`"
      incorrectExplanation: La cabecera también es una línea, así que la tercera es la segunda de `ana`.
    - id: c
      value: "`luis,SSOO,4.5`"
      incorrectExplanation: "`head -n 3` deja las tres primeras líneas, cabecera incluida, y `tail -n 1` se queda con la última de ellas."
    - id: d
      value: Las tres primeras líneas
      incorrectExplanation: "`tail -n 1` se queda solo con la última de las tres."
```

## Reto 2 · Prueba

Muestra `notas.csv` entero menos la última línea, sin contar cuántas líneas tiene.

::: details Solución

```bash
head -n -1 notas.csv
```

Con un número negativo, `head` muestra todo menos esas últimas líneas.

:::

## Reto 3 · Combina

```quiz
- id: "3"
  type: string
  content: |
    Muestra solo el nombre del alumno con la nota más alta.
    ¿Quién es?
  options:
    - id: a
      value: "marta"
```

::: details Solución

```bash
tail -n +2 notas.csv | LC_ALL=C sort -t, -k3,3nr | head -n 1 | cut -d, -f1
```

```text
marta
```

`tail -n +2` quita la cabecera antes de ordenar.

:::

## Reto 4 · Combina

```quiz
- id: "4"
  type: string
  content: |
    Crea `mejores.csv` con la cabecera de `notas.csv` y las tres notas más altas, de mayor a menor, usando una sola redirección.
    ¿Cuál es la última línea de `mejores.csv`?
  options:
    - id: a
      value: "ana,SSOO,7.5"
```

::: details Solución

```bash
{ head -n 1 notas.csv; tail -n +2 notas.csv | LC_ALL=C sort -t, -k3,3nr | head -n 3; } > mejores.csv
```

```text
alumno,asignatura,nota
marta,SSOO,9
marta,FP,8.5
ana,SSOO,7.5
```

Las llaves agrupan las dos órdenes, así que `> mejores.csv` recoge la salida de ambas.
Con paréntesis saldría lo mismo, porque el grupo no cambia nada de la *shell*, pero se crearía una *subshell* en otro proceso sin necesidad.

:::
