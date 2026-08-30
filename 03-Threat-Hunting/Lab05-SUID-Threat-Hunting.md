# 🎯 Lab 05: Threat Hunting - Auditoria de Binários com Bit SUID

## 🎯 Objetivo
Identificar arquivos executáveis com a permissão especial SUID (*Set User ID*) ativa, mapeando potenciais superfícies de escalada de privilégios (*Privilege Escalation*) e verificando conformidade com as diretrizes do **GTFOBins**.

---

## ⚙️ Comandos e Execução

1. Executar varredura a partir da raiz suprimindo mensagens de erro de permissão:
   `find / -perm -4000 -type f 2>/dev/null`

2. Validar binários do sistema identificados:
   - `/usr/bin/sudo` e `/usr/bin/su` (Elevação administrativa legítima via sudoers)
   - `/usr/bin/passwd` (Gravação segura de senhas no `/etc/shadow`)
   - `/usr/bin/pkexec` (Polkit - componente crítico a ser monitorado para falhas como CVE-2021-4034)

---

## 📊 Análise Técnica de SOC / Blue Team
- O bit SUID faz com que o processo execute com os privilégios do dono do arquivo (geralmente `root`).
- Binários não padrão com SUID ativo devem ser continuamente auditados para prevenir que atacantes escapem de shells restritos para obter acesso administrativo pleno.
