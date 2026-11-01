Al abrir una terminal aparece una ventana con una línea de texto que espera a que escribamos algo.
Pero ¿quién entiende lo que tecleamos?
No es la terminal, que solo es una aplicación que muestra texto y recoge lo que pulsamos en el teclado.

> [!NOTE] Terminales y emuladores de terminal
> Originalmente, una terminal era un aparato aparte: una pantalla de texto y un teclado conectados a un ordenador central.
> Hoy usamos un **emulador de terminal**, un programa que imita aquella terminal dentro de una ventana y que, al abrirse, lanza una *shell*.
> Hay muchos emuladores de terminal: GNOME Terminal, Konsole, Windows Terminal o la terminal integrada de VS Code.
> Su aspecto y sus atajos cambian; por ejemplo, en muchos para copiar se usa [[Ctrl]]+[[Mayús]]+[[C]], porque [[Ctrl]]+[[C]] interrumpe la orden en ejecución.
> Pero las órdenes que escribimos son las mismas en todos, porque vienen determinadas por la *shell*.
> Linux ofrece además varias terminales virtuales sin entorno gráfico, a las que se llega con [[Ctrl]]+[[Alt]]+[[F1]], [[Ctrl]]+[[Alt]]+[[F2]], etc.; pero no las necesitaremos en el curso.

La ***shell*** es el programa que lee las órdenes que escribimos, las interpreta y pide al sistema operativo que las ejecute.
En casi todas las distribuciones de Linux la *shell* por defecto es bash (*Bourne Again Shell*), y es la que usaremos en este curso.
Existen otras, como sh, zsh o fish, que comparten con bash muchas de las características que veremos.

La línea que la *shell* muestra cuando está lista para recibir una orden es el ***prompt***.
Su aspecto depende de la configuración, pero suele tener esta forma:

```text
alu@ull:~/ssoo$
```

De izquierda a derecha vemos el usuario (`alu`), el nombre de la máquina (`ull`) y el directorio en el que estamos (`~/ssoo`).
El carácter final indica quién escribe: `$` para un usuario normal y `#` para el administrador (root).
En los ejemplos del curso el *prompt* se abrevia a `$`, salvo cuando importa el directorio en el que estamos.

Una **orden** tiene siempre la misma estructura: el nombre del comando, unas opciones que modifican su comportamiento y unos argumentos sobre los que actúa.
Todo ello separado por espacios.

```bash
ls -l /etc
```

Aquí `ls` es el comando, `-l` una opción y `/etc` un argumento.
Las opciones cortas empiezan por un guion y, generalmente, se pueden agrupar (`-la` equivale a `-l -a`).
Las opciones largas suelen empezar por dos guiones y no se agrupan (`--all`).

También podemos escribir varias órdenes en una misma línea separándolas con `;`.
La *shell* las ejecuta una detrás de otra y espera a que termine cada una antes de empezar la siguiente: `cd /etc; ls; cd`.

> [!NOTE] Si algo se queda colgado
> [[Ctrl]]+[[C]] interrumpe la orden que se está ejecutando y nos devuelve el *prompt*.
> Es lo primero que hay que probar cuando algo tarda demasiado o parece que no responde.
