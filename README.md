# 🛡️ Blue Team & SOC / DFIR Practice Labs

Repositório estruturado contendo laboratórios práticos, análises de pacotes em baixo nível, políticas de contenção, monitoramento de integridade, auditoria do kernel e resposta a incidentes (DFIR).

---

## 📑 Índice dos Laboratórios

| Lab | Domínio Técnico | Descrição Prática | Link |
| :---: | :--- | :--- | :---: |
| **00** | **Análise de Tráfego de Rede** | Inspeção e dissecção de pacotes HTTP com `Wireshark` / `Tshark` | [Acessar Lab 00](00-Network-Traffic-Analysis/Lab00-Traffic-Analysis.md) |
| **01** | **Investigação de Tráfego Malicioso** | Dissecção forense de ataque DoS volumétrico (SYN Flood) | [Acessar Lab 01](01-Malicious-Traffic-Analysis/Lab01-DoS-SYN-Flood-Investigation.md) |
| **02** | **Inspeção de Credenciais** | Identificação e extração de credenciais em texto claro via PCAP | [Acessar Lab 02](02-Credential-Analysis/Lab02-Plaintext-Credentials-Extraction.md) |
| **03** | **Análise de Port Scanning** | Detecção e caracterização de varreduras TCP SYN / Full Connect | [Acessar Lab 03](03-Port-Scan-Analysis/Lab03-Port-Scanning-Detection.md) |
| **04** | **Engenharia de Regras NIDS** | Criação e validação de regras de detecção de assinaturas com `Snort 3` | [Acessar Lab 04](04-Snort-NIDS-Rules/Lab04-Snort3-Rule-Engineering.md) |
| **05** | **Firewall & Filtragem de Pacotes** | Criação de regras de firewall stateful e bloqueios seletivos com `iptables` | [Acessar Lab 05](05-Firewall-Hardening-iptables/Lab05-iptables-Defensive-Rules.md) |
| **06** | **Auditoria de Permissões & SUID** | Identificação de binários SUID mal configurados e riscos GTFOBins | [Acessar Lab 06](06-Linux-Hardening-SUID/Lab06-SUID-Privilege-Escalation-Defense.md) |
| **07** | **Análise Forense de Logs (SOC)** | Investigação de ataques de força bruta SSH via `auth.log` / `journalctl` | [Acessar Lab 07](07-Log-Analysis-SOC/Lab07-SSH-BruteForce-Investigation.md) |
| **08** | **Threat Hunting em Processos & Conexões** | Detecção de backdoors e conexões reversas ativas via `ss`, `lsof` e `/proc` | [Acessar Lab 08](08-Threat-Hunting-Linux/Lab08-Process-Network-Investigation.md) |
| **09** | **Auditoria de Políticas de Senha & Shadow** | Hardening de contas, hashing seguro (SHA-512) e expiração de senhas | [Acessar Lab 09](06-Linux-Hardening-SUID/Lab09-Shadow-Password-Policy-Hardening.md) |
| **10** | **Contenção Dinâmica contra Brute Force** | Defesa ativa e banimento automatizado de IPs atacantes com `Fail2ban` | [Acessar Lab 10](08-Dynamic-Defense-Fail2ban/Lab10-Fail2ban-SSH-Protection.md) |
| **11** | **Integridade de Arquivos (FIM)** | Detecção de adulterações, hashes SHA-256 e baselines com `AIDE` | [Acessar Lab 11](09-File-Integrity-Monitoring/Lab11-AIDE-Integrity-Check.md) |
| **12** | **Persistência & Threat Hunting** | Caça a artefatos em `Cron`, `Systemd services` e `SSH Authorized Keys` | [Acessar Lab 12](10-Threat-Hunting-Persistence/Lab12-Linux-Persistence-Artifacts.md) |
| **13** | **Auditoria do Kernel (Auditd)** | Rastreamento de syscalls, monitoramento de credenciais e logs com `auditd` | [Acessar Lab 13](11-Kernel-Auditing-Auditd/Lab13-Auditd-Syscall-Tracking.md) |
| **14** | **Kernel & Network Hardening** | Mitigação de SYN Flood, IP Spoofing e proteção de memória com `sysctl` | [Acessar Lab 14](12-Kernel-Hardening-Sysctl/Lab14-Kernel-Network-Hardening.md) |
| **15** | **Automação Forense (DFIR Triage)** | Coleta automatizada de evidências voláteis e cadeia de custódia SHA-256 | [Acessar Lab 15](13-DFIR-Automation/Lab15-Incident-Response-Triage-Collector.md) |
| **16** | **Análise Estática & Strings (Trilha A)** | Extração de IOCs (C2, IPs, paths) e classificação ELF com `strings` e `file` | [Acessar Lab 16](14-Malware-Analysis-YARA/Lab01-Static-Analysis-Strings-Extraction.md) |
---

## 🛠️ Tecnologias e Ferramentas Praticadas

* **Network Analysis:** Wireshark, Tshark, Nmap, TCP/IP, ICMP, HTTP/TLS
* **Defesa & Detecção:** Snort 3 (NIDS), iptables (Firewall Stateful), Fail2ban (Dynamic Containment), AIDE (FIM), Auditd (Kernel Auditing)
* **Threat Hunting & DFIR:** `ss`, `lsof`, `ps`, `/proc` inspection, GTFOBins audit, SUID hunt, Cron & Systemd Persistence Hunting, SSH Key Auditing, `ausearch`, `aureport`, Bash Incident Response Automation
* **SOC & Log Analysis:** `journalctl`, `auth.log`, `wtmp/btmp`, `last`, `grep`, `awk`, `sort`, `uniq`
* **Hardening:** Linux Access Control (`chmod`/`chown`), Shadow Password Policies, SSH Security, Kernel Tuning (`sysctl`)
* **Malware Analysis & Reversing:** `strings`, `file`, `binutils`, `gcc`, ELF binary format, YARA
---

## 🚀 Como Executar

1. Clone o repositório em uma distribuição Linux (Kali Linux / Ubuntu):
```bash
git clone https://github.com/FlavianaPina24/Labs_Cyber_Cisco_Google_etc.git
cd Labs_Cyber_Cisco_Google_etc
