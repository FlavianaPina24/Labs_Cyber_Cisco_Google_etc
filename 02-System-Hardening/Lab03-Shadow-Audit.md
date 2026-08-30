# 🔐 Lab 03: Hardening de Identidades e Hashes (/etc/shadow)

## 🎯 Objetivo
Inspecionar a separação de credenciais no Linux, compreendendo a estrutura do `/etc/passwd` e o armazenamento protegido de hashes criptográficos no `/etc/shadow`.

---

## ⚙️ Comandos e Validação

1. Consultar a entrada do usuário no arquivo público de contas:
   `grep "analista_soc" /etc/passwd`
   - *Resultado esperado:* `analista_soc:x:1001:1001::/home/analista_soc:/bin/bash`
   - *Análise:* O caractere `x` indica que a senha está protegida e redirecionada para o arquivo de hashes.

2. Inspecionar a linha criptografada no shadow com privilégio de root:
   `sudo grep "analista_soc" /etc/shadow`
   - *Estrutura do hash Yescrypt:* `$y$j9T$salt$hash...`

---

## 📊 Análise Técnica de Segurança
- Uso do algoritmo moderno Yescrypt (`$y$`) baseado em Scrypt/Argon2 para dificultar ataques de força bruta offline.
- Restrição de leitura do arquivo `/etc/shadow` apenas para a conta `root`.
