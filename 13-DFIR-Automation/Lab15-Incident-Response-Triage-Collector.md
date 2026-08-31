# 🚨 Lab 15: Automação Forense de Resposta a Incidentes (Live Triage & Artifact Collector Script)

## 📌 Visão Geral
Durante um incidente de segurança em um ambiente corporativo, a rapidez na coleta de evidências voláteis determina o sucesso da análise forense. Seguindo as diretrizes da **RFC 3227 (Order of Volatility)**, este laboratório aborda o desenvolvimento e a execução de um script em Shell para coleta automatizada de telemetria de rede, processos em memória, usuários logados e artefatos de persistência, empacotando os dados com cálculo de hash SHA-256 para preservação da **Cadeia de Custódia Forense**.

---

## 🎯 Objetivos Técnicos
* Desenvolver um coletor automatizado de *Live Response Triage* em Bash.
* Capturar dados em ordem de volatilidade: conexões de rede ativas, portas em escuta, árvore de processos e sockets abertos.
* Auditar pontos de persistência (`cron` e `systemd`) e base de contas locais (`/etc/passwd`).
* Compactar os dados em formato `.tar.gz` e gerar assinatura criptográfica de integridade SHA-256.
* Inspecionar a integridade do pacote gerado.

---

## 🧪 Topologia e Ferramentas
* **Ambiente:** Kali Linux
* **Script:** `dfir_collector.sh`
* **Ferramental Forense:** `ss`, `lsof`, `ps`, `tar`, `sha256sum`, `uptime`, `who`

---

## 🚀 Passo a Passo Prático

### 1. Criação do Coletor Forense Automatizado (`/usr/local/bin/dfir_collector.sh`)

```bash
sudo tee /usr/local/bin/dfir_collector.sh > /dev/null << 'EOF'
#!/usr/bin/env bash
# ==============================================================================
# DFIR Live Incident Response Artifact Collector (Linux Triage)
# RFC 3227 Volatile Data Acquisition
# ==============================================================================
set -euo pipefail

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
CASE_DIR="/tmp/dfir_case_${TIMESTAMP}"
mkdir -p "${CASE_DIR}"

echo "[*] Iniciando coleta forense ao vivo em: ${CASE_DIR}"

# 1. Informações de Sistema & Uptime
echo "[+] Coletando metadados do host..."
uname -a > "${CASE_DIR}/system_info.txt"
uptime >> "${CASE_DIR}/system_info.txt"
who -a > "${CASE_DIR}/active_sessions.txt"

# 2. Conexões de Rede Ativas & Sockets
echo "[+] Coletando telemetria de rede (L3/L4)..."
ss -tulpn > "${CASE_DIR}/listening_ports.txt"
ss -tanp > "${CASE_DIR}/active_network_connections.txt"
ip route > "${CASE_DIR}/routing_table.txt"

# 3. Processos em Execução & Memória
echo "[+] Coletando árvore de processos e binários..."
ps auxf > "${CASE_DIR}/process_tree.txt"
lsof -i -P -n > "${CASE_DIR}/open_network_files.txt" 2>/dev/null || true

# 4. Mecanismos de Persistência & Contas
echo "[+] Auditando persistências e contas locais..."
cat /etc/passwd > "${CASE_DIR}/passwd.txt"
ls -la /etc/cron* /var/spool/cron/crontabs/ > "${CASE_DIR}/cron_persistence.txt" 2>/dev/null || true
ls -la /etc/systemd/system/ > "${CASE_DIR}/systemd_services.txt"

# 5. Integridade Forense (Geração de Hash da Evidência)
echo "[+] Compactando evidências e gerando hash de custódia..."
tar -czf "/tmp/evidence_${TIMESTAMP}.tar.gz" -C "/tmp" "dfir_case_${TIMESTAMP}"
sha256sum "/tmp/evidence_${TIMESTAMP}.tar.gz" > "/tmp/evidence_${TIMESTAMP}.tar.gz.sha256"

rm -rf "${CASE_DIR}"

echo "[✓] Coleta finalizada com sucesso!"
echo "[✓] Pacote de Evidências: /tmp/evidence_${TIMESTAMP}.tar.gz"
echo "[✓] Hash SHA-256 de Custódia:"
cat "/tmp/evidence_${TIMESTAMP}.tar.gz.sha256"
EOF

sudo chmod +x /usr/local/bin/dfir_collector.sh
```

---

### 2. Execução da Coleta ao Vivo
Execução com privilégios de root para acesso irrestrito aos ponteiros do `/proc`:

```bash
sudo /usr/local/bin/dfir_collector.sh
```

**Evidência de Execução:**
```text
[*] Iniciando coleta forense ao vivo em: /tmp/dfir_case_20260831_024027
[+] Coletando metadados do host...
[+] Coletando telemetria de rede (L3/L4)...
[+] Coletando árvore de processos e binários...
[+] Auditando persistências e contas locais...
[+] Compactando evidências e gerando hash de custódia...
[✓] Coleta finalizada com sucesso!
[✓] Pacote de Evidências: /tmp/evidence_20260831_024027.tar.gz
[✓] Hash SHA-256 de Custódia:
bb69f683ceda9243cfa091d34794154d77d56913f0029a6a4f495a772f9f076f  /tmp/evidence_20260831_024027.tar.gz
```

---

### 3. Validação Estrutural das Evidências Coletadas

```bash
tar -ztvf /tmp/evidence_*.tar.gz
```

**Artefatos Preservados:**
```text
drwxr-xr-x root/root         0 2026-08-31 02:40 dfir_case_20260831_024027/
-rw-r--r-- root/root      1738 2026-08-31 02:40 dfir_case_20260831_024027/systemd_services.txt
-rw-r--r-- root/root      2078 2026-08-31 02:40 dfir_case_20260831_024027/cron_persistence.txt
-rw-r--r-- root/root      3301 2026-08-31 02:40 dfir_case_20260831_024027/passwd.txt
-rw-r--r-- root/root       795 2026-08-31 02:40 dfir_case_20260831_024027/open_network_files.txt
-rw-r--r-- root/root     46645 2026-08-31 02:40 dfir_case_20260831_024027/process_tree.txt
-rw-r--r-- root/root       416 2026-08-31 02:40 dfir_case_20260831_024027/routing_table.txt
-rw-r--r-- root/root       816 2026-08-31 02:40 dfir_case_20260831_024027/active_network_connections.txt
-rw-r--r-- root/root       288 2026-08-31 02:40 dfir_case_20260831_024027/listening_ports.txt
-rw-r--r-- root/root       272 2026-08-31 02:40 dfir_case_20260831_024027/active_sessions.txt
-rw-r--r-- root/root       164 2026-08-31 02:40 dfir_case_20260831_024027/system_info.txt
```

---

## 🛡️ Lições Aprendidas e Aplicação no SOC / DFIR
1. **Volatilidade dos Dados:** Informações de rede e processos residem na memória RAM. Desligar a máquina incorretamente acarreta a perda definitiva desses IOCs.
2. **Cadeia de Custódia:** A geração imediata do arquivo `.sha256` assegura que a evidência não foi adulterada durante o transporte para a estação de análise forense.
3. **Mínima Pegada no Host:** A execução de scripts consolidados reduz o número de comandos interativos manuais, preservando o estado original do sistema operacional sob investigação.
