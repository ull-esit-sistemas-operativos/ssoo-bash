Los retos suponen un usuario `alu` con UID 1001, grupo principal `alu` y grupo secundario `alumnos`.

## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `id -Gn alu | wc -w`?
  options:
    - id: a
      value: "`2`"
      isCorrect: true
      explanation: "Son `alu` y `alumnos`: `id -Gn` incluye también el grupo principal."
    - id: b
      value: "`1`"
      incorrectExplanation: "`id -Gn` incluye también el grupo principal, `alu`, además de `alumnos`."
    - id: c
      value: "`alu alumnos`"
      incorrectExplanation: "`wc -w` imprime cuántas palabras hay, no las palabras."
    - id: d
      value: Un error, porque `id` solo muestra los datos de quien lo ejecuta
      incorrectExplanation: "`id` admite el nombre de un usuario y muestra sus datos."
```

## Reto 2 · Prueba

Muestra solo el UID del usuario actual y, con otra orden, solo su nombre.

::: details Solución

```bash
id -u
id -un
```

```text
1001
alu
```

`whoami` da lo mismo que `id -un`.

:::

## Reto 3 · Combina

Escribe la línea que, al principio de un *script*, lo termina con un mensaje de error si no se está ejecutando como `root`.

::: details Solución

```bash
[[ $(id -u) -eq 0 ]] || { echo "hay que ejecutarlo como root" >&2; exit 1; }
```

Se compara el UID y no el nombre, porque lo que da los privilegios es el UID 0.

:::
