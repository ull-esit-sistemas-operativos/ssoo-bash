`limite.sh` recibe un número de segundos y una orden con sus argumentos.
Ejecuta la orden y, si no ha terminado cuando pasa ese tiempo, la para.

## Qué tiene que hacer

- Lanza la orden en segundo plano y comprueba cada segundo si sigue viva.
- Si la orden termina a tiempo, muestra `ORDEN: ha terminado con código N` y termina con ese mismo código.
  No espera el tiempo que falte: si la orden tarda medio segundo, `limite.sh` tampoco tarda mucho más.
- Si pasa el tiempo y la orden sigue viva, le envía `SIGTERM`, espera a que termine, muestra `ORDEN: no ha terminado en N s y se ha parado` y termina con código 124, el mismo que usa el comando `timeout`.
- `ORDEN` es la orden con sus argumentos, separados por espacios.
- Pasa los argumentos a la orden tal cual, también los que tienen espacios.

```console
$ bash limite.sh 5 sleep 1
sleep 1: ha terminado con código 0
$ bash limite.sh 2 sleep 60
sleep 60: no ha terminado en 2 s y se ha parado
$ echo $?
124
$ bash limite.sh 3 grep -q root /etc/passwd
grep -q root /etc/passwd: ha terminado con código 0
```

A diferencia de los otros ejercicios de la semana, este trabaja con procesos reales: los que lanza el propio *script*.
Mientras pruebas `bash limite.sh 30 sleep 60`, abre otro terminal y mira con `ps` cómo aparece el `sleep` y desaparece cuando se para.

## Errores

Los mensajes de error van al error estándar, y no se ejecuta la orden:

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| Recibe menos de dos argumentos | `Uso: limite.sh <segundos> <orden> [argumentos]...` | 1 |
| Los segundos no son un número entero mayor que 0 | `Error: SEGUNDOS no es un número de segundos` | 1 |

::: details Pista

Guarda los segundos y quítalos de los argumentos con `shift`, que elimina el primero: después, `"$@"` es la orden con sus argumentos y `"$*"`, la misma orden en una sola cadena para el mensaje.
`shift` se explica con detalle en la semana 6.

`"$@" &` lanza la orden y `$!` da su PID.
Un bucle con `kill -0` y `sleep 1` comprueba cada segundo si sigue viva, y un contador lleva la cuenta del tiempo.
Al salir del bucle, `wait` da el código con que terminó la orden.

:::
