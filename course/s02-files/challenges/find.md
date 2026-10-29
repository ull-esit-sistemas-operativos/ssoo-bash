## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Cuántas líneas imprime `find proyecto -maxdepth 1 -type f`?
  options:
    - id: a
      value: "`2`"
      isCorrect: true
      explanation: "Con `-maxdepth 1` no entra en `docs` ni en `src`, y `-type f` deja fuera los directorios: quedan `proyecto/.oculto` y `proyecto/README.md`."
    - id: b
      value: "`5`"
      incorrectExplanation: Con `-maxdepth 1` no entra en `docs` ni en `src`, así que no cuenta sus ficheros.
    - id: c
      value: "`4`"
      incorrectExplanation: "`-type f` deja fuera los directorios `docs` y `src`."
    - id: d
      value: "`1`"
      incorrectExplanation: "`find` también muestra los ficheros ocultos, como `proyecto/.oculto`."
```

## Reto 2 · Prueba

Lista los ficheros vacíos que hay en todo el árbol `proyecto`.

::: details Solución

```bash
find proyecto -type f -empty
```

Tres ficheros: `proyecto/src/util.h`, `proyecto/README.md` y `proyecto/docs/guía de uso.txt`, en el orden en que los devuelva el sistema de ficheros.

:::

## Reto 3 · Prueba

Lista los ficheros de `proyecto` modificados después que `proyecto/README.md`.

::: details Solución

```bash
find proyecto -type f -newer proyecto/README.md
```

```text
proyecto/src/main.c
```

:::

## Reto 4 · Combina

```quiz
- id: "4"
  type: string
  content: |
    ¿Cuántos bytes ocupan en total los ficheros de `proyecto`?
    Resuélvelo con `find` y `awk`.
  options:
    - id: a
      value: "2053"
```

::: details Solución

```bash
find proyecto -type f -printf '%s\n' | awk '{ s += $1 } END { print s }'
```

`2053`: los 2048 de `main.c` y los 5 de `.oculto`.

:::

## Reto 5 · Prueba

Muestra cuántos bytes tiene cada fichero `.txt` de `proyecto`, aunque su nombre tenga espacios, ejecutando `wc` desde el propio `find`.

::: details Solución

```bash
find proyecto -name '*.txt' -exec wc -c {} +
```

```text
0 proyecto/docs/guía de uso.txt
```

`find` pasa cada ruta como un solo argumento, así que el espacio del nombre no la parte.

:::
