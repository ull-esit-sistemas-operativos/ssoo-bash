La terminal premia a quien utiliza atajos para teclear poco.
Estas son las ayudas que más tiempo ahorran desde el primer día:

- **Autocompletado.**
  El tabulador completa nombres de comandos, ficheros y directorios.
  Si hay varias posibilidades, un segundo tabulador las lista.
- **Flechas.**
  Arriba y abajo recorren las órdenes anteriores.
- **[[Ctrl]]+[[R]].**
  Busca hacia atrás en el historial mientras escribimos.
  Cada nueva pulsación salta a la coincidencia anterior; [[Enter]] la ejecuta y las flechas la dejan lista para editar.
- **`!!`.**
  Se sustituye por la orden anterior completa.
  El uso típico es `sudo !!` cuando ejecutamos una orden que tenemos que repetir porque se nos olvidó usarla con `sudo`.
- **`!$`.**
  Se sustituye por el último argumento de la orden anterior.
- **[[Alt]]+[[.]].**
  Inserta el último argumento de la orden anterior; si se repite, va retrocediendo por las anteriores.

El **historial** es la lista de órdenes que hemos ejecutado, que bash guarda entre sesiones y que podemos ver con `history`.
Cuando usamos `!!` o `!$`, bash muestra la orden ya expandida antes de ejecutarla:

```console
alu@ull:~$ ls ssoo/practicas
info.sh  notas.txt
alu@ull:~$ cd !$
cd ssoo/practicas
```

> [!NOTE] Una nota sobre los alias
> Un alias es un nombre corto para una orden más larga: `alias ll='ls -l'` hace que `ll` liste en formato largo.
> Solo persiste hasta que cerramos la terminal, salvo que lo añadamos a un *script* de configuración de bash, como `~/.bashrc`.
> Los alias son una comodidad personal: no se expanden dentro de los *scripts*, así que nunca debemos contar con ellos al programar.
