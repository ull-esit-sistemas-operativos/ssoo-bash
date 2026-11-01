Una redirección cambia el origen o el destino de un flujo antes de que el comando empiece a ejecutarse.
El comando no se entera: sigue escribiendo en su descriptor 1, sin saber que ahora es un fichero.

| Redirección | Efecto |
| --- | --- |
| `> fichero` | Salida estándar al fichero, que se vacía antes si ya existía |
| `>> fichero` | Salida estándar al final del fichero, sin borrar lo que había |
| `< fichero` | Entrada estándar desde el fichero |
| `2> fichero` | Error estándar al fichero |
| `2>&1` | Error estándar al mismo sitio al que apunte la salida en ese momento |
| `>&2` / `1>&2` | Salida estándar al mismo sitio que el error |

Un destino especial es `/dev/null`, un fichero que descarta todo lo que se escribe en él.
Es decir, `orden 2> /dev/null` ejecuta la orden sin mostrar sus errores.

La redirección de entrada tiene un uso práctico inmediato.
`wc -l acceso.log` imprime el número de líneas seguido del nombre del fichero, mientras que `wc -l < acceso.log` imprime solo el número.
En el segundo caso, `wc` lee de su entrada estándar y no conoce el nombre del archivo.

## El orden importa

Las redirecciones se aplican de izquierda a derecha, y `2>&1` copia el destino que tenga la salida justo en ese momento.
Por eso estas dos líneas no hacen lo mismo:

```bash
ls /etc /noexiste > salida.txt 2>&1   # listado y error, ambos en salida.txt
ls /etc /noexiste 2>&1 > salida.txt   # error en pantalla, listado en salida.txt
```

En la primera, la salida ya apunta a `salida.txt` cuando el error se une a ella.
En la segunda, el error se une a la salida cuando esta aún apunta a la pantalla, y después solo la salida se redirige al fichero.

## Agrupar órdenes

¿Cómo guardamos en un fichero un título seguido del contenido de `proyecto`?
Con `echo "Contenido de proyecto:"; ls proyecto > lista.txt`, la redirección solo afecta a `ls`, y el título sale por la pantalla.

Un **grupo de órdenes** son varias órdenes entre llaves que se redirigen o se pasan a una tubería como si fueran una sola:

```console
$ { echo "Contenido de proyecto:"; ls proyecto; } > lista.txt
$ cat lista.txt
Contenido de proyecto:
README.md
docs
src
```

Las llaves necesitan un espacio después de `{` y un `;` o un salto de línea antes de `}`.
Sin el espacio, bash busca un comando llamado `{echo`; sin el `;`, toma `}` como un argumento más de `ls`, el último comando.

Con paréntesis, las órdenes también se agrupan, pero se ejecutan en una ***subshell***, una copia de la *shell* que finaliza al terminar el grupo.
Por eso, lo que cambie dentro, como el directorio actual o una variable, se pierde al salir:

```console
alu@ull:~/ssoo$ (cd proyecto; ls)
README.md  docs  src
alu@ull:~/ssoo$ x=1; (x=2); echo "$x"
1
```

`(cd dir; …)` sirve para trabajar un momento en otro directorio sin tener que volver después.
Cuando lo que queremos es conservar los cambios, como al asignar una variable, usamos llaves.

## Mensajes de error en un *script*

Un *script* bien hecho escribe sus resultados en la salida estándar y sus mensajes de error en el error estándar.
Así, quien redirija la salida a un fichero seguirá viendo los errores en la pantalla.
Basta con añadir `>&2` al `echo`:

```bash
echo "Error: no se puede leer $log" >&2
```
