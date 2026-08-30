---

## 🧠 Base Teórica e Fundamentos Operacionais (SOC & Cyber Defense)

### 🔬 1. Análise de Malware, Sandboxes e Engenharia Reversa
* **Comparativo de Sandboxes:**
  * **Cuckoo Sandbox:** Solução open-source e local personalizável para análise automatizada de arquivos suspeitos.
  * **ANY.RUN:** Sandbox interativa SaaS que permite análise dinâmica em tempo real com capturas de tela e interação com o malware.
  * **Cisco Threat Grid / AMP:** Plataformas proprietárias integradas para análise comportamental e telemetria global.
* **Técnicas de Evasão e Análise:**
  * **Ofuscação e Camuflagem:** Uso de packers e criptografia de payloads para dificultar a análise estática e burlar antivírus.
  * **Mecanismos Anti-VM / Anti-Sandbox:** Detecção de drivers de máquina virtual, checagem de núcleos de CPU e atrasos de execução (*sleep timers*).
  * **Análise Estática vs. Dinâmica:** Extração de hashes e strings vs. monitoramento de processos, registro e tráfego em tempo de execução.

---

### 🌐 2. Segurança de Redes, Perímetro e Firewalls
* **Firewalls Corporativos & ZFW:** Segmentação baseada em zonas (*Zone-Based Policy Firewall*) entre rede interna, externa e DMZ.
* **Acesso Remoto Seguro:** Bloqueio do Telnet e uso obrigatório de SSH nas linhas VTY com o comando `transport input ssh`.
* **Firewall de Host:** Criação de regras de filtragem no Windows Defender Firewall e no iptables do Linux.
* **Honeypots na DMZ:** Sistemas-isca para atrair invasores, coletar telemetria e atrasar ataques laterais.
* **NIDS vs. NIPS:** 
  * **NIDS:** Passivo via espelhamento de porta (SPAN/TAP) para envio de alertas.
  * **NIPS:** Ativo e posicionado inline para descarte de pacotes maliciosos em tempo real.

---

### 💻 3. Segurança de Endpoints e Administração Linux
* **HIDS:** Detecção de invasões e anomalias baseada no host diretamente no sistema operacional.
* **Identidades e Permissões:**
  * Usuários no `/etc/passwd` e hashes isolados no `/etc/shadow`.
  * Permissões octais restritivas (`chmod 750`) e auditoria de binários com bit **SUID/SGID**.
* **FIM (File Integrity Monitoring):** Monitoramento contínuo da integridade de arquivos críticos do sistema com ferramentas como **Tripwire**.

---

### ☁️ 4. Nuvem, Virtualização e Criptografia
* **Virtualização:** Otimização de servidores, consolidação de hardware e economia de espaço em rack.
* **Hipervisores:**
  * **Tipo 1 (Bare-Metal):** Roda direto no hardware físico (ex.: Proxmox, VMware ESXi).
  * **Tipo 2 (Hosted):** Roda sobre um sistema operacional comum (ex.: VirtualBox).
* **Proteção em Nuvem:** Adoção de MFA, criptografia de dados em trânsito/repouso e soluções de **DLP** para e-mails e arquivos.

---

### 🔑 5. Gestão de Identidade, Acesso e Modelo AAA
* **Federação de Identidades (FIdM):** SSO e login federado via protocolos **OAuth 2.0**, **OpenID Connect (OIDC)** e **SAML**.
* **Pilares AAA:**
  * **Autenticação:** Validação da identidade do usuário.
  * **Autorização:** Controle do que o usuário tem permissão para acessar.
  * **Auditoria (Accounting):** Registro e rastreabilidade de todas as ações em logs.
* **Fatores do MFA:** Algo que você sabe (senha), algo que você tem (token/celular) e algo que você é (biometria).

---

### 🚨 6. Resposta a Incidentes (NIST SP 800-61) e Computação Forense
* **Fases NIST SP 800-61:** Preparação -> Detecção e Análise -> Contenção, Erradicação e Recuperação -> Pós-incidente (Lições Aprendidas).
* **Perícia Forense:**
  * Nunca reiniciar ou desligar máquinas ativas para não perder os dados voláteis da memória RAM.
  * Seguir a **Ordem de Volatilidade (RFC 3227)**: Memória RAM -> Estado de Rede -> Disco Rígido.
  * Garantir a integridade da cópia forense através do cálculo de hashes criptográficos (**SHA-256** / **MD5**).
  * Registro rigoroso da **Cadeia de Custódia** para validade jurídica.

---

### 🎯 7. Inteligência de Ameaças e Métricas CVSS
* **Cisco Talos:** Feed de Threat Intelligence para regras do Snort, ClamAV e SpamCop.
* **Métricas do CVSS v3:** Avaliação de vulnerabilidades pelos grupos **Base** (Vetor, Complexidade, Privilégios, Escopo e Impacto), **Temporal** e **Ambiental**.
* **OSINT:** Coleta não intrusiva de inteligência em fontes públicas abertas.
* **MITRE ATT&CK:** Framework para identificação e mapeamento de Táticas, Técnicas e Procedimentos (TTPs) dos atacantes.

---

### 🏢 8. Ferramentas de SOC, Continuidade de Negócios e Governança
* **Ferramentas de SOC:**
  * **SIEM:** Centralização e correlação de logs.
  * **Tripwire:** Auditoria de integridade de arquivos (FIM).
  * **GFI LANguard:** Varredura de vulnerabilidades e gestão de patches.
  * **L0phtCrack:** Auditoria de força de senhas.
* **Continuidade de Negócios:**
  * **Exercícios de Mesa (Tabletop):** Simulações teóricas sem interrupção operacional.
  * **Métricas:** **RTO** (tempo máximo para voltar) e **RPO** (tolerância máxima de perda de dados).
  * **Sites de Contingência:** Hot Site (ativo imediato), Warm Site (estrutura pronta) e Cold Site (básico).
* **Segurança L2 em Switches:** Configuração de **DHCP Snooping** (bloqueio de servidores DHCP falsos) e **Dynamic ARP Inspection - DAI** (proteção contra ARP Poisoning).
