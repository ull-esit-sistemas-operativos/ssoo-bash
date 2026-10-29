## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `grep -c ana n.txt`?
  options:
    - id: a
      value: "`1`"
      isCorrect: true
      explanation: "`-c` cuenta líneas, no apariciones: `ana` sale dos veces, pero en la misma línea."
    - id: b
      value: "`2`"
      incorrectExplanation: "`-c` cuenta líneas, no apariciones, y las dos `ana` están en la misma línea."
    - id: c
      value: "`ana ana`"
      incorrectExplanation: "`-c` imprime cuántas líneas encajan, no las líneas."
    - id: d
      value: "`0`"
      incorrectExplanation: "`grep` busca el texto en cualquier parte de la línea, y la primera contiene `ana`."
```

## Reto 2 · Predice

```quiz
- id: "2"
  type: choice
  scrambleOrder: true
  content: |
    ¿Qué imprime esta orden?

    ```bash
    printf 'ana\nmariana\nana luisa\n' | grep -cw ana
    ```
  options:
    - id: a
      value: "`2`"
      isCorrect: true
      explanation: Con `-w`, `ana` tiene que ser una palabra completa, así que `mariana` no encaja.
    - id: b
      value: "`3`"
      incorrectExplanation: Con `-w`, `ana` tiene que ser una palabra completa, así que `mariana` no encaja.
    - id: c
      value: "`1`"
      incorrectExplanation: "`-w` pide que `ana` sea una palabra completa, no que sea la línea entera, así que `ana luisa` también encaja."
    - id: d
      value: "`ana` y `ana luisa`"
      incorrectExplanation: "`-c` imprime cuántas líneas encajan, no las líneas."
```

## Reto 3 · Prueba

Muestra las líneas del *log* que no son de la IP `192.168.1.10`.

::: details Solución

```bash
grep -v '^192\.168\.1\.10 ' acceso.log
```

Salen tres líneas, dos de `10.0.0.7` y una de `172.16.0.3`.
Los puntos van escapados para que sean literales, y el espacio final evita que encaje con una IP como `192.168.1.100`.

:::

## Reto 4 · Prueba

Muestra las IP distintas del *log* usando `grep` en lugar de `cut`.

::: details Solución

```bash
grep -oE '^[0-9.]+' acceso.log | sort -u
```

```text
10.0.0.7
172.16.0.3
192.168.1.10
```

:::

## Reto 5 · Combina

Muestra la petición completa (método, ruta y protocolo) de las líneas que dieron un error 404.

::: details Solución

```bash
grep '" 404 ' acceso.log | cut -d'"' -f2
```

```text
GET /logo.png HTTP/1.1
GET /favicon.ico HTTP/1.1
GET /tema2.html HTTP/1.1
```

Con `"` como separador, el campo 2 es lo que va entre las primeras comillas.

:::
