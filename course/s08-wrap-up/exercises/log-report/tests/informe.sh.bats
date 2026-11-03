bats_load_library check_helpers

# Las pruebas comparten el directorio: cada una empieza sin el informe.
setup() {
  cd "$CHECK_WORKDIR" && rm -f informe.txt "informe de hoy.txt"
}

@test "cuenta las peticiones de cada código de estado, ordenados" {
  run_script acceso.log
  assert_success
  assert_output $'200: 3\n404: 3'
}

@test "con varios logs, suma las peticiones de todos" {
  echo '10.0.0.9 - - [22/Oct/2026:09:00:00 +0200] "GET /x HTTP/1.1" 500 0' > otro.log
  run_script acceso.log otro.log
  assert_success
  assert_output $'200: 3\n404: 3\n500: 1'
}

@test "-o guarda el informe en el fichero y lo dice" {
  run_script -o informe.txt acceso.log
  assert_success
  assert_output "Informe guardado en informe.txt"
  run cat informe.txt
  assert_output $'200: 3\n404: 3'
}

@test "funciona con nombres que tienen espacios, en los logs y en -o" {
  cp acceso.log "acceso de hoy.log"
  run_script "acceso de hoy.log" -o "informe de hoy.txt"
  assert_success
  assert_file_exists "informe de hoy.txt"
}

@test "sin logs es un error por stderr con código 1" {
  run_script -o informe.txt
  assert_failure 1
  assert_stderr --partial "falta al menos un log"
  assert_output ""
}

@test "a -o sin fichero, o una opción desconocida, es un error por stderr con código 1" {
  run_script acceso.log -o
  assert_failure 1
  assert_stderr --partial "a -o le falta el fichero"
  run_script -x acceso.log
  assert_failure 1
  assert_stderr --partial "opción desconocida: -x"
}

@test "si no puede leer algún log, muestra un error por stderr, termina con código 2 y no crea el informe" {
  run_script -o informe.txt acceso.log no_existe.log
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.log"
  [[ ! -e informe.txt ]] || fail "Se ha creado informe.txt: comprueba todos los logs antes de escribir nada"
}
