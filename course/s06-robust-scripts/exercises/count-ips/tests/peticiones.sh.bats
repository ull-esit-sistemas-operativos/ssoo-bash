bats_load_library check_helpers

@test "cuenta las peticiones de una IP" {
  run_script -i 192.168.1.10 acceso.log
  assert_success
  assert_output "192.168.1.10: 3"
}

@test "-i admite varias IP, en el orden en que se dan, y una sin peticiones tiene 0" {
  run_script -i 10.0.0.7 1.2.3.4 172.16.0.3 acceso.log
  assert_success
  assert_output $'10.0.0.7: 2\n1.2.3.4: 0\n172.16.0.3: 1'
}

@test "el log puede ir antes de -i" {
  run_script acceso.log -i 10.0.0.7 172.16.0.3
  assert_success
  assert_output $'10.0.0.7: 2\n172.16.0.3: 1'
}

@test "la IP tiene que coincidir entera" {
  echo '10.0.0.70 - - [21/Oct/2026:11:00:00 +0200] "GET / HTTP/1.1" 200 100' > otro.log
  cat acceso.log >> otro.log
  run_script -i 10.0.0.7 otro.log
  assert_output "10.0.0.7: 2" ||
    fail "10.0.0.70 no es 10.0.0.7: compara el primer campo entero, no busques el texto en la línea"
}

@test "funciona con un log cuyo nombre tiene espacios" {
  cp acceso.log "acceso de hoy.log"
  run_script -i 10.0.0.7 "acceso de hoy.log"
  assert_success
  assert_output "10.0.0.7: 2"
}

@test "sin -i, o sin IP detrás, es un error por stderr con código 1" {
  run_script acceso.log
  assert_failure 1
  assert_stderr --partial "falta -i con al menos una IP"
  run_script -i acceso.log
  assert_failure 1
  assert_stderr --partial "falta -i con al menos una IP"
  assert_output ""
}

@test "una opción desconocida es un error por stderr con código 1" {
  run_script -x acceso.log
  assert_failure 1
  assert_stderr --partial "opción desconocida: -x"
}

@test "si no puede leer el log, muestra un error por stderr y termina con código 2" {
  run_script -i 10.0.0.7 no_existe.log
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.log"
  assert_output ""
}
