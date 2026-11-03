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
El comando nunca ve el patrón, sino que recibe los nombres ya expandidos.
Esto lo podemos comprobar con `echo`, que se limita a imprimir lo que recibe.
En un directorio que solo contiene `a.txt`, `b.txt` y `c.log`:

```console
$ echo *.txt
a.txt b.txt
$ echo *.pdf
*.pdf
```

El segundo caso es un problema común, porque si ningún fichero encaja, bash deja el patrón tal cual.
Una orden como `mv *.pdf docs/` recibiría entonces un fichero llamado literalmente `*.pdf` y fallaría.
Para evitarlo, con `shopt -s nullglob`, un patrón sin coincidencias desaparece de la orden en lugar de quedarse tal cual.

> [!NOTE] Opciones de *shell*
> `shopt -s` activa una opción de bash y `shopt -u` la desactiva.
> El cambio dura hasta que se cierra la terminal o termina el *script*.

Los comodines no encajan con `/`, así que cada uno vale para un solo nivel de la ruta.
Por ejemplo, `proyecto/*` da lo que hay dentro de `proyecto`, pero no lo de sus subdirectorios.
Para bajar un nivel, se tiene que escribir otro: `proyecto/*/*`.
Con `shopt -s globstar`, `**` encaja con cualquier número de niveles; por ejemplo, con los datos de la semana:

```console
$ echo **/*.txt
**/*.txt
$ shopt -s globstar
$ echo **/*.txt
proyecto/docs/guía de uso.txt
```

## Ficheros ocultos

Un **fichero oculto** es el que tiene un nombre que empieza por punto, como `.bashrc`.
No es una protección, solo una convención, por la que `ls` no los muestra sin `-a` y `*` no encaja con ellos.
Por eso `rm *` no borra los ficheros ocultos de un directorio, y `cp * destino` tampoco los copia.
Con `shopt -s dotglob`, `*` también encaja con ellos, salvo con `.` y `..`.
