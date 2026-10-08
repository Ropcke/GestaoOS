# Sistema de Gestão de Ordens de Serviço (OS)

Sistema desktop em arquitetura em camadas desenvolvido em Delphi para gestão completa de Ordens de Serviço (OS), contemplando cadastro de clientes, controle mestre-detalhe de serviços, validação de regras de SLA com alertas visuais, dashboard analítico e emissão de relatórios agrupados com exportação.

---

## 🛠️ Stack Tecnológica & Ambiente

- **Linguagem / IDE:** Delphi 10.2 Tokyo (compatível com VCL de versões posteriores)
- **Banco de Dados:** Firebird 3.0+
- **Componentes de Acesso a Dados:** FireDAC
- **Gerador de Relatórios:** FastReport 6 VCL
- **Arquitetura:** Camadas separadas em UI (Forms), DataModules (Acesso a Dados) e Domain/Service (Regras de Negócio e Cálculos)

---

## 🗄️ Estrutura do Banco de Dados & Scripts

O modelo relacional do projeto é composto por três entidades principais:

1. `CLIENTE`: Armazena dados cadastrais dos clientes (Nome, Documento, E-mail, Telefone, Data de Cadastro).
2. `ORDEM_SERVICO`: Tabela mestre para registro das OS (Cliente, Data de Abertura, Data Prevista, Status, Descrição do Problema e Valor Total).
3. `ITEM_ORDEM`: Tabela detalhe vinculada via Foreign Key (`ORDEM_ID`), contendo os itens/serviços prestados (Descrição, Quantidade e Valor Unitário).

> **Arquivo de Criação:** O script SQL completo com a criação das tabelas, Foreign Keys, índices e carga inicial de testes está disponível na raiz do repositório no arquivo `script_banco.sql`.

---

## ⚙️ Configuração e Execução do Projeto

### 1. Configuração do Banco de Dados
1. Certifique-se de ter o servidor **Firebird 3.0 (ou superior)** instalado e em execução na máquina.
2. Crie uma base de dados no Firebird ou utilize o banco fornecido.
3. Execute o script `script_banco.sql` no seu gerenciador SQL de preferência (ex.: FlameRobin, DBeaver) para criar a estrutura e os dados de teste.

### 2. Configuração da Conexão (`conexao.ini`)
O sistema utiliza um arquivo de configuração de banco dinâmico para facilitar a execução sem necessidade de recompilação. Na pasta do executável, crie ou edite o arquivo `conexao.ini` com o seguinte padrão:

```ini
[CONEXAO]
DriverID=FB
Database=C:\Caminho\Do\Banco\GESTAO_OS.FDB
User_Name=SYSDBA
Password=masterkey
Server=localhost
Port=3050