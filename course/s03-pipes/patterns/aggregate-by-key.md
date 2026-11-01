¿Cuántas peticiones ha hecho cada IP, cuántas notas tiene cada alumno, cuántas respuestas hay de cada código?
Son todas la misma pregunta: cuántas veces sale cada valor distinto de un campo (la clave).

## El problema

En `acceso.log`, la clave es la IP (campo 1).
Queremos una línea por IP con su número de peticiones, de la que más tiene a la que menos.

## Soluciones

### sort y uniq -c: contar

Se saca la clave, se ordena para juntar las iguales y `uniq -c` cuenta cada grupo.
Un último `sort -rn` ordena por el contador, de mayor a menor:

```console
$ cut -d' ' -f1 acceso.log | sort | uniq -c | sort -rn
      3 192.168.1.10
      2 10.0.0.7
      1 172.16.0.3
```

### Solo las primeras

Con `head` nos quedamos con las claves que más se repiten.
Si solo queremos la clave, sin el contador, `tr -s ' '` junta los espacios que pone `uniq -c` y `cut` extrae el tercer campo:

```console
$ cut -d' ' -f1 acceso.log | sort | uniq -c | sort -rn | head -n 1 | tr -s ' ' | cut -d' ' -f3
192.168.1.10
```

El primer campo está vacío, porque la línea empieza por un espacio; por eso la IP es el tercero.

### Sumar, media o máximo

`uniq -c` solo cuenta.
Para sumar los bytes servidos a cada IP, o calcular la media de cada asignatura, hace falta `awk`, que veremos en la semana 4: es la segunda parte de este patrón, «[Agregar por clave con awk](../../s04-expansions-loops/patterns/aggregate-with-awk.md)».

## En otros contextos

```bash
# CSV: número de notas de cada alumno
tail -n +2 notas.csv | cut -d, -f1 | sort | uniq -c

# Log: peticiones por código de estado
cut -d' ' -f9 acceso.log | sort | uniq -c

# Texto: las 3 palabras más repetidas
tr -s ' ' '\n' < texto.txt | sort | uniq -c | sort -rn | head -n 3
```

## Errores frecuentes

**`uniq` sin `sort`.**
`uniq -c` solo junta líneas seguidas: sin ordenar antes, la misma clave sale en varios grupos.

**`cut -d' '` sobre la salida de `uniq -c`.**
Los espacios de delante hacen que el contador no sea el campo 1.
Antes hay que juntarlos con `tr -s ' '`.

## Ver también

[Ficha de `sort`](../cards/sort.md) · [ficha de `uniq`](../cards/uniq.md) · [ficha de `cut`](../cards/cut.md) · [ficha de `tr`](../cards/tr.md) · patrón «[Agregar por clave con awk](../../s04-expansions-loops/patterns/aggregate-with-awk.md)»
