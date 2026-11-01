`trafico.sh` recibe un *log* de acceso, como `acceso.log`, y muestra una tabla con cuántas peticiones ha hecho cada IP y cuántos bytes ha recibido, de más a menos bytes.

## Qué tiene que hacer

- La IP es el primer campo de cada línea y los bytes, el último.
- Muestra una cabecera, `IP PETICIONES BYTES`, y una fila por IP.
- Cada fila tiene la IP alineada a la izquierda en 15 caracteres, y las peticiones y los bytes alineados a la derecha en 10 y 8, separados por un espacio, como la cabecera.
- Funciona con nombres que tienen espacios, como `acceso de hoy.log`.

```console
$ bash trafico.sh acceso.log
IP              PETICIONES    BYTES
192.168.1.10             3    13972
172.16.0.3               1     5120
10.0.0.7                 2     1024
```

## Errores

Los mensajes de error van al error estándar, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe un argumento | `Uso: trafico.sh <log>` | 1 |
| No puede leer el log | `Error: no se puede leer LOG` | 2 |

::: details Pista

Son dos patrones de la semana: «Agregar por clave con awk», que suma por IP, y «Tablas alineadas» con `printf`.
La cabecera va fuera de la tubería, para que `sort` no la ordene con los datos.

:::
