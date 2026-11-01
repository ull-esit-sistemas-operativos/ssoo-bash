Seis comandos cubren casi todo el trabajo diario con ficheros:

| Comando | Uso | Opciones útiles |
| --- | --- | --- |
| `cp origen destino` | Copia ficheros | `-r` para directorios, `-i` pregunta antes de sobrescribir |
| `mv origen destino` | Mueve o renombra | `-i` pregunta antes de sobrescribir |
| `rm fichero` | Borra ficheros | `-r` para directorios, `-i` pregunta, `-f` no pregunta ni avisa |
| `mkdir dir` | Crea directorios | `-p` crea los directorios intermedios de la ruta y no falla si ya existe |
| `rmdir dir` | Borra directorios vacíos | — |
| `touch fichero` | Crea un fichero vacío; si ya existe, solo actualiza su fecha de modificación | — |

Con `cp` y `mv`, si el destino es un directorio existente, los ficheros se copian o se mueven dentro conservando su nombre.
Si no lo es, el destino es el nuevo nombre.
Por eso `mv` sirve tanto para mover como para renombrar:

```bash
mv borrador.txt notas.txt        # renombra
mv notas.txt ~/ssoo/datos/       # mueve, conservando el nombre
```

> [!WARNING] `rm` no tiene papelera
> Un fichero borrado con `rm` no se puede recuperar.
> Antes de ejecutar un `rm` con comodines, conviene probar el mismo patrón con `ls` o `echo` para ver qué nombres va a recibir.

Un nombre que empieza por guion, como `-raro.txt`, se toma como una lista de opciones:

```console
$ rm -raro.txt
rm: opción inválida -- 'a'
Pruebe 'rm ./-raro.txt' para borrar el fichero '-raro.txt'.
Pruebe 'rm --help' para más información.
```

`--` marca el fin de las opciones, y lo que va detrás es un nombre aunque empiece por guion: `rm -- -raro.txt`.
Funciona igual en `cp`, `mv`, `ls` y casi todos los comandos.
Escribir la ruta empezando por `./`, como sugiere el mensaje, también lo evita.
