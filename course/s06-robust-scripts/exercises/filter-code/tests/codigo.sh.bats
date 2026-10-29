bats_load_library check_helpers

@test "sin opciones muestra las peticiones con código 404" {
  run_script acceso.log
  assert_success
  assert_output "$(grep '" 404 ' acceso.log)"
}

@test "-c elige el código" {
  run_script -c 200 acceso.log
  assert_success
  assert_output "$(grep '" 200 ' acceso.log)"
}

@test "-n limita cuántas muestra" {
  run_script -n 1 acceso.log
  assert_success
  assert_output "$(grep -m1 '" 404 ' acceso.log)"
}

@test "las opciones van en cualquier orden, antes o después del log" {
  run_script acceso.log -n 2 -c 200
  assert_success
  assert_output "$(grep '" 200 ' acceso.log | head -n 2)"
}

@test "solo mira el código de estado, no los números de otros campos" {
  echo '10.0.0.9 - - [21/Oct/2026:11:00:00 +0200] "GET /404.html HTTP/1.1" 200 404' > raro.log
  run_script raro.log
  assert_success
  assert_output "" ||
    fail "La petición tiene código 200, aunque 404 aparezca en la ruta y en los bytes: compara solo el campo 9"
}

@test "-h muestra el uso por la salida estándar y termina con código 0" {
  run_script -h
  assert_success
  assert_output --partial "Uso:"
}

@test "funciona con un log cuyo nombre tiene espacios" {
  cp acceso.log "acceso de hoy.log"
  run_script -c 200 "acceso de hoy.log"
  assert_success
  assert_output "$(grep '" 200 ' acceso.log)"
}

@test "una opción desconocida es un error por stderr con código 1" {
  run_script -x acceso.log
  assert_failure 1
  assert_stderr --partial "opción desconocida: -x"
  assert_output ""
}

@test "a -c o -n sin valor, o con uno no válido, es un error por stderr con código 1" {
  run_script acceso.log -c
  assert_failure 1
  assert_stderr --partial "a -c le falta el código"
  run_script -c abc acceso.log
  assert_failure 1
  assert_stderr --partial "código no válido: abc"
  run_script -n 0 acceso.log
  assert_failure 1
  assert_stderr --partial "número no válido: 0"
}

@test "sin log es un error por stderr con código 1" {
  run_script -c 200
  assert_failure 1
  assert_stderr --partial "falta el log"
}

@test "si no puede leer el log, muestra un error por stderr y termina con código 2" {
  run_script no_existe.log
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.log"
  assert_output ""
}
