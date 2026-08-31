# 🕵️‍♂️ Lab 09: Análise Forense de Processos e Conexões Ocultas no Linux (Live Forensics & DFIR)

## 📌 Visão Geral
Em cenários de intrusão, atacantes frequentemente estabelecem persistência ou canais de comando e controle (C2) por meio de backdoors ouvindo em portas não convencionais. Este laboratório simula a presença de um listener malicioso em background e demonstra as técnicas forenses ativas (Live Forensics) utilizadas por analistas de SOC/DFIR para identificar o PID, inspecionar o pseudofilesystem `/proc`, correlacionar portas de rede e executar a contenção imediata da ameaça.

---

## 🎯 Objetivos Técnicos
* Mapear conexões de rede ativas e sockets em estado `LISTEN` associando-os aos seus respectivos PIDs.
* Inspecionar argumentos de processos e executáveis vinculados através do `/proc/[PID]/`.
* Correlacionar descritores de arquivos abertos e tráfego de rede via `lsof`.
* Executar procedimentos de resposta a incidentes (IR) para erradicação de processos maliciosos.

---

## 🧪 Topologia e Ferramentas
* **Ambiente:** Kali Linux
* **Artefato Malicioso Simulado:** Backdoor com `nc` expondo `/bin/bash` na porta `4444/TCP`
* **Ferramentas Forenses:** `ss`, `ps`, `lsof`, `/proc` filesystem, `kill`

---

## 🚀 Passo a Passo Prático

### 1. Simulação do Incidente (Execução do Backdoor em Background)
Execução de um listener persistente em segundo plano com redirecionamento de shell:

```bash
nohup nc -lvnp 4444 -e /bin/bash > /dev/null 2>&1 &
```

**Evidência Operacional:**
```text
[1] 74103
```
> O processo foi alocado em segundo plano sob o **PID 74103**.

---

### 2. Triagem de Rede: Detecção da Porta Oculta (`ss`)
Mapeamento de sockets de escuta TCP/UDP com resolução de processos (`-tulpn`):

```bash
sudo ss -tulpn | grep 4444
```

**Evidência Coletada:**
```text
tcp   LISTEN 0      1            0.0.0.0:4444       0.0.0.0:*    users:(("nc",pid=74103,fd=3))
```

---

### 3. Inspeção de Processo e Argumentos de Execução (`ps`)
Verificação da árvore do processo, usuário executor e parâmetros utilizados:

```bash
ps aux | grep 74103 | grep -v grep
```

**Evidência Coletada:**
```text
kali       74103  0.0  0.0   2584  2048 pts/0    S    00:13   0:00 nc -lvnp 4444 -e /bin/bash
```

---

### 4. Análise de Arquivos Abertos e Sockets (`lsof`)
Mapeamento de descritores de arquivo, nós de rede e tipo de conexão atrelados à porta:

```bash
sudo lsof -i :4444
```

**Evidência Coletada:**
```text
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
nc      74103 kali    3u  IPv4 302413      0t0  TCP *:4444 (LISTEN)
```

---

### 5. Investigação do Pseudofilesystem `/proc`
Auditoria forense do binário real subjacente apontado pelo link simbólico `/proc/[PID]/exe`:

```bash
ls -l /proc/74103/exe
```

**Evidência Coletada:**
```text
lrwxrwxrwx 1 kali kali 0 Aug 31 00:16 /proc/74103/exe -> /usr/bin/nc.traditional
```

---

### 6. Contenção e Erradicação da Ameaça
Finalização forçada do processo malicioso via sinal `SIGKILL (-9)` e validação de liberação do socket:

```bash
# Encerrar o processo pelo PID identificado
sudo kill -9 74103

# Validar que a porta foi liberada
sudo ss -tulpn | grep 4444
```

---

## 🛡️ Lições Aprendidas e Conclusões Forenses (Blue Team)
1. **Visibilidade do `/proc`:** O diretório `/proc/[PID]` preserva metadados críticos como binário de origem (`exe`), diretório de execução atual (`cwd`), variáveis de ambiente (`environ`) e descritores de arquivos (`fd`), mesmo que o invasor tente renomear o processo em memória.
2. **Correlacionamento Cruzado:** A identificação de portas abertas (`ss`) deve ser imediatamente cruzada com `lsof` e `ps` para atestar a legitimidade dos argumentos de inicialização.
3. **Persistência e Contenção:** Além de matar o processo malicioso com `kill -9`, a resposta a incidentes deve auditar serviços systemd, tarefas no `cron` e chaves autorizadas em `~/.ssh/authorized_keys` para impedir reinicializações não autorizadas.
