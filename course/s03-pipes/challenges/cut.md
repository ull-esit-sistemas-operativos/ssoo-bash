## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `cut -d, -f2 notas.csv | sort -u`?
  options:
    - id: a
      value: "`asignatura`, `FP` y `SSOO`"
      isCorrect: true
      explanation: La cabecera también es una línea, así que su segundo campo aparece. En español, `sort` no separa mayúsculas y minúsculas, y `asignatura` va primero.
    - id: b
      value: "`FP` y `SSOO`"
      incorrectExplanation: La cabecera también es una línea, así que su segundo campo, `asignatura`, aparece.
    - id: c
      value: "`FP`, `SSOO` y `asignatura`"
      incorrectExplanation: En español, `sort` no separa mayúsculas y minúsculas, y `asignatura` va primero; ese orden sale con `LC_ALL=C`.
    - id: d
      value: La asignatura de cada línea, con repeticiones
      incorrectExplanation: "`sort -u` quita las líneas repetidas."
```

## Reto 2 · Prueba

Muestra las tres primeras letras del nombre de cada alumno, sin la cabecera.

::: details Solución

```bash
tail -n +2 notas.csv | cut -c1-3
```

```text
ana
ana
lui
lui
mar
mar
pab
```

:::

## Reto 3 · Prueba

Muestra `notas.csv` sin la columna de la asignatura, sin nombrar las columnas que quieres conservar.

::: details Solución

```bash
cut -d, --complement -f2 notas.csv
```

```text
alumno,nota
ana,7.5
ana,6
luis,4.5
luis,
marta,9
marta,8.5
pablo,
```

:::

## Reto 4 · Combina

¿En cuántas líneas aparece cada alumno?

::: details Solución

```bash
tail -n +2 notas.csv | cut -d, -f1 | sort | uniq -c
```

```text
      2 ana
      2 luis
      2 marta
      1 pablo
```

:::
