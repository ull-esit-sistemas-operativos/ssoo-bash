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
      incorrectExplanation: "`SIGINT` es la que envía Ctrl+C; `kill` sin opciones envía `SIGTERM`."

- id: pipe-subshell
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime el último `echo`?

    ```bash
    n=0
    printf 'a\nb\nc\n' | while read -r l; do n=$(( n + 1 )); done
    echo $n
    ```
  options:
    - id: a
      value: "`0`"
      isCorrect: true
      explanation: El `while` se ejecuta en un proceso aparte por estar al final de la tubería, así que sus cambios a `n` se pierden.
    - id: b
      value: "`3`"
      incorrectExplanation: El bucle da tres vueltas, pero en un proceso aparte por estar al final de la tubería; sus cambios a `n` se pierden.
    - id: c
      value: "`1`"
      incorrectExplanation: El `while` se ejecuta en un proceso aparte, así que el `n` del *script* no cambia nunca.
    - id: d
      value: Una línea vacía
      incorrectExplanation: "`n` sigue existiendo con el valor que se le asignó antes del bucle."

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

- id: case-sensitive
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime este `case`?

    ```bash
    f=informe.PDF
    case $f in
        *.pdf) echo documento ;;
        *)     echo otro ;;
    esac
    ```
  options:
    - id: a
      value: "`otro`"
      isCorrect: true
      explanation: Los patrones de `case` distinguen mayúsculas, y `*.pdf` no encaja con `.PDF`.
    - id: b
      value: "`documento`"
      incorrectExplanation: Los patrones de `case` distinguen mayúsculas, y `*.pdf` no encaja con `.PDF`.
    - id: c
      value: "`documento` y después `otro`"
      incorrectExplanation: "`case` ejecuta solo la primera rama que encaja; `;;` termina el `case`."
    - id: d
      value: Nada
      incorrectExplanation: "`*` encaja con cualquier valor, así que la última rama se ejecuta cuando no encaja ninguna anterior."
```
