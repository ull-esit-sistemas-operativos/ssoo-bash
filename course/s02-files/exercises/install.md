`instalar.sh` recibe el nombre de un *script* del directorio actual, lo copia al directorio `bin` y le da permiso de ejecución, para poder ejecutarlo como `bin/SCRIPT`.

## Qué tiene que hacer

- Crea `bin` si no existe, y no falla si ya existe.
- Copia el *script*, sin moverlo, a `bin/SCRIPT`, le da permiso de ejecución y lo dice.
- Funciona con nombres que tienen espacios, como `mi script.sh`.

```console
$ bash instalar.sh hola.sh
Instalado en bin/hola.sh
$ bin/hola.sh
Hola
```

Para probarlo, crea antes un `hola.sh` que muestre `Hola`.

## Errores

En los dos casos el *script* termina sin crear `bin`:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe un argumento | `Uso: instalar.sh <script>` | 1 |
| No es un fichero, o no existe | `Error: SCRIPT no es un fichero` | 2 |

::: details Pista

`mkdir -p` no falla si el directorio ya existe.
El permiso de ejecución se da a la copia, `bin/SCRIPT`, no al original.

:::
