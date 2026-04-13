# 🚀 Sistema de Gestão de Ativos e Service Desk: GLPI 11 na AWS

## 🎯 Objetivo

Este repositório contém a documentação técnica e os procedimentos de deploy para a implementação do GLPI 11.0.6 em ambiente de nuvem, focado em otimização de recursos e conformidade com as novas exigências de segurança da versão 11.

| Detalhe | Valor |
| :--- | :--- |
| **Documento** | Documento Tecnico |
| **Tecnologias** | Microsoft Entra ID (Azure AD) |
| **Escopo** | Procedimento tecnico relacionado a 📑 sistema de gestão de ativos e service desk: glpi 11 na aws. |
| **Pre-requisitos** | Acessos administrativos, rede configurada e dependencias do ambiente validadas. |

---

## 📌 1. O Cenário / Problema

O desafio consistia em implantar uma solução robusta de ITSM (IT Service Management) para centralizar a gestão de inventário e chamados técnicos. O ambiente alvo era uma instância AWS EC2 t3.micro (recurso computacional limitado: 2 vCPUs e 1GB RAM).

**As principais dificuldades técnicas identificadas foram:**

Gestão de Recursos: A escassez de memória RAM para sustentar a stack LAMP e o banco de dados MariaDB simultaneamente.

Segurança de Diretórios: A versão 11 do GLPI exige que apenas o diretório /public esteja exposto ao servidor web, visando mitigar vulnerabilidades de acesso direto a arquivos de sistema.

Dependências Modernas: A necessidade de garantir que todas as extensões do PHP 8.3 estivessem presentes para suportar as novas funcionalidades de criptografia e internacionalização da ferramenta.

## 📌 2. A Solução

A abordagem adotada foi o deploy de uma stack LAMP (Linux, Apache, MariaDB, PHP) otimizada.

**Tecnologias Utilizadas:**

AWS EC2 (Ubuntu 24.04 LTS): Escolhido pela estabilidade do kernel e ciclo de vida longo.

PHP 8.3: Versão de runtime necessária para performance e compatibilidade com o GLPI 11.

MariaDB 10.11: Utilizado como motor de banco de dados devido à sua eficiência em ambientes de baixo consumo de memória.

Linux Swap (1GB): Implementado como medida de contornamento (workaround) para evitar falhas de Out-Of-Memory (OOM) no MariaDB durante processos de indexação ou busca pesada.

## 🧱 3. Topologia / Arquitetura

A arquitetura segue o modelo de servidor único (Standalone), mas com separação lógica de privilégios.

Fluxo de Dados: O tráfego entra pela porta 80/443, é processado pelo VirtualHost do Apache que, por segurança, aponta para a pasta /public. O PHP-FPM processa as requisições e comunica-se via socket local com o MariaDB.

Segurança de Rede: A instância está inserida em uma VPC, com o Security Group liberando apenas os protocolos necessários (HTTP, HTTPS, SSH) e restringindo o acesso administrativo ao IP da gestão.

## 📌 4. Passo a Passo (Runbook)

### 🔹 4.1. Preparação do S.O e Instalação de Dependências

**Atualização do repositório e instalação dos pacotes necessários para o PHP 8.3:**

```bash
Bash
sudo apt update && sudo apt upgrade -y
sudo apt install apache2 mariadb-server php8.3 php8.3-curl php8.3-gd php8.3-mbstring \
```

php8.3-xml php8.3-mysql php8.3-bz2 php8.3-zip php8.3-intl php8.3-ldap \
php8.3-bcmath php8.3-sodium -y
### 🔹 4.2. Provisionamento do Banco de Dados

**Configuração da base de dados utilizando o collation recomendado para evitar erros de caracteres especiais:**

SQL
CREATE DATABASE glpi CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'glpi_user'@'localhost' IDENTIFIED BY 'SUA_SENHA_SEGURA';
GRANT ALL PRIVILEGES ON glpi.* TO 'glpi_user'@'localhost';
FLUSH PRIVILEGES;
### 🔹 4.3. Configuração de Permissões e Segurança

**Ajuste do proprietário dos arquivos para o usuário do serviço web e aplicação do endurecimento (hardening) de diretórios:**

```bash
Bash
# Definindo permissões no diretório raiz
sudo chown -R www-data:www-data /var/www/html/glpi
sudo chmod -R 755 /var/www/html/glpi
```

Nota: O VirtualHost deve ser configurado com DocumentRoot /var/www/html/glpi/public.

### 🔹 4.4. Tuning do PHP (php.ini)

**Ajustes realizados para garantir a estabilidade do sistema e suporte a uploads:**

Ini, TOML
memory_limit = 256M
upload_max_filesize = 20M
date.timezone = America/Sao_Paulo
session.cookie_httponly = on
### 🔹 4.5. Troubleshooting (Resolução de Erros)

Problema: Instabilidade do MariaDB ao iniciar a instalação via Web.

Causa: Esgotamento da memória RAM física (1GB).

Solução: Criação de um arquivo de Swap de 1GB para garantir memória virtual de backup.

```bash
Bash
```

sudo fallocate -l 1G /swapfile
```bash
sudo chmod 600 /swapfile
```

sudo mkswap /swapfile
sudo swapon /swapfile
# Adicionado ao /etc/fstab para persistência
