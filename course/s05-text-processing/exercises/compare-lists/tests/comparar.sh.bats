bats_load_library check_helpers

setup() {
  cd "$CHECK_WORKDIR" || return
  printf 'pablo\nana\nmarta\nluis\nana\nraúl\n' > presentes.txt
}

@test "muestra qué alumnos están solo en cada lista" {
  run_script alumnos.txt presentes.txt
  assert_success
  assert_output $'Solo en alumnos.txt:\nsara\nSolo en presentes.txt:\nraúl'
}

@test "las listas no tienen que estar ordenadas y una línea repetida sale una vez" {
  printf 'b\na\nb\n' > x.txt
  printf 'c\n' > y.txt
  run_script x.txt y.txt
  assert_output $'Solo en x.txt:\na\nb\nSolo en y.txt:\nc' ||
    fail "comm necesita las dos entradas ordenadas: ordénalas con sort -u dentro de <( )"
}

@test "si las dos listas son iguales, solo muestra los títulos" {
  run_script alumnos.txt alumnos.txt
  assert_success
  assert_output $'Solo en alumnos.txt:\nSolo en alumnos.txt:'
}

@test "funciona con ficheros cuyo nombre tiene espacios" {
  cp presentes.txt "presentes hoy.txt"
  run_script alumnos.txt "presentes hoy.txt"
  assert_success
  assert_line --index 2 "Solo en presentes hoy.txt:"
}

@test "sin dos argumentos muestra el uso por stderr y termina con código 1" {
  run_script alumnos.txt
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si no puede leer un fichero, muestra un error por stderr y termina con código 2" {
  run_script alumnos.txt no_existe.txt
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.txt"
  assert_output ""
}
