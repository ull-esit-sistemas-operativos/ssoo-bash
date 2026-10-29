Intenta responder sin ejecutar nada; después compruébalo en la terminal.

```quiz
- id: cd-dotdot
  type: choice
  scrambleOrder: true
  content: |
    Estás en `/home/alu/ssoo/practicas`.
    ¿Qué imprime `pwd` después de ejecutar `cd ../../ssoo/datos`?
  options:
    - id: a
      value: "`/home/alu/ssoo/datos`"
      isCorrect: true
      explanation: Los dos `..` suben primero a `ssoo` y después a `/home/alu`; desde ahí, `ssoo/datos` baja de nuevo.
    - id: b
      value: "`/home/alu/ssoo/ssoo/datos`"
      incorrectExplanation: Cada `..` sube un nivel, y aquí hay dos.
    - id: c
      value: "`/ssoo/datos`"
      incorrectExplanation: La ruta no empieza por `/`, así que es relativa al directorio de trabajo, no a la raíz.
    - id: d
      value: Un error, porque `ssoo` no está dentro de `/home/alu/ssoo/practicas`
      incorrectExplanation: La *shell* resuelve la ruta paso a paso; tras los dos `..`, `ssoo` sí existe.

- id: ls-hidden
  type: choice
  scrambleOrder: true
  content: |
    Un directorio contiene dos ficheros, `a.txt` y `.oculto`.
    ¿Cuántos nombres muestran `ls` y `ls -a`?
  options:
    - id: a
      value: "`ls` muestra 1 y `ls -a` muestra 4"
      isCorrect: true
      explanation: "`ls` muestra `a.txt`; `ls -a` muestra además `.oculto`, `.` y `..`."
    - id: b
      value: "`ls` muestra 1 y `ls -a` muestra 2"
      incorrectExplanation: "`-a` también muestra `.` y `..`, que existen en todos los directorios."
    - id: c
      value: "`ls` muestra 2 y `ls -a` muestra 4"
      incorrectExplanation: "`ls` oculta los nombres que empiezan por `.`."
    - id: d
      value: Los dos muestran 2
      incorrectExplanation: "`ls` oculta los nombres que empiezan por `.`, y `-a` los muestra todos, incluidos `.` y `..`."

- id: run-script
  type: choice
  scrambleOrder: true
  content: |
    Has creado `hola.sh` en el directorio de trabajo, con su *shebang*, pero no has ejecutado `chmod +x`.
    ¿Qué ocurre al escribir `hola.sh` y al escribir `./hola.sh`?
  options:
    - id: a
      value: "`hola.sh` no se encuentra y `./hola.sh` da «Permiso denegado»"
      isCorrect: true
      explanation: El directorio de trabajo no está en PATH, así que `hola.sh` no se encuentra; `./hola.sh` sí encuentra el fichero, pero no tiene permiso de ejecución.
    - id: b
      value: Los dos ejecutan el *script*
      incorrectExplanation: Sin `chmod +x` el fichero no tiene permiso de ejecución, y el *shebang* no lo sustituye.
    - id: c
      value: "`hola.sh` no se encuentra y `./hola.sh` ejecuta el *script*"
      incorrectExplanation: "`./` resuelve dónde está el fichero, pero sigue faltando el permiso de ejecución."
    - id: d
      value: Los dos dan «Permiso denegado»
      incorrectExplanation: Sin `./`, la *shell* busca `hola.sh` en PATH y no llega a encontrarlo.

- id: tilde
  type: choice
  scrambleOrder: true
  content: |
    El usuario `alu` ejecuta estas tres órdenes.
    ¿Qué imprimen los dos `echo`?

    ```bash
    echo ~
    cd /tmp
    echo ~
    ```
  options:
    - id: a
      value: "`/home/alu` las dos veces"
      isCorrect: true
      explanation: "`~` es siempre el directorio personal, no el de trabajo; el directorio de trabajo es `.`."
    - id: b
      value: "`/home/alu` y después `/tmp`"
      incorrectExplanation: "`cd` cambia el directorio de trabajo, pero `~` es el directorio personal."
    - id: c
      value: "`~` las dos veces"
      incorrectExplanation: La *shell* expande `~` antes de ejecutar `echo`.
    - id: d
      value: "El directorio de trabajo inicial y después `/tmp`"
      incorrectExplanation: Ese sería `pwd`; `~` no depende del directorio de trabajo.
```
