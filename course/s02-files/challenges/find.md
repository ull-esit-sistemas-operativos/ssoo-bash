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
    ¿Qué fichero de `proyecto` ocupa más de 1 KiB?
    Escribe su ruta tal y como la muestra `find`.
  options:
    - id: a
      value: "proyecto/src/main.c"
```

::: details Solución

```bash
find proyecto -type f -size +1k
```

`proyecto/src/main.c`, que tiene 2048 bytes.
`-size` redondea hacia arriba, así que `.oculto`, con 5 bytes, cuenta como 1 KiB y no lo supera.

:::

## Reto 5 · Prueba

Muestra con `ls -l` los datos de cada fichero `.txt` de `proyecto`, aunque su nombre tenga espacios, ejecutando `ls` desde el propio `find`.

::: details Solución

```bash
find proyecto -name '*.txt' -exec ls -l {} +
```

Sale una sola línea, la de `proyecto/docs/guía de uso.txt`, con tamaño 0.
En la terminal, `ls` muestra el nombre entre comillas simples porque tiene espacios.

`find` pasa cada ruta como un solo argumento, así que el espacio del nombre no la parte.

:::
