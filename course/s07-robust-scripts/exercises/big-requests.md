`grandes.sh` recibe un *log* de acceso y muestra las peticiones de al menos `UMBRAL` bytes, una variable de entorno que vale 5000 si no se da.

## Qué tiene que hacer

- Muestra, de cada petición de `UMBRAL` bytes o más, la IP, la ruta y los bytes, separados por un espacio.
- La IP es el campo 1, la ruta el 7 y los bytes, el último.
- Lee el umbral de la variable de entorno `UMBRAL`, con 5000 como valor por defecto.
- Funciona con nombres que tienen espacios, como `acceso de hoy.log`.

```console
$ bash grandes.sh acceso.log
192.168.1.10 /index.html 5120
192.168.1.10 /tema1.html 8340
172.16.0.3 /index.html 5120
$ UMBRAL=6000 bash grandes.sh acceso.log
192.168.1.10 /tema1.html 8340
```

## Errores

Los mensajes de error van al error estándar, precedidos de `grandes.sh: `, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe un argumento | `uso: grandes.sh LOG` | 1 |
| `UMBRAL` no es un número | `UMBRAL no es un número: VALOR` | 1 |
| No puede leer el *log* | `no se puede leer LOG` | 2 |

::: details Pista

`${UMBRAL:-5000}` da el valor de `UMBRAL`, o 5000 si no está definida o está vacía, y con `set -u` no falla aunque no exista.
Pon el filtro en una función que reciba el *log* y el mínimo en variables `local`.

:::
