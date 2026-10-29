La salida de estos retos depende de la máquina, así que las soluciones dan la orden y no el resultado.

## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: |
    ¿Cuántos PID muestra `ps -e -o pid | head -n 3`?
    ¿Y `ps -e -o pid= | head -n 3`?
  options:
    - id: a
      value: Dos y tres
      isCorrect: true
      explanation: La primera orden imprime la cabecera `PID` como primera línea, y `head -n 3` se la cuenta. Con `pid=` la columna no tiene título.
    - id: b
      value: Tres y tres
      incorrectExplanation: La primera orden imprime la cabecera `PID` como primera línea, y `head -n 3` se la cuenta.
    - id: c
      value: Tres y dos
      incorrectExplanation: "Es al revés: `pid=` quita el título de la columna, así que la segunda orden muestra tres PID."
    - id: d
      value: Dos y dos
      incorrectExplanation: Con `pid=` la columna no tiene título, así que las tres líneas son PID.
```

## Reto 2 · Prueba

Muestra los tres procesos que más CPU usan, con su PID, su porcentaje de CPU y su nombre.

::: details Solución

```bash
ps -eo pid,pcpu,comm --sort=-pcpu | head -n 4
```

`head -n 4` porque la primera línea es la cabecera.

:::

## Reto 3 · Prueba

Lanza `sleep 120 &` y muestra el PID de los procesos `sleep` y cuántos segundos llevan en marcha, sin cabecera.

::: details Solución

```bash
ps -C sleep -o pid=,etimes=
```

`-C` elige los procesos por nombre y `etimes` da el tiempo en segundos; `etime` lo daría como `mm:ss`.

:::

## Reto 4 · Combina

Muestra cuántos procesos tiene cada usuario, del que más tiene al que menos.

::: details Solución

```bash
ps -eo user= | sort | uniq -c | sort -rn
```

:::
