# 🚀 Sistema de Gestão de Ativos e Service Desk: GLPI 11 na AWS

## 🎯 Objetivo

Este repositório contém a documentação técnica avançada para a implementação, customização e endurecimento do GLPI 11.0.6. O projeto foca em escalabilidade, automação de notificações e integração com o ecossistema corporativo.

| Detalhe | Valor |
| :--- | :--- |
| **Documento** | Documento Tecnico |
| **Tecnologias** | Tecnologias identificadas automaticamente |
| **Escopo** | Procedimento tecnico relacionado a o desafio inicial era implantar uma solução de itsm robusta em uma instância aws ec2 t3.micro (1gb ram). com a evolução do projeto, surgiu a necessidade de:. |
| **Pre-requisitos** | Acessos administrativos, rede configurada e dependencias do ambiente validadas. |

---

## 📌 1. O Cenário / Problema

Comunicação Falha: A ausência de notificações automáticas gerava atrasos nos SLAs.

Complexidade da Interface: O excesso de campos nativos dificultava a adoção do sistema pelos usuários finais.

Rastreabilidade: Necessidade de campos customizados para gestão de patrimônio e centros de custo.

## 📌 2. A Solução

**Além da stack LAMP otimizada com PHP 8.3 e MariaDB 10.11, implementamos uma camada de inteligência de negócio:**

Relay de E-mail (SMTP): Integração com Google Workspace via TLS (Porta 587) utilizando App Passwords.

Customização de UX: Simplificação de formulários e modelos de chamados.

Ecossistema de Plugins: Expansão das funcionalidades nativas para suporte a SLAs complexos e relatórios gerenciais.

## 🧱 3. Topologia / Arquitetura

A solução foi expandida para incluir integrações externas e automação via Cron.

Camada de Aplicação: GLPI 11.0.6 rodando sobre Apache (diretório /public exposto).

Camada de Dados: MariaDB com suporte a utf8mb4.

Serviços de Background: Agendador de tarefas (Crontab) processando filas de e-mail e automações a cada 60 segundos.

Saída de Dados: Conexão segura com smtp.gmail.com para disparos transacionais.

## 📌 4. Passo a Passo (Runbook)

### 🔹 4.1. Instalação e Performance (Base)

```bash
Bash
# Instalação da Stack e Extensões PHP 8.3
sudo apt update && sudo apt upgrade -y
sudo apt install apache2 mariadb-server php8.3 php8.3-curl php8.3-gd php8.3-mbstring \
```

php8.3-xml php8.3-mysql php8.3-bz2 php8.3-zip php8.3-intl php8.3-ldap \
php8.3-bcmath php8.3-sodium -y

# Ativação do Swap (Essencial para t3.micro)
sudo fallocate -l 1G /swapfile && sudo chmod 600 /swapfile
sudo mkswap /swapfile && sudo swapon /swapfile
### 🔹 4.2. Configuração de Notificações (SMTP)

Configurado em: Configurar > Notificações > Configuração de acompanhamentos por e-mail.

Modo de envio: SMTP+TLS.

Servidor: smtp.gmail.com | Porta: 587.

Autenticação: Sim (App Password de 16 dígitos).

### 🔹 4.3. Plugins e Customização Corporativa

**Módulos validados e instalados no ambiente:**

Fields: Adição de campos de "Patrimônio" e "Centro de Custo".

Escalade: Gestão automática de escalonamento de tickets.

Meta-Demands: Fluxos de trabalho integrados (Onboarding de funcionários).

MReporting: Dashboards para métricas de TMA (Tempo Médio de Atendimento).

### 🔹 4.4. Automação do Sistema (Cron)

**Para que os e-mails e SLAs funcionem, o Cron do Linux foi configurado:**

```bash
Bash
# Editar o crontab do usuário www-data
```

sudo crontab -u www-data -e

# Adicionar a linha abaixo para execução por minuto
* * * * * /usr/bin/php8.3 /var/www/html/glpi/front/cron.php
### 🔹 4.5. Troubleshooting (Resolução de Erros)

Erro: Erro de autenticação SMTP ao usar a senha padrão da conta Google.

Causa: Bloqueio de "Apps menos seguros" pelo Google.

Solução: Ativação de 2FA e criação de uma Senha de Aplicativo dedicada.

Erro: Campo "Urgência" confundindo usuários.

Solução: Criação de Modelos de Chamado simplificados, ocultando campos via interface técnica.
