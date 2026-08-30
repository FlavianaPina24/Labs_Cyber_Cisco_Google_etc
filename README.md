# 🛡️ Hands-on: Host-based Firewall & Packet Filtering with iptables (Linux Security)

Repositório com a documentação técnica, comandos de configuração e validação prática de regras de firewall no Linux utilizando **Netfilter/iptables** para cenários de **Cyber Defense**, **Blue Team** e **Resposta a Incidentes (Contenção de Ameaças)**.

---

## 🎯 Objetivos do Laboratório

- Implementar regras de filtragem nas camadas de **Rede (ICMP)** e **Transporte (TCP/UDP)**.
- Configurar arquitetura de firewall baseada em estado (**Stateful Firewall**) utilizando o módulo `conntrack`.
- Garantir a integridade de serviços locais via interface de **Loopback (`lo`)**.
- Aplicar regras com políticas de descarte silencioso (**DROP**) para mitigação de varreduras e tentativas de conexão não autorizadas.
- Auditar contadores de pacotes (`pkts`) e bytes (`bytes`) para validação de telemetria e precedência de regras.

---

## 🧱 Arquitetura e Fluxo de Regras

```text
               +------------------------------------+
Entrada (SYN)  | Pacote TCP / ICMP chega à interface|
-------------->+------------------------------------+
                                 |
                                 v
          +----------------------------------------------+
          | Regra 1: LOG e Regra 2: DROP (Porta 8080)    | ---> [ Pacote descartado / Log gerado ]
          +----------------------------------------------+
                                 | (Se não der match)
                                 v
          +----------------------------------------------+
          | Regra 3: ACCEPT conntrack ESTABLISHED,RELATED| ---> [ Tráfego de retorno liberado ]
          +----------------------------------------------+
                                 | (Se não der match)
                                 v
          +----------------------------------------------+
          | Regra 4: ACCEPT Interface de Loopback (-i lo)| ---> [ Comunicação interna aceita ]
          +----------------------------------------------+# Labs_Cyber_Cisco_Google_etc
