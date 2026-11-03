Mientras una orden larga se ejecuta, la terminal queda ocupada.
¿Podemos seguir trabajando sin abrir otra?

Un **trabajo** es una orden lanzada desde la *shell* actual, que la *shell* numera y controla.
En cada terminal solo un trabajo puede estar en primer plano, recibiendo lo que tecleamos.
El resto puede estar en segundo plano o detenido.

- **`orden &`.**
  Lanza la orden directamente en segundo plano.
- **[[Ctrl]]+[[Z]].**
  Detiene el trabajo en primer plano.
- **`jobs`.**
  Lista los trabajos de la *shell* con su número.
- **`bg %n`.**
  Reanuda en segundo plano el trabajo detenido número n.
- **`fg %n`.**
  Trae el trabajo n al primer plano.
- **`kill %n`.**
  Envía una señal al trabajo n sin necesidad de conocer su PID.

![Estados de un trabajo y órdenes que los cambian](images/jobs.svg)

```console
$ sleep 300 &
[1] 4821
$ jobs
[1]+  Ejecutando              sleep 300 &
$ fg %1
sleep 300
^Z
[1]+  Detenido                sleep 300
$ bg %1
[1]+ sleep 300 &
$ kill %1
```

El número entre corchetes es el del trabajo y el otro, el PID.
En tu máquina estos números serán distintos.
Los trabajos pertenecen a la *shell* que los lanzó; por eso, desde otra terminal no aparecen en `jobs`, aunque sí en `ps`.

## En un *script*: `$!` y `wait`

En un *script* no se usan `fg`, `bg` ni [[Ctrl]]+[[Z]], pero sí `&`, que sirve para ejecutar varias órdenes a la vez y esperarlas después.
Justo después de lanzar una orden con `&`, **`$!`** contiene el PID de ese proceso.
Conviene guardarlo en una variable, porque la siguiente orden con `&` lo cambia.

**`wait PID`** espera a que termine ese proceso y acaba con su mismo estado de salida.
Así que, con `$?`, poniendo el `wait` en un `if` o con `||`, sabemos si la orden se ejecutó con éxito.
Sin argumentos, `wait` espera a todos los procesos que el *script* lanzó en segundo plano.

```bash
sort -u ventas_enero.txt > enero.txt &
pid_enero=$!
sort -u ventas_febrero.txt > febrero.txt &
pid_febrero=$!

wait "$pid_enero" || echo "falló la ordenación de enero" >&2
wait "$pid_febrero" || echo "falló la ordenación de febrero" >&2
```

Las dos ordenaciones se ejecutan a la vez, y el *script* no continúa hasta que acaban las dos.

Si el proceso terminó por una señal, `wait` acaba con 128 más el número de la señal:

```bash
sleep 300 &
pid=$!
kill "$pid"
wait "$pid"
echo $?        # 143, es decir, 128 + 15 (SIGTERM)
```

Por ejemplo, si murió por `SIGKILL`, el estado de salida sería 137, porque es 128 + 9.

Los procesos en segundo plano reciben `SIGHUP` cuando se cierra la terminal, y casi todos terminan con ella.
**`nohup orden &`** lanza `orden` en segundo plano ignorando esa señal y, si la salida estándar iba a la terminal, la redirige a `nohup.out`.
