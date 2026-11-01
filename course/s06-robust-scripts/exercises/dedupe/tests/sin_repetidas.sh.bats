bats_load_library check_helpers

# Los temporales van a un directorio propio, para comprobar que no queda ninguno.
setup() {
  cd "$CHECK_WORKDIR" || return
  export TMPDIR="$CHECK_WORKDIR/tmp"
  rm -rf "$TMPDIR"
  mkdir "$TMPDIR"
  printf 'rojo\nverde\nrojo\nazul\nverde\nrojo\n' > colores.txt
}

no_temporales() {
  local quedan
  quedan=$(ls -A "$TMPDIR")
  [[ -z $quedan ]] || fail "Han quedado ficheros temporales ($quedan): bórralos con trap 'rm -f \"\$tmp\"' EXIT"
}

@test "deja la primera aparición de cada línea, en su orden, y dice cuántas ha quitado" {
  run_script colores.txt
  assert_success
  assert_output "Quitadas 3 líneas repetidas de colores.txt"
  run cat colores.txt
  assert_output $'rojo\nverde\nazul'
}

@test "las líneas que solo se distinguen por los espacios del final cuentan como la misma" {
  printf 'rojo  \nverde\t\nrojo\nverde\n' > espacios.txt
  run_script espacios.txt
  assert_success
  assert_output "Quitadas 2 líneas repetidas de espacios.txt"
  run cat espacios.txt
  assert_output $'rojo\nverde' ||
    fail "Quita los espacios y tabuladores del final con sed antes de comparar: sed 's/[[:space:]]*\$//'"
}

@test "no deja ficheros temporales" {
  run_script colores.txt
  no_temporales
}

@test "el fichero conserva sus permisos" {
  chmod 640 colores.txt
  run_script colores.txt
  [[ $(stat -c %a colores.txt) == 640 ]] ||
    fail "Los permisos han pasado de 640 a $(stat -c %a colores.txt): mktemp crea el temporal con 600, y mv se los lleva; copia el contenido con cat \"\$tmp\" > \"\$fichero\""
}

@test "un fichero sin repetidas se queda igual" {
  printf 'a\nb\n' > limpio.txt
  run_script limpio.txt
  assert_success
  assert_output "Quitadas 0 líneas repetidas de limpio.txt"
  run cat limpio.txt
  assert_output $'a\nb'
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp colores.txt "mis colores.txt"
  run_script "mis colores.txt"
  assert_success
  run cat "mis colores.txt"
  assert_output $'rojo\nverde\nazul'
}

@test "sin un argumento muestra el uso por stderr y termina con código 1" {
  run_script
  assert_failure 1
  assert_stderr --partial "uso:"
  assert_output ""
}

@test "si no puede modificar el fichero, muestra un error por stderr, termina con código 2 y no deja temporales" {
  run_script no_existe.txt
  assert_failure 2
  assert_stderr --partial "no se puede modificar no_existe.txt"
  no_temporales
}
