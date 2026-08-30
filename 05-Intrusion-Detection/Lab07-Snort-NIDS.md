# 🛡️ Lab 07: Detecção e Prevenção de Intrusão com Snort (NIDS)

## 📌 Visão Geral do Laboratório
Este laboratório aborda a configuração, escrita de regras personalizadas e operação do **Snort** operando como um **NIDS (Network Intrusion Detection System)**. O objetivo é demonstrar a capacidade de inspecionar pacotes de rede em tempo real, identificar padrões de tráfego malicioso e gerar alertas detalhados para atuação do SOC.

---

## 🎯 Objetivos Técnicos
- Validar a instalação e sintaxe dos arquivos de configuração do Snort.
- Criar regras customizadas de detecção para tráfego **ICMP suspeito**, **tentativas de login inseguro (Telnet)** e **varreduras de rede**.
- Executar o Snort em modo de escuta ativa na interface de rede.
- Simular vetores de ataque controlados e validar os logs de alerta gerados no console e em arquivo.

---

## 🧪 Topologia e Ferramental
- **Ambiente:** Linux (Kali Linux / Ubuntu)
- **Interface Monitorada:** `eth0` (ou interface de rede ativa)
- **Ferramentas:** `snort`, `ping`, `nmap`, `curl`

---

## 🚀 Passo a Passo Prático

### 1. Verificação da Instalação e Teste de Configuração
Antes de iniciar a captura, valida-se se o arquivo de configuração principal do Snort está íntegro:

```bash
sudo snort -T -c /etc/snort/snort.conf -i eth0
