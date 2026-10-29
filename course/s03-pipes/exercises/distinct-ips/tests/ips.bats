bats_load_library check_helpers

# Las pruebas comparten el directorio: cada una empieza sin ficheros de salida.
setup() {
  cd "$CHECK_WORKDIR" && rm -f ips.txt "lista de ips.txt"
}

@test "dice cuántas IP distintas ha guardado" {
  run_script acceso.log ips.txt
  assert_success
  assert_output "3 IP distintas guardadas en ips.txt"
}

@test "guarda en el fichero cada IP una vez, ordenadas" {
  run_script acceso.log ips.txt
  assert_file_exists ips.txt
  run cat ips.txt
  assert_output $'10.0.0.7\n172.16.0.3\n192.168.1.10'
}

@test "sustituye lo que hubiera en el fichero de salida" {
  echo "contenido antiguo" > ips.txt
  run_script acceso.log ips.txt
  run cat ips.txt
  refute_output --partial "contenido antiguo"
}

@test "funciona con nombres que tienen espacios" {
  cp acceso.log "acceso de hoy.log"
  run_script "acceso de hoy.log" "lista de ips.txt"
  assert_success
  assert_output "3 IP distintas guardadas en lista de ips.txt"
  assert_file_exists "lista de ips.txt"
}

@test "sin dos argumentos muestra el uso por stderr y termina con código 1" {
  run_script acceso.log
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si no puede leer el log, muestra un error por stderr, termina con código 2 y no crea la salida" {
  run_script no_existe.log ips.txt
  assert_failure 2
  assert_stderr --partial "no se puede leer no_existe.log"
  [[ ! -e ips.txt ]] || fail "Se ha creado ips.txt: compruébalo antes de redirigir, porque > crea el fichero aunque la orden falle"
}
