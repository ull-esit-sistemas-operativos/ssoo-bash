## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Cuántas líneas escribe `sed -n 's/ 404 / NO /p' acceso.log`?
  options:
    - id: a
      value: "3"
      isCorrect: true
      explanation: Con `-n`, `sed` no escribe cada línea, y la `p` detrás de `s///` escribe solo las que han cambiado, las tres peticiones con código 404.
    - id: b
      value: "6"
      incorrectExplanation: Con `-n`, `sed` no escribe cada línea; solo las que pide la `p`, que son las que han cambiado.
    - id: c
      value: "9"
      incorrectExplanation: Eso escribiría sin `-n`, las seis líneas más otra copia de cada una de las tres que cambian.
    - id: d
      value: "0"
      incorrectExplanation: La `p` detrás de `s///` escribe las líneas que han cambiado, aunque esté `-n`.
```

## Reto 2 · Predice

```quiz
- id: "2"
  type: choice
  scrambleOrder: true
  content: ¿Qué escribe `echo 'abc abc' | sed 's/b/[&]/'`?
  options:
    - id: a
      value: "`a[b]c abc`"
      isCorrect: true
      explanation: En el texto de sustitución, `&` es lo que ha encajado, la `b`, y sin `g` solo se cambia la primera.
    - id: b
      value: "`a[b]c a[b]c`"
      incorrectExplanation: Sin `g`, `s///` solo cambia lo primero que encaja en cada línea.
    - id: c
      value: "`a[&]c abc`"
      incorrectExplanation: En el texto de sustitución, `&` no es un carácter normal, sino lo que ha encajado con el patrón.
    - id: d
      value: "`[abc] abc`"
      incorrectExplanation: El patrón es solo `b`, así que `&` vale `b`, no la palabra entera.
```

## Reto 3 · Prueba

Escribe la última línea de `acceso.log` con una sola orden de `sed`.

::: details Solución

```bash
sed -n '$p' acceso.log
```

En una dirección, `$` es la última línea, y las comillas simples evitan que la *shell* la tome por una variable.
Sin `-n`, `sed` escribiría todas las líneas y, además, otra vez la última.
Con `tail` es más corto: `tail -n 1 acceso.log`.

:::

## Reto 4 · Combina

```quiz
- id: "4"
  type: string
  content: |
    Escribe, sin repetir, las IP que han recibido algún 404, usando grupos de `sed`.
    ¿Cuántas IP distintas salen?
  options:
    - id: a
      value: "2"
```

::: details Solución

```bash
sed -nE 's/^([0-9.]+) .* 404 [0-9]+$/\1/p' acceso.log | sort -u
```

```text
10.0.0.7
192.168.1.10
```

El patrón solo encaja con las líneas que tienen el código 404 antes del tamaño, y las cambia por su IP, el grupo 1.
Con `-n` y la `p`, solo se escriben esas, y `sort -u` quita las repetidas.

:::

## Reto 5 · Combina

Copia `acceso.log` en `copia.log` y borra de la copia las peticiones con código 404, guardando antes una copia de seguridad.
Comprueba después cuántas líneas quedan y cuáles se han borrado.

::: details Solución

```bash
cp acceso.log copia.log
sed -i.bak '/ 404 /d' copia.log
wc -l copia.log
diff copia.log.bak copia.log
```

`wc -l` debe dar 3, las peticiones con código 200.
`diff` compara dos ficheros línea a línea y escribe las diferencias: aquí, cada línea borrada, precedida de `<`.
Como `-i.bak` guarda el original en `copia.log.bak`, para deshacer el cambio basta con `mv copia.log.bak copia.log`.

:::
