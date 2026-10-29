Intenta responder sin ejecutar nada; después compruébalo en la terminal.

```quiz
- id: stdout-only
  type: choice
  scrambleOrder: true
  content: |
    Ejecutas `ls /etc /noexiste > salida.txt`.
    ¿Qué aparece en la pantalla y qué queda en `salida.txt`?
  options:
    - id: a
      value: En la pantalla, el error sobre `/noexiste`; en `salida.txt`, el listado de `/etc`
      isCorrect: true
      explanation: Solo se redirigió la salida estándar; los errores van por el error estándar, que sigue en la pantalla.
    - id: b
      value: En la pantalla, nada; en `salida.txt`, el listado y el error
      incorrectExplanation: "`>` solo redirige la salida estándar; para los dos haría falta `> salida.txt 2>&1`."
    - id: c
      value: En la pantalla, nada; en `salida.txt`, el listado, y el error se pierde
      incorrectExplanation: El error estándar no se ha redirigido, así que sigue apareciendo en la pantalla.
    - id: d
      value: En la pantalla, el error; `salida.txt` queda vacío porque la orden falló
      incorrectExplanation: "`ls` lista `/etc` aunque falle con `/noexiste`; el fallo solo se ve en el mensaje y en el estado de salida."

- id: uniq-sorted
  type: choice
  scrambleOrder: true
  content: |
    El fichero `letras.txt` tiene cuatro líneas: `b`, `a`, `b` y `a`.
    ¿Qué imprimen `uniq -c letras.txt` y `sort letras.txt | uniq -c`?
  options:
    - id: a
      value: Primero cuatro líneas con un 1; después `2 a` y `2 b`
      isCorrect: true
      explanation: Sin ordenar no hay dos líneas iguales seguidas, así que cada una cuenta 1; ordenando antes, las iguales quedan juntas.
    - id: b
      value: "`2 a` y `2 b` las dos veces"
      incorrectExplanation: "`uniq` solo junta líneas iguales seguidas; por eso se ordena antes."
    - id: c
      value: Primero `2 b` y `2 a`; después `2 a` y `2 b`
      incorrectExplanation: Sin ordenar no hay dos líneas iguales seguidas, así que cada una cuenta 1.
    - id: d
      value: Cuatro líneas con un 1 las dos veces
      incorrectExplanation: Tras `sort`, las líneas iguales quedan juntas y `uniq -c` las cuenta.

- id: integer-division
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `echo $(( 7 / 2 * 2 ))`?
  options:
    - id: a
      value: "`6`"
      isCorrect: true
      explanation: La división entera da 3, y 3 por 2 es 6.
    - id: b
      value: "`7`"
      incorrectExplanation: "La aritmética de bash es entera: `7 / 2` da 3, no 3,5."
    - id: c
      value: "`1`"
      incorrectExplanation: "`/` y `*` tienen la misma prioridad y se evalúan de izquierda a derecha: `(7 / 2) * 2`."
    - id: d
      value: Un error, porque 7 no es divisible entre 2
      incorrectExplanation: bash descarta los decimales de la división sin avisar.

- id: top-path
  type: choice
  scrambleOrder: true
  content: Con el *log* de ejemplo de esta lectura, ¿qué imprime `cut -d' ' -f7 acceso.log | sort | uniq -c | sort -nr | head -n 1`?
  options:
    - id: a
      value: "`2 /index.html`, con el número alineado a la derecha"
      isCorrect: true
      explanation: Es la única ruta que aparece dos veces.
    - id: b
      value: "`/index.html`"
      incorrectExplanation: "`uniq -c` antepone a cada línea el número de veces que aparece."
    - id: c
      value: Una línea por cada ruta, empezando por `2 /index.html`
      incorrectExplanation: "`head -n 1` deja solo la primera línea."
    - id: d
      value: La ruta menos frecuente, con un 1 delante
      incorrectExplanation: "`-r` invierte el orden: los números mayores quedan arriba."
```
