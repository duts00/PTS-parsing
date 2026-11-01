# parsing.sh — Extração de Hosts e Resolução de IPs

Script Bash para estudo de parsing de HTML e resolução de endereços IP a partir de um domínio. A ferramenta baixa a página do domínio informado, coleta os hosts presentes nos atributos `href` e resolve o IP de cada um, apresentando o resultado em colunas alinhadas.

---

## Aviso Legal

Ferramenta de estudo, destinada ao uso em domínios próprios ou com autorização explícita. Coletar e varrer páginas de terceiros sem permissão pode violar os termos de uso do alvo e a legislação aplicável (no Brasil, Lei 12.737/2012 e Marco Civil da Internet). Respeite o `robots.txt` e as políticas do alvo. Use de forma ética e responsável.

---

## Descrição

O fluxo do script é:

1. Baixa a página do domínio informado (HTTPS, com fallback para HTTP).
2. Extrai as URLs presentes em atributos `href` e deriva os hosts.
3. Remove duplicatas e resolve o IP de cada host.
4. Exibe o resultado em formato tabular.

> Nota sobre o histórico: este projeto começou como dois scripts (`parsing.sh`, base, e `parsing.visual.sh`, com formatação aprimorada com auxílio de IA). As duas versões foram unificadas em um único `parsing.sh`, reunindo a lógica de coleta e a saída formatada.

---

## Dependências

- `bash`
- `wget`
- `grep`
- `host` (pacote `dnsutils`)
- `awk`, `sort` (coreutils)

Instalação em Debian/Ubuntu/Kali:

```bash
sudo apt update
sudo apt install -y wget dnsutils grep gawk coreutils
```

---

## Uso

Tornar executável:

```bash
chmod +x parsing.sh
```

Executar:

```bash
./parsing.sh exemplo.com.br
```

### Saída esperada

```
[*] Baixando pagina de exemplo.com.br ...
[*] Hosts encontrados e IPs:
HOST                                IP
----                                --
host1.externo.com                   93.184.216.34
host2.externo.net                   192.0.2.123
============================================
[ok] Concluido.
```

---

## Comportamento e Robustez

- Sem argumento: exibe a tela de ajuda e encerra.
- Segue redirecionamentos e tenta HTTPS antes de HTTP.
- Possui timeout no download, evitando travamentos.
- Remove hosts duplicados (`sort -u`).
- Usa arquivos temporários seguros (`mktemp`), removidos automaticamente ao sair (`trap`).
- Avisa quando nenhum host com IP é encontrado.

---

## Limitações Conhecidas

Inerentes ao caráter de estudo do script:

1. Parsing de HTML baseado em `href` simples (não cobre todos os formatos).
2. Coleta apenas os hosts da página principal; não enumera subdomínios por força bruta.
3. Execução sequencial na resolução dos IPs.

---

## Sugestões de Melhoria (exercícios)

- Parsing mais robusto com ferramentas como `htmlq` ou `pup`.
- Paralelizar a resolução de IPs para acelerar a execução.
- Opções de linha de comando (`--output`, modo verbose, formato CSV).
- Suporte a listas de domínios ou a ranges personalizados.
- Destaque para hosts fora do domínio principal (referências a terceiros).

---

## Boas Práticas e Ética

- Não utilizar em redes ou domínios sem permissão.
- Respeitar as políticas e o `robots.txt` do alvo.
- Cuidado com arquivos temporários e dados sensíveis.

---

## Nota Final

Projeto de estudo de parsing de HTML e automação em Bash. O objetivo é compreender, de forma prática, como ferramentas de reconhecimento coletam e organizam informações públicas de um alvo — base da fase de reconhecimento em um pentest.

---

Desenvolvido por duts00 — projeto de estudo em segurança da informação
