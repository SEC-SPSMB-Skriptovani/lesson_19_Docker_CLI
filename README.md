# Lesson 19 - Docker CLI - Pokračování

# Vytváření valastních konterjnerů
[Docker Cheat sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf)

# Base Images  - Příklady
ubuntu:resolute-20260413
debian:trixie-backports

eclipse-temurin:23-jre (java)
python:3.11.15-alpine3.22
gcc:15.1.0 (c++)
mcr.microsoft.com/dotnet/sdk:8.0 (c#)
node:lts-alpine3.22 (Nodejs)


# Dockerfile - použitý příklad
Soubor: `Dockerfile`

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

# Jak na build kontejneru

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
- `-d` - běh na pozadí (detached).
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

# Co znamená tag `latest`
- `latest` je jen obyčejný tag (alias), není to "nejnovější verze podle data".
- Pokud při buildu nepoužiješ tag, Docker často pracuje s `:latest`.
- Když přepíšeš `latest`, začne ukazovat na jiný image ID.
- Pro produkci je lepší používat konkrétní verze (`1.0.0`, `2026-04-21`, git SHA) a `latest` mít jen jako pomocný tag.

Příklad spuštění s `latest`:
```bash
docker run --rm lesson19-rest-api:latest
```

# Jak přidat více tagů na jeden image
Možnost 1 - rovnou při buildu:
```bash
docker build \
  -t lesson19-rest-api:1.1.0 \
  -t lesson19-rest-api:stable \
  -t lesson19-rest-api:latest \
  .
```

Možnost 2 - dodatečně přes `docker tag`:
```bash
docker build -t lesson19-rest-api:1.1.0 .
docker tag lesson19-rest-api:1.1.0 lesson19-rest-api:stable
docker tag lesson19-rest-api:1.1.0 lesson19-rest-api:latest
```

Kontrola všech tagů:
```bash
docker images lesson19-rest-api
```
