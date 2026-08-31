# 🛡️ Lab 13: Auditoria do Kernel Linux e Rastreamento de Syscalls com Auditd

## 📌 Visão Geral
Em investigações forenses e operações de SOC, a manipulação de logs tradicionais de aplicação pode ocultar a ação de atacantes. O subsistema **Linux Audit Daemon (`auditd`)** opera no espaço do kernel (*kernel-space*), capturando chamadas de sistema (*syscalls*), execuções de binários arbitrários e adulterações em arquivos sensíveis de forma imutável, registrando o identificador original do usuário (`auid`), mesmo após escalonamento de privilégios (`sudo`/`su`).

---

## 🎯 Objetivos Técnicos
* Instalar, habilitar e auditar o status operacional do daemon `auditd`.
* Criar e carregar regras dinâmicas de auditoria via `auditctl` para monitoramento de escrita (`-p wa`) e execução (`-p x`).
* Rastrear alterações no arquivo crítico de senhas `/etc/shadow` associando uma chave de busca (`-k shadow_tamper`).
* Rastrear a execução de ferramentas de reconhecimento de rede (`/usr/bin/nmap`) com chave de busca (`-k recon_nmap`).
* Realizar consultas forenses estruturadas utilizando o utilitário `ausearch` com resolução de identificadores (`-i`).

---

## 🧪 Topologia e Ferramentas
* **Ambiente:** Kali Linux
* **Serviços:** `auditd`, `systemd`
* **Ferramental:** `auditctl`, `ausearch`, `aureport`
* **Syscalls Auditadas:** `openat` (File Access/Write), `execve` (Process Execution)

---

## 🚀 Passo a Passo Prático

### 1. Habilitação e Inspeção do Status do Subsistema de Auditoria
Ativação do serviço e validação do suporte no kernel:

```bash
sudo apt install -y auditd audispd-plugins
sudo systemctl enable --now auditd
sudo auditctl -s
```

**Evidência Operacional (Auditd Ativo no Kernel):**
```text
enabled 1
failure 1
pid 171968
rate_limit 0
backlog_limit 8192
lost 0
backlog 0
```

---

### 2. Configuração de Regras de Auditoria no Kernel
Criação de gatilhos para integridade de credenciais e detecção de reconhecimento:

```bash
# Monitorar escrita e alteração de atributos no /etc/shadow
sudo auditctl -w /etc/shadow -p wa -k shadow_tamper

# Monitorar a execução do binário nmap
sudo auditctl -w /usr/bin/nmap -p x -k recon_nmap

# Listar regras carregadas no kernel
sudo auditctl -l
```

**Evidência das Regras Ativas:**
```text
-w /etc/shadow -p wa -k shadow_tamper
-w /usr/bin/nmap -p x -k recon_nmap
```

---

### 3. Simulação de Ações Suspeitas (Geração de Telemetria)
Execução controlada das ações monitoradas:

```bash
# Simular tentativa de manipulação no arquivo de hashes
sudo touch /etc/shadow

# Simular varredura de portas local
nmap 127.0.0.1 -p 80
```

---

### 4. Análise Forense com `ausearch`

#### A. Investigação da Adulteração em `/etc/shadow`
```bash
sudo ausearch -k shadow_tamper -i
```

**Evidência Forense Coletada:**
```text
type=PROCTITLE msg=audit(08/31/26 02:18:15.717:56) : proctitle=touch /etc/shadow
type=PATH msg=audit(08/31/26 02:18:15.717:56) : item=1 name=/etc/shadow inode=396090 mode=file,640 ouid=root ogid=shadow
type=CWD msg=audit(08/31/26 02:18:15.717:56) : cwd=/home/kali
type=SYSCALL msg=audit(08/31/26 02:18:15.717:56) : arch=x86_64 syscall=openat success=yes exit=3 a0=AT_FDCWD a1=0x7ffa79d578d a2=O_WRONLY|O_CREAT|O_NOCTTY|O_NONBLOCK a3=0x1b6 items=2 ppid=175233 pid=175234 auid=kali uid=root gid=root euid=root suid=root fsuid=root egid=root sgid=root fsgid=root comm=touch exe=/usr/bin/touch subj=unconfined key=shadow_tamper
```

* **Análise:** O kernel registrou a chamada `openat` com flags `O_WRONLY|O_CREAT` no arquivo `/etc/shadow`. O campo `auid=kali` comprova a identidade de login original do operador que executou a ação, enquanto `euid=root` indica a elevação de privilégios.

---

#### B. Investigação da Execução do `nmap`
```bash
sudo ausearch -k recon_nmap -i
```

**Evidência Forense Coletada:**
```text
type=PROCTITLE msg=audit(08/31/26 02:18:28.313:59) : proctitle=nmap 127.0.0.1 -p 80
type=PATH msg=audit(08/31/26 02:18:28.313:59) : item=1 name=/usr/bin/nmap inode=1484021 mode=file,755 ouid=root ogid=root
type=EXECVE msg=audit(08/31/26 02:18:28.313:59) : argc=4 a0=nmap a1=127.0.0.1 a2=-p a3=80
type=SYSCALL msg=audit(08/31/26 02:18:28.313:59) : arch=x86_64 syscall=execve success=yes exit=0 a0=0x55e2619d2ea0 a1=0x55e2619d2a40 a2=0x55e261995070 a3=0x4522105a8ddc489 items=3 ppid=7169 pid=175339 auid=kali uid=kali gid=kali euid=kali suid=kali fsuid=kali egid=kali sgid=kali fsgid=kali comm=nmap exe=/usr/bin/nmap subj=unconfined key=recon_nmap
```

* **Análise:** O evento capturou a execução de processo (`execve`) com todos os argumentos passados em linha de comando (`a0=nmap a1=127.0.0.1 a2=-p a3=80`), mapeando a atividade de reconhecimento em rede.

---

## 🛡️ Lições Aprendidas e Aplicação no SOC
1. **Rastreabilidade Não Repudiável (`auid`):** O campo `auid` (*Audit UID*) preserva a sessão de autenticação inicial do usuário antes de qualquer `sudo` ou `su`, inviabilizando a perda de rastreabilidade de ações privilegiadas.
2. **Visibilidade Profunda de Processos:** Diferente do monitoramento tradicional de processos (`ps`), o `auditd` captura comandos de vida efêmera que são executados e finalizados em milissegundos.
3. **Persistência de Regras:** Para persistir as regras após reinicialização do sistema operacional, as diretivas devem ser salvas no arquivo de configuração `/etc/audit/rules.d/audit.rules`.
