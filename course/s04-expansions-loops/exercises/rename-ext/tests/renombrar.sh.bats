bats_load_library check_helpers

# Las pruebas comparten el directorio: cada una empieza con un apuntes nuevo.
setup() {
  cd "$CHECK_WORKDIR" || return
  rm -rf apuntes "mis apuntes"
  mkdir apuntes
  touch "apuntes/tema 1.txt" apuntes/tema2.txt apuntes/informe.final.txt apuntes/lista.csv
}

@test "cambia .txt por .md en los ficheros que la tienen" {
  run_script apuntes txt md
  assert_success
  assert_file_exists "apuntes/tema 1.md"
  assert_file_exists apuntes/tema2.md
  assert_file_not_exists apuntes/tema2.txt
}

@test "dice cada cambio con el nombre de antes y el de después" {
  run_script apuntes txt md
  assert_line "apuntes/tema 1.txt -> apuntes/tema 1.md"
  assert_line "apuntes/tema2.txt -> apuntes/tema2.md"
  ((${#lines[@]} == 3)) || fail "Se esperaban 3 líneas, una por fichero .txt, y han salido ${#lines[@]}"
}

@test "solo cambia la última extensión" {
  run_script apuntes txt md
  [[ -e apuntes/informe.final.md ]] ||
    fail "No está apuntes/informe.final.md: \${f%.*} quita la última extensión y \${f%%.*}, todas desde el primer punto"
}

@test "no toca los ficheros con otra extensión" {
  run_script apuntes txt md
  assert_file_exists apuntes/lista.csv
}

@test "funciona con un directorio cuyo nombre tiene espacios" {
  mkdir "mis apuntes"
  touch "mis apuntes/a b.txt"
  run_script "mis apuntes" txt md
  assert_success
  assert_file_exists "mis apuntes/a b.md"
}

@test "sin tres argumentos muestra el uso por stderr y termina con código 1" {
  run_script apuntes txt
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si no es un directorio, muestra un error por stderr y termina con código 2" {
  run_script no_existe txt md
  assert_failure 2
  assert_stderr --partial "no_existe no es un directorio"
}

@test "si no hay ficheros con esa extensión, lo dice por stderr y termina con código 3" {
  run_script apuntes pdf md
  ((status == 3)) ||
    fail "Se esperaba el código de salida 3 y ha sido $status: si el comodín no encaja con nada, el for recibe el patrón tal cual, apuntes/*.pdf"
  assert_stderr --partial "no hay ficheros .pdf en apuntes"
  assert_output ""
  [[ ! -e "apuntes/*.md" ]] || fail "Se ha creado «apuntes/*.md»: comprueba con -e que el fichero existe antes de moverlo"
}
