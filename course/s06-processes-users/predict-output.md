Intenta responder sin ejecutar nada; después compruébalo en la terminal.

```quiz
- id: kill-default
  type: choice
  scrambleOrder: true
  content: |
    Ejecutas `kill 4821` sin opciones.
    ¿Qué señal recibe el proceso y puede ignorarla?
  options:
    - id: a
      value: "`SIGTERM` (15), y sí puede ignorarla"
      isCorrect: true
      explanation: El proceso puede atender o ignorar `SIGTERM`; la que no puede ignorar es `SIGKILL`.
    - id: b
      value: "`SIGKILL` (9), y no puede ignorarla"
      incorrectExplanation: "`kill` sin opciones envía `SIGTERM`; `SIGKILL` hay que pedirla con `-9` o `-KILL`."
    - id: c
      value: "`SIGTERM` (15), y no puede ignorarla"
      incorrectExplanation: El proceso puede atender o ignorar `SIGTERM`; la que no puede ignorar es `SIGKILL`.
    - id: d
      value: "`SIGINT` (2), y sí puede ignorarla"
      incorrectExplanation: "`SIGINT` es la que envía [[Ctrl]]+[[C]]; `kill` sin opciones envía `SIGTERM`."

- id: passwd-field
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime `echo 'alu:x:1000:1000:Alumno ULL:/home/alu:/bin/bash' | cut -d: -f6`?
  options:
    - id: a
      value: "`/home/alu`"
      isCorrect: true
      explanation: El sexto campo es el directorio personal.
    - id: b
      value: "`Alumno ULL`"
      incorrectExplanation: Ese es el quinto campo; los campos se cuentan desde 1.
    - id: c
      value: "`/bin/bash`"
      incorrectExplanation: Ese es el séptimo y último campo, la *shell* del usuario.
    - id: d
      value: "`1000`"
      incorrectExplanation: Los campos tercero y cuarto son el UID y el GID; el sexto es el directorio personal.

- id: wait-status
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime el último `echo`?

    ```bash
    ( exit 3 ) &
    wait $!
    echo $?
    ```
  options:
    - id: a
      value: "`3`"
      isCorrect: true
      explanation: "`wait` espera al proceso de `$!` y termina con su mismo estado de salida."
    - id: b
      value: "`0`"
      incorrectExplanation: "`wait` no termina con 0 porque la espera vaya bien, sino con el estado del proceso al que espera."
    - id: c
      value: El PID del proceso en segundo plano
      incorrectExplanation: "`$!` es el PID, pero `$?` es el estado de salida de la última orden, `wait`."
    - id: d
      value: Nada, porque `wait` se queda esperando para siempre
      incorrectExplanation: El proceso termina enseguida con `exit 3`, y `wait` vuelve en cuanto termina.
```
