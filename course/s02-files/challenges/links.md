## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué hace el último `cat`?

    ```bash
    cp notas.csv a.csv
    ln a.csv b.csv
    rm a.csv
    cat b.csv
    ```
  options:
    - id: a
      value: Muestra el contenido de `notas.csv`
      isCorrect: true
      explanation: "`b.csv` es otro nombre del mismo fichero, y el contenido solo desaparece al borrar el último nombre."
    - id: b
      value: Da un error, porque el original ya no existe
      incorrectExplanation: "Eso le pasaría a un enlace simbólico. Un enlace duro es otro nombre del mismo fichero, tan válido como el primero."
    - id: c
      value: No muestra nada, porque el fichero se ha quedado vacío
      incorrectExplanation: "`rm` quita un nombre; el contenido sigue ahí mientras quede otro nombre, `b.csv`."
    - id: d
      value: Muestra `a.csv`, la ruta a la que apunta
      incorrectExplanation: Un enlace duro no guarda ninguna ruta; es el propio fichero con otro nombre.
```

## Reto 2 · Prueba

```quiz
- id: "2"
  type: string
  content: |
    Ejecuta `cp notas.csv a.csv` y `ln a.csv b.csv`.
    ¿Qué número aparece en la segunda columna de `ls -l a.csv`?
  options:
    - id: a
      value: "2"
```

::: details Solución

```bash
cp notas.csv a.csv
ln a.csv b.csv
ls -l a.csv b.csv
```

Las dos líneas muestran `2`: el fichero tiene dos nombres, `a.csv` y `b.csv`.
Con `rm b.csv`, `ls -l a.csv` vuelve a mostrar `1`.

:::

## Reto 3 · Prueba

Crea en el directorio actual un enlace simbólico `leeme` a `proyecto/README.md`, y mira a dónde apunta, primero con `ls -l` y después con `readlink`.

::: details Solución

```bash
ln -s proyecto/README.md leeme
ls -l leeme
readlink leeme
```

`ls -l` empieza por `l` y termina en `leeme -> proyecto/README.md`, y `readlink` escribe solo la ruta: `proyecto/README.md`.

:::

## Reto 4 · Predice

```quiz
- id: "4"
  type: choice
  scrambleOrder: true
  content: |
    Ejecutas `ln -s notas.csv proyecto/notas`.
    ¿Qué hace después `cat proyecto/notas`?
  options:
    - id: a
      value: Da un error, porque `proyecto/notas.csv` no existe
      isCorrect: true
      explanation: "La ruta relativa `notas.csv` se sigue desde `proyecto`, el directorio del enlace, así que lleva a `proyecto/notas.csv`."
    - id: b
      value: Muestra el contenido de `notas.csv`
      incorrectExplanation: "La ruta relativa se sigue desde el directorio del enlace, `proyecto`, no desde donde se creó."
    - id: c
      value: Nada, porque ya falla `ln`
      incorrectExplanation: "`ln -s` guarda la ruta tal cual, sin comprobar que exista."
    - id: d
      value: Muestra `notas.csv`, la ruta que guarda el enlace
      incorrectExplanation: "`cat` lee el fichero al que lleva el enlace; la ruta que guarda la escribe `readlink`."
```

## Reto 5 · Combina

Haz que el enlace `proyecto/notas` del reto anterior lleve a `notas.csv`, y comprueba con `cat` que funciona.

::: details Solución

```bash
rm proyecto/notas
ln -s ../notas.csv proyecto/notas
cat proyecto/notas
```

`rm` borra el enlace, no `notas.csv`.
Desde `proyecto`, `notas.csv` está en el directorio padre, así que el enlace tiene que guardar `../notas.csv`.

:::
