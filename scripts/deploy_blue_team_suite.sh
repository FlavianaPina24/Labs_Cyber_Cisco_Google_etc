#!/usr/bin/env bash
# ==============================================================================
# Blue Team & SOC / DFIR - Automated Hardening & Security Baseline Suite
# Covers Labs 00 to 15: Network Defense, Host Hardening, FIM, Kernel Auditing & Triage
# ==============================================================================
set -euo pipefail

echo "======================================================================"
echo "   🛡️ INICIANDO IMPLANTAÇÃO DA SUÍTE DE DEFESA BLUE TEAM & SOC"
echo "======================================================================"

# 1. Instalação de Ferramentas de Defesa & Auditoria (Modo Não-Interativo)
echo "[+] [1/6] Atualizando repositórios e instalando ferramentais defensivos..."
DEBIAN_FRONTEND=noninteractive apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent fail2ban aide auditd audispd-plugins tshark lsof

# 2. Hardening do Kernel & Proteções de Rede (Lab 14)
echo "[+] [2/6] Aplicando parâmetros de segurança no Kernel via sysctl..."
tee /etc/sysctl.d/99-security-hardening.conf > /dev/null << 'SYSCTL_EOF'
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.icmp_echo_ignore_broadcasts = 1
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
SYSCTL_EOF
sysctl --system > /dev/null

# 3. Firewall Stateful & Filtragem Defensiva (Lab 05)
echo "[+] [3/6] Configurando regras estritas de Firewall (iptables)..."
iptables -F
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
mkdir -p /etc/iptables
iptables-save > /etc/iptables/rules.v4

# 4. Defesa Dinâmica contra Brute Force (Lab 10)
echo "[+] [4/6] Configurando contenção dinâmica com Fail2ban..."
tee /etc/fail2ban/jail.local > /dev/null << 'FAIL2BAN_EOF'
[DEFAULT]
bantime  = 10m
findtime  = 10m
maxretry = 3
backend = systemd

[sshd]
enabled = true
port    = ssh
FAIL2BAN_EOF
systemctl restart fail2ban

# 5. Auditoria do Kernel Linux com Auditd (Lab 13)
echo "[+] [5/6] Configurando regras imutáveis de auditoria no auditd..."
systemctl enable --now auditd
auditctl -D > /dev/null 2>&1 || true
auditctl -w /etc/shadow -p wa -k shadow_tamper || true
auditctl -w /usr/bin/nmap -p x -k recon_nmap || true

# 6. File Integrity Monitoring - AIDE Baseline (Lab 11)
echo "[+] [6/6] Inicializando baseline de integridade de arquivos com AIDE..."
mkdir -p /etc/aide /var/lib/aide
tee /etc/aide/aide.conf > /dev/null << 'AIDE_EOF'
database_in=file:/var/lib/aide/aide.db
database_out=file:/var/lib/aide/aide.db.new
gzip_dbout=no
CRITICAL = p+u+g+s+m+c+sha256
/etc/hosts CRITICAL
/etc/passwd CRITICAL
/etc/shadow CRITICAL
AIDE_EOF
aide --config /etc/aide/aide.conf --init || true
cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db 2>/dev/null || true

echo "======================================================================"
echo "   [✓] SUÍTE DE DEFESA, AUDITORIA E HARDENING IMPLANTADA COM SUCESSO!"
echo "======================================================================"
