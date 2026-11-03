bats_load_library check_helpers

# Las pruebas comparten el directorio: cada una empieza sin registros.
setup() {
  cd "$CHECK_WORKDIR" && rm -f errores.log "mis errores.log"
}

@test "muestra cuántas peticiones tiene el log y cuántas han terminado en error" {
  run_script acceso.log
  assert_success
  assert_output "acceso.log: 6 peticiones, 3 con error"
}

@test "con varios logs, muestra una línea por log en el orden en que se dan" {
  printf '%s\n' '10.0.0.9 - - [22/Oct/2026:09:00:00 +0200] "GET /x HTTP/1.1" 500 0' \
    '10.0.0.9 - - [22/Oct/2026:09:00:01 +0200] "GET /y HTTP/1.1" 301 0' > otro.log
  run_script otro.log acceso.log
  assert_success
  assert_output $'otro.log: 2 peticiones, 1 con error\nacceso.log: 6 peticiones, 3 con error'
}

@test "si no puede leer un log, apunta el error en errores.log, sigue con los demás y termina con código 2" {
  run_script no_existe.log acceso.log
  assert_failure 2
  assert_output "acceso.log: 6 peticiones, 3 con error"
  assert_stderr --partial "no se han podido leer 1 logs; mira errores.log"
  assert_file_exists errores.log
  grep -q no_existe.log errores.log || fail "errores.log no menciona no_existe.log: redirige el error estándar de awk con 2>>"
}

@test "cada ejecución añade sus errores al registro, sin borrar los de antes" {
  run_script no_existe.log
  run_script otro_que_falta.log
  assert_failure 2
  grep -q no_existe.log errores.log ||
    fail "errores.log ya no tiene el error de la primera ejecución: usa 2>>, que añade, en lugar de 2>, que vacía el fichero"
  grep -q otro_que_falta.log errores.log || fail "errores.log no tiene el error de la segunda ejecución"
}

@test "-e elige el registro, y los nombres pueden tener espacios" {
  cp acceso.log "acceso de hoy.log"
  run_script -e "mis errores.log" "acceso de hoy.log" no_existe.log
  assert_failure 2
  assert_output "acceso de hoy.log: 6 peticiones, 3 con error"
  assert_stderr --partial "mira mis errores.log"
  grep -q no_existe.log "mis errores.log" || fail "mis errores.log no menciona no_existe.log"
  assert_file_not_exists errores.log
}

@test "sin logs muestra el uso por stderr y termina con código 1" {
  run_script
  assert_failure 1
  assert_stderr --partial "uso:"
  assert_output ""
}

@test "-e sin registro, o una opción desconocida, es un error por stderr con código 1" {
  run_script -e
  assert_failure 1
  assert_stderr --partial "a -e le falta el registro"
  run_script -x acceso.log
  assert_failure 1
  assert_stderr --partial "opción desconocida: -x"
  assert_output ""
}
