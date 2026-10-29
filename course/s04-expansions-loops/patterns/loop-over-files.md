¿Cómo hago algo con cada fichero de un directorio, aunque alguno tenga espacios en el nombre?
Las rutas tienen que llegar enteras a cada vuelta del bucle, sin que la *shell* las parta por los espacios.

## El problema

`proyecto/docs` contiene `guía de uso.txt`.
Si los nombres salen de `ls`, la sustitución de comandos los parte por los espacios:

```console
$ for f in $(ls proyecto/docs); do echo "[$f]"; done
[guía]
[de]
[uso.txt]
```

## Soluciones

### Comodines en un for

La *shell* expande el comodín a una lista de rutas, y cada ruta es una palabra aunque tenga espacios:

```console
$ for f in proyecto/docs/*; do printf '%s: %s bytes\n' "$f" "$(wc -c < "$f")"; done
proyecto/docs/guía de uso.txt: 0 bytes
```

Dentro del bucle, `"$f"` debe ir siempre entre comillas.

### find con -exec

Para un árbol entero, o para elegir los ficheros por tipo, tamaño o fecha, cuando basta con ejecutar un comando sobre cada uno:

```bash
find proyecto -type f -name '*.txt' -exec wc -c {} +
```

Con `+`, `find` ejecuta el comando una vez con muchos ficheros; con `\;`, una vez por fichero.

### find con -print0 y while read

Cuando hay que hacer varias cosas con cada fichero, `find` separa las rutas con un carácter nulo y `read -d ''` las lee una a una.
El carácter nulo es el único que no puede aparecer en un nombre:

```bash
while IFS= read -r -d '' f; do
    echo "[$f]"
done < <(find proyecto -type f -print0)
```

```text
[proyecto/src/util.h]
[proyecto/src/main.c]
[proyecto/.oculto]
[proyecto/README.md]
[proyecto/docs/guía de uso.txt]
```

### Cuándo usar cada una

| Forma | Cuándo |
| --- | --- |
| `for f in dir/*` | Un solo directorio, sin bajar a subdirectorios |
| `find … -exec cmd {} +` | Un árbol, y basta con un comando por fichero |
| `find … -print0` y `while read -d ''` | Un árbol, y hay varias órdenes o variables que conservar |

## En otros contextos

```bash
# Ficheros: mover cada fichero a una carpeta según su extensión
for f in "$dir"/*; do
    [[ -f $f ]] || continue
    mkdir -p "$dir/${f##*.}"
    mv "$f" "$dir/${f##*.}/"
done

# Logs: contar los 404 de cada fichero de log
for log in /var/log/apache2/*.log; do
    echo "$log: $(grep -c '" 404 ' "$log")"
done

# CSV: cuántas notas tiene cada fichero de notas
for csv in notas_*.csv; do
    echo "$csv: $(tail -n +2 "$csv" | wc -l) notas"
done
```

## Errores frecuentes

**El comodín sin coincidencias.**
Si no hay ningún fichero que encaje, bash deja el comodín tal cual y el bucle da una vuelta con él:

```console
$ for f in proyecto/*.log; do echo "[$f]"; done
[proyecto/*.log]
```

Se evita comprobando que existe (`[[ -e $f ]] || continue`) o con `shopt -s nullglob`, que hace que el comodín sin coincidencias desaparezca.

**Los ocultos no entran.**
`*` no incluye los nombres que empiezan por punto: `for f in proyecto/*` no ve `.oculto`.
`find` sí los incluye.

**Variables que se pierden en una tubería.**
Con `find … | while read`, el bucle se ejecuta en otro proceso y cualquier variable modificads en el cuerpo del bucle pierde los cambios.
Con `done < <(find …)`, el bucle se ejecuta en la *shell* actual:

```bash
n=0
find proyecto -type f -print0 | while IFS= read -r -d '' f; do n=$((n + 1)); done
echo "$n"    # 0

n=0
while IFS= read -r -d '' f; do n=$((n + 1)); done < <(find proyecto -type f -print0)
echo "$n"    # 5
```

## Ver también

[Ficha de `find`](../../s02-files/cards/find.md) · [ficha de `ls`](../../s01-shell/cards/ls.md) · [ficha de `[[ ]]` y `test`](../../s03-pipes/cards/test.md) · patrón «[Recorrer líneas](../../s05-processes-users/patterns/loop-over-lines.md)»
