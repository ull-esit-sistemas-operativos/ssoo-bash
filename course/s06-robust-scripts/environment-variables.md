A veces queremos cambiar el comportamiento de un *script* sin escribir la opción en cada ocasión.
Por ejemplo, que en nuestra cuenta muestre siempre 5 IP al listar direcciones.

Una **variable de entorno** es una variable que la *shell* pasa a todos los programas que ejecuta.
Las variables normales no se pasan: hay que marcarlas con `export`.
También se puede dar una variable a una sola orden, escribiéndola delante:

```bash
export RESUMEN_TOP=5                        # Para todas las órdenes de esta shell
RESUMEN_TOP=5 ./resumen_log.sh acceso.log   # Solo para esta ejecución
```

Dentro del *script*, usamos `${VAR:-defecto}`, que ya vimos en la semana 4: vale lo que tenga `VAR` si está definida y no vacía, y `defecto` en otro caso.
Su variante `${VAR:=defecto}` hace lo mismo y, además, asigna el valor a la variable.

```bash
top=${RESUMEN_TOP:-10}
```

Esta línea va antes del bucle de opciones.
Así, la prioridad queda como se espera: la opción `-n` gana a la variable de entorno, y esta al valor por defecto.

El comando `printenv` lista las variables de entorno de la *shell* actual.
