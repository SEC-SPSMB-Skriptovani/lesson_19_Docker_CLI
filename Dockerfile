#FROM <base image:tag> - nastavení base image.
FROM debian:trixie-backports

#`RUN` spustí příkazy při buildu image. Typycky se používá pro instalaci
# potřebných balíčků a závislostí.
RUN apt-get update && apt-get install -y socat

#`COPY <source DIR> <destination DIR>` - zkopíruje soubor ze složky projektu do image.
COPY  rest-api.sh /opt/rest-api/rest-api.sh

#nastaví spustitelné právo pro skript.
RUN chmod +x /opt/rest-api/rest-api.sh

# deklaruje port na kterém aplikace vystavuje data.
EXPOSE 8080

#`WORKDIR` - nastaví pracovní adresář. Všechny následující příkazy budou spuštěny z tohoto adresáře.
# obdodba `cd` v shellu.
WORKDIR /opt/rest-api

#`CMD` - výchozí příkaz po startu kontejneru.
CMD ["rest-api.sh"]
