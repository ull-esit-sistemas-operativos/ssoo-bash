`peticiones.sh` recibe un *log* de acceso y, con la opción `-i`, una lista de IP, y muestra cuántas peticiones ha hecho cada una.

## Qué tiene que hacer

- `-i IP...` recibe una o varias IP; la lista termina donde empieza otro argumento que no es una IP.
- Muestra `IP: N` por cada IP de la lista, en el orden en que se dan; una IP sin peticiones tiene 0.
- La IP tiene que coincidir entera con el primer campo: `10.0.0.7` no es `10.0.0.70`.
- `-i` y el *log* van en cualquier orden.
- Funciona con nombres que tienen espacios, como `acceso de hoy.log`.

```console
$ bash peticiones.sh -i 10.0.0.7 1.2.3.4 acceso.log
10.0.0.7: 2
1.2.3.4: 0
$ bash peticiones.sh acceso.log -i 192.168.1.10
192.168.1.10: 3
```

## Errores

Los mensajes de error van al error estándar, precedidos de `peticiones.sh: `, y la salida estándar queda vacía:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| Falta `-i`, o no tiene ninguna IP | `falta -i con al menos una IP` | 1 |
| Una opción que no existe | `opción desconocida: OPCIÓN` | 1 |
| Falta el *log* | `falta el log` | 1 |
| No puede leer el *log* | `no se puede leer LOG` | 2 |

::: details Pista

Es el patrón «Opciones con lista»: la rama de `-i` añade a un *array* con `ips+=("$1")` mientras el argumento tenga forma de IP, que se comprueba con `=~`.

:::
