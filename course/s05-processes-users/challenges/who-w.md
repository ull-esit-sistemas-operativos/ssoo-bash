Los retos suponen que `who` devuelve la salida de `who.txt`, que está en la carpeta de los retos.
En un equipo sin sesiones registradas se pueden resolver sustituyendo `who` por `cat who.txt`.

## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprimen `who | wc -l` y `who | cut -d' ' -f1 | sort -u | wc -l`?
  options:
    - id: a
      value: "`3` y `2`"
      isCorrect: true
      explanation: "`who` lista sesiones, y `alu` tiene dos."
    - id: b
      value: "`3` y `3`"
      incorrectExplanation: "`sort -u` deja una línea por usuario, y `alu` tiene dos sesiones."
    - id: c
      value: "`2` y `2`"
      incorrectExplanation: "`who` lista sesiones, no usuarios, y `alu` tiene dos."
    - id: d
      value: "`2` y `3`"
      incorrectExplanation: "`who` lista sesiones y `sort -u` quita los usuarios repetidos, así que la segunda no puede dar más que la primera."
```

## Reto 2 · Prueba

Muestra solo el usuario y el terminal de cada sesión.

::: details Solución

```bash
who | awk '{ print $1, $2 }'
```

```text
alu pts/0
luis pts/1
alu pts/2
```

`awk` y no `cut`, porque las columnas de `who` están separadas por varios espacios.

:::

## Reto 3 · Combina

Muestra el usuario con más sesiones abiertas y cuántas tiene.

::: details Solución

```bash
who | cut -d' ' -f1 | sort | uniq -c | sort -rn | head -n 1
```

```text
      2 alu
```

:::
