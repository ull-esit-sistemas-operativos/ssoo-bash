¿Cómo hago algo con cada línea de un fichero, o con cada proceso que da `ps`?
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

### while read desde un comando

La salida de un comando se conecta con `done < <(comando)`, la sustitución de procesos, o con una tubería (`comando | while read …`).
Las dos leen igual, pero solo la primera conserva las variables del bucle al terminar (ver el apartado «[Errores frecuentes](#errores-frecuentes)»):

```bash
while read -r usuario pid; do
    echo "$usuario tiene el proceso $pid"
done < <(ps -eo user=,pid=)
```

Sin `IFS=`, `read` separa por blancos y se salta los del principio, así que sirve para la salida alineada de `ps`.

### Cuándo usar cada una

| Forma | Cuándo |
| --- | --- |
| `while read … done < fichero` | Un fichero entero |
| `while read … done < <(comando)` | La salida de un comando, y hacen falta las variables después del bucle |
| `comando \| while read …` | La salida de un comando, y todo se resuelve dentro del bucle |
| `awk` | Solo hay que filtrar, contar o calcular, sin ejecutar otros comandos por línea: es más rápido |

## En otros contextos

```bash
# Usuarios: personas (UID desde 1000, sin contar nobody, que tiene el 65534)
while IFS=: read -r usuario _ uid _ _ home shell; do
    (( uid >= 1000 && uid < 65534 )) && echo "$usuario $home $shell"
done < /etc/passwd

# Procesos: avisar de los que llevan más de una hora
while read -r pid segundos comando; do
    (( segundos > 3600 )) && echo "$pid ($comando) lleva $segundos s"
done < <(ps -eo pid=,etimes=,comm=)
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

[Ficha de `awk`](../../s04-expansions-loops/cards/awk.md) · [ficha de `ps`](../cards/ps.md) · [ficha de `cut`](../../s03-pipes/cards/cut.md) · patrón «[Recorrer ficheros](../../s04-expansions-loops/patterns/loop-over-files.md)»
