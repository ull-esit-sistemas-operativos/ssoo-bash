## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `printf '%s\n' 10 9 100 | sort`?
  options:
    - id: a
      value: "`10`, `100` y `9`"
      isCorrect: true
      explanation: Sin `-n` compara como texto, carácter a carácter, y `1` va antes que `9`.
    - id: b
      value: "`9`, `10` y `100`"
      incorrectExplanation: Ese es el orden numérico, el de `sort -n`; sin `-n` compara como texto, carácter a carácter.
    - id: c
      value: "`100`, `10` y `9`"
      incorrectExplanation: Comparando como texto, `10` es un prefijo de `100` y va antes.
    - id: d
      value: "`10`, `9` y `100`, en el mismo orden"
      incorrectExplanation: "`sort` ordena las líneas; sin opciones compara como texto, y `1` va antes que `9`."
```

## Reto 2 · Predice

```quiz
- id: "2"
  type: choice
  scrambleOrder: true
  content: En un equipo configurado en español, ¿qué imprime `printf '%s\n' 7.5 10 6.25 9 | sort -n`?
  options:
    - id: a
      value: "`9`, `10`, `7.5` y `6.25`"
      isCorrect: true
      explanation: "Con el *locale* en español, la coma es el separador decimal y el punto, el de miles: `7.5` vale 75 y `6.25` vale 625. Con `LC_ALL=C sort -n` sale `6.25`, `7.5`, `9`, `10`."
    - id: b
      value: "`6.25`, `7.5`, `9` y `10`"
      incorrectExplanation: "Eso sale con `LC_ALL=C sort -n`. En español, el punto es el separador de miles: `7.5` vale 75 y `6.25` vale 625."
    - id: c
      value: "`10`, `6.25`, `7.5` y `9`"
      incorrectExplanation: Ese es el orden como texto, el de `sort` sin `-n`; con `-n` compara números, pero en español el punto es el separador de miles.
    - id: d
      value: "`6.25`, `7.5`, `10` y `9`"
      incorrectExplanation: "En español, el punto es el separador de miles: `7.5` vale 75 y `6.25` vale 625, más que `9` y `10`."
```

## Reto 3 · Prueba

Ordena `f10`, `f2` y `f1` de forma que `f2` vaya antes que `f10`.

::: details Solución

```bash
printf '%s\n' f10 f2 f1 | sort -V
```

```text
f1
f2
f10
```

:::

## Reto 4 · Prueba

Ordena las notas, sin la cabecera, por alumno y, para un mismo alumno, de la nota más baja a la más alta.

::: details Solución

```bash
tail -n +2 notas.csv | LC_ALL=C sort -t, -k1,1 -k3,3n
```

```text
ana,FP,6
ana,SSOO,7.5
luis,FP,
luis,SSOO,4.5
marta,FP,8.5
marta,SSOO,9
pablo,SSOO,
```

`LC_ALL=C` hace falta por los decimales con punto.
La nota vacía de `luis` va primero: como número vale 0.

:::

## Reto 5 · Combina

```quiz
- id: "5"
  type: string
  content: |
    Muestra la línea con la nota más baja, sin contar las notas vacías.
    Escribe esa línea.
  options:
    - id: a
      value: "luis,SSOO,4.5"
```

::: details Solución

```bash
tail -n +2 notas.csv | grep -v ',$' | LC_ALL=C sort -t, -k3,3n | head -n 1
```

```text
luis,SSOO,4.5
```

`grep -v ',$'` quita las líneas que acaban en coma, las que no tienen nota.
Sin él saldría `luis,FP,`, porque una nota vacía cuenta como 0.

:::
