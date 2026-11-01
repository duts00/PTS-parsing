#!/bin/bash
#
# parsing.sh - Identifica hosts referenciados em uma pagina e resolve seus IPs.
#
# Objetivo: a partir de um dominio, coletar os hosts presentes nos atributos
# href da pagina e resolver o IP de cada um, com saida formatada em colunas.
#
# Uso: ./parsing.sh exemplo.com.br
#
# Estudo de seguranca - usar apenas em dominios proprios ou autorizados.

set -u  # erro ao usar variavel nao definida

# --- Verificacao de argumento ---
if [ -z "${1:-}" ]; then
    echo "_____ DUTS00 SECURITY - PARSING _____"
    echo "Modo de uso: $0 DOMINIO"
    echo "Exemplo:     $0 exemplo.com.br"
    exit 1
fi

DOMAIN="$1"

# --- Arquivos temporarios seguros, removidos ao sair ---
HOSTS="$(mktemp)" || exit 1
RESULT="$(mktemp)" || exit 1
trap 'rm -f "$HOSTS" "$RESULT"' EXIT

echo "[*] Baixando pagina de $DOMAIN ..."

# Baixa a pagina e extrai os hosts dos href.
# -L segue redirecionamentos (http -> https); --timeout evita travar.
# Tenta https primeiro; se nao achar nada, tenta http.
baixar() {
    wget -qL --timeout=10 -O - "$1" 2>/dev/null \
        | grep -o 'href="[^"]*"' \
        | cut -d '"' -f 2 \
        | grep -oE '[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' \
        | sort -u
}

baixar "https://$DOMAIN" > "$HOSTS"
if [ ! -s "$HOSTS" ]; then
    baixar "http://$DOMAIN" > "$HOSTS"
fi

# --- Resolve o IP de cada host encontrado ---
while read -r url; do
    host "$url" 2>/dev/null | grep "has address"
done < "$HOSTS" | sort -u > "$RESULT"

# --- Se nao houver nenhum host/IP, avisa e sai ---
if [ ! -s "$RESULT" ]; then
    echo "[!] Nenhum host com IP encontrado em $DOMAIN."
    exit 0
fi

# --- Saida formatada em colunas ---
echo "[*] Hosts encontrados e IPs:"
printf "%-35s %s\n" "HOST" "IP"
printf "%-35s %s\n" "----" "--"

# "host X has address Y" -> coluna HOST (campo 1) e IP (ultimo campo)
while read -r linha; do
    nome="$(echo "$linha" | awk '{print $1}')"
    ip="$(echo "$linha" | awk '{print $NF}')"
    printf "%-35s %s\n" "$nome" "$ip"
done < "$RESULT"

echo "============================================"
echo "[ok] Concluido."
