¿Qué proceso lleva más tiempo en marcha, uno con `1:05:10` u otro con `59:59`?
Comparar tiempos escritos así es difícil.
Mejor pasarlos a segundos para comparar como números.

Cuando las partes están separadas por dos puntos, la siguiente orden con `awk` las convierte recorriéndolas de izquierda a derecha y multiplicando por 60 en cada paso.
El mismo programa sirve para `mm:ss` y para `hh:mm:ss`:

```console
$ echo 1:05:10 | awk -F: '{ s = 0; for (i = 1; i <= NF; i++) s = s * 60 + $i; print s }'
3910
```

Si el tiempo viene de `etime`, puede llevar además los días delante con un guion, como `2-03:04:05`.
El patrón «[Tiempos a segundos](patterns/times-to-seconds.md)» explica cómo separarlos.

El patrón se aplica igual a la hora de una línea del *log*.
Por ejemplo, en `[21/Oct/2026:10:15:32`, `cut -d: -f2-4` extrae `10:15:32`, que se puede convertir a segundos con la orden anterior.
Para procesos no hace falta convertir nada, porque la columna `etimes` de `ps` ya da los segundos.

> [!NOTE] Ceros a la izquierda en bash
> En `$(( ))`, un número que empieza por 0 se interpreta en octal, así que `$(( 08 + 1 ))` da error.
> Si los valores vienen de una hora como `08:09`, hay que forzar la base 10 con `10#$h`, o hacer la cuenta en `awk`, que no tiene este problema.

## Actuar según una condición

Con todo lo anterior podemos actuar solo sobre los procesos que cumplan algo.
Este bucle termina los `sleep` del usuario actual que lleven más de un minuto:

```bash
ps -u "$USER" -o pid= -o etimes= -o comm= | while read -r pid segs nombre; do
    if [[ $nombre == sleep && $segs -gt 60 ]]; then
        kill "$pid"
    fi
done
```
