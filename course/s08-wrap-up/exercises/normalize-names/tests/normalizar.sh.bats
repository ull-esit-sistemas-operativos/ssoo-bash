bats_load_library check_helpers

# Las pruebas comparten el directorio: cada una crea de nuevo fotos y "mis fotos".
setup() {
  cd "$CHECK_WORKDIR" || return
  rm -rf fotos "mis fotos"
  mkdir -p fotos/Viajes
  touch "fotos/Foto Playa.JPG" fotos/notas.txt "fotos/Viaje a Roma.png" fotos/.Oculto
}

@test "cambia los espacios por _ y las mayúsculas por minúsculas, y dice qué ha renombrado" {
  run_script fotos
  assert_success
  assert_output $'Foto Playa.JPG -> foto_playa.jpg\nViaje a Roma.png -> viaje_a_roma.png\nRenombrados 2 ficheros'
  assert_file_exists fotos/foto_playa.jpg
  assert_file_exists fotos/viaje_a_roma.png
  assert_file_not_exists "fotos/Foto Playa.JPG"
}

@test "no toca los ficheros que ya están bien, los ocultos ni los subdirectorios" {
  run_script fotos
  assert_file_exists fotos/notas.txt
  assert_file_exists fotos/.Oculto
  assert_dir_exists fotos/Viajes
}

@test "-n dice lo que haría sin renombrar nada" {
  run_script -n fotos
  assert_success
  assert_output $'Foto Playa.JPG -> foto_playa.jpg\nViaje a Roma.png -> viaje_a_roma.png\nSe renombrarían 2 ficheros'
  assert_file_exists "fotos/Foto Playa.JPG"
  assert_file_not_exists fotos/foto_playa.jpg
}

@test "funciona con un directorio cuyo nombre tiene espacios, también acabado en /" {
  mv fotos "mis fotos"
  run_script "mis fotos/" -n
  assert_success
  assert_line --index 2 "Se renombrarían 2 ficheros"
  run_script "mis fotos"
  assert_success
  assert_file_exists "mis fotos/foto_playa.jpg"
}

@test "si ya existe el nombre nuevo, no lo pisa: lo dice por stderr, sigue con los demás y termina con código 3" {
  echo "la buena" > fotos/foto_playa.jpg
  run_script fotos
  assert_failure 3
  assert_stderr --partial "ya existe foto_playa.jpg; no se renombra Foto Playa.JPG"
  assert_output $'Viaje a Roma.png -> viaje_a_roma.png\nRenombrados 1 ficheros'
  assert_file_exists "fotos/Foto Playa.JPG"
  run cat fotos/foto_playa.jpg
  assert_output "la buena"
}

@test "sin directorio, o con una opción desconocida, es un error por stderr con código 1" {
  run_script
  assert_failure 1
  assert_stderr --partial "falta el directorio"
  run_script -x fotos
  assert_failure 1
  assert_stderr --partial "opción desconocida: -x"
  assert_file_exists "fotos/Foto Playa.JPG"
}

@test "si no es un directorio, muestra un error por stderr y termina con código 2" {
  run_script notas.csv
  assert_failure 2
  assert_stderr --partial "notas.csv no es un directorio"
  assert_output ""
}
