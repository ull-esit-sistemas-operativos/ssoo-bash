`for` recorre palabras, así que si lo usamos para leer una línea con espacios, la rompe en trozos.
Para procesar la salida de `ps` o un fichero línea a línea necesitamos otra estructura.

El bucle **`while`** repite un bloque mientras la orden de su condición termine con éxito.
Combinado con `read`, que lee una línea de la entrada estándar y falla al llegar al final, recorre un fichero línea a línea:

```bash
while IFS= read -r linea; do
    echo "Leído: $linea"
done < fichero.txt
```

`-r` evita que `read` interprete las barras invertidas (`\`), e `IFS=` hace que `read` conserve los espacios del principio y del final.
La redirección `done` afecta a todo el bucle, de forma que `read` lee el contenido de ese fichero.

Si damos a `read` varias variables, reparte la línea en campos usando como separador el contenido de `IFS`, y la última variable se queda con el resto.
Por convención, usamos `_` para recoger los campos que no nos interesan:

```bash
while IFS=: read -r nombre _ uid _ _ home shell; do
    echo "$nombre ($uid) usa $shell"
done < /etc/passwd
```

Para leer la salida de un comando línea a línea, la conectamos con una tubería (`ps … | while read …`) o con una sustitución de procesos (`done < <(ps …)`).

```bash
ps -u "$USER" -o pid= -o comm= | while read -r pid nombre; do
    echo "El proceso $pid es $nombre"
done
```

Cada línea de `ps` trae dos campos, y `read` deja el primero en `pid` y el segundo en `nombre`.

> [!NOTE] Variables que se pierden
> Cada comando de una tubería se ejecuta en un proceso aparte.
> Si el `while` está al final de una tubería, las variables que modifica desaparecen al terminar el bucle.
> Por ejemplo, un contador incrementado dentro valdrá 0 después.
> Si necesitamos el valor tras el bucle, mejor usar `done < <(orden)`, que mantiene el bucle en la *shell* actual.

## Esperar con until

`until` es el contrario de `while`: repite mientras la condición falla.
Es la forma natural de esperar a que algo ocurra:

```bash
until pgrep -x firefox > /dev/null; do
    sleep 1
done
echo "Firefox se ha iniciado"
```

## Pedir datos al usuario con read

`read` también sirve para preguntar al usuario.
Con `-p` muestra un texto antes de leer y `-t` fija un límite en segundos; si se agota, `read` termina con un estado de error:

```bash
if read -r -t 10 -p "¿Terminar el proceso $pid? [s/n] " resp; then
    echo "Has respondido: $resp"
else
    echo
    echo "No has respondido a tiempo" >&2
fi
```

Como `read` termina con error si se agota el tiempo, puede ir directamente como condición de un `if`.
El `echo` vacío del `else` añade el salto de línea que falta, porque el texto mostrado por `-p` no lo incluye.
