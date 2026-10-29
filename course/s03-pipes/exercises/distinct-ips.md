`ips.sh` recibe un *log* de acceso, como `acceso.log`, y el nombre de un fichero de salida.
Guarda en ese fichero cada IP del *log* una sola vez, ordenadas, y dice cuántas son.

## Qué tiene que hacer

- La IP es el primer campo de cada línea del *log*, separado por un espacio.
- Escribe en el fichero de salida una IP por línea, sin repetir y en orden; si ya existía, sustituye su contenido.
- Muestra cuántas IP ha guardado y dónde.
- Funciona con nombres que tienen espacios, tanto el del *log* como el de la salida.

```console
$ bash ips.sh acceso.log ips.txt
3 IP distintas guardadas en ips.txt
$ cat ips.txt
10.0.0.7
172.16.0.3
192.168.1.10
```

## Errores

Los mensajes de error van al error estándar, la salida estándar queda vacía y no se crea el fichero de salida:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe dos argumentos | `Uso: ips.sh <log> <salida>` | 1 |
| No puede leer el *log* | `Error: no se puede leer LOG` | 2 |

::: details Pista

Para contar las líneas del fichero que acabas de escribir, `wc -l < fichero` muestra solo el número.
Recuerda que `>` crea el fichero de salida antes de ejecutar la orden, aunque esta falle.

:::
