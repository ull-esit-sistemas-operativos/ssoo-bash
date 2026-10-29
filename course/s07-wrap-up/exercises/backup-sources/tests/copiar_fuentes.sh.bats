bats_load_library check_helpers

# Las pruebas comparten el directorio: cada una empieza sin copias.
setup() {
  cd "$CHECK_WORKDIR" && rm -rf copia "mi copia" "mi proyecto"
}

@test "copia main.c y util.h a copia/src y dice cuántos ha copiado" {
  run_script proyecto
  assert_success
  assert_output "Copiados 2 ficheros a copia"
  assert_file_exists copia/src/main.c
  assert_file_exists copia/src/util.h
  assert_files_equal proyecto/src/main.c copia/src/main.c
}

@test "solo copia los ficheros de C" {
  run_script proyecto
  assert_file_not_exists copia/README.md
  assert_file_not_exists "copia/docs/guía de uso.txt"
}

@test "copia, no mueve" {
  run_script proyecto
  assert_file_exists proyecto/src/main.c
}

@test "-d elige el destino" {
  run_script -d "mi copia" proyecto
  assert_success
  assert_output "Copiados 2 ficheros a mi copia"
  assert_file_exists "mi copia/src/main.c"
}

@test "mantiene la estructura de directorios, también con espacios en los nombres" {
  mkdir -p "mi proyecto/código fuente/listas" "mi proyecto/tests"
  touch "mi proyecto/código fuente/listas/lista enlazada.c" "mi proyecto/tests/prueba.c" "mi proyecto/raíz.h"
  run_script "mi proyecto"
  assert_success
  assert_output "Copiados 3 ficheros a copia"
  assert_file_exists "copia/código fuente/listas/lista enlazada.c"
  assert_file_exists copia/tests/prueba.c
  assert_file_exists "copia/raíz.h"
}

@test "sin directorio, o con una opción desconocida, es un error por stderr con código 1" {
  run_script
  assert_failure 1
  assert_stderr --partial "falta el directorio"
  run_script -x proyecto
  assert_failure 1
  assert_stderr --partial "opción desconocida: -x"
}

@test "si no es un directorio, muestra un error por stderr, termina con código 2 y no crea la copia" {
  run_script notas.csv
  assert_failure 2
  assert_stderr --partial "notas.csv no es un directorio"
  [[ ! -e copia ]] || fail "Se ha creado copia: comprueba el directorio antes de crear nada"
}
