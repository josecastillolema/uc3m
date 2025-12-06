<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Arquitectura de Redes de Acceso y Medio Compartido](#arquitectura-de-redes-de-acceso-y-medio-compartido)
  - [Spanning Tree Protocol (STP)](#spanning-tree-protocol-stp)
  - [Despliegue del laboratorio](#despliegue-del-laboratorio)
    - [GitHub Codespaces](#github-codespaces)
    - [Entorno local](#entorno-local)
      - [Acceso a los switches](#acceso-a-los-switches)
      - [Comandos útiles de STP en Linux](#comandos-%C3%BAtiles-de-stp-en-linux)
  - [Ejercicios](#ejercicios)
  - [Destruir el laboratorio](#destruir-el-laboratorio)
    - [GitHub Codespaces](#github-codespaces-1)
    - [Entorno local](#entorno-local-1)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Arquitectura de Redes de Acceso y Medio Compartido

## Spanning Tree Protocol (STP)

Este laboratorio implementa un escenario básico para estudiar STP (Spanning Tree Protocol) usando Containerlab, Linux bridges y imágenes Alpine.
Incluye tres switches interconectados en un triángulo, permitiendo observar la convergencia del STP, bloqueo de puertos, elección del *root bridge* y comportamiento ante fallos.

Topología:
```
   sw1
  /   \
sw2---sw3
```

## Despliegue del laboratorio

### GitHub Codespaces

---
<div align=center markdown>
<a href="https://github.com/codespaces/new/josecastillolema/uc3m?quickstart=1">
<img src="https://gitlab.com/rdodin/pics/-/wikis/uploads/d78a6f9f6869b3ac3c286928dd52fa08/run_in_codespaces-v1.svg?sanitize=true" style="width:50%"/></a>

**[Run](https://github.com/codespaces/new/josecastillolema/uc3m?quickstart=1) this lab in GitHub Codespaces for free**.  
[Learn more](https://containerlab.dev/manual/codespaces) about Containerlab for Codespaces.  
<small>Machine type: 2 vCPU · 8 GB RAM</small>
</div>

---

### Entorno local

Pre requisitos:
 - [Podman](https://podman.io/) (o [Docker](https://www.docker.com/))
 - [Containerlab](https://containerlab.dev/)

Con Docker:
```bash
sudo containerlab deploy -t stp-lab.clab.yml
```

Con Podman:
```bash
sudo containerlab deploy --runtime podman -t stp-lab.clab.yml
```

Ver contenedores con Docker:
```bash
sudo docker ps
```

Ver contenedores con Podman:
```bash
sudo podman ps
```

#### Acceso a los switches

Con Docker:
```bash
sudo docker exec -it clab-stp-lab-sw1 sh
sudo docker exec -it clab-stp-lab-sw2 sh
sudo docker exec -it clab-stp-lab-sw3 sh
```

Con Podman:
```bash
sudo podman exec -it clab-stp-lab-sw1 sh
sudo podman exec -it clab-stp-lab-sw2 sh
sudo podman exec -it clab-stp-lab-sw3 sh
```

#### Comandos útiles de STP en Linux

Ver puertos y su estado:
```sh
bridge link
```

Ver estados STP:
```sh
bridge -s link
```

Ver el *root port*:
```sh
bridge -s link | grep brport
```

Ver cambios en vivo:
```sh
bridge monitor br0
```

## Ejercicios

1. Identificar el root bridge por defecto

   Ejecutar en cada nodo:
    ```sh
    bridge -s link
    ```

    El switch sin `root_port` es el *root*.

2. Forzar que un switch sea el *root bridge*

    Ejemplo en **sw3**:
    ```sh
    ip link set br0 type bridge priority 0
    ```

    Ver cambios:
    ```sh
    bridge -s link
    ```

3. Simular fallo de enlace

    Ejemplo en **sw2**:
    ```sh
    ip link set eth2 down
    ```


    Observar reconvergencia:
    ```sh
    bridge -s link
    ```


    Restaurar:
    ```sh
    ip link set eth2 up
    ```

4. Observar STP en tiempo real mientras se reactiva un puerto

    En una consola:
    ```sh
    bridge monitor br0
    ```

    En otra:
    ```sh
    ip link set eth1 down
    sleep 4
    ip link set eth1 up
    ```

## Destruir el laboratorio

### GitHub Codespaces

### Entorno local

Con Docker:
```bash
sudo containerlab destroy -t stp-lab.clab.yml
```

Con Podman:
```bash
sudo containerlab destroy --runtime podman -t stp-lab.clab.yml
```
