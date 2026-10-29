`resumen_log.sh` recibe un *log* de acceso y muestra las 10 IP con más peticiones y cuántas respuestas fueron un 404.
Lo construimos en cuatro pasos.

1. **Comprobar el argumento.**
   Los mensajes van al error estándar y cada error tiene su propio estado de salida:

   ```bash
   if [[ $# -ne 1 ]]; then
       echo "Uso: $0 <log>" >&2
       exit 1
   fi
   log=$1
   if [[ ! -r $log ]]; then
       echo "Error: no se puede leer $log" >&2
       exit 2
   fi
   ```
2. **Las IP más frecuentes.**
   Es la tubería del apartado anterior:

   ```bash
   echo "Las 10 IP con más peticiones:"
   cut -d' ' -f1 "$log" | sort | uniq -c | sort -nr | head -n 10
   ```
3. **Contar los 404.**
   Guardamos los dos recuentos en variables para poder operar con ellos.
   Para guardar en una variable lo que imprime un comando se escribe `variable=$(comando)`.
   Esto es la sustitución de comandos, que estudiaremos a fondo la semana que viene.

   ```bash
   total=$(wc -l < "$log")
   errores=$(cut -d' ' -f9 "$log" | grep -c '^404$')
   ```
4. **Mostrar el porcentaje.**
   Un fichero vacío daría una división por cero, así que lo comprobamos antes:

   ```bash
   if [[ $total -eq 0 ]]; then
       echo "El log está vacío"
   else
       echo "Errores 404: $errores de $total ($(( errores * 100 / total ))%)"
   fi
   ```

**Resultado** con el *log* de ejemplo:

```console
$ ./resumen_log.sh acceso.log
Las 10 IP con más peticiones:
      3 192.168.1.10
      2 10.0.0.7
      1 172.16.0.3
Errores 404: 3 de 6 (50%)
```

Volveremos a `resumen_log.sh` en la semana 6 para añadirle opciones, como elegir cuántas IP mostrar o qué códigos contar.
