¿Cómo le pedimos a un proceso que termine?
Lo que hacemos es avisarle.

Una **señal** es un aviso que el sistema o un proceso envía a otro proceso.
El destinatario puede atender la mayoría de las señales con un manejador propio, ignorarlas o dejar que se aplique la acción por defecto, que suele ser terminar.

| Señal | Número | Cuándo se envía | Se puede atender |
| --- | --- | --- | --- |
| `SIGHUP` | 1 | Se cierra la terminal | Sí |
| `SIGINT` | 2 | Pulsamos [[Ctrl]]+[[C]] | Sí |
| `SIGKILL` | 9 | `kill -KILL`: terminación inmediata | No |
| `SIGTERM` | 15 | `kill` sin opciones: petición de terminar | Sí |
| `SIGTSTP` | — | Pulsamos [[Ctrl]]+[[Z]] | Sí |
| `SIGSTOP` | — | Detiene el proceso | No |
| `SIGCONT` | — | Reanuda un proceso detenido | Sí |

Los números de las tres últimas dependen de la arquitectura, por eso conviene usar siempre los nombres.
`kill -l` los lista todos.

```bash
kill 4821             # envía SIGTERM
kill -s KILL 4821     # envía SIGKILL; equivale a kill -9 4821
```

Lo correcto es pedir primero la terminación con `SIGTERM`, que da al proceso ocasión de guardar su trabajo y borrar archivos temporales.
`SIGKILL` es el último recurso si el proceso no termina con `SIGTERM`.

Solo podemos enviar señales a nuestros propios procesos, salvo que seamos root.
