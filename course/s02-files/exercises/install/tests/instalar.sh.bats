bats_load_library check_helpers

# Las pruebas comparten el directorio: cada una empieza sin bin.
setup() {
  cd "$CHECK_WORKDIR" || return
  rm -rf bin
  printf '#!/bin/bash\necho "Hola"\n' > hola.sh
  chmod 644 hola.sh
}

@test "copia hola.sh a bin/hola.sh y lo dice" {
  run_script hola.sh
  assert_success
  assert_output "Instalado en bin/hola.sh"
  assert_file_exists bin/hola.sh
  assert_files_equal hola.sh bin/hola.sh
}

@test "la copia tiene permiso de ejecución y se puede ejecutar" {
  run_script hola.sh
  [[ -x bin/hola.sh ]] || fail "bin/hola.sh no tiene permiso de ejecución: falta chmod +x sobre la copia"
  run bin/hola.sh
  assert_output "Hola"
}

@test "copia el script, no lo mueve" {
  run_script hola.sh
  [[ -f hola.sh ]] || fail "hola.sh ya no está: se esperaba copiarlo con cp, no moverlo con mv"
}

@test "se puede ejecutar dos veces aunque bin ya exista" {
  run_script hola.sh
  cp hola.sh adios.sh
  run_script adios.sh
  ((status == 0)) || fail "La segunda ejecución ha terminado con el código $status: mkdir falla si el directorio ya existe, salvo con -p"
  assert_file_exists bin/adios.sh
}

@test "funciona con un script cuyo nombre tiene espacios" {
  cp hola.sh "mi script.sh"
  run_script "mi script.sh"
  assert_success
  [[ -x "bin/mi script.sh" ]] || fail "bin/mi script.sh no existe o no tiene permiso de ejecución"
}

@test "sin un argumento muestra el uso y termina con código 1" {
  run_script
  assert_failure 1
  assert_message "Uso:"
}

@test "si el script no existe, muestra un error, termina con código 2 y no crea bin" {
  run_script no_existe.sh
  assert_failure 2
  assert_message "Error: no_existe.sh no es un fichero"
  [[ ! -e bin ]] || fail "Se ha creado bin: comprueba el argumento antes de crear nada"
}
