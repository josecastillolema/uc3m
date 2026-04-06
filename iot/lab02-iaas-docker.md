# Lab 2 - Docker

Usaremos la imagen oficial `Amazon Linux` para aprender algunos conceptos importantes de [Docker](https://www.docker.com/):
 - instalación
 - personalización de imágenes vía Dockerfile
 - subida de imágenes en [DockerHub](https://hub.docker.com/)

Vamos a trabajar con dos terminales abiertos (**T1** y **T2**).

## Pre-reqs

Una máquina virtual `Amazon Linux` en AWS.

## Instalación

1. **[T1]** Instalación de Docker

    a. Instalar el software
    ```
    $ sudo yum install -y docker
    ```

    b. Iniciar el servicio:
    ```
    $ sudo systemctl start docker
    $ sudo systemctl enable docker
    ```

    c. Verificar que el usuario no forma parte del grupo `docker`, y consecuentemente no tiene permiso para ejecutar comandos `docker`:
    ```
    $ groups
    ubuntu adm dialout cdrom floppy sudo audio dip video plugdev lxd netdev
    ```

    d. Añadir el usuario (`ec2-user`) al grupo `docker`:

    ```
    $ sudo usermod -aG docker ec2-user
    ```

    e. Reiniciar la VM para que los cambios de grupo sean aplicados:
    ```
    $ sudo reboot
    Connection to ec2-18-210-19-170.compute-1.amazonaws.com closed by remote host.
    Connection to ec2-18-210-19-170.compute-1.amazonaws.com closed.
    ```

    f. Después del reboot, confirmar que el usuario pertenece al grupo `docker`:
    ```
    $ groups
    ec2-user adm dialout cdrom floppy sudo audio dip video plugdev lxd netdev docker
    ```

    g. Ejecutar un `docker version` para validar la instalación, y verificar que se muestra tanto la versión del cliente **como la del servidor**:
    ```
     $ docker version
     Client:
      Version:           19.03.6
      API version:       1.40
      Go version:        go1.12.17
      Git commit:        369ce74a3c
      Built:             Fri Feb 28 23:45:43 2020
      OS/Arch:           linux/amd64
      Experimental:      false

     Server:
      Engine:
       Version:          19.03.6
       API version:      1.40 (minimum version 1.12)
       Go version:       go1.12.17
       Git commit:       369ce74a3c
       Built:            Wed Feb 19 01:06:16 2020
       OS/Arch:          linux/amd64
       Experimental:     false
      containerd:
       Version:          1.3.3-0ubuntu1~18.04.2
       GitCommit:
      runc:
       Version:          spec: 1.0.1-dev
       GitCommit:
      docker-init:
       Version:          0.18.0
       GitCommit:
    ```

## Primeros pasos

2. **[T1]** Listar las imágenes del repositorio local (el catálogo debería estar vacío, pues no hemos descargado ninguna imagen aún):
    ```
    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    ```

3. **[T1]** Buscar imágenes dentro del catálogo de [DockerHub](https://hub.docker.com/):
    ```
    $ docker search mongodb
    NAME                                DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
    mongo                               MongoDB document databases provide high avai…   7041                [OK]
    mongo-express                       Web-based MongoDB admin interface, written w…   735                 [OK]
    tutum/mongodb                       MongoDB Docker image – listens in port 27017…   229                                     [OK]
    bitnami/mongodb                     Bitnami MongoDB Docker Image                    123                                     [OK]
    frodenas/mongodb                    A Docker Image for MongoDB                      18                                      [OK]
    centos/mongodb-32-centos7           MongoDB NoSQL database server                   8
    webhippie/mongodb                   Docker images for MongoDB                       7                                       [OK]
    centos/mongodb-26-centos7           MongoDB NoSQL database server                   5
    centos/mongodb-36-centos7           MongoDB NoSQL database server                   5
    eses/mongodb_exporter               mongodb exporter for prometheus                 4                                       [OK]
    neowaylabs/mongodb-mms-agent        This Docker image with MongoDB Monitoring Ag…   4                                       [OK]
    centos/mongodb-34-centos7           MongoDB NoSQL database server                   3
    quadstingray/mongodb                MongoDB with Memory and User Settings           3                                       [OK]
    tozd/mongodb                        Base image for MongoDB server.                  2                                       [OK]
    mongodbsap/mongodbdocker                                                            2
    zadki3l/mongodb-oplog               Simple mongodb image with single-node replic…   2                                       [OK]
    ssalaues/mongodb-exporter           MongoDB Replicaset Prometheus Compatible Met…   2
    xogroup/mongodb_backup_gdrive       Docker image to create a MongoDB database ba…   1                                       [OK]
    bitnami/mongodb-exporter                                                            1
    openshift/mongodb-24-centos7        DEPRECATED: A Centos7 based MongoDB v2.4 ima…   1
    ansibleplaybookbundle/mongodb-apb   An APB to deploy MongoDB.                       1                                       [OK]
    targetprocess/mongodb_exporter      MongoDB exporter for prometheus                 0                                       [OK]
    gebele/mongodb                      mongodb                                         0                                       [OK]
    phenompeople/mongodb                 MongoDB is an open-source, document databas…   0                                       [OK]
    astronomerio/mongodb-source         Mongodb source.                                 0                                       [OK]
    ```

4. **[T1]** Hacer el *download* (`pull`) de la imagen de Ubuntu en el repositorio local:
    ```
    $ docker pull ubuntu
    Using default tag: latest
    latest: Pulling from library/ubuntu
    692c352adcf2: Pull complete
    97058a342707: Pull complete
    2821b8e766f4: Pull complete
    4e643cc37772: Pull complete
    Digest: sha256:55cd38b70425947db71112eb5dddfa3aa3e3ce307754a3df2269069d2278ce47
    Status: Downloaded newer image for ubuntu:latest
    docker.io/library/ubuntu:latest
    ```

5. **[T1]** Listar las imágenes nuevamente, verificar que existe la imagen `ubuntu`:
    ```
    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    ubuntu              latest              adafef2e596e        11 days ago         73.9MB
    ```

6. **[T1]** Eliminar la imagen (opcional):
    ```
    $ docker image rm ubuntu
    ```

7. **[T1]** Ejecutar un comando de ejemplo (`hostname`) dentro del contenedor:
    ```
    $ docker run ubuntu hostname
    c293c1989a56
    ```

8. **[T1]** Medir el tiempo del comando anterior:
    ```
    $ time docker run ubuntu hostname
    7aa02808ccfc

    real	0m0.812s
    user	0m0.023s
    sys	0m0.027s
    ```
    Nótese que en menos de un segundo:
    - Docker creó el contenedor
    - Ejecutó el comando `hostname` en él
    - Imprimió la salida
    - Eliminó el contenedor

9. **[T1]** Verificar que tanto el contenedor como el *host* comparten el Kernel:
    ```
    $ uname -a
    Linux ip-172-31-60-180 5.3.0-1023-aws #25~18.04.1-Ubuntu SMP Fri Jun 5 15:18:30 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

    $ docker run ubuntu uname -a
    Linux de0407ee790f 5.3.0-1023-aws #25~18.04.1-Ubuntu SMP Fri Jun 5 15:18:30 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux
    ```

10. **[T1]** Ejecutar la imagen `ubuntu` en modo interactivo. Obsérvese que el `prompt` cambia cuando entramos en el contenedor: usuario `root` con hostname `5b83d8b5b521` (el ID del contenedor en este caso).
    ```
    $ docker run -it ubuntu
    root@d8924e5138b3:/#
    ```

11. **[T2]** **Sin salir del contenedor en el 1er terminal**, listar los contenedores en ejecución **en el 2do terminal**:
    ```
    $ docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    d8924e5138b3        ubuntu              "/bin/bash"         14 seconds ago      Up 13 seconds                           xenodochial_allen
    ```

12. **[T1]** Continuando en el 1er terminal, crear un archivo aún dentro del contenedor y salir del contenedor:
    ```
    root@d8924e5138b3:/# touch meuArquivo

    root@d8924e5138b3:/# ls
    bin   dev  home  lib32  libx32  meuArquivo  opt   root  sbin  sys  usr
    boot  etc  lib   lib64  media   mnt         proc  run   srv   tmp  var

    root@d8924e5138b3:/# exit
    ```

13. **[T1]** Verificar que el contenedor ya no está en ejecución:
    ```
    $ docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    ```

14. **[T1]** Ejecutar el contenedor nuevamente, y confirmar que el archivo creado ya no existe. **Los contenedores son efímeros**, no almacenan ningún tipo de cambio, sean archivos, datos, software instalado, etc.:
    ```
    $ docker run -it ubuntu
    root@5b83d8b5b521:/# ls
    bin   dev  home  lib32  libx32  mnt  proc  run   srv  tmp  var
    boot  etc  lib   lib64  media   opt  root  sbin  sys  usr

    root@5b83d8b5b521:/# ls meuArquivo
    ls: meuArquivo: No such file or directory
    ```

## Personalización de imágenes

### Vía `docker commit`

15. Personalización de imágenes vía `docker commit`.

    Vamos a crear una imagen personalizada instalando algún *software*, por ejemplo `nmap` (un *scanner* de puertos).

    a. **[T1]** **Sin salir del contenedor**, actualizar los repositorios:
    ```
    root@5b83d8b5b521:/# apt update
    Get:1 http://security.ubuntu.com/ubuntu focal-security InRelease [107 kB]
    Get:2 http://archive.ubuntu.com/ubuntu focal InRelease [265 kB]
    Get:3 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [45.2 kB]
    Get:4 http://archive.ubuntu.com/ubuntu focal-updates InRelease [111 kB]
    Get:5 http://security.ubuntu.com/ubuntu focal-security/restricted amd64 Packages [33.9 kB]
    Get:6 http://archive.ubuntu.com/ubuntu focal-backports InRelease [98.3 kB]
    Get:7 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [165 kB]
    Get:8 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 Packages [1078 B]
    Get:9 http://archive.ubuntu.com/ubuntu focal/multiverse amd64 Packages [177 kB]
    Get:10 http://archive.ubuntu.com/ubuntu focal/main amd64 Packages [1275 kB]
    Get:11 http://archive.ubuntu.com/ubuntu focal/restricted amd64 Packages [33.4 kB]
    Get:12 http://archive.ubuntu.com/ubuntu focal/universe amd64 Packages [11.3 MB]
    Get:13 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [165 kB]
    Get:14 http://archive.ubuntu.com/ubuntu focal-updates/restricted amd64 Packages [33.9 kB]
    Get:15 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [330 kB]
    Get:16 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [4202 B]
    Get:17 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 Packages [3209 B]
    Fetched 14.2 MB in 2s (6179 kB/s)
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    1 package can be upgraded. Run 'apt list --upgradable' to see it.
    ```

    b. **[T1]** Instalar el paquete `nmap`. El flag `-y` omite la pregunta de confirmación:
    ```
    root@5b83d8b5b521:/# apt install -y nmap
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    The following additional packages will be installed:
      libblas3 liblinear4 liblua5.3-0 libpcap0.8 libssl1.1 lua-lpeg nmap-common
    Suggested packages:
      liblinear-tools liblinear-dev ncat ndiff zenmap
    The following NEW packages will be installed:
      libblas3 liblinear4 liblua5.3-0 libpcap0.8 libssl1.1 lua-lpeg nmap nmap-common
    0 upgraded, 8 newly installed, 0 to remove and 1 not upgraded.
    Need to get 7115 kB of archives.
    After this operation, 31.3 MB of additional disk space will be used.
    Get:1 http://archive.ubuntu.com/ubuntu focal/main amd64 libssl1.1 amd64 1.1.1f-1ubuntu2 [1318 kB]
    Get:2 http://archive.ubuntu.com/ubuntu focal/main amd64 libpcap0.8 amd64 1.9.1-3 [128 kB]
    Get:3 http://archive.ubuntu.com/ubuntu focal/main amd64 libblas3 amd64 3.9.0-1build1 [142 kB]
    Get:4 http://archive.ubuntu.com/ubuntu focal/universe amd64 liblinear4 amd64 2.3.0+dfsg-3build1 [41.7 kB]
    Get:5 http://archive.ubuntu.com/ubuntu focal/main amd64 liblua5.3-0 amd64 5.3.3-1.1ubuntu2 [116 kB]
    Get:6 http://archive.ubuntu.com/ubuntu focal/universe amd64 lua-lpeg amd64 1.0.2-1 [31.4 kB]
    Get:7 http://archive.ubuntu.com/ubuntu focal/universe amd64 nmap-common all 7.80+dfsg1-2build1 [3676 kB]
    Get:8 http://archive.ubuntu.com/ubuntu focal/universe amd64 nmap amd64 7.80+dfsg1-2build1 [1662 kB]
    Fetched 7115 kB in 1s (7120 kB/s)
    debconf: delaying package configuration, since apt-utils is not installed
    Selecting previously unselected package libssl1.1:amd64.
    (Reading database ... 4122 files and directories currently installed.)
    Preparing to unpack .../0-libssl1.1_1.1.1f-1ubuntu2_amd64.deb ...
    Unpacking libssl1.1:amd64 (1.1.1f-1ubuntu2) ...
    Selecting previously unselected package libpcap0.8:amd64.
    Preparing to unpack .../1-libpcap0.8_1.9.1-3_amd64.deb ...
    Unpacking libpcap0.8:amd64 (1.9.1-3) ...
    Selecting previously unselected package libblas3:amd64.
    Preparing to unpack .../2-libblas3_3.9.0-1build1_amd64.deb ...
    Unpacking libblas3:amd64 (3.9.0-1build1) ...
    Selecting previously unselected package liblinear4:amd64.
    Preparing to unpack .../3-liblinear4_2.3.0+dfsg-3build1_amd64.deb ...
    Unpacking liblinear4:amd64 (2.3.0+dfsg-3build1) ...
    Selecting previously unselected package liblua5.3-0:amd64.
    Preparing to unpack .../4-liblua5.3-0_5.3.3-1.1ubuntu2_amd64.deb ...
    Unpacking liblua5.3-0:amd64 (5.3.3-1.1ubuntu2) ...
    Selecting previously unselected package lua-lpeg:amd64.
    Preparing to unpack .../5-lua-lpeg_1.0.2-1_amd64.deb ...
    Unpacking lua-lpeg:amd64 (1.0.2-1) ...
    Selecting previously unselected package nmap-common.
    Preparing to unpack .../6-nmap-common_7.80+dfsg1-2build1_all.deb ...
    Unpacking nmap-common (7.80+dfsg1-2build1) ...
    Selecting previously unselected package nmap.
    Preparing to unpack .../7-nmap_7.80+dfsg1-2build1_amd64.deb ...
    Unpacking nmap (7.80+dfsg1-2build1) ...
    Setting up lua-lpeg:amd64 (1.0.2-1) ...
    Setting up libssl1.1:amd64 (1.1.1f-1ubuntu2) ...
    debconf: unable to initialize frontend: Dialog
    debconf: (No usable dialog-like program is installed, so the dialog based frontend cannot be used. at /usr/share/perl5/Debconf/FrontEnd/Dialog.pm line 76.)
    debconf: falling back to frontend: Readline
    debconf: unable to initialize frontend: Readline
    debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module) (@INC contains: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.30.0 /usr/local/share/perl/5.30.0 /usr/lib/x86_64-linux-gnu/perl5/5.30 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl/5.30 /usr/share/perl/5.30 /usr/local/lib/site_perl /usr/lib/x86_64-linux-gnu/perl-base) at /usr/share/perl5/Debconf/FrontEnd/Readline.pm line 7.)
    debconf: falling back to frontend: Teletype
    Setting up libblas3:amd64 (3.9.0-1build1) ...
    update-alternatives: using /usr/lib/x86_64-linux-gnu/blas/libblas.so.3 to provide /usr/lib/x86_64-linux-gnu/libblas.so.3 (libblas.so.3-x86_64-linux-gnu) in auto mode
    Setting up libpcap0.8:amd64 (1.9.1-3) ...
    Setting up nmap-common (7.80+dfsg1-2build1) ...
    Setting up liblua5.3-0:amd64 (5.3.3-1.1ubuntu2) ...
    Setting up liblinear4:amd64 (2.3.0+dfsg-3build1) ...
    Setting up nmap (7.80+dfsg1-2build1) ...
    Processing triggers for libc-bin (2.31-0ubuntu9) ...
    ```

    c. **[T1]** Verificar la versión instalada:
    ```
    root@5b83d8b5b521:/# nmap --version
    Nmap version 7.80 ( https://nmap.org )
    Platform: x86_64-pc-linux-gnu
    Compiled with: liblua-5.3.3 openssl-1.1.1d nmap-libssh2-1.8.2 libz-1.2.11 libpcre-8.39 libpcap-1.9.1 nmap-libdnet-1.12 ipv6
    Compiled without:
    Available nsock engines: epoll poll select
    ```

    d. **[T2]** En el 2do terminal, confirmar el ID del contenedor en ejecución (en el cual acabamos de instalar `nmap`):
    ```
    $ docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    5b83d8b5b521        ubuntu              "/bin/bash"         18 minutes ago      Up 18 minutes                           compassionate_edison
    ```

    e. **[T2]** Crear una nueva imagen (`ubuntu_com_nmap`) a partir del contenedor:
    ```
    $ docker commit 5b8 ubuntu_com_nmap
    sha256:287d2c84024a50ba13c9d8304d57df853feea9b3dd9df785313111480a84eecc
    ```

    f. Confirmar la creación de la imagen (con un tamaño mayor que la imagen original):
    ```
    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    ubuntu_com_nmap     latest              287d2c84024a        7 seconds ago       127MB
    ubuntu              latest              adafef2e596e        11 days ago         73.9MB
    ```

    g. Confirmar que en la nueva imagen, efectivamente tiene `nmap` instalado:
    ```
    $ docker run ubuntu_com_nmap nmap --version
    Nmap version 7.80 ( https://nmap.org )
    Platform: x86_64-pc-linux-gnu
    Compiled with: liblua-5.3.3 openssl-1.1.1d nmap-libssh2-1.8.2 libz-1.2.11 libpcre-8.39 libpcap-1.9.1 nmap-libdnet-1.12 ipv6
    Compiled without:
    Available nsock engines: epoll poll select
    ```

    h. Confirmar que la imagen original no fue alterada y no tiene `nmap` instalado:
    ```
    $ docker run ubuntu nmap --version
    docker: Error response from daemon: OCI runtime create failed: container_linux.go:349: starting container process caused "exec: \"nmap\": executable file not found in $PATH": unknown.
    ```

### Vía `Dockerfile`

16. Personalización de imágenes vía **Dockerfile**. Este es el método recomendado para personalizar imágenes, pues es más reproducible que `docker commit`.

    a. Crear el archivo `Dockerfile` con el siguiente contenido:
    ```
    FROM ubuntu

    MAINTAINER Jose Castillo <jose.castillo@uc3m.es>

    RUN apt-get update
    RUN apt-get install -y nmap
    ```

    b. "Compilar" el `Dockerfile`:
    ```
    $ docker build -t ubuntu-com-nmap-viadockerfile .
    Sending build context to Docker daemon  15.87kB
    Step 1/4 : FROM ubuntu
     ---> adafef2e596e
    Step 2/4 : MAINTAINER Jose Castillo
     ---> Running in d3894b0f5f25
    Removing intermediate container d3894b0f5f25
     ---> 94aab8c83039
    Step 3/4 : RUN apt-get update
     ---> Running in 4ea03e5d7f32
    Get:1 http://security.ubuntu.com/ubuntu focal-security InRelease [107 kB]
    Get:2 http://security.ubuntu.com/ubuntu focal-security/multiverse amd64 Packages [1078 B]
    Get:3 http://security.ubuntu.com/ubuntu focal-security/universe amd64 Packages [45.2 kB]
    Get:4 http://security.ubuntu.com/ubuntu focal-security/restricted amd64 Packages [33.9 kB]
    Get:5 http://security.ubuntu.com/ubuntu focal-security/main amd64 Packages [165 kB]
    Get:6 http://archive.ubuntu.com/ubuntu focal InRelease [265 kB]
    Get:7 http://archive.ubuntu.com/ubuntu focal-updates InRelease [111 kB]
    Get:8 http://archive.ubuntu.com/ubuntu focal-backports InRelease [98.3 kB]
    Get:9 http://archive.ubuntu.com/ubuntu focal/multiverse amd64 Packages [177 kB]
    Get:10 http://archive.ubuntu.com/ubuntu focal/universe amd64 Packages [11.3 MB]
    Get:11 http://archive.ubuntu.com/ubuntu focal/main amd64 Packages [1275 kB]
    Get:12 http://archive.ubuntu.com/ubuntu focal/restricted amd64 Packages [33.4 kB]
    Get:13 http://archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [165 kB]
    Get:14 http://archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [4202 B]
    Get:15 http://archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [329 kB]
    Get:16 http://archive.ubuntu.com/ubuntu focal-updates/restricted amd64 Packages [33.9 kB]
    Get:17 http://archive.ubuntu.com/ubuntu focal-backports/universe amd64 Packages [3209 kB]
    Fetched 14.2 MB in 2s (5775 kB/s)
    Reading package lists...
    Removing intermediate container 4ea03e5d7f32
     ---> 3bf3668ec12d
    Step 4/4 : RUN apt-get install -y nmap
     ---> Running in 057b00bbe74b
    Reading package lists...
    Building dependency tree...
    Reading state information...
    The following additional packages will be installed:
      libblas3 liblinear4 liblua5.3-0 libpcap0.8 libssl1.1 lua-lpeg nmap-common
    Suggested packages:
      liblinear-tools liblinear-dev ncat ndiff zenmap
    The following NEW packages will be installed:
      libblas3 liblinear4 liblua5.3-0 libpcap0.8 libssl1.1 lua-lpeg nmap
      nmap-common
    0 upgraded, 8 newly installed, 0 to remove and 1 not upgraded.
    Need to get 7115 kB of archives.
    After this operation, 31.3 MB of additional disk space will be used.
    Get:1 http://archive.ubuntu.com/ubuntu focal/main amd64 libssl1.1 amd64 1.1.1f-1ubuntu2 [1318 kB]
    Get:2 http://archive.ubuntu.com/ubuntu focal/main amd64 libpcap0.8 amd64 1.9.1-3 [128 kB]
    Get:3 http://archive.ubuntu.com/ubuntu focal/main amd64 libblas3 amd64 3.9.0-1build1 [142 kB]
    Get:4 http://archive.ubuntu.com/ubuntu focal/universe amd64 liblinear4 amd64 2.3.0+dfsg-3build1 [41.7 kB]
    Get:5 http://archive.ubuntu.com/ubuntu focal/main amd64 liblua5.3-0 amd64 5.3.3-1.1ubuntu2 [116 kB]
    Get:6 http://archive.ubuntu.com/ubuntu focal/universe amd64 lua-lpeg amd64 1.0.2-1 [31.4 kB]
    Get:7 http://archive.ubuntu.com/ubuntu focal/universe amd64 nmap-common all 7.80+dfsg1-2build1 [3676 kB]
    Get:8 http://archive.ubuntu.com/ubuntu focal/universe amd64 nmap amd64 7.80+dfsg1-2build1 [1662 kB]
    debconf: delaying package configuration, since apt-utils is not installed
    Fetched 7115 kB in 1s (7096 kB/s)
    Selecting previously unselected package libssl1.1:amd64.
    (Reading database ... 4122 files and directories currently installed.)
    Preparing to unpack .../0-libssl1.1_1.1.1f-1ubuntu2_amd64.deb ...
    Unpacking libssl1.1:amd64 (1.1.1f-1ubuntu2) ...
    Selecting previously unselected package libpcap0.8:amd64.
    Preparing to unpack .../1-libpcap0.8_1.9.1-3_amd64.deb ...
    Unpacking libpcap0.8:amd64 (1.9.1-3) ...
    Selecting previously unselected package libblas3:amd64.
    Preparing to unpack .../2-libblas3_3.9.0-1build1_amd64.deb ...
    Unpacking libblas3:amd64 (3.9.0-1build1) ...
    Selecting previously unselected package liblinear4:amd64.
    Preparing to unpack .../3-liblinear4_2.3.0+dfsg-3build1_amd64.deb ...
    Unpacking liblinear4:amd64 (2.3.0+dfsg-3build1) ...
    Selecting previously unselected package liblua5.3-0:amd64.
    Preparing to unpack .../4-liblua5.3-0_5.3.3-1.1ubuntu2_amd64.deb ...
    Unpacking liblua5.3-0:amd64 (5.3.3-1.1ubuntu2) ...
    Selecting previously unselected package lua-lpeg:amd64.
    Preparing to unpack .../5-lua-lpeg_1.0.2-1_amd64.deb ...
    Unpacking lua-lpeg:amd64 (1.0.2-1) ...
    Selecting previously unselected package nmap-common.
    Preparing to unpack .../6-nmap-common_7.80+dfsg1-2build1_all.deb ...
    Unpacking nmap-common (7.80+dfsg1-2build1) ...
    Selecting previously unselected package nmap.
    Preparing to unpack .../7-nmap_7.80+dfsg1-2build1_amd64.deb ...
    Unpacking nmap (7.80+dfsg1-2build1) ...
    Setting up lua-lpeg:amd64 (1.0.2-1) ...
    Setting up libssl1.1:amd64 (1.1.1f-1ubuntu2) ...
    debconf: unable to initialize frontend: Dialog
    debconf: (TERM is not set, so the dialog frontend is not usable.)
    debconf: falling back to frontend: Readline
    debconf: unable to initialize frontend: Readline
    debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module) (@INC contains: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.30.0 /usr/local/share/perl/5.30.0 /usr/lib/x86_64-linux-gnu/perl5/5.30 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl/5.30 /usr/share/perl/5.30 /usr/local/lib/site_perl /usr/lib/x86_64-linux-gnu/perl-base) at /usr/share/perl5/Debconf/FrontEnd/Readline.pm line 7.)
    debconf: falling back to frontend: Teletype
    Setting up libblas3:amd64 (3.9.0-1build1) ...
    update-alternatives: using /usr/lib/x86_64-linux-gnu/blas/libblas.so.3 to provide /usr/lib/x86_64-linux-gnu/libblas.so.3 (libblas.so.3-x86_64-linux-gnu) in auto mode
    Setting up libpcap0.8:amd64 (1.9.1-3) ...
    Setting up nmap-common (7.80+dfsg1-2build1) ...
    Setting up liblua5.3-0:amd64 (5.3.3-1.1ubuntu2) ...
    Setting up liblinear4:amd64 (2.3.0+dfsg-3build1) ...
    Setting up nmap (7.80+dfsg1-2build1) ...
    Processing triggers for libc-bin (2.31-0ubuntu9) ...
    Removing intermediate container 057b00bbe74b
     ---> 4647bd58aa0e
    Successfully built 4647bd58aa0e
    Successfully tagged ubuntu-com-nmap-viadockerfile:latest
    ```

    c. Verificar que la nueva imagen fue creada (y tiene el mismo tamaño que la imagen creada vía `docker commit`):
    ```
    $ docker images
    REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
    ubuntu-com-nmap-viadockerfile   latest              4647bd58aa0e        13 seconds ago      127MB
    ubuntu_com_nmap                 latest              287d2c84024a        18 minutes ago      127MB
    ubuntu                          latest              adafef2e596e        11 days ago         73.9MB
    ```

    d. Probar la nueva imagen:
    ```
    $ docker run ubuntu-com-nmap-viadockerfile nmap --version
    Nmap version 7.80 ( https://nmap.org )
    Platform: x86_64-pc-linux-gnu
    Compiled with: liblua-5.3.3 openssl-1.1.1d nmap-libssh2-1.8.2 libz-1.2.11 libpcre-8.39 libpcap-1.9.1 nmap-libdnet-1.12 ipv6
    Compiled without:
    Available nsock engines: epoll poll select
    ```

## DockerHub

17. *Upload* de la nueva imagen en [DockerHub](https://hub.docker.com/):

    a. Crear una cuenta gratuita

    b. Iniciar sesión en la cuenta desde el terminal con el usuario recién creado:
    ```
    $ docker login
    Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
    Username: josecastillolema
    Password:
    WARNING! Your password will be stored unencrypted in /home/ubuntu/.docker/config.json.
    Configure a credential helper to remove this warning. See
    https://docs.docker.com/engine/reference/commandline/login/#credentials-store

    Login Succeeded
    ```

    c. Etiquetar la imagen. El nombre de la imagen debe ser `username/nombre de la imagen`:
    ```
    $ docker tag ubuntu-com-nmap-viadockerfile josecastillolema/fiap-bdt
    ```

    d. Hacer el *upload* (`push`) de la imagen:
    ```
    $ docker push josecastillolema/fiap-bdt
    ```

    e. Verificar la imagen en el portal de DockerHub:
       ![](https://raw.githubusercontent.com/josecastillolema/fiap/master/mob/cloud/img/docker0.png)
