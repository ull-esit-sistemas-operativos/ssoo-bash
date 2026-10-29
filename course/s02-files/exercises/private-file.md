`privado.sh` recibe un fichero y le quita todos los permisos del grupo y de los otros, de forma que solo su propietario pueda usarlo.
Después muestra cómo han quedado con `ls -l`.

## Qué tiene que hacer

- Quita la lectura, la escritura y la ejecución al grupo y a los otros.
- No cambia los permisos del propietario.
- Funciona con nombres que tienen espacios, como `mis notas.csv`.

```console
$ ls -l notas.csv
-rw-r--r-- 1 alu alu 117 oct 21 10:00 notas.csv
$ bash privado.sh notas.csv
-rw------- 1 alu alu 117 oct 21 10:00 notas.csv
```

## Errores

| Situación | Mensaje | Código de salida |
| --- | --- | --- |
| No recibe un argumento | `Uso: privado.sh <fichero>` | 1 |
| No es un fichero, o no existe | `Error: FICHERO no es un fichero` | 2 |

::: details Pista

`-f` comprueba que algo es un fichero normal, igual que `-d` comprueba que es un directorio.
En la notación simbólica de `chmod`, `=` sin permisos detrás los quita todos.

:::
