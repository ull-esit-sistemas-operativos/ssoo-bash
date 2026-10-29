bats_load_library check_helpers

# find no garantiza un orden: las pruebas comparan la salida ordenada.
sorted() { printf '%s\n' "$output" | LC_ALL=C sort; }

# Las pruebas comparten el directorio: cada una empieza sin los ficheros que añaden las otras.
setup() {
  cd "$CHECK_WORKDIR" && rm -rf proyecto/lib.c proyecto/otros "mi proyecto"
}

@test "lista main.c y util.h, que están en proyecto/src" {
  run_script proyecto
  assert_success
  [[ $(sorted) == $'proyecto/src/main.c\nproyecto/src/util.h' ]] ||
    fail "Se esperaba proyecto/src/main.c y proyecto/src/util.h, y ha salido:"$'\n'"$output"
}

@test "no lista otros ficheros ni directorios cuyo nombre acaba en c" {
  mkdir -p "proyecto/lib.c" proyecto/otros
  touch proyecto/otros/main.cpp proyecto/otros/notas.c.txt proyecto/otros/doc
  run_script proyecto
  refute_line --partial "main.cpp"
  refute_line --partial "notas.c.txt"
  refute_line "proyecto/otros/doc"
  refute_line "proyecto/lib.c"
}

@test "funciona con nombres que tienen espacios" {
  mkdir -p "mi proyecto/código fuente"
  touch "mi proyecto/código fuente/lista enlazada.c"
  run_script "mi proyecto"
  assert_success
  assert_output "mi proyecto/código fuente/lista enlazada.c"
}

@test "sin un argumento muestra el uso y termina con código 1" {
  run_script
  assert_failure 1
  assert_message "Uso:"
}

@test "si no es un directorio, muestra un error y termina con código 2" {
  run_script notas.csv
  assert_failure 2
  assert_message "Error: notas.csv no es un directorio"
}
