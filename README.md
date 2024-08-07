﻿### Repositorio "apache-compilado-docker"

Este repositorio contiene un Dockerfile optimizado para compilar y ejecutar Apache HTTP Server dentro de un contenedor Docker.

**Características:**
- Utiliza un entorno Docker para compilar y ejecutar Apache HTTP Server.
- Incluye instrucciones claras para compilar Apache desde el código fuente.
- Configuración básica para la ejecución de Apache con un archivo de configuración inicial.

**Uso:**
1. Clona este repositorio en tu máquina local.
2. Construye la imagen Docker usando el Dockerfile proporcionado.
   ```bash
   docker build -t apache-server .

La forma más fácil de ejecutar Apache con una versión reciente de OpenSSL es compilar el código criptográfico de forma estática e instalar todo en una ubicación separada. De esa manera logras el objetivo, pero no te metes con el resto del sistema operativo.
