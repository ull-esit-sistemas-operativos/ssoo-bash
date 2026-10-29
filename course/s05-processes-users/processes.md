Un programa es un fichero en disco, como `/usr/bin/sleep`.
Si dos usuarios lo ejecutan a la vez, ¿hay uno o dos programas?
Hay dos procesos.

Un **proceso** es un programa en ejecución, con su propia memoria, sus ficheros abiertos y un número que lo identifica, el **identificador de proceso (PID)**.
Todo proceso lo crea otro proceso, su padre, cuyo PID es el **identificador del proceso padre (PPID)**.
Cuando ejecutamos una orden desde la terminal, la *shell* es el padre del nuevo proceso.
`echo $$` muestra el PID de la propia *shell*.

## Consultar procesos con ps

Sin opciones, `ps` solo muestra los procesos de la terminal actual.
Con `-e` muestra todos, y con `-o` elegimos las columnas que nos interesan:

| Columna | Contenido |
| --- | --- |
| `pid`, `ppid` | El PID del proceso y el de su padre |
| `user` | El propietario |
| `%cpu`, `%mem` | Porcentaje de CPU y de memoria física |
| `etime`, `etimes` | Tiempo desde que empezó, como `[[dd-]hh:]mm:ss` o en segundos |
| `stat` | Estado: `R` ejecutándose, `S` dormido, `T` detenido, `Z` zombi |
| `comm`, `args` | El nombre del programa, o la orden completa con sus argumentos |

```bash
ps -e -o pid,user,%mem,comm --sort=-%mem | head -n 6
```

Esta línea muestra los cinco procesos que más memoria usan, más la cabecera.
`--sort` ordena por una columna, y el `-` delante invierte el orden.
Si escribimos `=` detrás de un nombre de columna, como `-o user=`, esa columna se imprime sin cabecera, lo que viene muy bien cuando la salida va a otro comando.
Algunas versiones de `ps` toman como cabecera todo lo que sigue al `=`, así que lo más seguro es poner cada columna sin cabecera en su propio `-o`: `ps -e -o user= -o %mem=`.

En Linux hay una forma más cómoda: la opción `--no-headers` quita la cabecera de todas las columnas a la vez, como en `ps -e --no-headers -o user,%mem`.
El `=` sirve, además, en otros sistemas, porque es lo que indica el estándar POSIX.

`pgrep` busca procesos por nombre y devuelve sus PID: `pgrep -x sleep` busca los que se llaman exactamente `sleep`, `pgrep -u alu` los del usuario `alu` y `-l` añade el nombre a cada PID.
Termina con estado 0 si encuentra alguno y 1 si no, así que sirve como condición de un `if` para actuar según haya o no procesos con ese nombre.

## Ficheros abiertos con lsof

`lsof` lista los ficheros que tienen abiertos los procesos, uno por línea.
Sus columnas más útiles son `COMMAND` (el nombre del comando), `PID`, `USER`, `FD` y `NAME` (la ruta del fichero).
`FD` indica cómo usa el proceso el fichero: `cwd` si es su directorio de trabajo, `txt` si es el ejecutable, y el número del descriptor de archivo si es un fichero abierto.
Estas son las opciones para elegir qué se muestra:

| Opción | Muestra los ficheros abiertos… |
| --- | --- |
| `-p 4821` | por el proceso con ese PID |
| `-u alu` | por los procesos de un usuario |
| `-c bash` | por los procesos cuyo comando empieza por ese nombre |
| `/ruta/fichero` | que son ese fichero, es decir, qué procesos lo usan |
| `+D /ruta/dir` | dentro de ese directorio, recorriéndolo entero |
| `-t` | solo los PID, sin cabecera ni repetidos |

Sirve para responder a una pregunta habitual: ¿qué proceso está usando este fichero que no me deja desmontar la unidad?
Con `-t` podemos obtener el PID para actuar sobre esos procesos: `kill $(lsof -t /ruta/fichero)`.
Sin permisos de administrador, solo veremos los ficheros de nuestros procesos.

> [!NOTE] `lsof` une las condiciones con «o»
> A diferencia de casi todos los comandos, si damos varias opciones de selección, `lsof` muestra los ficheros que cumplen *cualquiera* de ellas.
> Es decir, `lsof -u alu -c bash` lista los ficheros de `alu` más los de todos los `bash`.
> Para exigir que se cumplan todas hay que añadir `-a`.
> Por ejemplo, `lsof -a -u alu -c bash` muestra solo los de los `bash` de `alu`.
