# Lekce 19 - Docker CLI (pokračování)

# Vytváření vlastních kontejnerů
[Docker Cheat sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf)

# Base image - příklady
ubuntu:resolute-20260413
debian:trixie-backports

eclipse-temurin:23-jre (Java)
python:3.11.15-alpine3.22
gcc:15.1.0 (c++)
mcr.microsoft.com/dotnet/sdk:8.0 (c#)
node:lts-alpine3.22 (Node.js)


# Dockerfile - použitý příklad
Soubor: `applications/test/docker/Dockerfile`

# Co je Dockerfile
Dockerfile je textový soubor s instrukcemi, podle kterých Docker krok za krokem sestaví image.
Každá instrukce vytvoří novou vrstvu (layer), kterou lze uložit do cache pro další build.

# Co musí Dockerfile obsahovat
Technicky stačí i jedna instrukce (`FROM` nebo `ARG` před `FROM`), ale v praxi se obvykle používá minimálně:
- `FROM` - povinný základ image (odkud stavíme).
- `CMD` nebo `ENTRYPOINT` - co se má spustit po startu kontejneru (doporučeno, aby kontejner plnil konkrétní úlohu).

# Často používané volitelné instrukce
- `RUN` - spouští příkazy při buildu (instalace balíčků, build aplikace).
- `COPY` / `ADD` - kopíruje soubory do image (`ADD` navíc umí například URL nebo rozbalení archivu).
- `WORKDIR` - nastaví pracovní adresář pro další kroky.
- `EXPOSE` - dokumentuje port aplikace.
- `ENV` - nastaví proměnné prostředí.
- `ARG` - proměnné dostupné pouze při buildu.
- `USER` - spuštění pod uživatelem bez root oprávnění (bezpečnost).
- `LABEL` - metadata image (autor, verze, popis).
- `VOLUME` - deklarace mount pointu pro data.
- `HEALTHCHECK` - kontrola stavu běžícího kontejneru.

Ukázka `ADD` z URL:
```dockerfile
FROM debian:trixie-backports
WORKDIR /opt/app
ADD https://example.com/files/config.yaml /opt/app/config.yaml
```

Poznámka:
- `ADD` umí stáhnout soubor z URL při buildu image.
- Ve většině případů je lepší použít `COPY`; `ADD` používejte hlavně tehdy, když potřebujete URL nebo automatické rozbalení archivu.

Ukázka automatického rozbalení archivu:
```dockerfile
FROM debian:trixie-backports
WORKDIR /opt/app
ADD app-release.tar.gz /opt/app/
```

Vysvětlení:
- Pokud je zdroj lokální archiv `.tar`, `.tar.gz` nebo `.tgz`, `ADD` jej při kopírování automaticky rozbalí do cílové složky.
- U souborů stažených z URL se automatické rozbalení standardně neprovádí.


# Docker CLI - nejpoužívanější metody (příkazy)
- `docker build` - vytvoření image z Dockerfile.
- `docker images` - výpis lokálních image.
- `docker run` - spuštění kontejneru z image.
- `docker ps` - běžící kontejnery.
- `docker ps -a` - všechny kontejnery (i zastavené).
- `docker logs` - výpis logů kontejneru.
- `docker exec` - spuštění příkazu uvnitř běžícího kontejneru.
- `docker stop` - korektní zastavení kontejneru.
- `docker rm` - smazání kontejneru.
- `docker rmi` - smazání image.

# Jak image sestavit (build)
Spusťte ve složce `applications/test/docker`:

```bash
docker build -t lesson19-rest-api:1.0 .
```

Vysvětlení:
- `-t lesson19-rest-api:1.0` - jméno a tag image.
- `.` - build context (aktuální adresář).

# Jak kontejner spustit
```bash
docker run -d --name lesson19-rest-api -p 8080:8080 lesson19-rest-api:1.0
```

Vysvětlení:
- `-d` - běh na pozadí (detached mode).
- `--name` - vlastní název kontejneru.
- `-p 8080:8080` - mapování portu host:container.

# Ukázky volání metod
Kontrola image:
```bash
docker images | rg lesson19-rest-api
```

Kontrola běžících kontejnerů:
```bash
docker ps
```

Logy kontejneru:
```bash
docker logs lesson19-rest-api
```

Interaktivní shell uvnitř kontejneru:
```bash
docker exec -it lesson19-rest-api /bin/bash
```

Otestování endpointu (z hosta):
```bash
curl -i http://localhost:8080
```

Zastavení a odstranění kontejneru:
```bash
docker stop lesson19-rest-api
docker rm lesson19-rest-api
```

Odstranění image:
```bash
docker rmi lesson19-rest-api:1.0
```

# Co znamená tag `latest` a kdy se používá?
- `latest` je pouze běžný tag (alias), neznamená automaticky "nejnovější verzi podle data".
- Pokud při buildu neuvedete tag, Docker často použije `:latest`.
- Když přepíšete `latest`, začne ukazovat na jiné image ID.
- V produkci je vhodnější používat konkrétní verze (`1.0.0`, `2026-04-21`, git SHA) a `latest` ponechat jen jako pomocný tag.

Příklad spuštění s `latest`:
```bash
docker run --rm lesson19-rest-api:latest
```

# Jak přidat více tagů na jeden image
Možnost 1 - přímo při buildu:
```bash
docker build \
  -t lesson19-rest-api:1.1.0 \
  -t lesson19-rest-api:stable \
  -t lesson19-rest-api:latest \
  .
```

Možnost 2 - dodatečně pomocí `docker tag`:
```bash
docker build -t lesson19-rest-api:1.1.0 .
docker tag lesson19-rest-api:1.1.0 lesson19-rest-api:stable
docker tag lesson19-rest-api:1.1.0 lesson19-rest-api:latest
```

Kontrola všech tagů:
```bash
docker images lesson19-rest-api
```
