Los PID cambian en cada ejecución, así que las soluciones usan una variable `pid`.

## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprimen `kill -l 9` y `kill -l TERM`?
  options:
    - id: a
      value: "`KILL` y `15`"
      isCorrect: true
      explanation: Con un número, `kill -l` da el nombre, y con un nombre, el número.
    - id: b
      value: "`9` y `TERM`"
      incorrectExplanation: Con un número, `kill -l` da el nombre, y con un nombre, el número.
    - id: c
      value: "`SIGKILL` y `15`"
      incorrectExplanation: "`kill -l` escribe el nombre sin el prefijo `SIG`."
    - id: d
      value: Nada, porque envían las señales
      incorrectExplanation: "Con `-l`, `kill` no envía señales: traduce entre número y nombre."
```

## Reto 2 · Prueba

Lanza `sleep 120 &`, detén el proceso sin terminarlo, comprueba su estado con `ps` y vuelve a ponerlo en marcha.

::: details Solución

```bash
sleep 120 &
pid=$!
kill -STOP "$pid"
ps -o stat= -p "$pid"
kill -CONT "$pid"
ps -o stat= -p "$pid"
```

El estado pasa de `T` (detenido) a `S` (dormido).
`$!` es el PID del último proceso lanzado en segundo plano.

:::

## Reto 3 · Combina

Pide a un proceso que termine y, si sigue vivo cinco segundos después, fúerzalo.

::: details Solución

```bash
kill "$pid"
sleep 5
kill -0 "$pid" 2>/dev/null && kill -KILL "$pid"
```

`kill -0` no envía nada: solo comprueba si el proceso sigue existiendo.

:::
