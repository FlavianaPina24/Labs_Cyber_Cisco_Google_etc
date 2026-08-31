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
