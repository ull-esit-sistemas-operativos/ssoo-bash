## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `echo 'a b c' | awk '{ print NF, $NF }'`?
  options:
    - id: a
      value: "`3 c`"
      isCorrect: true
      explanation: "`NF` es el número de campos y `$NF`, el último."
    - id: b
      value: "`3 3`"
      incorrectExplanation: "`$NF` es el campo número `NF`, es decir, el último, y no el valor de `NF`."
    - id: c
      value: "`3c`"
      incorrectExplanation: La coma de `print` separa los valores con un espacio.
    - id: d
      value: "`c 3`"
      incorrectExplanation: "`print` escribe los valores en el orden en que se le dan: primero `NF` y después `$NF`."
```

## Reto 2 · Predice

```quiz
- id: "2"
  type: choice
  scrambleOrder: true
  content: En un equipo configurado en español, con el `awk` de Ubuntu (`mawk`), ¿qué imprime `awk 'BEGIN { print 7.5 + 1 }'`?
  options:
    - id: a
      value: "`8,5`"
      isCorrect: true
      explanation: El `7.5` del programa es código y se lee con punto, pero `mawk` escribe el resultado con la coma del *locale*.
    - id: b
      value: "`8.5`"
      incorrectExplanation: "`mawk` escribe el resultado con la coma del *locale*; `8.5` saldría con `LC_ALL=C`."
    - id: c
      value: "`8`"
      incorrectExplanation: El `7.5` del programa es código y se lee siempre con punto; solo los datos siguen el *locale*.
    - id: d
      value: Un error, porque en español los decimales llevan coma
      incorrectExplanation: El programa es código y se lee siempre con punto, aunque el resultado salga con coma.
```

## Reto 3 · Predice

```quiz
- id: "3"
  type: choice
  scrambleOrder: true
  content: |
    En el mismo equipo, ¿qué imprime esto?

    ```bash
    awk -F, 'NR > 1 { print $3 }' notas.csv | awk '{ s += $1 } END { print s }'
    ```
  options:
    - id: a
      value: "`34`"
      isCorrect: true
      explanation: "El segundo `awk` lee las notas como datos con la coma del *locale*: `7.5` vale 7 y `4.5` vale 4. Las vacías valen 0. Con `LC_ALL=C` delante de los dos `awk`, o con los datos convertidos a coma, sale `35.5`."
    - id: b
      value: "`35.5`"
      incorrectExplanation: El segundo `awk` lee las notas como datos con la coma del *locale*, así que `7.5` vale 7 y `4.5` vale 4.
    - id: c
      value: "`35,5`"
      incorrectExplanation: "Con el *locale* en español, `awk` lee los datos hasta el punto: `7.5` vale 7 y `4.5` vale 4, y los decimales se pierden."
    - id: d
      value: "`15`"
      incorrectExplanation: "`awk` no se salta las notas con punto: lee su parte entera, así que `7.5` vale 7 y `4.5` vale 4."
```

## Reto 4 · Prueba

Muestra las líneas de `notas.csv` del alumno cuyo nombre está en la variable de la *shell* `u=ana`, sin escribir el nombre dentro del programa.

::: details Solución

```bash
u=ana
awk -F, -v u="$u" '$1 == u' notas.csv
```

```text
ana,SSOO,7.5
ana,FP,6
```

:::

## Reto 5 · Prueba

Muestra la IP y los bytes de las peticiones del *log* que sirvieron más de 1000 bytes (los bytes son el campo 10).

::: details Solución

```bash
awk '$10 > 1000 { print $1, $10 }' acceso.log
```

```text
192.168.1.10 5120
192.168.1.10 8340
172.16.0.3 5120
```

:::

## Reto 6 · Combina

¿Cuántas peticiones hay de cada código de estado (campo 9)?
Muestra los códigos ordenados.

::: details Solución

```bash
awk '{ c[$9]++ } END { for (k in c) print k, c[k] }' acceso.log | sort
```

```text
200 3
404 3
```

El `sort` hace falta porque `for (k in c)` no recorre las claves en ningún orden fijo.

:::

## Reto 7 · Combina

Muestra la media de cada alumno con dos decimales, de la más alta a la más baja, sin contar las notas vacías.

::: details Solución

```bash
LC_ALL=C awk -F, 'NR > 1 && $3 != "" { s[$1] += $3; n[$1]++ } END { for (a in s) printf "%s %.2f\n", a, s[a] / n[a] }' notas.csv |
    LC_ALL=C sort -k2,2nr
```

```text
marta 8.75
ana 6.75
luis 4.50
```

`pablo` no sale porque no tiene ninguna nota.
Sin `$3 != ""`, la nota vacía de `luis` contaría como 0 y su media bajaría a 2.25.

:::

## Reto 8 · Prueba

Quita las líneas repetidas de `colores.txt` conservando la primera aparición y sin cambiar el orden.

::: details Solución

```bash
awk '!visto[$0]++' colores.txt
```

```text
rojo
verde
```

`visto[$0]++` vale 0 la primera vez que aparece una línea, así que `!` la deja pasar solo esa vez.

:::

## Reto 9 · Combina

```quiz
- id: "9"
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
Los demás ficheros están vacíos.

:::
