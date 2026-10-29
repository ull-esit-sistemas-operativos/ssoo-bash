`sort` por defecto ordena usando el texto de la línea completa.
Para ordenar por un campo concreto hay que indicarle el separador y la clave:

- **`-t';'`** indica que los campos se separan por punto y coma; con `-t,` serían comas.
- **`-k3,3`** ordena por el campo 3 y solo por él.
  Sin el `,3`, la clave para ordenar iría del campo 3 al final de la línea.
- **Modificadores.**
  Se añaden a la clave: `nr` en `-k3,3nr` indica numérico (`n`) y de mayor a menor (`r`).
- **Desempate.**
  Si varias líneas tienen el mismo valor en el campo, se añade una segunda clave: `-k3,3nr -k1,1` ordena por nota y, a igual nota, por nombre.

```console
$ tail -n +2 notas_es.csv | sort -t';' -k3,3nr | head -n 3
marta;SSOO;9
marta;FP;8,5
ana;SSOO;7,5
```

> [!NOTE] Decimales y configuración regional
> `sort -n` también lee los decimales según la configuración regional.
> Con `notas_es.csv` ordena bien; con `notas.csv`, en un equipo en español, tomaría `7.5` como 75.
> Si quieres ordenar `notas.csv` sin conversión, es necesario llamar a `sort` como `LC_ALL=C sort` (ver el apartado «[Decimales y configuración regional](locale.md)»).
