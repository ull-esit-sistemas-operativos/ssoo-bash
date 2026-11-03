`for` recorre palabras, así que si lo usamos para leer una línea con espacios, la rompe en trozos.
Para procesar un fichero o la salida de un comando línea a línea necesitamos otra estructura.

El bucle **`while`** repite un bloque mientras la orden de su condición termine con éxito.
Combinado con `read`, que lee una línea de la entrada estándar y falla al llegar al final, recorre un fichero línea a línea:

```bash
while IFS= read -r linea; do
    echo "Leído: $linea"
done < fichero.txt
```

`-r` evita que `read` interprete las barras invertidas (`\`), e `IFS=` hace que `read` conserve los espacios del principio y del final.
La redirección tras `done` afecta a todo el bucle, de forma que `read` lee el contenido de ese fichero.

Si damos a `read` varias variables, reparte la línea en campos usando como separador el contenido de `IFS`, y la última variable se queda con el resto.
Por convención, usamos `_` para recoger los campos que no nos interesan:

```bash
while IFS=, read -r alumno _ nota; do
    echo "$alumno: $nota"
done < notas.csv
```

Para leer la salida de un comando línea a línea, la conectamos con una tubería (`orden | while read …`) o con una sustitución de procesos (`done < <(orden)`).
La sintaxis `<(orden)` es la **sustitución de procesos**.
Bash ejecuta la orden y pone en su lugar el nombre de un fichero especial del que se lee esa salida.
El primer `<` es la redirección de siempre, que hace que el bucle lea de ese fichero.
Por ejemplo, para saltar la cabecera de `notas.csv`:

```bash
tail -n +2 notas.csv | while IFS=, read -r alumno asignatura nota; do
    echo "$alumno ($asignatura): ${nota:-sin nota}"
done
```

> [!NOTE] Variables que se pierden
> Cada comando de una tubería se ejecuta en un proceso aparte.
> Si el `while` está al final de una tubería, las variables que modifica desaparecen al terminar el bucle.
> Por ejemplo, un contador incrementado dentro valdrá 0 después.
> Si necesitamos el valor tras el bucle, mejor usar `done < <(orden)`, que mantiene el bucle en la *shell* actual.

## Esperar con until

`until` es el contrario de `while`, porque repite mientras la condición falla.
Es la forma natural de esperar a que algo ocurra:

```bash
until [[ -e listo.txt ]]; do
    sleep 1
done
echo "Ya existe listo.txt"
```

`sleep 1` espera un segundo, para no repetir la comprobación sin parar.

## Pedir datos al usuario con read

`read` también sirve para preguntar al usuario.
Con `-p` muestra un texto antes de leer y `-t` fija un límite en segundos; si se agota, `read` termina con un estado de error:

```bash
if read -r -t 10 -p "¿Borrar $f? [s/n] " resp; then
    echo "Has respondido: $resp"
else
    echo
    echo "No has respondido a tiempo" >&2
fi
```

Como `read` termina con error si se agota el tiempo, puede ir directamente como condición de un `if`.
El `echo` vacío del `else` añade el salto de línea que falta, porque el texto mostrado por `-p` no lo incluye.
