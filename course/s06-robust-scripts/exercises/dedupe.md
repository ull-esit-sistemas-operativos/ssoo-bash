`sin_repetidas.sh` recibe un fichero y le quita las líneas repetidas, dejando la primera aparición de cada una en su sitio.
Trabaja con un fichero temporal, que borra siempre al terminar.

## Qué tiene que hacer

- Deja en el fichero cada línea una sola vez, en el orden en que aparecen por primera vez.
- Dice cuántas líneas ha quitado.
- El fichero conserva sus permisos.
- No deja ficheros temporales, ni cuando todo va bien ni cuando falla.
- Funciona con nombres que tienen espacios, como `mis colores.txt`.

```console
$ printf 'rojo\nverde\nrojo\nazul\n' > colores.txt
$ bash sin_repetidas.sh colores.txt
Quitadas 1 líneas repetidas de colores.txt
$ cat colores.txt
rojo
verde
azul
```

## Errores

Los mensajes de error van al error estándar, precedidos de `sin_repetidas.sh: `, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe un argumento | `uso: sin_repetidas.sh FICHERO` | 1 |
| No es un fichero que se pueda leer y escribir | `no se puede modificar FICHERO` | 2 |

::: details Pista

No se puede leer un fichero y redirigir la salida a él a la vez: `>` lo vacía antes de leerlo.
Escribe el resultado en un temporal de `mktemp` y bórralo con `trap … EXIT`.
`awk '!visto[$0]++'` deja la primera aparición de cada línea.
Para pasar el resultado al fichero, piensa qué hace `mv` con los permisos.

:::
