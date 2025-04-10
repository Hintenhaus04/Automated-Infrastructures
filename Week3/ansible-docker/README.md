### Gebruiksaanwijzing

Voeg de `labsuser.pem` to aan deze directory en update het `inventory` bestand (`../opdrachten/inventory`) met de juiste groepen en hosts. Draai daarna het volgende commando:
```shell
docker build . -t ansible
```

Wanneer de Docker image gemaakt is, start de container met daarin alle Ansible code.
```shell
docker run -it -v <root-directory-van-dit-project>/ansible/opdrachten:/work ansible
```

Draai het volgende commando om de connectiviteit naar alle hosts te testen
```shell
ansible -i <inventory-bestand> -m ping all
```
