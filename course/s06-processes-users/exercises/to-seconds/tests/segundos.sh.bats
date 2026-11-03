bats_load_library check_helpers

setup() {
  cd "$CHECK_WORKDIR" || return
  printf '59:59\n1:05:10\n2-03:00:00\n' > tiempos.txt
}

@test "pasa a segundos los tres formatos de etime" {
  run_script tiempos.txt
  assert_success
  assert_output $'59:59 3599\n1:05:10 3910\n2-03:00:00 183600'
}

@test "acepta ceros a la izquierda, como 08:09" {
  printf '08:09\n00:09:08\n' > ceros.txt
  run_script ceros.txt
  assert_success
  assert_output $'08:09 489\n00:09:08 548' ||
    fail "En \$(( )), 08 y 09 se leen en octal y dan error: usa 10#\$h, o haz la cuenta en awk"
}

@test "funciona con un fichero cuyo nombre tiene espacios" {
  cp tiempos.txt "tiempos de hoy.txt"
  run_script "tiempos de hoy.txt"
  assert_success
  assert_line --index 0 "59:59 3599"
}

@test "avisa por stderr de las líneas que no son tiempos, sigue con las demás y termina con código 3" {
  printf '1:00\nabc\n1:2:3:4\n2:00\n' > mal.txt
  run_script mal.txt
  assert_failure 3
  assert_output $'1:00 60\n2:00 120'
  assert_stderr --partial "línea 2: «abc» no es un tiempo"
  assert_stderr --partial "línea 3: «1:2:3:4» no es un tiempo"
}

@test "sin un argumento muestra el uso por stderr y termina con código 1" {
  run_script
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si no puede leer el fichero, muestra un error por stderr y termina con código 2" {
  run_script no_existe.txt
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.txt"
  assert_output ""
}
