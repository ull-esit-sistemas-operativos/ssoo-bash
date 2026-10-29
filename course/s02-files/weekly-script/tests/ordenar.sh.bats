bats_load_library check_helpers

# descargas/ con un fichero de cada tipo y una subcarpeta que no se toca.
setup() {
  cd "$CHECK_WORKDIR" || return
  rm -rf descargas "mis descargas"
  mkdir -p "descargas/fotos viejas"
  touch "descargas/foto 1.JPG" descargas/dibujo.png descargas/apuntes.pdf descargas/tema.txt \
    descargas/lista "descargas/fotos viejas/playa.jpg"
}

@test "mueve los .jpg y los .png a imagenes, aunque estén en mayúsculas" {
  run_script descargas
  assert_success
  [[ -f "descargas/imagenes/foto 1.JPG" ]] ||
    fail "foto 1.JPG no está en imagenes: -iname no distingue mayúsculas y, si ha acabado en otros, al último find le falta -maxdepth 1"
  assert_file_exists descargas/imagenes/dibujo.png
}

@test "mueve los .pdf y los .txt a documentos" {
  run_script descargas
  assert_file_exists descargas/documentos/apuntes.pdf
  assert_file_exists descargas/documentos/tema.txt
}

@test "mueve el resto de ficheros a otros" {
  run_script descargas
  assert_file_exists descargas/otros/lista
}

@test "no deja ficheros en el primer nivel" {
  run_script descargas
  local resto
  resto=$(find descargas -maxdepth 1 -type f)
  [[ -z $resto ]] || fail "Quedan ficheros sin mover: $resto"
}

@test "no toca las subcarpetas que ya había" {
  run_script descargas
  assert_file_exists "descargas/fotos viejas/playa.jpg" ||
    fail "playa.jpg ha salido de «fotos viejas»: limita find al primer nivel con -maxdepth 1"
}

@test "crea las tres carpetas aunque alguna quede vacía" {
  rm -f descargas/*.*
  run_script descargas
  assert_success
  assert_dir_exists descargas/imagenes
  assert_dir_exists descargas/documentos
  assert_dir_exists descargas/otros
}

@test "se puede ejecutar dos veces sin errores ni cambios" {
  run_script descargas
  run_script descargas
  assert_success ||
    fail "La segunda vez ha terminado con código $status: con -p, mkdir no falla si las carpetas ya existen"
  assert_file_exists "descargas/imagenes/foto 1.JPG"
  assert_file_exists descargas/documentos/apuntes.pdf
  assert_file_exists descargas/otros/lista ||
    fail "lista ha cambiado de sitio: con -maxdepth 1, find no entra en las carpetas ya ordenadas"
}

@test "funciona con un directorio cuyo nombre tiene espacios" {
  mkdir "mis descargas"
  touch "mis descargas/foto.jpg"
  run_script "mis descargas"
  assert_success
  assert_file_exists "mis descargas/imagenes/foto.jpg"
}

@test "sin argumentos muestra el uso y termina con código 1" {
  run_script
  assert_failure 1
  assert_message "Uso:"
}

@test "si el argumento no es un directorio, muestra un error y termina con código 2" {
  run_script no_existe
  assert_failure 2
  assert_message "no_existe no es un directorio"
}
