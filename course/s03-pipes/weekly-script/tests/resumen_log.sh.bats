bats_load_library check_helpers

setup() {
  cd "$CHECK_WORKDIR" || return
}

@test "con acceso.log muestra las IP de más a menos peticiones" {
  run_script acceso.log
  assert_success
  assert_line --index 0 "Las 10 IP con más peticiones:"
  [[ ${lines[1]} =~ ^\ *3\ 192\.168\.1\.10$ ]] || fail "Se esperaba «3 192.168.1.10» en la segunda línea y ha salido «${lines[1]}»"
  [[ ${lines[2]} =~ ^\ *2\ 10\.0\.0\.7$ ]] || fail "Se esperaba «2 10.0.0.7» en la tercera línea y ha salido «${lines[2]}»"
  [[ ${lines[3]} =~ ^\ *1\ 172\.16\.0\.3$ ]] || fail "Se esperaba «1 172.16.0.3» en la cuarta línea y ha salido «${lines[3]}»"
}

@test "con acceso.log cuenta 3 errores 404 de 6 peticiones" {
  run_script acceso.log
  assert_line --index 4 "Errores 404: 3 de 6 (50%)"
}

@test "muestra solo las 10 IP con más peticiones" {
  local i
  for i in $(seq 1 12); do
    echo "10.0.0.$i - - [21/Oct/2026:10:00:00 +0200] \"GET / HTTP/1.1\" 200 100"
  done > grande.log
  run_script grande.log
  assert_success
  ((${#lines[@]} == 12)) ||
    fail "Se esperaban 12 líneas (el título, 10 IP y los 404) y han salido ${#lines[@]}: head -n 10 se queda con las 10 primeras"
  assert_line --index 11 "Errores 404: 0 de 12 (0%)"
}

@test "solo cuenta los 404 del código de respuesta, no los de la ruta" {
  cat > rutas.log <<'LOG'
10.0.0.1 - - [21/Oct/2026:10:00:00 +0200] "GET /404.html HTTP/1.1" 200 100
10.0.0.1 - - [21/Oct/2026:10:00:01 +0200] "GET /x HTTP/1.1" 404 512
10.0.0.2 - - [21/Oct/2026:10:00:02 +0200] "GET / HTTP/1.1" 200 404
10.0.0.2 - - [21/Oct/2026:10:00:03 +0200] "GET / HTTP/1.1" 200 100
LOG
  run_script rutas.log
  assert_line "Errores 404: 1 de 4 (25%)" ||
    fail "Solo la segunda línea es un 404: compara el campo 9 entero (cut -d' ' -f9 y grep '^404$'), no busques 404 en toda la línea"
}

@test "con un log vacío lo dice y termina con código 0" {
  : > vacio.log
  run_script vacio.log
  assert_success ||
    fail "Ha terminado con código $status: con 0 peticiones el porcentaje divide por cero, compruébalo antes"
  assert_line "El log está vacío"
}

@test "funciona con un log cuyo nombre tiene espacios" {
  cp acceso.log "acceso de octubre.log"
  run_script "acceso de octubre.log"
  assert_success
  assert_line "Errores 404: 3 de 6 (50%)"
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
