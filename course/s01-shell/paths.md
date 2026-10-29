Los ficheros de Linux se organizan en un único árbol de directorios que parte de la raíz, `/`.
Para nombrar un fichero tenemos que decir cómo llegar a él dentro de ese árbol.
¿Desde dónde empezamos a contar?

Cada *shell* tiene en todo momento un **directorio de trabajo**: el directorio desde el que se interpretan los nombres que no empiezan por `/`.
El comando `pwd` lo muestra y `cd` lo cambia.

Con eso podemos distinguir dos formas de escribir una ruta:

- **Ruta absoluta.**
  Empieza por `/` y describe el camino desde la raíz.
  Significa lo mismo sea cual sea el directorio de trabajo actual de la *shell*: `/home/alu/ssoo/datos`.
- **Ruta relativa.**
  No empieza por `/` y se interpreta desde el directorio de trabajo.
  Es decir, `ssoo/datos` solo lleva al mismo sitio que la ruta absoluta anterior si estamos en `/home/alu`.

Desde la raíz, la ruta absoluta a `datos` es `/home/alu/ssoo/datos`; desde `practicas`, la relativa es `../datos`:

```text
/
├── etc
├── home
│   └── alu
│       └── ssoo
│           ├── datos
│           └── practicas    ← tú estás aquí
└── usr
```

Las dos rutas llegan a `datos`, pero la relativa solo funciona si el directorio de trabajo es `practicas`.

En las rutas relativas son muy útiles algunos nombres especiales:

| Nombre | Significado |
| --- | --- |
| `.` | El directorio actual |
| `..` | El directorio padre |
| `~` | El directorio personal del usuario (`/home/alu`) |
| `cd -` | Vuelve al directorio en el que estábamos antes |
| `cd` sin argumentos | Vuelve al directorio personal del usuario |

Veamos una sesión completa.
Suponemos que en el directorio personal de `alu` existe `ssoo`, con dos subdirectorios, `practicas` y `datos`:

```console
alu@ull:~$ pwd
/home/alu
alu@ull:~$ cd ssoo/practicas
alu@ull:~/ssoo/practicas$ pwd
/home/alu/ssoo/practicas
alu@ull:~/ssoo/practicas$ cd ../datos
alu@ull:~/ssoo/datos$ pwd
/home/alu/ssoo/datos
alu@ull:~/ssoo/datos$ cd -
/home/alu/ssoo/practicas
alu@ull:~/ssoo/practicas$ cd
alu@ull:~$ pwd
/home/alu
```

Fíjate en `cd ../datos`: primero sube al padre de `practicas`, que es `ssoo`, y desde ahí entra en `datos`.
Y `cd -` imprime el directorio al que vuelve, para que sepamos dónde nos hemos quedado.
