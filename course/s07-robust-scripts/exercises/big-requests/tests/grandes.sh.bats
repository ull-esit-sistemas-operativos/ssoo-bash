bats_load_library check_helpers

setup() {
  unset UMBRAL
}

@test "sin UMBRAL muestra la IP, la ruta y los bytes de las peticiones de 5000 bytes o más" {
  run_script acceso.log
  assert_success
  assert_output $'192.168.1.10 /index.html 5120\n192.168.1.10 /tema1.html 8340\n172.16.0.3 /index.html 5120'
}

@test "UMBRAL cambia el mínimo" {
  UMBRAL=6000 run_script acceso.log
  assert_success
  assert_output "192.168.1.10 /tema1.html 8340"
}

@test "una petición de justo UMBRAL bytes cuenta" {
  UMBRAL=8340 run_script acceso.log
  assert_output "192.168.1.10 /tema1.html 8340"
}

@test "funciona con un log cuyo nombre tiene espacios" {
  cp acceso.log "acceso de hoy.log"
  UMBRAL=8000 run_script "acceso de hoy.log"
  assert_success
  assert_output "192.168.1.10 /tema1.html 8340"
}

@test "si UMBRAL no es un número, es un error por stderr con código 1" {
  UMBRAL=mucho run_script acceso.log
  assert_failure 1
  assert_stderr --partial "UMBRAL no es un número: mucho"
  assert_output ""
}

@test "sin un argumento muestra el uso por stderr y termina con código 1" {
  run_script
  assert_failure 1
  assert_stderr --partial "uso:"
  assert_output ""
}

@test "si no puede leer el log, muestra un error por stderr y termina con código 2" {
  run_script no_existe.log
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.log"
  assert_output ""
}
