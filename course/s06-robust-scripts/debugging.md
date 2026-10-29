## ShellCheck

ShellCheck es un analizador que lee un *script* sin ejecutarlo y avisa de errores frecuentes: variables sin comillas, comparaciones mal escritas, variables que no se usan.
Cada aviso tiene un código que se puede buscar en su documentación:

```console
$ shellcheck ordenar.sh

In ordenar.sh line 9:
        mv $f "$dir/otros/"
           ^-- SC2086 (info): Double quote to prevent globbing and word splitting.
```

En los ejercicios y en el proyecto, ShellCheck sin errores es condición para aprobar.
La mayoría de sus avisos se resuelven con las comillas dobles de la semana 4.

## bash -x

Cuando un *script* hace algo inesperado, lo más rápido es ver qué ejecuta de verdad.
`bash -x script.sh` muestra cada orden, ya expandida, antes de ejecutarla, precedida de `+`:

```console
$ bash -x resumen_log.sh -n 2 acceso.log
+ set -eu
+ top=10
+ codigos=()
+ log=
+ [[ 3 -gt 0 ]]
…
```

Para trazar solo una parte, se rodea esa parte con `set -x` y `set +x` dentro del *script*.
