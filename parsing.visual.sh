
#codigo original, apenas modificado a parte de visual feita pela IA. 


#!/bin/bash
# parsing + formatter integrado
# Não muda a lógica original, só formata a saída no final

if [ "$1" == "" ]; then
    echo "DUTS00 SECURITY - PARSING"
    echo "MODO DE USO: $0 DOMINIO"
    exit 1
fi

DOMAIN="$1"

# limpa arquivo anterior
> dados

echo "[*] Baixando página de $DOMAIN ..."
wget -q -O - "http://$DOMAIN" 2>/dev/null \
    | grep "href" \
    | cut -d "/" -f 3 \
    | grep "\." \
    | cut -d '"' -f 1 \
    | grep -v "<l" > dados

echo "[*] Hosts encontrados e IPs:"

# Cria temporário para formatação
TMP="$(mktemp)" || exit 1
trap 'rm -f "$TMP"' EXIT

# Extrai HOST IP das linhas com host
while read -r url; do
    host "$url" 2>/dev/null | grep "has address"
done < dados > "$TMP"

# Se não houver nenhum host/IP, avisa e sai
if [ ! -s "$TMP" ]; then
    echo "Nenhum host com IP encontrado."
    exit 0
fi

# Imprime cabeçalho simples
printf "%-30s %s\n" "HOST" "IP"
printf "%-30s %s\n" "----" "--"

# Ordena, remove duplicados e imprime colunas alinhadas
sort -u "$TMP" | while read -r HOST IP; do
    printf "%-30s %s\n" "$HOST" "$IP"
done

echo "===================="