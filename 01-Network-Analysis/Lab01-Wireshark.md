# 🔍 Lab 01: Análise de Tráfego de Rede com Wireshark

## 🎯 Objetivo
Inspecionar pacotes de rede, analisar o aperto de mão TCP (three-way handshake) e identificar o comportamento de redirecionamento HTTP/HTTPS.

---

## ⚙️ Comandos e Filtros

1. Iniciar a captura na interface ativa (`eth0` ou `wlan0`).
2. Aplicar o filtro de visualização no Wireshark:
   `http || tls`
3. Inspecionar o fluxo da sessão:
   - Clicar com o botão direito sobre o pacote HTTP capturado.
   - Selecionar **Follow -> TCP Stream** para visualizar cabeçalhos, requisições e respostas em texto claro.

---

## 📊 Resultados e Análise Técnica

- Identificação visual dos códigos de status HTTP `301 Moved Permanently` e `302 Found`.
- Análise da transição da navegação em texto claro para a sessão segura criptografada via TLS/HTTPS na porta 443.
