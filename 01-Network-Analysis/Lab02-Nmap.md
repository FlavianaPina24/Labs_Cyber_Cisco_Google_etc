# 🌐 Lab 02: Mapeamento de Superfície de Ataque com Nmap

## 🎯 Objetivo
Identificar portas TCP abertas, banners de versões de serviços ativos e realizar varredura de reconhecimento furtivo.

---

## ⚙️ Comandos e Execução

1. Executar varredura furtiva TCP SYN Scan com detecção de versão:
   `nmap -sS -sV -T4 <TARGET_IP>`
2. Mapeamento de portas específicas de serviços web e administração:
   `nmap -p 22,80,443,8080 <TARGET_IP>`

---

## 📊 Resultados e Análise Técnica
- Mapeamento das portas e identificação dos serviços ativos (SSH, HTTP, HTTPS).
- Levantamento de versões de software para correlação com bases de vulnerabilidades conhecidas (CVEs).
