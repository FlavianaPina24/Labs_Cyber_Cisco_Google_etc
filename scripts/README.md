# ⚙️ Scripts de Automação & Security as Code

Este diretório reúne os scripts operacionais desenvolvidos para automação de hardening, monitoramento defensivo e resposta a incidentes (DFIR).

---

## 📜 Inventário de Scripts

### 1. `deploy_blue_team_suite.sh` (Orquestrador de Hardening & Monitoramento)
Script unificado para provisionamento automatizado de linhas de base defensivas:
* **Hardening de Kernel:** Configura parâmetros `sysctl` contra IP Spoofing, SYN Flood e vazamento de ponteiros de memória.
* **Firewall Stateful:** Aplica políticas estritas no `iptables` com política padrão DROP.
* **Contenção Dinâmica:** Configura o `Fail2ban` para bloqueio automático de ataques de força bruta no SSH.
* **Auditoria de Kernel:** Carrega regras no `auditd` para monitorar chamadas de sistema e acessos a arquivos críticos (`/etc/shadow`).
* **Integridade de Arquivos (FIM):** Inicializa e ativa a base de hashes criptográficos no `AIDE`.

**Execução:**
```bash
chmod +x deploy_blue_team_suite.sh
sudo ./deploy_blue_team_suite.sh
```

---

### 2. `dfir_collector.sh` (Live Incident Response Triage)
Script forense automatizado para coleta de evidências voláteis em conformidade com a **RFC 3227**:
* Extrai metadados do host, sessões ativas e tabelas de rotas.
* Captura conexões ativas e portas em escuta (`ss`).
* Mapeia árvores de processos e sockets abertos (`ps`, `lsof`).
* Audita vetores de persistência (`cron`, `systemd`).
* Empacota as evidências em arquivo `.tar.gz` com cálculo de hash SHA-256 para preservação da cadeia de custódia.

**Execução:**
```bash
sudo /usr/local/bin/dfir_collector.sh
```
