# 🧱 Lab 06: Firewall Stateful e Contenção de Tráfego com iptables

## 🎯 Objetivo
Implementar filtragem de pacotes nas camadas de rede (ICMP) e transporte (TCP), estruturar uma política de firewall baseada em estado (*Stateful*) e auditar contadores de telemetria e precedência de regras.

---

## ⚙️ Comandos e Execução Técnica

1. **Permitir tráfego de retorno de conexões legítimas (Stateful):**
   `sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT`

2. **Permitir comunicação interna na interface de Loopback:**
   `sudo iptables -A INPUT -i lo -j ACCEPT`

3. **Inserir regra de LOG para tráfego na porta 8080 (Posição 1):**
   `sudo iptables -I INPUT 1 -p tcp --dport 8080 -j LOG --log-prefix "FIREWALL-DROP-8080: " --log-level 4`

4. **Inserir regra de bloqueio silencioso (DROP) na porta 8080 (Posição 2):**
   `sudo iptables -I INPUT 2 -p tcp --dport 8080 -j DROP`

5. **Auditar contadores de pacotes e bytes por linha:**
   `sudo iptables -L INPUT -v -n --line-numbers`

6. **Limpeza do ambiente (após testes):**
   `sudo iptables -F INPUT`

---

## 📊 Análise Técnica de SOC / Incident Response
- **Precedência de Regras:** Pacotes destinados à porta 8080 acionam o log e são descartados antes de atingir as regras subsequentes.
- **Isolamento de Host:** A política de descarte silencioso (`DROP`) previne a enumeração de serviços por invasores sem expor mensagens de rejeição explícita.
