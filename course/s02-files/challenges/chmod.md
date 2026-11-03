## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: Si `notas.csv` tiene los permisos `rw-r--r--`, ¿cuáles tiene después de `chmod u+x,g=w notas.csv`?
  options:
    - id: a
      value: "`rwx-w-r--`"
      isCorrect: true
      explanation: "`u+x` añade la ejecución al propietario, `g=w` deja al grupo solo con la escritura y los demás no cambian."
    - id: b
      value: "`rwxrw-r--`"
      incorrectExplanation: "`=` fija exactamente los permisos que nombra, así que el grupo pierde la lectura."
    - id: c
      value: "`rw--w-r--`"
      incorrectExplanation: "`u+x` también añade la ejecución al propietario."
    - id: d
      value: "`rwx-w----`"
      incorrectExplanation: Los cambios solo afectan a las clases que nombran, `u` y `g`; los demás conservan la lectura.
```

## Reto 2 · Prueba

Con notación octal, deja `proyecto/src/main.c` con lectura y escritura para ti, solo lectura para el grupo y nada para los demás.

::: details Solución

```bash
chmod 640 proyecto/src/main.c
ls -l proyecto/src/main.c
```

```text
-rw-r----- 1 alu alu 2048 oct  3 12:00 proyecto/src/main.c
```

`6` es `rw-` (4 + 2), `4` es `r--` y `0`, `---`.

:::

Los retos que siguen son para practicar más.

## Reto 3 · Combina

Quita el permiso de escritura a todos en todo el árbol `proyecto` y comprueba con `find` que no queda ninguna entrada con escritura para nadie (`-perm` se explica en la [ficha de `find`](../cards/find.md)).
Después, devuélvesela al propietario.

::: details Solución

```bash
chmod -R a-w proyecto
find proyecto -perm /222
chmod -R u+w proyecto
```

El `find` no muestra nada, porque `-perm /222` encaja con las entradas que tienen la escritura para alguna clase.
Mientras `proyecto` no tiene escritura, tampoco se puede crear ni borrar nada dentro.

:::

## Reto 4 · Predice

```quiz
- id: "4"
  type: choice
  scrambleOrder: true
  content: ¿Qué permisos deja `chmod 64 notas.csv`?
  options:
    - id: a
      value: "`---rw-r--`"
      isCorrect: true
      explanation: "Las cifras que faltan son ceros a la izquierda: `64` es `064`, nada para el propietario, `rw-` para el grupo y `r--` para los demás."
    - id: b
      value: "`rw-r--r--`"
      incorrectExplanation: "Eso es `644`. Con dos cifras, falta la del propietario, que se toma como 0."
    - id: c
      value: "`rw-r-----`"
      incorrectExplanation: "Las cifras se completan por la izquierda, no por la derecha: `64` es `064`, no `640`."
    - id: d
      value: Un error, porque faltan cifras
      incorrectExplanation: "`chmod` acepta menos de tres cifras y completa con ceros por la izquierda."
```
