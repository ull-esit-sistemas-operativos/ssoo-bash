Intenta responder sin ejecutar nada; después compruébalo en la terminal.

```quiz
- id: globs
  type: choice
  scrambleOrder: true
  content: En un directorio con `a.txt`, `b.txt` y `c.log`, ¿qué imprime `echo ?.txt [bc]*`?
  options:
    - id: a
      value: "`a.txt b.txt b.txt c.log`"
      isCorrect: true
      explanation: "Cada patrón se expande por separado: `?.txt` da `a.txt b.txt` y `[bc]*` da `b.txt c.log`, así que `b.txt` aparece dos veces."
    - id: b
      value: "`a.txt b.txt c.log`"
      incorrectExplanation: Cada patrón se expande por separado, y `b.txt` encaja con los dos.
    - id: c
      value: "`?.txt [bc]*`"
      incorrectExplanation: La *shell* expande los patrones antes de ejecutar `echo`; solo los dejaría tal cual si no encajaran con ningún fichero.
    - id: d
      value: "`a.txt b.txt`"
      incorrectExplanation: "`[bc]*` encaja con cualquier nombre que empiece por `b` o `c`, sea cual sea su extensión."

- id: chmod-640
  type: choice
  scrambleOrder: true
  content: Después de `chmod 640 notas.csv`, ¿cómo aparecen los permisos de `notas.csv` en `ls -l`?
  options:
    - id: a
      value: "`-rw-r-----`"
      isCorrect: true
      explanation: 6 = `rw-` para el propietario, 4 = `r--` para el grupo y 0 = `---` para el resto.
    - id: b
      value: "`-rw-r--r--`"
      incorrectExplanation: Esos son los permisos `644`; el 0 final quita todos los permisos al resto.
    - id: c
      value: "`-r--rw----`"
      incorrectExplanation: "Cada cifra es la suma de r = 4, w = 2 y x = 1: 6 es `rw-` y 4 es `r--`."
    - id: d
      value: "`-rwxr-----`"
      incorrectExplanation: El 6 es 4 + 2, lectura y escritura; con ejecución sería 7.

- id: umask
  type: choice
  scrambleOrder: true
  content: |
    Ejecutas `umask 077` y después `touch secreto`.
    ¿Con qué permisos nace `secreto`?
  options:
    - id: a
      value: "`-rw-------`"
      isCorrect: true
      explanation: "Es decir, `600`: a los `666` que pide `touch` se les quitan todos los permisos de grupo y otros."
    - id: b
      value: "`-rwx------`"
      incorrectExplanation: "`touch` pide `666`, sin ejecución, y la máscara solo quita permisos; nunca los añade."
    - id: c
      value: "`----rwxrwx`"
      incorrectExplanation: La máscara indica los permisos que se quitan, no los que se dan.
    - id: d
      value: "`-rw-r--r--`"
      incorrectExplanation: Ese es el resultado con la máscara habitual, `022`; `077` quita también la lectura al grupo y a los otros.

- id: unquoted-var
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué ficheros nuevos aparecen en el directorio después de estas dos líneas?

    ```bash
    nombre="mi fichero.txt"
    touch $nombre
    ```
  options:
    - id: a
      value: Dos, `mi` y `fichero.txt`
      isCorrect: true
      explanation: "Sin comillas, el valor de `$nombre` se parte por el espacio. Con `touch \"$nombre\"` se crearía uno solo."
    - id: b
      value: Uno, `mi fichero.txt`
      incorrectExplanation: "Sin comillas, el valor de `$nombre` se parte por el espacio; haría falta `touch \"$nombre\"`."
    - id: c
      value: Uno, `$nombre`
      incorrectExplanation: La *shell* expande la variable antes de ejecutar `touch`.
    - id: d
      value: Ninguno, porque `touch` da un error por el espacio
      incorrectExplanation: "`touch` recibe dos argumentos y crea un fichero por cada uno."

- id: braces
  type: choice
  scrambleOrder: true
  content: |
    Con `base=informe`, ¿qué ficheros crea esta orden?

    ```bash
    touch "$base_v2.txt" "${base}_v2.txt"
    ```
  options:
    - id: a
      value: "`.txt` e `informe_v2.txt`"
      isCorrect: true
      explanation: "En el primer nombre, bash busca una variable llamada `base_v2`, que no existe y vale la cadena vacía, así que queda `.txt`: un fichero oculto. Las llaves del segundo separan `base` de `_v2`."
    - id: b
      value: Solo `informe_v2.txt`, porque los dos nombres son iguales
      incorrectExplanation: "`_` puede formar parte de un nombre de variable, así que en el primero bash busca `base_v2`."
    - id: c
      value: "`informe.txt` e `informe_v2.txt`"
      incorrectExplanation: bash no se detiene en `_`; busca una variable llamada `base_v2`.
    - id: d
      value: Ninguno, porque `base_v2` no existe
      incorrectExplanation: Una variable sin definir vale la cadena vacía; sin `set -u` no hay error.
```
