# 📚 Cyber Defense & SOC Security Labs Library

Biblioteca prática e documentação técnica dos laboratórios de **Cyber Defense**, **Linux Hardening**, **Análise de Tráfego** e **Threat Hunting**.

---

## 🗂️ Grade de Laboratórios Práticos

| # | Laboratório | Foco Técnico | Ferramentas / Comandos Principais |
| :-: | :--- | :--- | :--- |
| **01** | **Análise de Tráfego de Rede** | Inspeção de pacotes e redirecionamento HTTP/HTTPS | `Wireshark`, `TCP Stream`, `HTTP 301/302` |
| **02** | **Reconhecimento de Superfície** | Varredura de portas e detecção de versões | `nmap -sS -sV -T4` |
| **03** | **Forense e Auditoria de Logs** | Triagem de tentativas de força bruta e telemetria | `journalctl -u ssh`, `grep` |
| **04** | **Hardening de Identidades** | Hashes protegidos e criptografia moderna | `/etc/passwd`, `/etc/shadow`, Yescrypt `$y$` |
| **05** | **Controle de Acesso e Permissões** | Aplicação do Princípio do Menor Privilégio | `chmod 750`, `ls -l`, `Bash` |
| **06** | **Threat Hunting: Bit SUID** | Caça a vetores de escalada de privilégios | `find / -perm -4000 -type f`, `GTFOBins` |
| **07** | **Host Defense & Firewall** | Filtragem Stateful e contenção de tráfego | `iptables`, `conntrack`, `DROP/ACCEPT` |

---

## 🛠️ Detalhamento dos Módulos

### 🔍 Módulo 1: Análise e Reconhecimento de Redes
* **Lab 01 (Wireshark):** Inspeção de handshakes TCP e tráfego web com filtro `http || tls`.
* **Lab 02 (Nmap):** Mapeamento de portas e versões de serviços:
  ```bash
  nmap -sS -sV -T4 <TARGET_IP>
