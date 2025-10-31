#objetivo:

#criar um script para identificar possiveis hosts em um dominio.

# o usuario deve informar o dominio e caso o site possua subdominios na pagina ele deve retornar o IP do hosts.

#!/bin/bash

# uso: ./script.sh exemplo.com.br

if [ "$1" == "" ]; then
    echo "_____ DUTS00 SECURITY - PARSING _____"

    echo "_____ MODO DE USO: $0 DOMINIO _____"
    exit 1
fi

DOMAIN="$1"

# limpa arquivo anterior
> dados

echo "[*]>>>> Baixando página de $DOMAIN... <<<<<[*]"

wget -q -O - "http://$DOMAIN" 2>/dev/null \
    | grep "href" \
    | cut -d "/" -f 3 \
    | grep "\." \
    | cut -d '"' -f 1 \
    | grep -v "<l" > dados

echo "[*]>>>>>> Hosts encontrados e IPs:"
while read -r url; do
    host "$url" 2>/dev/null | grep "has address"
    echo "\................................................../"
    done < dados
echo ".........................//.........................."