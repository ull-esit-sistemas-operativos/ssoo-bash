## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `[[ 10 < 9 ]] && echo sí || echo no`?
  options:
    - id: a
      value: "`sí`"
      isCorrect: true
      explanation: "`<` compara cadenas, y `10` va antes que `9` alfabéticamente. Para comparar números, `-lt`."
    - id: b
      value: "`no`"
      incorrectExplanation: "`<` compara cadenas, no números, y `10` va antes que `9` alfabéticamente. Para comparar números, `-lt`."
    - id: c
      value: Un error, porque `<` es una redirección
      incorrectExplanation: Dentro de `[[ ]]`, `<` compara cadenas; no es una redirección.
    - id: d
      value: "`sí` y después `no`"
      incorrectExplanation: "`||` solo ejecuta lo que sigue si falla lo anterior, y `echo sí` no falla."
```

## Reto 2 · Predice

```quiz
- id: "2"
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime esto?

    ```bash
    v=""
    [ $v = x ]
    echo $?
    ```
  options:
    - id: a
      value: Un error y después `2`
      isCorrect: true
      explanation: "El error es `[: =: unary operator expected` (en un equipo en español, el mensaje sale traducido). Sin comillas, la variable vacía desaparece y `[` recibe `= x`. Con `[ \"$v\" = x ]` imprimiría `1`."
    - id: b
      value: "`1`"
      incorrectExplanation: Eso imprimiría `[ "$v" = x ]`. Sin comillas, la variable vacía desaparece, `[` recibe `= x` y da un error.
    - id: c
      value: "`0`"
      incorrectExplanation: Sin comillas, la variable vacía desaparece y `[` recibe `= x`, que es un error.
    - id: d
      value: Un error y después `1`
      incorrectExplanation: "`[` termina con estado 2 cuando la expresión es incorrecta; 1 es para una comparación falsa."
```

## Reto 3 · Prueba

```quiz
- id: "3"
  type: string
  content: |
    Escribe una condición que sea verdadera solo si `proyecto/README.md` existe y no está vacío.
    ¿Se cumple?
  options:
    - id: a
      value: "no"
```

::: details Solución

```bash
[[ -s proyecto/README.md ]] && echo "tiene datos" || echo "vacío o no existe"
```

No se cumple: `README.md` existe, pero está vacío.

:::

## Reto 4 · Prueba

```quiz
- id: "4"
  type: string
  content: |
    Comprueba con una sola condición si `proyecto/src/main.c` es más reciente que `proyecto/README.md`.
    ¿Lo es?
  options:
    - id: a
      value: "sí"
    - id: b
      value: "si"
```

::: details Solución

```bash
[[ proyecto/src/main.c -nt proyecto/README.md ]] && echo sí || echo no
```

`sí`: `main.c` es del 3 de octubre y `README.md`, del 2.

:::

## Reto 5 · Combina

Para cada valor de la lista `42`, `4.2`, `-3` y la cadena vacía, imprime si es un número entero sin signo.

::: details Solución

```bash
re='^[0-9]+$'
for v in 42 4.2 -3 ''; do
    [[ $v =~ $re ]] && echo "[$v] sí" || echo "[$v] no"
done
```

```text
[42] sí
[4.2] no
[-3] no
[] no
```

:::

## Reto 6 · Combina

Recorre `proyecto/*` e imprime solo las entradas que son directorios.

::: details Solución

```bash
for f in proyecto/*; do
    [[ -d $f ]] && echo "$f"
done
```

```text
proyecto/docs
proyecto/src
```

:::
