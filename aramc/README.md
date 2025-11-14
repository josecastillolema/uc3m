# Arquitectura de Redes de Acceso y Medio Compartido

## Spanning Tree Protocol (STP)

Este laboratorio implementa un escenario básico para estudiar STP (Spanning Tree Protocol) usando Containerlab, Linux bridges y imágenes Alpine.
Incluye tres switches interconectados en un triángulo, permitiendo observar la convergencia del STP, bloqueo de puertos, elección de *root bridge* y comportamiento ante fallos.

Pre requisitos:
 - Podman (o Docker)
 - Containerlab

Topología:
```
   sw1
  /   \
sw2---sw3
```

### Despliegue del laboratorio

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

### Acceso a los switches

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

### Comandos útiles de STP en Linux

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

### Ejercicios

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

### Destruir el laboratorio

Con Docker:
```bash
sudo containerlab destroy -t stp-lab.clab.yml
```

Con Podman:
```bash
sudo containerlab destroy --runtime podman -t stp-lab.clab.yml
```
