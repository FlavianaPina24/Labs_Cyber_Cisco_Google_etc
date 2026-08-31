# 🛡️ Lab 14: Hardening de Kernel Linux & Proteções de Rede com Sysctl

## 📌 Visão Geral
O utilitário `sysctl` permite configurar parâmetros de tempo de execução no espaço do kernel (*kernel-space*) por meio do sistema de arquivos virtual `/proc/sys/`. Este laboratório aborda a blindagem da pilha de rede TCP/IP e restrições de visibilidade de memória, mitigando ataques de **IP Spoofing**, negação de serviço via **SYN Flood**, ataques **Man-in-the-Middle (MitM) via ICMP Redirects** e vazamento de ponteiros de memória do kernel.

---

## 🎯 Objetivos Técnicos
* Criar uma política persistente de hardening de kernel no diretório `/etc/sysctl.d/`.
* Habilitar mitigação contra exaustão de conexões TCP através de **TCP SYN Cookies**.
* Configurar o filtro de rota reversa (**Reverse Path Filtering - `rp_filter`**) contra pacotes forjados (IP Spoofing).
* Bloquear o processamento e envio de redirecionamentos ICMP maliciosos.
* Restringir o acesso a logs do buffer de mensagens do kernel (`dmesg_restrict`) e ponteiros (`kptr_restrict`).
* Validar a aplicação das diretivas diretamente na árvore de execução do kernel.

---

## 🧪 Topologia e Ferramentas
* **Ambiente:** Kali Linux
* **Ferramental:** `sysctl`, `/etc/sysctl.d/`, `/proc/sys/`
* **Camadas de Proteção:** Network Layer (L3), Transport Layer (L4), Kernel Isolation

---

## 🚀 Passo a Passo Prático

### 1. Definição da Política de Segurança (`99-security-hardening.conf`)
Criação do arquivo de parametrização estrita de rede e isolamento:

```bash
sudo tee /etc/sysctl.d/99-security-hardening.conf > /dev/null << 'EOF'
# 1. Proteção contra IP Spoofing (Reverse Path Filtering)
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# 2. Mitigação contra SYN Flood Attacks (SYN Cookies)
net.ipv4.tcp_syncookies = 1

# 3. Bloquear redirecionamentos ICMP maliciosos (Mitigação de MitM)
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0

# 4. Ignorar requisições ICMP de Broadcast (Mitigação de Smurf Attack)
net.ipv4.icmp_echo_ignore_broadcasts = 1

# 5. Restringir acesso a logs e ponteiros do Kernel (ASLR & dmesg)
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
EOF
```

---

### 2. Aplicação das Regras no Kernel Ativo
Carregamento dinâmico sem necessidade de reinicialização do sistema:

```bash
sudo sysctl --system
```

---

### 3. Validação Operacional dos Parâmetros

#### A. Verificação do TCP SYN Cookies
```bash
sudo sysctl net.ipv4.tcp_syncookies
```
**Saída:** `net.ipv4.tcp_syncookies = 1`

#### B. Verificação do Reverse Path Filtering (Anti-Spoofing)
```bash
sudo sysctl net.ipv4.conf.all.rp_filter
```
**Saída:** `net.ipv4.conf.all.rp_filter = 1`

#### C. Verificação da Restrição do dmesg
```bash
sudo sysctl kernel.dmesg_restrict
```
**Saída:** `kernel.dmesg_restrict = 1`

---

## 🛡️ Mecanismos de Defesa Explicados (Blue Team)
| Parâmetro | Mecanismo de Defesa | Vetor Mitigado |
| :--- | :--- | :--- |
| `tcp_syncookies = 1` | Responde ao SYN inicial com cookie criptográfico no seq number sem alocar estado em memória até receber o ACK final. | SYN Flood DoS |
| `rp_filter = 1` | Descarta pacotes cuja rota de retorno não corresponda à interface de entrada de onde o pacote se originou. | IP Spoofing / DDoS Reflection |
| `accept_redirects = 0` | Impede que roteadores maliciosos alterem a tabela de roteamento do host local via mensagens ICMP Type 5. | Man-in-the-Middle (MitM) |
| `dmesg_restrict = 1` | Bloqueia leitura de `dmesg` para usuários não-root, impedindo mapeamento de vulnerabilidades locais e offsets. | Privilege Escalation Recon |

---

## 🛡️ Lições Aprendidas
1. **Defesa em Profundidade:** Parâmetros de `sysctl` atuam antes mesmo que os pacotes atinjam aplicações de usuário, reduzindo overhead de CPU durante ataques volumétricos.
2. **Persistência Declarativa:** Arquivos criados em `/etc/sysctl.d/` garantem que o estado seguro permaneça consistente após reboots.
