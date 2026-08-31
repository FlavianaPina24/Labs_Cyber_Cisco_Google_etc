# 🛡️ Cyber Defense & SOC Security Labs Library

Repositório técnico voltado para **Segurança Defensiva**, **Operações de SOC (Security Operations Center)**, **Threat Hunting** e **Análise Forense (DFIR)**. Contém documentações completas, simulações controladas em ambiente Linux e evidências reais de execução de linha de comando.

---

## 🧭 Índice Geral dos Módulos

| # | Módulo | Foco Técnico | Documento |
| :-: | :--- | :--- | :--- |
| **00** | **Fundamentos & Ferramentas** | Casos de uso, comandos e sintaxes operacionais | [Acessar Guia Teórico](00-Fundamentos-Teoricos/Guia-Ferramentas-Comandos.md) |
| **01** | **Análise de Tráfego de Rede** | Inspeção de pacotes, handshakes e fluxos HTTP/HTTPS | [Acessar Lab 01](01-Network-Analysis/Lab01-Wireshark.md) |
| **02** | **Reconhecimento de Superfície** | Varredura de portas e detecção de versões de serviços | [Acessar Lab 02](01-Network-Analysis/Lab02-Nmap.md) |
| **03** | **Hardening de Identidades** | Hashes protegidos e estrutura do `/etc/shadow` | [Acessar Lab 03](02-System-Hardening/Lab03-Shadow-Audit.md) |
| **04** | **Controle de Acesso** | Menor privilégio em scripts e permissões com `chmod` | [Acessar Lab 04](02-System-Hardening/Lab04-Permissions-Chmod.md) |
| **05** | **Threat Hunting** | Auditoria de binários com bit SUID e prevenção GTFOBins | [Acessar Lab 05](03-Threat-Hunting/Lab05-SUID-Threat-Hunting.md) |
| **06** | **Firewall & Contenção** | Filtragem Stateful e bloqueio de tráfego com `iptables` | [Acessar Lab 06](04-Firewall-Containment/Lab06-Iptables-Firewall.md) |
| **07** | **Detecção de Intrusão (NIDS)** | Assinaturas customizadas e alertas em tempo real com `Snort` | [Acessar Lab 07](05-Intrusion-Detection/Lab07-Snort-NIDS.md) |
| **08** | **Investigação de Logs & SOC** | Análise de `auth.log`, força bruta SSH e pipelines no shell | [Acessar Lab 08](06-Log-Analysis-SOC/Lab08-Linux-Log-Investigation.md) |
| **09** | **Live Forensics & Processos** | Caça a ameaças, portas em `LISTEN`, análise de `/proc` e contenção | [Acessar Lab 09](07-Digital-Forensics/Lab09-Process-Network-Forensics.md) |
| **10** | **Resposta Automatizada & Fail2ban** | Contenção dinâmica, políticas de `jail.local` e gestão de bans | [Acessar Lab 10](08-Incident-Response/Lab10-Fail2ban-Automation.md) |
---

## 🛠️ Tecnologias e Ferramentas Praticadas

* **Network Analysis:** Wireshark, Tshark, Nmap, TCP/IP, ICMP, HTTP/TLS
* **Defesa & Detecção:** Snort 3 (NIDS), iptables (Firewall Stateful)
* **Threat Hunting & DFIR:** `ss`, `lsof`, `ps`, `/proc` inspection, GTFOBins audit, SUID hunt
* **SOC & Log Analysis:** `journalctl`, `auth.log`, `wtmp/btmp`, `last`, `grep`, `awk`, `sort`, `uniq`
* **Hardening:** Linux Access Control (`chmod`/`chown`), Shadow Password Policies, SSH Security

---

## 🚀 Como Executar

1. Clone o repositório em uma distribuição Linux (Kali Linux / Ubuntu):
```bash
git clone https://github.com/FlavianaPina24/Labs_Cyber_Cisco_Google_etc.git
cd Labs_Cyber_Cisco_Google_etc
