bats_load_library check_helpers

# descargas/ con un fichero de cada tipo, uno oculto y una subcarpeta que no se toca.
setup() {
  cd "$CHECK_WORKDIR" || return
  rm -rf descargas "mis descargas" vacia
  mkdir -p "descargas/fotos viejas"
  touch "descargas/foto 1.JPG" descargas/dibujo.png descargas/apuntes.pdf descargas/tema.txt \
    descargas/lista descargas/.borrador "descargas/fotos viejas/playa.jpg"
}

@test "mueve los .jpg y los .png a imagenes, aunque estén en mayúsculas" {
  run_script descargas
  assert_success
  [[ -f "descargas/imagenes/foto 1.JPG" ]] ||
    fail "foto 1.JPG no está en imagenes: compara el nombre en minúsculas, con \${nombre,,}"
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

@test "dice cuántos ficheros ha movido" {
  run_script descargas
  assert_output "Ficheros movidos: 5"
}

@test "no toca las subcarpetas ni los ficheros ocultos" {
  run_script descargas
  assert_file_exists "descargas/fotos viejas/playa.jpg"
  [[ -d "descargas/fotos viejas" ]] ||
    fail "«fotos viejas» ha cambiado de sitio: salta lo que no sea un fichero con [[ -f \$f ]] || continue"
  assert_file_exists descargas/.borrador
}

@test "con un directorio vacío crea las carpetas y no mueve nada" {
  mkdir vacia
  run_script vacia
  assert_success ||
    fail "Ha terminado con código $status: sin ficheros, el comodín queda sin expandir y [[ -f \$f ]] debe saltarlo"
  assert_output "Ficheros movidos: 0"
  assert_dir_exists vacia/imagenes
  assert_dir_exists vacia/documentos
  assert_dir_exists vacia/otros
}

@test "se puede ejecutar dos veces sin errores" {
  run_script descargas
  run_script descargas
  assert_success
  assert_output "Ficheros movidos: 0"
  assert_file_exists "descargas/imagenes/foto 1.JPG"
}

@test "funciona con un directorio cuyo nombre tiene espacios" {
  mkdir "mis descargas"
  touch "mis descargas/foto.jpg"
  run_script "mis descargas"
  assert_success
  assert_file_exists "mis descargas/imagenes/foto.jpg"
}

@test "sin argumentos muestra el uso por stderr y termina con código 1" {
  run_script
  assert_failure 1
  assert_stderr --partial "Uso:"
  assert_output ""
}

@test "si el argumento no es un directorio, lo dice por stderr y termina con código 2" {
  run_script no_existe
  assert_failure 2
  assert_stderr --partial "no_existe no es un directorio"
  assert_output ""
}
