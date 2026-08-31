# 🛡️ Lab 10: Automação de Resposta a Incidentes com Fail2ban (Dynamic Firewall Containment)

## 📌 Visão Geral
Em operações de SOC e Blue Team, a automação da contenção reduz drasticamente a janela de exposição contra ataques automatizados de força bruta e varredura de credenciais. Este laboratório aborda a instalação, parametrização e operação do **Fail2ban**, integrando a leitura de logs do sistema via backend `systemd` à injeção dinâmica de regras de bloqueio de tráfego de rede.

---

## 🎯 Objetivos Técnicos
* Instalar e configurar o serviço Fail2ban criando uma política customizada em `/etc/fail2ban/jail.local`.
* Parametrizar tempos de banimento (`bantime`), janela de observação (`findtime`) e limite de tentativas (`maxretry`).
* Configurar o monitoramento de eventos de autenticação do serviço SSH via backend `systemd`.
* Executar ações manuais e automatizadas de resposta a incidentes (`banip` e `unbanip`).
* Auditar o status operacional da jail e validar a lista de atacantes contidos.

---

## 🧪 Topologia e Ferramentas
* **Ambiente:** Kali Linux
* **Serviços:** `fail2ban`, `sshd`, `systemd-journald`
* **Ferramental:** `fail2ban-client`, `systemctl`, `tee`

---

## 🚀 Passo a Passo Prático

### 1. Instalação e Preparação do Ambiente
Instalação do daemon e dependências de integração com o journal:

```bash
sudo apt install -y fail2ban
```

---

### 2. Configuração da Jail Customizada (`jail.local`)
Criação da política local de segurança para o serviço SSH sem sobrescrever os arquivos padrão:

```bash
sudo tee /etc/fail2ban/jail.local > /dev/null << 'EOF'
[DEFAULT]
bantime  = 10m
findtime  = 10m
maxretry = 3
ignoreip = 

[sshd]
enabled = true
port    = ssh
backend = systemd
EOF
```

**Parâmetros da Política:**
* `bantime = 10m`: Tempo de bloqueio temporário aplicado ao IP atacante.
* `findtime = 10m`: Janela de tempo considerada para contabilizar falhas consecutivas.
* `maxretry = 3`: Número máximo de tentativas inválidas antes do bloqueio automático.
* `backend = systemd`: Integração direta com os journals do systemd para leitura de eventos do `sshd`.

---

### 3. Inicialização e Inspeção da Jail SSH
Reinicialização do serviço para aplicação das regras e verificação do status inicial:

```bash
sudo systemctl restart fail2ban
sudo fail2ban-client status sshd
```

**Evidência Operacional (Status Inicial):**
```text
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     0
|  `- Journal matches:  _SYSTEMD_UNIT=ssh.service + _COMM=sshd
`- Actions
   |- Currently banned: 0
   |- Total banned:     0
   `- Banned IP list:
```

---

### 4. Execução de Contenção Ativa (Ban de IP Atacante)
Aplicação de ban imediato de um IP identificado durante a triagem do incidente:

```bash
sudo fail2ban-client set sshd banip 192.168.1.100
```

**Validação do Bloqueio Ativo:**
```bash
sudo fail2ban-client status sshd
```

**Evidência Coletada:**
```text
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     0
|  `- Journal matches:  _SYSTEMD_UNIT=ssh.service + _COMM=sshd
`- Actions
   |- Currently banned: 1
   |- Total banned:     1
   `- Banned IP list:   192.168.1.100
```

---

### 5. Procedimento de Desbloqueio e Recuperação (Unban)
Liberação manual do IP após análise e validação de falso positivo / encerramento do incidente:

```bash
sudo fail2ban-client set sshd unbanip 192.168.1.100
sudo fail2ban-client status sshd
```

---

## 🛡️ Lições Aprendidas e Recomendações (Blue Team)
1. **Contenção Dinâmica:** O uso do Fail2ban mitiga o consumo excessivo de recursos do servidor e saturação de logs causados por botnets de força bruta.
2. **Backends Modernos:** O backend `systemd` oferece maior resiliência na captura de eventos em tempo real em comparação com a leitura manual de arquivos estáticos como `/var/log/auth.log`.
3. **Equilíbrio de Regras:** Janelas de `findtime` e `bantime` progressivas (*recidive jails*) devem ser empregadas para punir com bloqueios mais longos atacantes que repetem investidas ao longo de dias.
