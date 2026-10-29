## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `echo hola | tr hola adios`?
  options:
    - id: a
      value: "`adio`"
      isCorrect: true
      explanation: "`tr` cambia carácter a carácter: `h` por `a`, `o` por `d`, `l` por `i` y `a` por `o`. La `s` de `adios` sobra."
    - id: b
      value: "`adios`"
      incorrectExplanation: "`tr` no cambia palabras, sino caracteres: cada uno del primer conjunto por el de la misma posición en el segundo. La `s` de `adios` sobra."
    - id: c
      value: "`hola`"
      incorrectExplanation: "`tr` cambia cada carácter del primer conjunto que aparece en la entrada, y aparecen todos."
    - id: d
      value: Un error, porque los conjuntos tienen distinto tamaño
      incorrectExplanation: Si el segundo conjunto es más largo, `tr` ignora los caracteres que sobran.
```

## Reto 2 · Prueba

De la línea `tel: 922-31-82-00`, quédate solo con los dígitos, sin perder el salto de línea final.

::: details Solución

```bash
echo "tel: 922-31-82-00" | tr -cd '0-9\n'
```

```text
922318200
```

`-c` toma todos los caracteres que no están en el conjunto y `-d` los borra.
El `\n` del conjunto conserva el salto de línea.

:::

## Reto 3 · Prueba

Convierte `notas.csv` a la convención española: coma decimal y punto y coma como separador de campos.

::: details Solución

```bash
tr ',.' ';,' < notas.csv
```

```text
alumno;asignatura;nota
ana;SSOO;7,5
ana;FP;6
luis;SSOO;4,5
luis;FP;
marta;SSOO;9
marta;FP;8,5
pablo;SSOO;
```

:::

## Reto 4 · Combina

Muestra las palabras de `texto.txt` ordenadas por número de apariciones, con su contador.

::: details Solución

```bash
tr -s ' ' '\n' < texto.txt | sort | uniq -c | sort -rn
```

```text
      3 el
      2 y
      2 gato
      1 perro
```

`tr -s` pone cada palabra en su línea aunque haya varios espacios seguidos.

:::
