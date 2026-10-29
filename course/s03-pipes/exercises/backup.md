`copia_seguridad.sh` recibe el nombre de un fichero del directorio actual y guarda una copia en el directorio `copias`, con `.bak` añadido al nombre.

## Qué tiene que hacer

- Crea `copias` si no existe, y no falla si ya existe.
- Copia el fichero, sin moverlo, a `copias/FICHERO.bak`, y lo dice.
- Funciona con nombres que tienen espacios: `mi texto.txt` se copia en `copias/mi texto.txt.bak`.

```console
$ bash copia_seguridad.sh texto.txt
Copia guardada en copias/texto.txt.bak
$ ls copias
texto.txt.bak
```

## Errores

Los mensajes de error van al error estándar, la salida estándar queda vacía y no se crea `copias`:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe un argumento | `Uso: copia_seguridad.sh <fichero>` | 1 |
| El argumento no es un fichero normal (no existe o es un directorio) | `Error: FICHERO no es un fichero` | 2 |

Las pruebas ejecutan tu *script* sobre una copia nueva de los datos de la semana, así que tus pruebas en el terminal no les afectan.
Si borras algún fichero de datos, vuelve a abrir esta página para recuperarlo.

::: details Pista

Comprueba los errores antes de crear nada.
`mkdir` tiene una opción para no fallar si el directorio ya existe.

:::
