## Reto 1 · Predice

```quiz
- id: "1"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `uniq -c colores.txt`, sin ordenar antes?
  options:
    - id: a
      value: "`2 rojo`, `1 verde` y `1 rojo`, con los números alineados a la derecha"
      isCorrect: true
      explanation: "`uniq` solo junta líneas seguidas, así que los dos grupos de `rojo` se cuentan por separado."
    - id: b
      value: "`3 rojo` y `1 verde`"
      incorrectExplanation: "`uniq` solo junta líneas seguidas, así que los dos grupos de `rojo` se cuentan por separado. Para contar en total, hay que ordenar antes con `sort`."
    - id: c
      value: "`rojo`, `verde` y `rojo`"
      incorrectExplanation: "`-c` antepone a cada línea el número de veces que se repite seguida."
    - id: d
      value: "`1 verde` y `3 rojo`"
      incorrectExplanation: "`uniq` no ordena: escribe los grupos en el orden en que aparecen, y los dos de `rojo` por separado."
```

## Reto 2 · Prueba

```quiz
- id: "2"
  type: string
  content: |
    Muestra las IP del *log* que hicieron exactamente una petición.
    ¿Cuál sale?
  options:
    - id: a
      value: "172.16.0.3"
```

::: details Solución

```bash
cut -d' ' -f1 acceso.log | sort | uniq -u
```

```text
172.16.0.3
```

:::

## Reto 3 · Combina

```quiz
- id: "3"
  type: string
  content: |
    Muestra solo la IP con más peticiones, sin el contador.
    ¿Cuál es?
  options:
    - id: a
      value: "192.168.1.10"
```

::: details Solución

```bash
cut -d' ' -f1 acceso.log | sort | uniq -c | sort -rn | head -n 1 | tr -s ' ' | cut -d' ' -f3
```

```text
192.168.1.10
```

`uniq -c` pone espacios delante del contador, así que `cut` no puede usar el espacio como separador directamente.
`tr -s ' '` deja un solo espacio en cada hueco, y la línea queda ` 3 192.168.1.10`, que empieza por un espacio: el primer campo está vacío, el contador es el 2 y la IP, el 3.

:::

## Reto 4 · Predice

```quiz
- id: "4"
  type: choice
  scrambleOrder: true
  content: ¿Qué imprime `uniq -d colores.txt`, sin ordenar antes?
  options:
    - id: a
      value: "`rojo`, una vez"
      isCorrect: true
      explanation: "Solo las dos primeras líneas son iguales y seguidas, así que forman el único grupo repetido. El último `rojo` va solo, detrás de `verde`."
    - id: b
      value: "`rojo`, dos veces"
      incorrectExplanation: "`-d` escribe una línea por cada grupo de repetidas, y el último `rojo` no forma grupo: va solo, detrás de `verde`."
    - id: c
      value: "`verde`"
      incorrectExplanation: "`-d` muestra las líneas repetidas; `verde` aparece una sola vez. Eso sería `-u`, que aquí también daría el último `rojo`."
    - id: d
      value: "`rojo`, `rojo` y `rojo`"
      incorrectExplanation: "Ni siquiera `-D`, que escribe todas las copias de cada grupo repetido, daría eso: solo las dos primeras líneas forman grupo, así que sale `rojo` dos veces."
```
