# 🛡️ Lab 04: Controle de Acesso e Menor Privilégio (Chmod)

## 🎯 Objetivo
Aplicar o Princípio do Menor Privilégio na criação e execução de scripts administrativos, restringindo permissões para evitar execuções indevidas por usuários não autorizados.

---

## ⚙️ Comandos e Execução

1. Criar script de teste:
   `echo -e '#!/bin/bash\necho "[+] Auditoria de Seguranca Concluida"' > script_auditoria.sh`

2. Auditar permissões padrão geradas pelo umask:
   `ls -l script_auditoria.sh`
   - *Padrão:* `-rw-r--r--`

3. Aplicar política restritiva (Dono: Leitura/Escrita/Execução, Grupo: Leitura/Execução, Outros: Nenhum acesso):
   `chmod 750 script_auditoria.sh`

4. Executar e validar saída:
   `./script_auditoria.sh`
   - *Resultado:* `[+] Auditoria de Seguranca Concluida`

---

## 📊 Análise Técnica de Segurança
- Uso da máscara octal `750` (`rwxr-x---`) para isolamento de scripts de auditoria em servidores multiusuário.
- Prevenção contra leitura e execução de ferramentas internas por usuários não privilegiados no sistema.
