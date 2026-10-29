¿Qué proceso lleva más tiempo en marcha, o cuánto pasó entre la primera y la última petición del *log*?
Con tiempos escritos como `1:05:10` no se puede comparar ni restar: primero hay que pasarlos a segundos.

## El problema

`ps -o etime` da el tiempo en marcha con un formato que cambia según lo largo que sea: `05:10` (minutos y segundos), `1:05:10` (horas) o `2-03:04:05` (días).
El *log* escribe la hora como `10:15:32`.

## Soluciones

### awk, campo a campo

Se separa por `:` y se recorren los campos de izquierda a derecha, multiplicando por 60 en cada paso.
El mismo programa sirve para `mm:ss` y para `hh:mm:ss`:

```console
$ echo 1:05:10 | awk -F: '{ s = 0; for (i = 1; i <= NF; i++) s = s * 60 + $i; print s }'
3910
$ echo 05:10 | awk -F: '{ s = 0; for (i = 1; i <= NF; i++) s = s * 60 + $i; print s }'
310
```

Si puede haber días, se separan antes por el guion:

```bash
awk '{
    d = 0
    if (index($0, "-")) { split($0, p, "-"); d = p[1]; $0 = p[2] }
    n = split($0, t, ":")
    s = 0
    for (i = 1; i <= n; i++) s = s * 60 + t[i]
    print d * 86400 + s
}'
```

Con `2-03:04:05` da `183845`.

### bash, con read y aritmética

Si el formato es fijo, `read` reparte las partes en variables y `$(( ))` hace la cuenta.
`10#` obliga a leer en base 10:

```bash
t=08:09:10
IFS=: read -r h m s <<< "$t"
echo $(( 10#$h * 3600 + 10#$m * 60 + 10#$s ))    # 29350
```

`<<<` pasa el contenido de la variable como entrada estándar de `read`.

### date, para fechas completas

Si hay día y hora, `date -d` convierte la fecha a segundos desde 1970 y se restan:

```console
$ echo $(( $(date -d '2026-10-21 10:18:44' +%s) - $(date -d '2026-10-21 10:15:32' +%s) ))
192
```

### Pedir los segundos directamente

Con `ps`, lo más sencillo es no convertir: la columna `etimes` ya da el tiempo en segundos, en lugar de `etime`.

### Cuándo usar cada una

| Forma | Cuándo |
| --- | --- |
| `ps -o etimes` | El tiempo viene de `ps` |
| `awk` campo a campo | El número de partes varía, o hay que convertir muchas líneas |
| `read` y `$(( ))` | Un solo valor con formato fijo, dentro de un *script* |
| `date -d` | Fechas completas, que pueden cruzar de un día a otro |

## En otros contextos

```bash
# Log: segundos entre la primera y la última petición del mismo día
primera=$(head -n 1 acceso.log | cut -d: -f2-4 | cut -d' ' -f1)
ultima=$(tail -n 1 acceso.log | cut -d: -f2-4 | cut -d' ' -f1)
echo "$primera $ultima" | awk '{ split($1, a, ":"); split($2, b, ":");
    print (b[1] * 3600 + b[2] * 60 + b[3]) - (a[1] * 3600 + a[2] * 60 + a[3]) }'

# Log: la fecha completa de una línea, en segundos
s='21/Oct/2026:10:15:32'
date -d "$(echo "${s%%:*} ${s#*:}" | tr / ' ')" +%s
```

El primero da `192`: de `10:15:32` a `10:18:44`.
En el segundo, `date -d` no entiende el formato del *log*, así que se convierte antes a `21 Oct 2026 10:15:32`.

## Errores frecuentes

**Ceros a la izquierda en bash.**
En `$(( ))`, un número que empieza por 0 se lee en octal, y `08` y `09` no existen en octal:

```console
$ h=08; echo $(( h * 3600 ))
bash: 08: value too great for base (error token is "08")
```

Se evita con `10#$h`, o haciendo la cuenta en `awk`, que no tiene este problema.

**Los días de `etime`.**
Si se separa por `[-:]` sin tratar el guion aparte, el día se toma como horas: `2-03:04:05` da `443045` en lugar de `183845`.

**Suponer siempre `hh:mm:ss`.**
`etime` omite las horas cuando son cero.
Un programa que tome siempre el primer campo como horas lee `05:10` como cinco horas y diez minutos.

**Pasar de un día a otro.**
Restando solo las horas, una petición a las 23:59 y la siguiente a las 00:01 dan un resultado negativo.
Si las fechas pueden cambiar de día, `date -d`.

## Ver también

[Ficha de `awk`](../../s04-expansions-loops/cards/awk.md) · [ficha de `ps`](../cards/ps.md)
