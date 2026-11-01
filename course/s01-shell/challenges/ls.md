## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `ls -A proyecto | wc -l`?
  options:
    - id: a
      value: "`4`"
      isCorrect: true
      explanation: "`-A` incluye las entradas ocultas (`.oculto`) pero no `.` ni `..`: `.oculto`, `docs`, `README.md` y `src`."
    - id: b
      value: "`3`"
      incorrectExplanation: "`-A` también incluye las entradas ocultas, como `.oculto`."
    - id: c
      value: "`6`"
      incorrectExplanation: "`-A` deja fuera `.` y `..`; las incluiría `-a`."
    - id: d
      value: "`1`"
      incorrectExplanation: Cuando su salida va a una tubería, `ls` escribe un nombre por línea.
```

## Reto 2 · Prueba

Muestra el contenido de `proyecto/src` ordenado del fichero modificado hace más tiempo al más reciente.

::: details Solución

```bash
ls -tr proyecto/src
```

```text
util.h
main.c
```

`-t` ordena por fecha, del más reciente al más antiguo, y `-r` invierte el orden.

:::

## Reto 3 · Prueba

Muestra los permisos, el propietario y la fecha del propio directorio `proyecto/src`, no los de lo que contiene.

::: details Solución

```bash
ls -ld proyecto/src
```

```text
drwxr-xr-x 2 alu alu 4096 oct  1 10:00 proyecto/src
```

Sin `-d`, `ls -l` mostraría `main.c` y `util.h`.

:::

## Reto 4 · Combina

```quiz
- id: "4"
  type: string
  content: |
    ¿Cuántos subdirectorios hay directamente dentro de `proyecto`, contando también los ocultos?
    Resuélvelo con una sola orden `ls`, combinando dos opciones.
  options:
    - id: a
      value: "2"
```

::: details Solución

```bash
ls -AF proyecto
```

```text
.oculto  README.md  docs/  src/
```

`2`: `-A` añade las entradas ocultas y `-F` marca los directorios con `/`.
`.oculto` sale, pero sin `/`, porque es un fichero.

:::
