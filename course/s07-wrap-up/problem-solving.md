Ante un problema nuevo, la tentación es empezar a escribir código desde el primer minuto.
Suele salir caro, pues es muy típico que a mitad de camino se descubra que una opción cambiaba el formato de la salida o que faltaba un caso.
Este procedimiento evita esas sorpresas:

1. **Leer entero y anotar.**
   Qué recibe el *script* (argumentos, opciones, variables de entorno), qué debe mostrar exactamente y qué errores hay que detectar.
2. **Traducir a competencias.**
   Junto a cada requisito, la competencia y el patrón que lo resuelve: «usuarios sin procesos» es una diferencia de conjuntos; «total por usuario», agregar por clave.
3. **Escribir el esqueleto.**
   El de la sección siguiente, adaptado a las opciones que necesitamos.
   Al acabar, el *script* ya muestra la ayuda y rechaza los argumentos incorrectos aunque no haga nada más.
4. **Construir el trabajo en la terminal.**
   Cada tubería se prueba primero en la terminal con datos reales, añadiendo un eslabón cada vez, y solo cuando funciona se copia al *script*.
5. **Probar los casos límite.**
   Sin argumentos, con un fichero que no existe, con un nombre con espacios, con una opción desconocida y con una lista vacía.
6. **Repasar.**
   ShellCheck, la salida carácter a carácter frente a lo que se pedía y el estado de salida en cada caso.

Lo importante es no saltarse los pasos 1 a 3.
Un *script* que valida bien sus argumentos y hace la mitad del trabajo vale más que uno que lo hace todo y falla con la primera entrada inesperada.
