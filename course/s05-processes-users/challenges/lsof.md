La salida de estos retos depende de la máquina, así que las soluciones dan la orden y no el resultado.

## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: |
    ¿Cuál de estas dos órdenes muestra más líneas?

    ```bash
    lsof -u alu -c bash
    lsof -a -u alu -c bash
    ```
  options:
    - id: a
      value: La primera, porque sin `-a` las condiciones se suman
      isCorrect: true
      explanation: "`lsof` suma las condiciones con «o»: lista lo de los procesos de `alu` más lo de cualquier `bash`. Con `-a` exige las dos, y solo quedan los `bash` de `alu`."
    - id: b
      value: La segunda, porque `-a` añade lo de todos los procesos
      incorrectExplanation: "`-a` exige las dos condiciones a la vez, así que solo quedan los `bash` de `alu`."
    - id: c
      value: Las dos muestran lo mismo
      incorrectExplanation: "Sin `-a`, `lsof` suma las condiciones con «o»: lo de los procesos de `alu` más lo de cualquier `bash`."
    - id: d
      value: La primera, porque sin `-a` se ignora `-c bash`
      incorrectExplanation: Sin `-a` cuentan las dos opciones, pero se suman con «o» en lugar de exigirse a la vez.
```

## Reto 2 · Prueba

Abre `notas.csv` en la *shell* con `exec 3< notas.csv` y muestra solo los PID de los procesos que lo tienen abierto.

::: details Solución

```bash
exec 3< notas.csv
lsof -t notas.csv
```

Sale el PID de la *shell* y el de los procesos que hayan heredado el descriptor 3.

:::

## Reto 3 · Combina

Muestra cuántos ficheros tiene abiertos cada uno de tus procesos, del que más tiene al que menos, sin los avisos de permisos.

::: details Solución

```bash
lsof -u "$USER" 2>/dev/null | awk 'NR > 1 { print $2 }' | sort | uniq -c | sort -rn
```

`NR > 1` salta la cabecera, y el campo 2 es el PID.

:::
