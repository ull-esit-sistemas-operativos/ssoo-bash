`normalizar.sh` recibe un directorio y renombra sus ficheros para que no tengan espacios ni mayúsculas.
Con `-n` solo dice qué haría.

## Qué tiene que hacer

- Cambia cada espacio del nombre por `_` y cada mayúscula por su minúscula: `Foto Playa.JPG` pasa a ser `foto_playa.jpg`.
- Por cada fichero que renombra muestra `ANTES -> DESPUÉS`, solo con los nombres, y al final `Renombrados N ficheros`.
- No toca los ficheros que ya están bien, los ocultos, los subdirectorios ni lo que hay dentro de ellos.
- Si ya existe un fichero con el nombre nuevo, no lo pisa: lo dice por el error estándar, sigue con los demás y al final termina con código 3.
- `-n` muestra lo mismo sin renombrar nada, y al final `Se renombrarían N ficheros`.
- La opción y el directorio van en cualquier orden.
- El nombre del directorio puede tener espacios y acabar en `/`.

Para probarlo, crea antes unos ficheros:

```console
$ mkdir fotos
$ touch 'fotos/Foto Playa.JPG' fotos/notas.txt 'fotos/Viaje a Roma.png'
$ bash normalizar.sh -n fotos
Foto Playa.JPG -> foto_playa.jpg
Viaje a Roma.png -> viaje_a_roma.png
Se renombrarían 2 ficheros
$ bash normalizar.sh fotos
Foto Playa.JPG -> foto_playa.jpg
Viaje a Roma.png -> viaje_a_roma.png
Renombrados 2 ficheros
$ ls fotos
foto_playa.jpg  notas.txt  viaje_a_roma.png
```

## Errores

Los mensajes de error van al error estándar, precedidos de `normalizar.sh: `:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| Falta el directorio | `falta el directorio` | 1 |
| Una opción que no existe | `opción desconocida: OPCIÓN` | 1 |
| No es un directorio | `DIRECTORIO no es un directorio` | 2 |
| Ya existe el nombre nuevo | `ya existe DESPUÉS; no se renombra ANTES` | 3 |

En los tres primeros casos no se renombra nada.

::: details Pista

`"$dir"/*` da los ficheros del directorio, sin los ocultos, y `[[ -f ]]` descarta los subdirectorios.
`${f##*/}` quita el directorio de la ruta, `${n// /_}` cambia todos los espacios y `${n,,}` pasa a minúsculas.
Cuenta los conflictos en una variable y termina con `exit 3` después del resumen.

:::
