Un *script* que acepte `-n 3`, `-u alu luis` y un fichero, en el orden que el usuario quiera.
Las opciones se procesan una a una con un bucle, `case` y `shift`.

## El problema

Los argumentos llegan en `$1`, `$2`…, pero no se sabe en qué orden.
Algunas opciones van solas (`-h`), otras llevan un valor (`-n 3`) y otras una lista de valores que termina donde empieza la siguiente opción (`-u alu luis`).

## Soluciones

### while, case y shift

El bucle mira siempre `$1`.
Cada rama del `case` consume con `shift` lo que ha usado, y el bucle termina cuando no quedan argumentos:

```bash
#!/bin/bash
error_exit() { echo "opciones.sh: $1" >&2; exit 1; }

n=10
usuarios=()
fichero=
while (( $# > 0 )); do
    case $1 in
        -h|--help)
            echo "uso: opciones.sh [-n N] [-u usuario...] [--] fichero"
            exit 0 ;;
        -n)
            [[ $# -ge 2 ]] || error_exit "-n necesita un valor"
            n=$2
            shift 2 ;;
        -u)
            shift
            while (( $# > 0 )) && [[ $1 != -* ]]; do
                usuarios+=("$1")
                shift
            done
            (( ${#usuarios[@]} > 0 )) || error_exit "-u necesita al menos un usuario"
            ;;
        --)
            shift
            break ;;
        -*)
            error_exit "opción desconocida: $1" ;;
        *)
            fichero=$1
            shift ;;
    esac
done

(( $# > 0 )) && fichero=$1
echo "n=$n usuarios=${usuarios[*]} (${#usuarios[@]}) fichero=$fichero"
```

El orden no importa:

```console
$ ./opciones.sh -u alu luis -n 3 acceso.log
n=3 usuarios=alu luis (2) fichero=acceso.log
$ ./opciones.sh acceso.log -n 5 -u alu
n=5 usuarios=alu (1) fichero=acceso.log
```

Y los errores salen por la salida de error, con código 1:

```console
$ ./opciones.sh -n
opciones.sh: -n necesita un valor
$ ./opciones.sh -x
opciones.sh: opción desconocida: -x
$ ./opciones.sh -u -n 3
opciones.sh: -u necesita al menos un usuario
```

### Las piezas

| Opción | Qué hace la rama |
| --- | --- |
| Sin valor (`-h`) | Actúa y hace `shift` |
| Con un valor (`-n N`) | Comprueba que hay `$2`, lo guarda y hace `shift 2` |
| Con lista (`-u a b…`) | Hace `shift` y añade a un *array* hasta el siguiente argumento que empiece por `-` |
| Fin de opciones (`--`) | Hace `shift` y sale del bucle. Lo que queda son argumentos normales, por ejemplo, un fichero. |
| Desconocida (`-*`) | Error |
| El resto (`*`) | Argumento normal: el fichero |

Las ramas `--` y `-*` van después de todas las opciones conocidas, y `--` antes que `-*`, porque `case` se queda con la primera que encaja.

### getopts

`getopts` es la orden de bash para opciones cortas.
Sirve cuando todas las opciones son de una letra y llevan como mucho un valor, pero no admite opciones largas como `--help` ni listas como `-u alu luis`.

### Cuándo usar cada una

| Forma | Cuándo |
| --- | --- |
| `while`, `case` y `shift` | Opciones largas, listas de valores o cualquier orden |
| `getopts` | Solo opciones cortas, cada una con un valor como mucho |

## En otros contextos

```bash
# Procesos: -u con una lista de usuarios, y se recorre después
for u in "${usuarios[@]}"; do
    ps -u "$u" -o pid=,comm=
done

# Log: -n limita cuántas líneas se muestran
tail -n "$n" "$fichero"
```

## Errores frecuentes

**Un argumento detrás de la lista.**
La lista termina en el siguiente argumento que empieza por `-`, así que un fichero puesto justo después se toma como un usuario más:

```console
$ ./opciones.sh -n 3 -u alu luis f
n=3 usuarios=alu luis f (3) fichero=
```

La solución es admitir un `--` que indique el fin de las opciones, y ponerlo antes del fichero:

```console
$ ./opciones.sh -n 3 -u alu luis -- f
n=3 usuarios=alu luis (2) fichero=f
```

`--` también sirve para aceptar ficheros cuyo nombre empieza por guion: `./opciones.sh -- -raro.txt`.

**Olvidar el `shift`.**
Si una rama no consume su argumento, `$1` no cambia y el bucle no termina nunca.

**`-n` sin valor.**
Sin la comprobación `[[ $# -ge 2 ]]`, `n` queda vacía y `shift 2` falla sin mover nada: el bucle vuelve a ver `-n` una y otra vez.

**Opciones desconocidas como ficheros.**
Sin la rama `-*`, `-x` acaba en `*` y se toma como el nombre del fichero.

## Ver también

[Ficha de `[[ ]]` y `test`](../../s03-pipes/cards/test.md)
