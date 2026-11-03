bats_load_library check_helpers

@test "sin opciones muestra las peticiones con código 404" {
  run_script acceso.log
  assert_success
  assert_output "$(grep '" 404 ' acceso.log)"
}

@test "-c y -n eligen el código y cuántas muestra" {
  run_script -c 200 -n 2 acceso.log
  assert_success
  assert_output "$(grep '" 200 ' acceso.log | head -n 2)"
}

@test "el valor puede ir pegado a la opción" {
  run_script -c200 -n1 acceso.log
  assert_success
  assert_output "$(grep -m1 '" 200 ' acceso.log)" ||
    fail "getopts admite -c200 igual que -c 200: el valor queda en OPTARG"
}

@test "una opción detrás del log es un argumento que sobra, por stderr con código 1" {
  run_script acceso.log -n 2
  assert_failure 1
  assert_stderr --partial "sobra el argumento: -n" ||
    fail "getopts se para en el log: después de shift \$((OPTIND - 1)), -n y 2 quedan como argumentos"
  assert_output ""
}

@test "-h muestra la ayuda por la salida estándar y termina con código 0" {
  run_script -h
  assert_success
  assert_line --index 0 "Uso: filtro.sh [-c CÓDIGO] [-n N] [-h] LOG"
  assert_line "  -c CÓDIGO  código de tres cifras (por defecto, 404)" ||
    fail "Escribe la ayuda completa del enunciado, con cat << EOF"
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
  run_script -c
  assert_failure 1
  assert_stderr --partial "a -c le falta el valor"
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
