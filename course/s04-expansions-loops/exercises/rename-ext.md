`renombrar.sh` recibe un directorio y dos extensiones, y cambia la primera por la segunda en todos los ficheros del directorio que la tienen.

## Qué tiene que hacer

- Renombra cada fichero `NOMBRE.VIEJA` del directorio a `NOMBRE.NUEVA` y lo dice con una línea `ANTES -> DESPUÉS`.
- Solo cambia la última extensión: `informe.final.txt` pasa a `informe.final.md`.
- No toca los ficheros con otra extensión.
- Funciona con nombres que tienen espacios, como `tema 1.txt`.
- No sobrescribe ningún fichero: si `NOMBRE.NUEVA` ya existe, no lo renombra, lo dice por el error estándar y sigue con los demás.

```console
$ ls apuntes
informe.final.txt  lista.csv  tema 1.txt  tema2.txt
$ bash renombrar.sh apuntes txt md
apuntes/informe.final.txt -> apuntes/informe.final.md
apuntes/tema 1.txt -> apuntes/tema 1.md
apuntes/tema2.txt -> apuntes/tema2.md
```

Para probarlo, crea antes el directorio con `mkdir apuntes` y los ficheros con `touch`.

## Errores

Los mensajes de error van al error estándar.
En los tres primeros casos no se renombra nada y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe tres argumentos | `Uso: renombrar.sh <directorio> <extensión> <nueva extensión>` | 1 |
| No es un directorio | `Error: DIRECTORIO no es un directorio` | 2 |
| Ningún fichero tiene esa extensión | `Error: no hay ficheros .VIEJA en DIRECTORIO` | 3 |
| Ya existe un fichero con el nombre nuevo | `Error: DESPUÉS ya existe, no se renombra ANTES` | 4 |

::: details Pista

Es el patrón «Recorrer ficheros»: un `for` sobre `"$dir"/*."$vieja"`.
Si el comodín no encaja con nada, el bucle da una vuelta con el patrón tal cual, así que comprueba con `-e` que el fichero existe.
`-e` también sirve para ver si el nombre nuevo ya está ocupado; `continue` pasa al siguiente fichero.

:::
