Si queremos copiar todos los ficheros `.txt` de un directorio, escribir sus nombres uno a uno no es una opción.
Los comodines nos permiten describirlos con un patrón.

La **expansión de nombres de fichero** es el paso en el que la *shell* sustituye un patrón con comodines por la lista de ficheros que encajan con él.
Ocurre antes de ejecutar la orden.
Los comodines son estos:

| Comodín | Encaja con | Ejemplo |
| --- | --- | --- |
| `*` | Cualquier secuencia de caracteres, incluida la vacía | `*.txt` |
| `?` | Exactamente un carácter | `foto?.jpg` |
| `[abc]` | Uno de los caracteres de la lista | `[ab]*.log` |
| `[a-z]` | Un carácter del rango | `informe[0-9].pdf` |
| `[!abc]` | Un carácter que no está en la lista | `[!.]*` |

Lo importante es quién hace el trabajo.
El comando nunca ve el patrón: recibe los nombres ya expandidos.
Esto lo podemos comprobar con `echo`, que se limita a imprimir lo que recibe.
En un directorio que solo contiene `a.txt`, `b.txt` y `c.log`:

```console
$ echo *.txt
a.txt b.txt
$ echo *.pdf
*.pdf
```

El segundo caso es la trampa típica: si ningún fichero encaja, bash deja el patrón tal cual.
Una orden como `mv *.pdf docs/` recibiría entonces un fichero llamado literalmente `*.pdf` y fallaría.

## Ficheros ocultos

Un **fichero oculto** es el que tiene un nombre que empieza por punto, como `.bashrc`.
No es una protección, solo una convención: `ls` no los muestra sin `-a` y `*` no encaja con ellos.
Por eso `rm *` no borra los ficheros ocultos de un directorio, y `cp * destino` tampoco los copia.
