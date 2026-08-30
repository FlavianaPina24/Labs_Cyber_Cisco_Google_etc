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
- **Ferramentas:** `snort`, `ping`, `nmap`, `nc`, `curl`

---

## 🚀 Passo a Passo Prático

### 1. Verificação da Instalação do Snort 3
Validação da versão instalada e suporte aos módulos DAQ e PCAP:

```bash
snort -V
```

---

### 2. Criação de Regras Customizadas de Detecção
Criação do diretório e do arquivo de regras locais (`/etc/snort/rules/local.rules`):

```bash
sudo mkdir -p /etc/snort/rules
sudo nano /etc/snort/rules/local.rules
```

Insira as seguintes assinaturas:

```text
# Regra 1: Detectar pacotes ICMP Echo Request (Ping Sweep / Reconhecimento)
alert icmp any any -> any any (msg:"[SOC-ALERTA] ICMP Echo Request Detectado"; itype:8; sid:1000001; rev:1;)

# Regra 2: Detectar tentativa de conexao não criptografada Telnet (Porta 23)
alert tcp any any -> any 23 (msg:"[SOC-ALERTA] Tentativa de Conexao Telnet (Insegura)"; sid:1000002; rev:1;)

# Regra 3: Detectar requisicao HTTP com Scanner (User-Agent Nikto)
alert tcp any any -> any 80 (msg:"[SOC-ALERTA] Varredura HTTP com Scanner Detectada"; content:"nikto",nocase; sid:1000003; rev:1;)
```

**Anatomia da regra:**
- `alert`: Ação tomada quando o tráfego corresponde aos critérios.
- `icmp / tcp`: Protocolo de transporte/rede inspecionado.
- `any any -> any [porta]`: Origem (IP/porta) para Destino (IP/porta).
- `msg`: Mensagem de alerta exibida para o analista de SOC.
- `sid`: *Signature ID* único para identificar a regra (regras customizadas usam $\ge 1000000$).
- `rev`: Versão de revisão da assinatura.

---

### 3. Execução do Snort em Modo IDS Ativo
Inicie o motor do Snort apontando para a interface local com alertas em tempo real no console:

```bash
sudo snort -i eth0 -R /etc/snort/rules/local.rules -A alert_fast -s 65535 -k none
```
- `-i eth0`: Interface de rede a ser monitorada em modo promíscuo.
- `-R /etc/snort/rules/local.rules`: Caminho para o arquivo de regras customizadas.
- `-A alert_fast`: Formato rápido de exibição de alertas com timestamp e IPs.
- `-k none`: Desativa a validação de checksum para evitar descarte em placas virtuais.

---

### 4. Simulação de Ataques e Validação de Alertas

#### Cenário A: Disparo de ICMP Ping
Em outro terminal:
```bash
ping -c 3 8.8.8.8
```
**Resultado no console do Snort:**
```text
08/30-23:32:20.523675 [**] [1:1000001:1] "[SOC-ALERTA] ICMP Echo Request Detectado" [**] [Priority: 0] {ICMP} 10.0.2.15 -> 8.8.8.8
08/30-23:32:21.525559 [**] [1:1000001:1] "[SOC-ALERTA] ICMP Echo Request Detectado" [**] [Priority: 0] {ICMP} 10.0.2.15 -> 8.8.8.8
08/30-23:32:22.525907 [**] [1:1000001:1] "[SOC-ALERTA] ICMP Echo Request Detectado" [**] [Priority: 0] {ICMP} 10.0.2.15 -> 8.8.8.8
```

#### Cenário B: Tentativa de Conexão em Porta Insegura (Telnet 23)
```bash
nc -vn -w 2 8.8.8.8 23
```
**Resultado no console do Snort:**
```text
08/30-23:35:10.654321 [**] [1:1000002:1] "[SOC-ALERTA] Tentativa de Conexao Telnet (Insegura)" [**] [Priority: 0] {TCP} 10.0.2.15:45892 -> 8.8.8.8:23
```

---

## 🛡️ Lições Aprendidas e Recomendações de Defesa (Blue Team)
1. **Assinaturas Precisas:** Regras com campos como `content` e `nocase` aumentam a precisão na identificação de payloads e scanners automatizados.
2. **Posicionamento de Sensores:** Em arquiteturas corporativas, sensores NIDS são posicionados em portas espelho (SPAN/TAP) de switches centrais e na DMZ para máxima visibilidade de tráfego leste-oeste e norte-sul.
3. **Integração SIEM:** Alertas gerados pelo Snort são centralizados via Syslog/Logstash para correlação automatizada de eventos no SIEM (Wazuh/Splunk/Elastic).
