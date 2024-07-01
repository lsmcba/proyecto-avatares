#!/bin/bash

Red='\033[0;31m'    
Green='\033[0;32m'  
Yellow='\033[0;33m' 
White='\033[0;97m'

clear
unset usuario
unset clave

echo -e "${Green}-----------------------------------------------${Color_off}"
echo -e "${Green}Ingrese su Usuario y contraseña de DockerHub...${Color_off}"
echo -e "${Green}-----------------------------------------------${Color_off}"
echo
echo -e "${Yellow}Usuario: ${Color_off}"
read usuario
echo
PROMPT="Contraseña: "
while IFS= read -p "$PROMPT" -r -s -n 1 char; do
    if [[ $char == $'\0' ]]; then
        break
    fi
    PROMPT='*'
    clave+="$char"
done
echo
docker login -p $clave -u $usuario
echo
echo
echo -e "${White}-----------------------------${Color_off}"
echo -e "${Green}Creando imagenes Web y Api...${Color_off}"
echo -e "${White}-----------------------------${Color_off}"
echo
docker build -t $usuario/api:1.0 ./api
echo
docker build -t $usuario/web:1.0 ./web
echo
echo
echo -e "${White}------------------------------------------${Color_off}"
echo -e "${Green}Subiendo imagenes Web y Api a DockerHub...${Color_off}"
echo -e "${White}------------------------------------------${Color_off}"
echo
docker push $usuario/api:1.0
echo
docker push $usuario/web:1.0
echo
echo
echo -e "${White}------------------------------------------------------------------------${Color_off}"
echo -e "${Green}Imagenes creadas y subidas al repositorio, ejecutando docker-compose...${Color_off}"
echo -e "${White}------------------------------------------------------------------------${Color_off}"
echo
docker-compose up -d --build
echo