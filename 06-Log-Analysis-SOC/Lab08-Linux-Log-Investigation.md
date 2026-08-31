# 🔍 Lab 08: Investigação de Incidentes e Análise de Logs do Sistema (SOC Workflow)

## 📌 Visão Geral
A análise de logs é uma das atribuições centrais em operações de SOC (Security Operations Center). Este laboratório demonstra a simulação de uma tentativa de intrusão contra o serviço SSH, a inspeção forense dos eventos registrados em `/var/log/auth.log` e a criação de pipelines de agregação via linha de comando (`grep`, `awk`, `sort`, `uniq`) para ranquear atacantes e identificar anomalias.

---

## 🎯 Objetivos Técnicos
* Auditar sessões ativas e histórico do sistema via `/var/log/wtmp` com `last`.
* Simular e mitigar problemas operacionais de conectividade do protocolo SSH.
* Registrar tentativas reais de login não autorizado com usuários inexistentes.
* Construir pipelines no shell para extrair os principais atacantes e contas visadas.
* Auditar rastros de execução de comandos com privilégios administrativos (`sudo`).

---

## 🧪 Topologia e Ferramental
* **Ambiente:** Kali Linux
* **Serviços:** `sshd` (OpenSSH Server)
* **Arquivos Auditados:** `/var/log/auth.log`, `/var/log/wtmp`
* **Ferramental de Análise:** `grep`, `awk`, `sort`, `uniq`, `last`, `systemctl`

---

## 🚀 Passo a Passo Prático

### 1. Auditoria do Histórico de Acessos (`last`)
Auditoria das últimas sessões estabelecidas e eventos de boot registrados no arquivo binário `/var/log/wtmp`:

```bash
last -n 5
```

**Evidência Operacional:**
```text
kali     tty7         :0               Sun Aug 30 22:59   still logged in
reboot   system boot  6.3.0-kali1-amd6 Sun Aug 30 19:58   still running
kali     tty7         :0               Sun Aug 30 18:35 - crash  (01:23)
reboot   system boot  6.3.0-kali1-amd6 Sun Aug 30 15:34   still running
reboot   system boot  6.3.0-kali1-amd6 Mon Aug 14 08:07 - 09:45  (01:37)

wtmp begins Mon Aug 14 08:07:59 2023
```

---

### 2. Inicialização do Serviço SSH e Ajuste de Configuração
Garantir a execução do daemon SSH e remoção de opções depreciadas legadas (`ssh-dss`):

```bash
# Iniciar o daemon do SSH
sudo systemctl start ssh

# Fazer backup/remoção de chaves legadas locais
mv ~/.ssh/config ~/.ssh/config.bak
```

---

### 3. Simulação de Ataque de Força Bruta
Disparo de tentativa de autenticação com credencial inexistente (`usuario_fantasma`):

```bash
ssh usuario_fantasma@127.0.0.1
```

**Evidência de Rejeição de Acesso:**
```text
usuario_fantasma@127.0.0.1's password: 
Permission denied, please try again.
usuario_fantasma@127.0.0.1's password: 
Permission denied, please try again.
usuario_fantasma@127.0.0.1's password: 
usuario_fantasma@127.0.0.1: Permission denied (publickey,password).
```

---

### 4. Análise Forense do Log de Autenticação (`/var/log/auth.log`)

#### A. Rastrear o Incidente do Usuário Inexistente
```bash
sudo grep "usuario_fantasma" /var/log/auth.log
```

**Resultado nos Logs:**
```text
2026-08-31T00:01:08.247810+00:00 Kali sshd-session[65492]: Invalid user usuario_fantasma from 127.0.0.1 port 57268
2026-08-31T00:01:15.587994+00:00 Kali sshd-session[65492]: Failed password for invalid user usuario_fantasma from 127.0.0.1 port 57268 ssh2
2026-08-31T00:01:22.112612+00:00 Kali sshd-session[65492]: Failed password for invalid user usuario_fantasma from 127.0.0.1 port 57268 ssh2
2026-08-31T00:01:34.081289+00:00 Kali sshd-session[65492]: Failed password for invalid user usuario_fantasma from 127.0.0.1 port 57268 ssh2
2026-08-31T00:01:34.713140+00:00 Kali sshd-session[65492]: Connection closed by invalid user usuario_fantasma 127.0.0.1 port 57268 [preauth]
2026-08-31T00:02:16.249350+00:00 Kali sudo:    kali : TTY=pts/0 ; PWD=/home/kali ; USER=root ; COMMAND=/usr/bin/grep usuario_fantasma /var/log/auth.log
```

---

### 5. Pipelines SOC: Agregação e Ranqueamento de Ameaças

#### Ranking 1: Contagem de Tentativas por IP Atacante
```bash
sudo grep "Failed password" /var/log/auth.log | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr
```

**Saída Agregada:**
```text
3 127.0.0.1
```

#### Ranking 2: Usuários Inválidos mais Visados no Ataque
```bash
sudo grep "Invalid user" /var/log/auth.log | awk '{print $(NF-2)}' | sort | uniq -c | sort -nr
```

**Saída Agregada:**
```text
1 127.0.0.1
```

---

## 🛡️ Conclusões e Medidas de Contenção (Blue Team)
1. **Auditoria de Linha de Comando:** O encadeamento de comandos Unix (`grep`, `awk`, `sort`, `uniq`) viabiliza triagens rápidas no SOC sem necessidade imediata de interfaces gráficas.
2. **Correlação de Identidades:** Falhas de autenticação associadas a `Invalid user` indicam atividade de enumeração de contas (*account harvesting*).
3. **Respostas Automáticas:** IPs reincidentes devem ser bloqueados automaticamente via regras de `fail2ban` ou ACLs restritivas de firewall (`iptables`).
