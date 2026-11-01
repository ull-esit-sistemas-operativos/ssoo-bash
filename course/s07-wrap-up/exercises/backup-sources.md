`copiar_fuentes.sh` recibe un directorio y copia sus ficheros de C, los `.c` y los `.h`, también los de sus subdirectorios, a otro directorio, por defecto `copia`.
La copia mantiene la estructura de directorios del original.

## Qué tiene que hacer

- Copia cada fichero `.c` o `.h` a la misma ruta dentro del destino: `proyecto/src/main.c` va a `copia/src/main.c`.
- Crea los directorios que hagan falta, y no copia los demás ficheros.
- `-d DESTINO` elige el destino.
- Al terminar dice cuántos ficheros ha copiado.
- Funciona con nombres que tienen espacios, en el origen, en sus subdirectorios y en el destino.
- El directorio puede acabar en `/`: `bash copiar_fuentes.sh proyecto/` hace la misma copia.

```console
$ bash copiar_fuentes.sh proyecto
Copiados 2 ficheros a copia
$ find copia -type f
copia/src/main.c
copia/src/util.h
```

## Errores

Los mensajes de error van al error estándar, precedidos de `copiar_fuentes.sh: `, y no se crea el destino:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| Falta el directorio | `falta el directorio` | 1 |
| `-d` sin destino | `a -d le falta el directorio` | 1 |
| Una opción que no existe | `opción desconocida: OPCIÓN` | 1 |
| No es un directorio | `DIRECTORIO no es un directorio` | 2 |

::: details Pista

`find … -print0` y `while IFS= read -r -d '' f` recorren los ficheros aunque tengan espacios.
`${f#"$origen"/}` da la ruta dentro del origen, y `dirname` el directorio que hay que crear en el destino.
Si el origen acaba en `/`, quítasela antes con `${origen%/}`, o `${f#"$origen"/}` no quitará nada.

:::
