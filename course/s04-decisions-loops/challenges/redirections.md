## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué sale en la pantalla con `ls proyecto /noexiste 2>&1 > salida.txt`?
  options:
    - id: a
      value: El mensaje de error de `ls`
      isCorrect: true
      explanation: "`2>&1` copia el destino que tiene la salida en ese momento, la pantalla. Después, solo la salida va a `salida.txt`. Con `> salida.txt 2>&1` no saldría nada."
    - id: b
      value: Nada
      incorrectExplanation: "Eso pasaría con `> salida.txt 2>&1`. Las redirecciones se aplican de izquierda a derecha, y cuando se aplica `2>&1` la salida aún apunta a la pantalla."
    - id: c
      value: El listado de `proyecto`
      incorrectExplanation: "El listado va por la salida estándar, que acaba en `salida.txt`. Lo que se queda en la pantalla es el error."
    - id: d
      value: El listado y el error
      incorrectExplanation: "`> salida.txt` sí afecta a la salida, aunque vaya al final. Lo que no sigue al fichero es el error."
```

## Reto 2 · Predice

```quiz
- id: "2"
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime esto?

    ```bash
    n=0
    tail -n +2 notas.csv | while IFS=, read -r _ _ nota; do
        [[ -z $nota ]] && n=$((n + 1))
    done
    echo "$n"
    ```
  options:
    - id: a
      value: "`0`"
      isCorrect: true
      explanation: "El `while` está al final de una tubería, así que se ejecuta en un proceso aparte y su `n` se pierde al terminar. Con `done < <(tail -n +2 notas.csv)` imprimiría `2`."
    - id: b
      value: "`2`"
      incorrectExplanation: "Hay dos notas vacías, pero el bucle las cuenta en un proceso aparte, porque está al final de una tubería. La `n` de la *shell* sigue valiendo 0."
    - id: c
      value: "`7`"
      incorrectExplanation: "`[[ -z $nota ]]` solo suma con las notas vacías. Además, el bucle está al final de una tubería y su `n` se pierde al terminar."
    - id: d
      value: Nada, porque la tubería no deja que `echo` se ejecute
      incorrectExplanation: "`echo` va después de `done`, fuera de la tubería, y se ejecuta igualmente cuando termina el bucle."
```

Los retos que siguen son para practicar más.

## Reto 3 · Prueba

```quiz
- id: "3"
  type: string
  content: |
    Ejecuta `ls proyecto /noexiste /tampoco` sin que salga nada en la pantalla, guardando solo sus errores en `errores.txt`.
    ¿Cuántas líneas tiene `errores.txt`?
  options:
    - id: a
      value: "2"
```

::: details Solución

```bash
ls proyecto /noexiste /tampoco > /dev/null 2> errores.txt
wc -l < errores.txt
```

`2`, una por cada ruta que no existe.
El listado de `proyecto` va a `/dev/null`.

:::

## Reto 4 · Combina

Escribe en `vacias.txt`, con una sola redirección, la línea «Notas vacías:» seguida de los alumnos de `notas.csv` que no tienen nota.

::: details Solución

```bash
{ echo "Notas vacías:"; grep ',$' notas.csv | cut -d, -f1; } > vacias.txt
cat vacias.txt
```

```text
Notas vacías:
luis
pablo
```

El grupo de órdenes junta la salida de `echo` y la de la tubería en una sola redirección.
Con `echo "Notas vacías:" > vacias.txt` y luego `>>`, harían falta dos.

:::

## Reto 5 · Predice

```quiz
- id: "5"
  type: choice
  scrambleOrder: true
  content: ¿Qué hace `echo "Error" >2`?
  options:
    - id: a
      value: Crea un fichero llamado `2` con el texto `Error`
      isCorrect: true
      explanation: "Sin `&`, lo que sigue a `>` es el nombre de un fichero. Para escribir en el error estándar, `>&2`."
    - id: b
      value: Escribe `Error` en el error estándar
      incorrectExplanation: "Eso es `>&2`. Sin `&`, `2` es el nombre de un fichero."
    - id: c
      value: Da un error de sintaxis
      incorrectExplanation: "`>2` es una redirección válida a un fichero llamado `2`."
    - id: d
      value: Descarta el texto
      incorrectExplanation: "Para descartarlo haría falta `> /dev/null`. Aquí el texto acaba en un fichero llamado `2`."
```
