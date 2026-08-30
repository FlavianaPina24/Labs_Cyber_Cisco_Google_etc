## 🛠️ Guia Prático de Ferramentas e Comandos de Cibersegurança

### 🔬 1. Análise de Malware e Sandboxing

* **Cuckoo Sandbox**
  * **Finalidade:** Análise dinâmica automatizada de artefatos maliciosos em ambiente isolado on-premises.
  * **Exemplo de Uso:** Submeter executáveis para monitorar chamadas de API do Windows e persistência.
  * **Comandos Principais:**
    * Iniciar serviço principal: `cuckoo -d`
    * Submeter amostra para análise: `cuckoo submit /caminho/amostra_malware.exe`

* **ANY.RUN**
  * **Finalidade:** Sandbox interativa em nuvem (SaaS) com telemetria em tempo real e captura de tela.
  * **Exemplo de Uso:** Interagir com telas de phishing e simular preenchimento para capturar C2.

* **Cisco Secure Malware Analytics (Threat Grid) & AMP**
  * **Finalidade:** Mecanismo corporativo de proteção avançada contra malware integrado a feeds globais.

---

### 🔑 2. Auditoria de Senhas e Identidade

* **L0phtCrack**
  * **Finalidade:** Auditoria de robustez e quebra de hashes de senha corporativas (SAM / Active Directory).
  * **Exemplo de Uso:** Validar a conformidade da política de senhas contra ataques de dicionário.
  * **Comando Principal:**
    * Executar auditoria de hashes NTLM com wordlist: `lc7 -a ntlm -d wordlist.txt hashes_exportados.txt`

---

### 🛡️ 3. Monitoramento de Integridade e Endpoints (FIM & SIEM)

* **Tripwire / OSSEC (FIM & HIDS)**
  * **Finalidade:** Monitoramento de integridade de arquivos de sistema e detecção de intrusão baseada em host.
  * **Exemplo de Uso:** Detectar alterações não autorizadas em binários do sistema e arquivos de configuração.
  * **Comandos Principais (Tripwire):**
    * Inicializar banco de dados de integridade (baseline): `tripwire --init`
    * Executar auditoria comparativa com a baseline: `tripwire --check`

* **SIEM (Splunk / QRadar / Wazuh)**
  * **Finalidade:** Centralização, correlação de eventos e monitoramento contínuo de logs.
  * **Consulta de Exemplo (Splunk SPL para Brute Force):**
    * `index=windows EventCode=4625 | stats count by src_ip | where count > 10`

---

### 🔍 4. Gerenciamento de Vulnerabilidades

* **GFI LANguard**
  * **Finalidade:** Scanner de vulnerabilidades em rede local, inventário de ativos e gestão de patches.
  * **Exemplo de Uso:** Mapear serviços desatualizados e auditar patches de segurança pendentes.

---

### 📡 5. Inteligência de Ameaças, Regras de Rede e Antivírus

* **Cisco Talos**
  * **Finalidade:** Plataforma global de Threat Intelligence para fornecimento de assinaturas e regras.

* **Snort (NIDS/NIPS)**
  * **Finalidade:** Detecção e prevenção de intrusão de rede baseado em assinaturas.
  * **Exemplo de Regra (Detecção de Telnet na porta 23):**
    * `alert tcp any any -> any 23 (msg:"Tentativa de Conexao Telnet detectada"; sid:1000001; rev:1;)`
  * **Comando de Execução:**
    * `snort -A console -q -u snort -g snort -c /etc/snort/snort.conf -i eth0`

* **ClamAV**
  * **Finalidade:** Motor antivírus open-source para varredura de diretórios e servidores.
  * **Comandos Principais:**
    * Atualizar assinaturas via Talos/comunidade: `freshclam`
    * Escanear diretório alertando arquivos infectados: `clamscan -r -i /var/log/`

---

### 💻 6. Administração, Hardening e Defesa de Host

* **Linux Identity & Access Management:**
  * Criar usuário com diretório pessoal e shell bash: `sudo useradd -m -s /bin/bash analista_soc`
  * Definir senha para a conta criada: `sudo passwd analista_soc`
  * Aplicar permissões octais restritivas: `chmod 744 script_auditoria.sh`
  * Auditar mapeamento de contas e hashes: `/etc/passwd` e `/etc/shadow`

* **Windows Defender Firewall (PowerShell):**
  * Criar regra de entrada para receber pacotes Syslog (UDP 514):
    * `New-NetFirewallRule -DisplayName "Allow Syslog Inbound" -Direction Inbound -Protocol UDP -LocalPort 514 -Action Allow`

* **Cisco IOS Switch/Router Hardening:**
  * Restringir conexões remotas VTY para SSH:
    * `Switch(config)# line vty 0 4`
    * `Switch(config-line)# transport input ssh`
    * `Switch(config-line)# login local`
    * `Switch(config-line)# exit`
  * Mitigar ataques de Camada 2 (DHCP Snooping & Dynamic ARP Inspection):
    * `Switch(config)# ip dhcp snooping`
    * `Switch(config)# ip dhcp snooping vlan 10`
    * `Switch(config)# ip arp inspection vlan 10`
