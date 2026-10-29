bats_load_library check_helpers

@test "muestra la cabecera y una fila por IP, de más a menos bytes" {
  run_script acceso.log
  assert_success
  assert_output "$(printf '%-15s %10s %8s\n' IP PETICIONES BYTES 192.168.1.10 3 13972 172.16.0.3 1 5120 10.0.0.7 2 1024)"
}

@test "las columnas están alineadas: la IP a la izquierda en 15 caracteres y los números a la derecha" {
  run_script acceso.log
  assert_line --index 0 "IP              PETICIONES    BYTES"
  assert_line --index 3 "10.0.0.7                 2     1024" ||
    fail "Usa printf con %-15s para la IP y %10d y %8d para los números, separados por un espacio"
}

@test "la cabecera queda arriba aunque se ordene" {
  run_script acceso.log
  assert_line --index 0 --regexp '^IP +PETICIONES +BYTES$' ||
    fail "La cabecera no es la primera línea: imprímela con printf antes de la tubería, para que sort no la mezcle con los datos"
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  head -n 2 acceso.log > "acceso de hoy.log"
  run_script "acceso de hoy.log"
  assert_success
  assert_line --index 1 --regexp '^192\.168\.1\.10 +1 +5120$'
  assert_line --index 2 --regexp '^10\.0\.0\.7 +1 +512$'
}

@test "sin un argumento muestra el uso por stderr y termina con código 1" {
  run_script
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si no puede leer el log, muestra un error por stderr y termina con código 2" {
  run_script no_existe.log
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.log"
  assert_output ""
}
