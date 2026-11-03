¿Cómo hago algo con cada línea de un fichero, o de la salida de una orden?
`while read` lee una línea en cada vuelta y la reparte en variables, una por campo.

## El problema

Queremos una frase por cada nota de `notas.csv`.
Un `for` sobre `$(cat …)` no sirve: recorre palabras, no líneas, así que una línea con espacios se parte:

```console
$ cat sp.csv
ana garcía,SSOO
$ for l in $(cat sp.csv); do echo "[$l]"; done
[ana]
[garcía,SSOO]
```

## Soluciones

### while read desde un fichero

`IFS` fija el separador de campos solo para ese `read`, y `-r` deja las barras invertidas como están.
Cada campo va a una variable; el último recibe el resto de la línea:

```console
$ while IFS=, read -r alumno asig nota; do echo "$alumno tiene $nota en $asig"; done < <(tail -n +2 notas.csv | grep -v ',$')
ana tiene 7.5 en SSOO
ana tiene 6 en FP
luis tiene 4.5 en SSOO
marta tiene 9 en SSOO
marta tiene 8.5 en FP
```

`grep -v ',$'` quita las líneas sin nota, que darían frases como «luis tiene  en FP».

Si el fichero no tiene cabecera, la redirección es directa: `done < fichero`.

### while read desde una orden

La salida de una orden se conecta con `done < <(orden)`, la sustitución de procesos, o con una tubería (`orden | while read …`).
Las dos leen igual, pero solo la primera conserva las variables del bucle al terminar (ver el apartado «[Errores frecuentes](#errores-frecuentes)»):

```bash
while read -r n asignatura; do
    echo "$asignatura aparece $n veces"
done < <(tail -n +2 notas.csv | cut -d, -f2 | sort | uniq -c)
```

Sin `IFS=`, `read` separa por blancos y se salta los del principio, así que sirve para la salida alineada de `uniq -c`.

### Cuándo usar cada una

| Forma | Cuándo |
| --- | --- |
| `while read … done < fichero` | Un fichero entero |
| `while read … done < <(orden)` | La salida de una orden, y hacen falta las variables después del bucle |
| `orden \| while read …` | La salida de una orden, y todo se resuelve dentro del bucle |
| `awk`, que se explica en la semana 5 | Solo hay que filtrar, contar o calcular, sin ejecutar otros comandos por línea: es más rápido |

## En otros contextos

```bash
# Log: las peticiones que terminaron en error (código 400 o mayor)
while read -r ip _ _ _ _ _ ruta _ codigo _; do
    (( codigo >= 400 )) && echo "$ip pidió $ruta: $codigo"
done < acceso.log

# Ficheros: una lista de nombres, uno por línea, que pueden tener espacios
while IFS= read -r f; do
    [[ -e $f ]] || echo "Falta: $f"
done < lista.txt
```

`_` es una variable de descarte para los campos que no interesan.

## Errores frecuentes

**Variables que se pierden en una tubería.**
Cada lado de una tubería se ejecuta en un proceso aparte, así que un contador incrementado dentro del bucle vuelve a valer 0 al salir:

```bash
n=0
tail -n +2 notas.csv | while IFS=, read -r a b c; do n=$((n + 1)); done
echo "$n"    # 0

n=0
while IFS=, read -r a b c; do n=$((n + 1)); done < <(tail -n +2 notas.csv)
echo "$n"    # 7
```

**La última línea sin salto.**
Si el fichero no acaba en salto de línea, `read` lee la última línea pero devuelve error, y el bucle no la procesa:

```console
$ printf 'a\nb' | while read -r l; do echo "[$l]"; done
[a]
$ printf 'a\nb' | while read -r l || [[ -n $l ]]; do echo "[$l]"; done
[a]
[b]
```

**`read` sin `-r`.**
Las barras invertidas se interpretan como escapes y desaparecen.
Por ejemplo, `C:\temp` se lee como `C:temp`.

**Los blancos del principio y del final.**
Con el `IFS` por defecto, `read` los quita.
Para conservar la línea exacta, `IFS= read -r l`.

## Ver también

[Ficha de `awk`](../../s05-text-processing/cards/awk.md) · [ficha de `cut`](../../s03-pipes/cards/cut.md) · patrón «[Recorrer ficheros](loop-over-files.md)»
