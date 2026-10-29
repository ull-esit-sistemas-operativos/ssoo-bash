Unas preguntas para repasar cómo funciona el curso.

```quiz
- id: locked
  type: choice
  scrambleOrder: true
  content: Los «Retos de grep» aparecen en el árbol con un candado. ¿Qué significa?
  options:
    - id: a
      value: Dependen de la «Ficha de grep», que aún no has completado; puedes abrirlos igualmente
      isCorrect: true
      explanation: El candado avisa de lo que conviene hacer antes, pero no impide abrir la sección.
    - id: b
      value: No se pueden abrir hasta que completes la ficha
      incorrectExplanation: La sección se abre igualmente; empieza con un aviso «Antes de empezar» que enlaza a la ficha.
    - id: c
      value: Son de una semana que aún no ha empezado
      incorrectExplanation: Todas las semanas están disponibles desde el principio; el candado solo indica una dependencia.

- id: broken-data
  type: choice
  scrambleOrder: true
  content: Has estropeado `notas.csv` mientras probabas un reto de la semana 1. ¿Cómo lo recuperas?
  options:
    - id: a
      value: Lo borras y vuelves a abrir una sección de la semana
      isCorrect: true
      explanation: Al abrir una sección se copian los datos que falten, sin sobrescribir los que ya tienes.
    - id: b
      value: Vuelves a abrir la sección, sin borrarlo
      incorrectExplanation: Lo que ya está en tu directorio nunca se sobrescribe, así que el fichero estropeado se queda como está.
    - id: c
      value: No se puede; hay que volver a clonar el repositorio
      incorrectExplanation: Los datos se copian desde el curso cada vez que faltan.

- id: script-done
  type: choice
  scrambleOrder: true
  content: ¿Cuándo se completa un ejercicio de *script*?
  options:
    - id: a
      value: Cuando supera *shellcheck* y todas las pruebas
      isCorrect: true
      explanation: Se completa al pasar todas las comprobaciones, con *Comprobar ejercicio* o con `check`.
    - id: b
      value: Al pulsar *Marcar como completado*
      incorrectExplanation: Ese botón es de las prácticas en terminal, que no se comprueban solas.
    - id: c
      value: Cuando el *script* se ejecuta sin errores en la terminal
      incorrectExplanation: Que no dé errores no basta; las pruebas comprueban también lo que muestra y su estado de salida.

- id: fresh-copy
  type: choice
  scrambleOrder: true
  content: Tu *script* borra un fichero de datos y, al ejecutarlo varias veces en la terminal, ya no funciona. ¿Afecta a la comprobación?
  options:
    - id: a
      value: No, las pruebas se ejecutan sobre una copia nueva de los datos
      isCorrect: true
      explanation: "`check` copia los datos en un directorio temporal antes de cada comprobación."
    - id: b
      value: Sí, las pruebas usan los ficheros de tu directorio
      incorrectExplanation: Las pruebas no tocan tu directorio; trabajan en una copia nueva.
```
