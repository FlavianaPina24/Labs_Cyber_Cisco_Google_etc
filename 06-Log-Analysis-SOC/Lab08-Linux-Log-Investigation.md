# 🔍 Lab 08: Investigação de Incidentes e Análise de Logs do Sistema (SOC Workflow)

## 📌 Visão Geral
A análise de logs é uma das atribuições mais críticas em operações de SOC (Security Operations Center). Este laboratório demonstra como extrair, filtrar e correlacionar eventos de autenticação, tentativas de força bruta e elevação de privilégios no Linux utilizando ferramentas nativas de auditoria de linha de comando (`grep`, `awk`, `journalctl` e `lastb`).

---

## 🎯 Objetivos Técnicos
- Mapear a localização e estrutura dos principais arquivos de log do Linux (`/var/log/auth.log`, `/var/log/syslog`, `/var/log/secure`).
- Identificar e quantificar ataques de força bruta contra o serviço SSH.
- Auditar sessões ativas e tentativas de autenticação inválidas via `utmp`/`btmp`.
- Rastrear execuções de comandos com privilégios de root (`sudo`) para detecção de abuso de acesso.

---

## 🧪 Topologia e Ferramentas
- **Ambiente:** Linux (Debian / Kali / Ubuntu)
- **Ferramentas:** `journalctl`, `last`, `lastb`, `grep`, `awk`, `cut`, `sort`, `uniq`
- **Alvos de Auditoria:** `/var/log/auth.log`, `/var/log/syslog`

---

## 🚀 Passo a Passo Prático

- **Auditar tentativas falhas de login (possível ataque de força bruta):**
```bash
sudo lastb -n 20
```

---

### 2. Investigação de Força Bruta SSH via `auth.log`
O arquivo `/var/log/auth.log` registra eventos relacionados a identidade e autenticação.

- **Filtrar todas as falhas de autenticação SSH:**
```bash
sudo grep "Failed password" /var/log/auth.log
```

- **Extrair IPs atacantes e contar a quantidade de tentativas (Top Atacantes):**
```bash
sudo grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr
```

- **Identificar usuários inexistentes visados no ataque:**
```bash
sudo grep "Invalid user" /var/log/auth.log | awk '{print $(NF-2)}' | sort | uniq -c | sort -nr
```

---

### 3. Monitoramento de Elevação de Privilégios (`sudo` Abuse)
Identificar quais comandos foram executados por usuários comuns utilizando `sudo`:

- **Filtrar execuções de comandos com `sudo`:**
```bash
sudo grep "COMMAND=" /var/log/auth.log | awk -F "COMMAND=" '{print $2}'
```

- **Auditar tentativas de uso de `sudo` sem autorização (Incidentes de Segurança):**
```bash
sudo grep "authentication failure" /var/log/auth.log
```

---

### 4. Análise com `journalctl` (Systemd Journal)
Em distribuições modernas, o `systemd-journald` indexa logs estruturados do sistema.

- **Verificar eventos do serviço SSH em tempo real:**
```bash
sudo journalctl -u ssh -f
```

- **Filtrar apenas mensagens com severidade de Erro/Crítico (Prioridade 0 a 3):**
```bash
sudo journalctl -p err..emerg -n 30
```

- **Buscar eventos de segurança ocorridos nas últimas 2 horas:**
```bash
sudo journalctl --since "2 hours ago" -u ssh
```

---

## 🛡️ Lições Aprendidas e Ações de Resposta a Incidentes (Blue Team)
1. **Contenção Automatizada:** IPs detectados no Top Atacantes de SSH devem ser inseridos automaticamente em regras de bloqueio com `fail2ban` ou `iptables`.
2. **Hardening de SSH:** Desativar login de root direto (`PermitRootLogin no`) e restringir autenticação exclusivamente para chaves criptográficas (`PasswordAuthentication no`).
3. **Imutabilidade de Logs:** Em arquiteturas corporativas, os arquivos de log locais devem ser encaminhados em tempo real para um servidor Syslog central ou SIEM para evitar que um invasor com privilégios de root apague os rastros (`log wiping`).
