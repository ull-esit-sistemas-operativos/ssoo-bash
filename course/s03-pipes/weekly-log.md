Trabajaremos con un fichero `acceso.log` en el formato que usan servidores web como Apache o nginx: una línea por petición.
Este es un ejemplo de seis líneas que usaremos esta semana:

```text
192.168.1.10 - - [21/Oct/2026:10:15:32 +0200] "GET /index.html HTTP/1.1" 200 5120
10.0.0.7 - - [21/Oct/2026:10:15:40 +0200] "GET /logo.png HTTP/1.1" 404 512
192.168.1.10 - - [21/Oct/2026:10:16:02 +0200] "GET /tema1.html HTTP/1.1" 200 8340
172.16.0.3 - - [21/Oct/2026:10:17:15 +0200] "GET /index.html HTTP/1.1" 200 5120
10.0.0.7 - - [21/Oct/2026:10:17:16 +0200] "GET /favicon.ico HTTP/1.1" 404 512
192.168.1.10 - - [21/Oct/2026:10:18:44 +0200] "GET /tema2.html HTTP/1.1" 404 512
```

Si separamos cada línea por espacios, el campo 1 es la IP del cliente, el 7 la ruta pedida y el 9 el código de respuesta: 200 si todo fue bien, 404 si la página no existe.
El campo 10 es el tamaño de la respuesta en bytes.
