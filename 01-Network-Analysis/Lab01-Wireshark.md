# 🔍 Lab 01: Análise de Tráfego de Rede com Wireshark

## 🎯 Objetivo
Inspecionar pacotes de rede, analisar o aperto de mão TCP (*three-way handshake*) e identificar o comportamento de redirecionamento HTTP/HTTPS.

---

## ⚙️ Comandos e Filtros
1. Iniciar a captura na interface ativa.
2. Aplicar o filtro de visualização:
   ```text
   http || tls
