# 🛡️ Lab 11: Monitoramento de Integridade de Arquivos (FIM com AIDE)

## 📌 Visão Geral
O Monitoramento de Integridade de Arquivos (*File Integrity Monitoring* - FIM) é um controle crítico para auditoria e detecção de persistências, backdoors e adulterações em configurações do sistema operacional. Este laboratório aborda a configuração do **AIDE (Advanced Intrusion Detection Environment)**, a geração de uma baseline criptográfica de integridade e a detecção de alterações não autorizadas em arquivos críticos via hash SHA-256.

---

## 🎯 Objetivos Técnicos
* Criar uma política de auditoria personalizada para arquivos e diretórios essenciais no `/etc/aide/aide.conf`.
* Gerar uma linha de base criptográfica inicial (*baseline database*) com hashes SHA-256 e SHA-512.
* Simular uma injeção maliciosa de dados no arquivo `/etc/hosts`.
* Executar a rotina de verificação (`--check`) e auditar as discrepâncias de integridade detectadas.

---

## 🧪 Topologia e Ferramentas
* **Ambiente:** Kali Linux
* **Ferramenta:** AIDE 0.19+ (File Integrity Monitoring)
* **Algoritmos Criptográficos:** SHA-256, SHA-512, STRIBOG, SHA3

---

## 🚀 Passo a Passo Prático

### 1. Configuração da Política de Integridade (`aide.conf`)
Criação do arquivo de configuração do AIDE monitorando permissões, dono, tamanho, data de modificação e hash SHA-256:

```bash
sudo mkdir -p /etc/aide /var/lib/aide
sudo tee /etc/aide/aide.conf > /dev/null << 'EOF'
database_in=file:/var/lib/aide/aide.db
database_out=file:/var/lib/aide/aide.db.new
gzip_dbout=no

CRITICAL = p+u+g+s+m+c+sha256

/etc/hosts CRITICAL
/etc/passwd CRITICAL
/etc/shadow CRITICAL
/etc/ssh/sshd_config CRITICAL
/bin CRITICAL
/sbin CRITICAL
EOF
```

---

### 2. Geração e Ativação da Baseline Criptográfica
Inicialização da base de dados e promoção para o banco de produção:

```bash
# Inicializar a base de dados
sudo aide --config /etc/aide/aide.conf --init

# Ativar como base oficial de comparação
sudo cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
```

**Evidência Operacional (Baseline Gerada):**
```text
AIDE successfully initialized database.
New AIDE database written to /var/lib/aide/aide.db.new
Number of entries:      12

The attributes of the (uncompressed) database(s):
/var/lib/aide/aide.db.new
SHA256   : unwci/ExOjX8QtJp21ECIeH/Whdd+kRwk2dhBsvE/4o=
SHA512   : 51FCzuq8jiVKBumS3+p7ZzIlere2+grbZPWgki8GFj42u3cgu+1ym/3A4ZgrV+Gip7B5v5M1CR4Q416TUec3rg==
```

---

### 3. Simulação de Adulteração Clandestina
Injeção de linha não autorizada no `/etc/hosts` simulando um ataque de redirecionamento/persistência:

```bash
echo "# Modificacao suspeita por invasor" | sudo tee -a /etc/hosts
```

---

### 4. Execução da Auditoria de Integridade (FIM Check)
Varredura do sistema confrontando o estado atual contra a baseline:

```bash
sudo aide --config /etc/aide/aide.conf --check
```

**Evidência de Detecção de Adulteração:**
```text
CTime    : 2023-08-14 09:42:43 +0000 | 2026-08-31 01:42:27 +0000
SHA256   : GjODtaMcnCcHmPJJA3yy53L/EywP4aUO | VBl8VqFBH6BdyZf2iqhWEjxXhVycqgU+j
           s4WeCGvGIK4=                     | rUetLmVtn4A=

The attributes of the (uncompressed) database(s):
/var/lib/aide/aide.db
SHA256   : unwci/ExOjX8QtJp21ECIeH/Whdd+kRwk2dhBsvE/4o=
```

---

## 🛡️ Lições Aprendidas e Aplicação no SOC
1. **Deteção Sem Assinatura de Rede:** O FIM detecta alterações mesmo que o atacante tenha usado credenciais válidas ou métodos que burlam NIDS e firewalls.
2. **Proteção da Base de Hashes:** Em ambientes de produção, o arquivo `aide.db` deve ser armazenado em mídia somente-leitura ou enviado remotamente para um servidor SIEM seguro.
3. **Automação Contínua:** Verificações de integridade devem ser agendadas via cron jobs diários ou disparadas via rotinas de conformidade (PCI-DSS, ISO 27001).
