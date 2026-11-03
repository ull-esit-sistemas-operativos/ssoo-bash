`sustituir.sh` cambia un identificador por otro en todos los ficheros de C de un directorio y sus subdirectorios, como cuando se cambia el nombre de una función.
Con `-n` solo dice en qué ficheros lo cambiaría, y con `-h` muestra la ayuda.

## Qué tiene que hacer

- Se usa como `sustituir.sh [-n] [-h] VIEJO NUEVO DIRECTORIO`, con las opciones delante.
- Cambia `VIEJO` por `NUEVO` en los `.c` y los `.h` del directorio y sus subdirectorios, y no toca los demás ficheros.
- Solo cambia `VIEJO` cuando es una palabra completa, así que al cambiar `suma`, `suma(1, 2)` cambia y `sumatorio` no.
- `VIEJO` y `NUEVO` tienen que ser identificadores de C, hechos de letras, cifras y `_`, sin empezar por una cifra.
- Por cada fichero que cambia muestra `FICHERO: N líneas`, con las líneas en las que aparece, ordenados por nombre.
  Al final muestra `Cambiado VIEJO por NUEVO en N ficheros`, o `No aparece VIEJO en DIRECTORIO` si no lo encuentra.
- `-n` muestra lo mismo sin cambiar nada, y al final `Se cambiaría VIEJO por NUEVO en N ficheros`.
- `-h` muestra cómo se usa y qué hace cada opción, y termina con éxito.
- Funciona con nombres que tienen espacios, en el directorio y en sus subdirectorios.

Para probarlo, crea antes un pequeño proyecto:

```console
$ mkdir -p calc/src
$ printf 'int suma(int a, int b);\n' > calc/src/suma.h
$ printf 'int sumatorio = 0;\nint main(void) { return suma(1, 2) + suma(3, 4); }\n' > calc/main.c
$ bash sustituir.sh -n suma sumar calc
calc/main.c: 1 líneas
calc/src/suma.h: 1 líneas
Se cambiaría suma por sumar en 2 ficheros
$ bash sustituir.sh suma sumar calc
calc/main.c: 1 líneas
calc/src/suma.h: 1 líneas
Cambiado suma por sumar en 2 ficheros
$ cat calc/main.c
int sumatorio = 0;
int main(void) { return sumar(1, 2) + sumar(3, 4); }
```

## Errores

Los mensajes de error van al error estándar, precedidos de `sustituir.sh: `, y no se cambia ningún fichero:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe tres argumentos | `uso: sustituir.sh [-n] [-h] VIEJO NUEVO DIRECTORIO` | 1 |
| Una opción que no existe | `opción desconocida: -OPCIÓN` | 1 |
| `VIEJO` o `NUEVO` no es un identificador | `NOMBRE no es un identificador de C` | 1 |
| No es un directorio | `DIRECTORIO no es un directorio` | 2 |

::: details Pista

La ayuda de `-h` cabe en un *here document*, dentro de una función `uso`, como en «El esqueleto».
`find … -print0 | xargs -0 -r grep -lw VIEJO` da los ficheros donde aparece la palabra, aunque sus nombres tengan espacios.
Sin `-r`, si no hay ningún fichero de C, `xargs` ejecuta `grep` sin ficheros, y `grep` se queda esperando a leer del teclado.
En `sed`, `\<` y `\>` marcan el principio y el final de una palabra, como en `grep`, y `sed -i` cambia el fichero en su sitio.
Comprobar que `VIEJO` es un identificador evita además que sus caracteres tengan un significado especial en la expresión regular.

:::
