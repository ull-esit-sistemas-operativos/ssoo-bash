## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué muestra el `ls`?

    ```bash
    mkdir copia
    cp -r proyecto copia
    ls copia
    ```
  options:
    - id: a
      value: "`proyecto`"
      isCorrect: true
      explanation: Como `copia` ya existe y es un directorio, `cp` deja dentro la copia de `proyecto`, con su nombre.
    - id: b
      value: "`docs  README.md  src`"
      incorrectExplanation: "Eso pasaría si `copia` no existiera: entonces `cp -r` la crearía como copia de `proyecto`."
    - id: c
      value: Nada, porque `copia` está vacía
      incorrectExplanation: "`cp -r` copia `proyecto` dentro de `copia`, porque `copia` es un directorio que existe."
    - id: d
      value: Un error, porque `copia` ya existe
      incorrectExplanation: "`cp` no falla si el destino es un directorio que existe: copia dentro de él."
```

## Reto 2 · Prueba

Haz una copia de `proyecto` llamada `copia`.
Dentro de la copia, renombra `README.md` a `LEEME.md` y borra el directorio `docs` con lo que contiene.

::: details Solución

```bash
cp -r proyecto copia
mv copia/README.md copia/LEEME.md
rm -r copia/docs
ls -A copia
```

```text
LEEME.md  .oculto  src
```

Si `copia` ya existía de otro reto, bórrala antes con `rm -r copia`, o la copia quedará en `copia/proyecto`.

:::

Los retos que siguen son para practicar más.

## Reto 3 · Prueba

Copia `proyecto/src/main.c` sobre `proyecto/src/util.h`, pero de forma que `cp` pregunte antes de sobrescribir, y contesta que no.
Comprueba que `util.h` sigue vacío.

::: details Solución

```bash
cp -i proyecto/src/main.c proyecto/src/util.h
ls -l proyecto/src/util.h
```

`cp -i` pregunta si sobrescribe `proyecto/src/util.h`; con `n`, no copia nada, y `ls -l` sigue mostrando un tamaño de 0.

:::

## Reto 4 · Combina

Crea un fichero vacío llamado `-raro.txt`, comprueba con `ls` que existe y bórralo.

::: details Solución

```bash
touch -- -raro.txt
ls -- -raro.txt
rm -- -raro.txt
```

Sin `--`, los tres comandos tomarían `-raro.txt` como una lista de opciones.
`touch ./-raro.txt` o `rm ./-raro.txt` también funcionan, porque la ruta ya no empieza por guion.

:::
