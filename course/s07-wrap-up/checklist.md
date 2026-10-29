Repasa esta lista con el *script* terminado.
Cada punto corresponde a un fallo frecuente:

- [ ] Tiene *shebang* y permiso de ejecución, y se ejecuta con `./`.
- [ ] ShellCheck no muestra errores.
- [ ] Todas las expansiones de variables y de comandos van entre comillas dobles.
- [ ] Sin argumentos, muestra un error o la ayuda, y termina con estado distinto de 0.
- [ ] Con un fichero que no existe, avisa con un mensaje propio.
- [ ] Funciona con nombres que contienen espacios.
- [ ] Rechaza las opciones desconocidas y las que no traen su valor.
- [ ] Los errores van al error estándar y los resultados a la salida estándar.
- [ ] La salida es exactamente la pedida: cabecera, columnas, orden y desempate.
- [ ] No deja ficheros temporales.
