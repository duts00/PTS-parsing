# parsing.visual.sh & parsing.sh — Estudo de Identificação e Resolução de Hosts

> Dois scripts Bash complementares para estudo em parsing de HTML e resolução de endereços IP a partir de um domínio informado.

**Aviso:** Este README documenta os dois scripts **sem alterar nenhum código**. Ambos foram criados para estudo: `parsing.sh` feito de forma normal, `parsing.visual.sh` feito com ajuda de IA apenas para melhorar o visual da saída.

---

## Descrição

Os scripts `parsing.sh` e `parsing.visual.sh` permitem:

* Coletar URLs presentes em `href` de páginas web de um domínio.
* Resolver IPs dos hosts encontrados.

Diferença principal:

* `parsing.sh`: saída simples, com separadores básicos, feito normalmente pelo autor.
* `parsing.visual.sh`: saída formatada em colunas, ordenada e com duplicatas removidas, feito com ajuda de IA apenas para aprimorar o visual.

Ambos são exercícios de estudo para aprender parsing básico de HTML e manipulação de saídas no Bash.

---

## Dependências

* `bash`
* `wget`
* `grep`
* `cut`
* `host`

Instalação em Debian/Ubuntu:

```bash
sudo apt update
sudo apt install -y wget dnsutils grep coreutils
```

---

## Uso

Tornar executável:

```bash
chmod +x parsing.sh parsing.visual.sh
```

Executar:

```bash
./parsing.sh exemplo.com.br
# ou
./parsing.visual.sh exemplo.com.br
```

Saída esperada de `parsing.sh`:

```
[*]>>>> Baixando página de exemplo.com.br... <<<<<[*]
[*]>>>>>> Hosts encontrados e IPs:
host1.externo.com has address 93.184.216.34
................................................../
host2.externo.net has address 192.0.2.123
.........................//..................
```

Saída esperada de `parsing.visual.sh` (mais organizada, apenas visual):

```
[*] Baixando página de exemplo.com.br ...
[*] Hosts encontrados e IPs:
HOST                           IP
----                           --
host1.externo.com              93.184.216.34
host2.externo.net              192.0.2.123
====================
```

---

## Comportamento em caso de erro

* Nenhum parâmetro passado → imprime tela de ajuda e encerra.
* Hosts não resolvidos são ignorados.
* `parsing.visual.sh` avisa se nenhum host/IP foi encontrado.

---

## Limitações

1. Parsing HTML frágil (só href simples).
2. Apenas HTTP, não HTTPS.
3. Não varre subdomínios por nome, apenas coleta hrefs da página principal.
4. Sequencial e sem timeout específico para wget.
5. Arquivos temporários (`dados` ou `TMP`) podem sobrescrever dados se rodar simultaneamente.

---

## Sugestões de melhorias

* Adicionar suporte HTTPS e redirecionamentos.
* Parsing robusto com `htmlq`/`pup` para pegar hrefs em formatos diferentes.
* Paralelizar downloads para acelerar o script.
* Adicionar opções de log, verbose ou saída personalizada (`--output`).
* Suporte a arquivos de subdomínios ou ranges personalizados.
* Melhor tratamento de arquivos temporários com `trap` (já presente em parsing.visual.sh).

---

## Boas práticas

* Não usar em redes/domínios sem permissão.
* Cuidado com arquivos temporários e dados sensíveis.
* Respeitar políticas e `robots.txt` do alvo.

---


## Changelog

* v0.1 — README inicial para estudo de `parsing.sh` e `parsing.visual.sh`.
* v0.2 — Documentação das diferenças, saídas e sugestões de melhoria, destacando caráter educativo.

---

> Nota: Este projeto é um estudo de parsing HTML. O script `parsing.visual.sh` recebeu ajuda de IA apenas para melhorar a visualização da saída e facilitar o entendimento, enquanto `parsing.sh` foi feito manualmente como exercício.
