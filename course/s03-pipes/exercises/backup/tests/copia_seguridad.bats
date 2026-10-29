bats_load_library check_helpers

# Las pruebas comparten el directorio: cada una empieza sin copias.
setup() {
  cd "$CHECK_WORKDIR" && rm -rf copias
}

@test "guarda la copia en copias/texto.txt.bak y lo dice" {
  run_script texto.txt
  assert_success
  assert_output "Copia guardada en copias/texto.txt.bak"
  assert_file_exists copias/texto.txt.bak
}

@test "la copia tiene el mismo contenido que el original" {
  run_script texto.txt
  assert_files_equal texto.txt copias/texto.txt.bak
}

@test "copia el fichero, no lo mueve" {
  run_script texto.txt
  [[ -f texto.txt ]] || fail "texto.txt ya no está: se esperaba copiarlo con cp, no moverlo con mv"
}

@test "se puede ejecutar dos veces aunque copias ya exista" {
  run_script texto.txt
  run_script colores.txt
  ((status == 0)) || fail "La segunda ejecución ha terminado con el código $status: mkdir falla si el directorio ya existe, salvo con -p"
  assert_file_exists copias/texto.txt.bak
  assert_file_exists copias/colores.txt.bak
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp texto.txt "mi texto.txt"
  run_script "mi texto.txt"
  assert_success
  assert_file_exists "copias/mi texto.txt.bak"
}

@test "sin argumentos muestra el uso por stderr, termina con código 1 y no crea copias" {
  run_script
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
  [[ ! -e copias ]] || fail "Se ha creado copias, pero sin argumentos no hay nada que copiar"
}

@test "si el fichero no existe, muestra un error por stderr y termina con código 2" {
  run_script no_existe.txt
  assert_failure 2
  assert_stderr --partial "no_existe.txt no es un fichero"
  assert_output ""
}

@test "un directorio no es un fichero: muestra un error y termina con código 2" {
  run_script proyecto
  assert_failure 2
  assert_stderr --partial "proyecto no es un fichero"
}
