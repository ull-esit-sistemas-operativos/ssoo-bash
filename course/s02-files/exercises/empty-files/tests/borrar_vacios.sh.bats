bats_load_library check_helpers

# Las pruebas comparten el directorio: cada una empieza con el proyecto original.
setup() {
  cd "$CHECK_WORKDIR" || return
  rm -rf p
  cp -r proyecto p
}

@test "dice qué ficheros vacíos borra" {
  run_script p
  assert_success
  assert_line --index 0 "Ficheros vacíos borrados:"
  assert_line "p/README.md"
  assert_line "p/src/util.h"
  assert_line "p/docs/guía de uso.txt"
  ((${#lines[@]} == 4)) || fail "Se esperaban 4 líneas, el título y tres ficheros, y han salido ${#lines[@]}"
}

@test "borra los ficheros vacíos, también los que tienen espacios en el nombre" {
  run_script p
  assert_file_not_exists p/README.md
  assert_file_not_exists p/src/util.h
  assert_file_not_exists "p/docs/guía de uso.txt"
}

@test "no borra los ficheros con contenido, aunque estén ocultos" {
  run_script p
  assert_file_exists p/src/main.c
  assert_file_exists p/.oculto
}

@test "no borra los directorios, aunque se queden vacíos" {
  run_script p
  [[ -d p/docs ]] || fail "p/docs ya no está: hay que borrar solo ficheros, con -type f"
}

@test "funciona con un directorio cuyo nombre tiene espacios" {
  rm -rf "mi proyecto"
  cp -r proyecto "mi proyecto"
  run_script "mi proyecto"
  assert_success
  assert_file_not_exists "mi proyecto/README.md"
  assert_file_exists "mi proyecto/src/main.c"
}

@test "sin un argumento muestra el uso y termina con código 1" {
  run_script
  assert_failure 1
  assert_message "Uso:"
}

@test "si no es un directorio, muestra un error, termina con código 2 y no borra nada" {
  run_script no_existe
  assert_failure 2
  assert_message "Error: no_existe no es un directorio"
}
