## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `echo proyecto/*`?
  options:
    - id: a
      value: "`proyecto/README.md proyecto/docs proyecto/src`"
      isCorrect: true
      explanation: "`*` encaja con los directorios igual que con los ficheros, pero no con `.oculto`, que empieza por punto."
    - id: b
      value: "`proyecto/.oculto proyecto/README.md proyecto/docs proyecto/src`"
      incorrectExplanation: "`*` no encaja con los nombres que empiezan por punto, así que `.oculto` no sale."
    - id: c
      value: "`proyecto/README.md`"
      incorrectExplanation: "`*` encaja con cualquier nombre, también con el de un directorio como `docs` o `src`."
    - id: d
      value: "`proyecto/README.md proyecto/docs/guía de uso.txt proyecto/src/main.c proyecto/src/util.h`"
      incorrectExplanation: "`*` no encaja con `/`, así que no entra en los subdirectorios: da los nombres que hay en `proyecto`, también `docs` y `src`."
```

## Reto 2 · Prueba

Muestra con `echo` los ficheros ocultos de `proyecto`, y solo esos.

::: details Solución

```bash
echo proyecto/.[!.]*
```

```text
proyecto/.oculto
```

El patrón pide un punto al principio y, detrás, un carácter que no sea otro punto, para dejar fuera `..`.
En bash 5.2, `proyecto/.*` da lo mismo, pero en versiones anteriores incluye también `proyecto/.` y `proyecto/..`.

:::

## Reto 3 · Predice

```quiz
- id: "3"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `echo proyecto/src/[!m]*`?
  options:
    - id: a
      value: "`proyecto/src/util.h`"
      isCorrect: true
      explanation: "`[!m]` encaja con un carácter que no es `m`, así que deja fuera `main.c`."
    - id: b
      value: "`proyecto/src/main.c`"
      incorrectExplanation: "`!` niega la lista: `[!m]` encaja con cualquier carácter salvo `m`."
    - id: c
      value: "`proyecto/src/main.c proyecto/src/util.h`"
      incorrectExplanation: "El primer carácter del nombre no puede ser `m`, así que `main.c` no encaja."
    - id: d
      value: "`proyecto/src/[!m]*`"
      incorrectExplanation: "El patrón queda tal cual solo si no encaja ningún nombre, y `util.h` encaja."
```

## Reto 4 · Combina

```quiz
- id: "4"
  type: string
  content: |
    ¿Cuántos ficheros encajan con `proyecto/*/*.?`?
    Escribe el número.
  options:
    - id: a
      value: "2"
```

::: details Solución

```bash
echo proyecto/*/*.?
```

```text
proyecto/src/main.c proyecto/src/util.h
```

El primer `*` recorre los subdirectorios `docs` y `src`, y `.?` exige que el nombre termine en un punto y un solo carácter.
`guía de uso.txt` no encaja, porque su extensión tiene tres.

:::

## Reto 5 · Prueba

Crea un directorio `fuentes` y copia en él, con un solo `cp`, los ficheros `.c` y `.h` de `proyecto/src`.

::: details Solución

```bash
mkdir fuentes
cp proyecto/src/*.[ch] fuentes/
```

```console
$ ls fuentes
main.c  util.h
```

`[ch]` encaja con una `c` o con una `h`, así que el patrón sirve para las dos extensiones.
Cuando termines, puedes borrar la copia con `rm -r fuentes`.

:::
