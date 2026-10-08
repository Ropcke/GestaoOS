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
```

### 3. Compilação e Execução
1. Abra o projeto `GestaoOS.dpr` no Delphi 10.2 Tokyo.
2. Certifique-se de que os pacotes do **FireDAC** e **FastReport VCL** estão ativos na IDE.
3. Certifique-se de que o arquivo de leiaute do relatório (`RelatorioOS.fr3`) está presente na mesma pasta do executável (`Win32\Debug` ou `bin`).
4. Execute o projeto pressionando **F9**.

---

## 🚀 Funcionalidades & Destaques de Regras de Negócio

- **CRUD Mestre-Detalhe Transacional:** O formulário de cadastro de OS utiliza uma tabela em memória (`TFDMemTable`) para manipulação dinâmica dos itens na interface. A persistência no banco é realizada dentro de um bloco de transação explícito (`StartTransaction` / `Commit` / `Rollback`), garantindo atomicidade na gravação da OS e de seus respectivos itens.
- **Validação e Destaque de SLA (Funcionalidade Não-CRUD):** 
  - Regra de Atraso: Se `DATA_PREVISTA < CURRENT_DATE` e o status for diferente de `Concluida` ou `Cancelada`, a OS é categorizada automaticamente como em atraso.
  - Destaque Visual: Na listagem de Ordens de Serviço (`DBGrid`), as linhas com OS em atraso recebem coloração destacada através do evento `OnDrawColumnCell`.
- **Dashboard de Indicadores:** O painel superior da tela de consultas exibe contadores em tempo real para ordens *Abertas*, *Em Andamento*, *Concluídas* e *Em Atraso*.
- **Relatório e Exportação:** Relatório desenvolvido no FastReport 6 com suporte a agrupamento por Status, exibição de subtotais por grupo (quantidade e valor total acumulado), total geral e suporte nativo para exportação em formato **PDF** e **CSV**.

---

## 🏗️ Decisões Arquiteturais

1. **Separação em Camadas:**
   - `ufrmMain`, `ufrmClientes`, `ufrmOrdens`: Responsáveis estritamente pela camada de apresentação (UI).
   - `dmConexao`, `dmClientes`, `dmOrdens`: DataModules responsáveis pelo encapsulamento de queries SQL, transações e datasets.
   - `uOrdemServico`, `uClienteServico`: Classes de serviço e regras de negócio puras (cálculos de subtotal, validações de SLA e regras de domínio).
2. **Parametrização de Consultas:** Todas as buscas e listagens dinâmicas utilizam parâmetros SQL (`:CLIENTE_ID`, `:STATUS`, `:DATA_INI`, `:DATA_FIM`), evitando SQL hard-coded repetido e prevenindo vulnerabilidades de SQL Injection.
3. **Persistência de Estado na Exclusão:** Exclusões de OS executam deleção em cascata controlada via transação (removendo primeiro os itens em `ITEM_ORDEM` e em seguida o registro pai em `ORDEM_SERVICO`).

---

## ⚠️ Limitações Conhecidas

- O relatório FastReport requer a presença do arquivo de modelo `RelatorioOS.fr3` no mesmo diretório do arquivo executável da aplicação.
- A aplicação foi estruturada focando no SGBD Firebird 3.0+ com driver nativo FireDAC.

---

## 📋 Perguntas de Autoavaliação

* **O que levaria mais tempo para evoluir se tivesse +20 horas no projeto?**  
  Implementaria uma arquitetura ORM completa (como Aurelius ou mORMot) com padrão Repository/Unit of Work, um módulo completo de auditoria/log de alteração de status em tabela dedicada (`StatusLog`), e cobertura de testes unitários automatizados para as regras de negócio de SLA e cálculo de impostos.

* **Um gargalo potencial no design atual?**  
  A listagem de OS carrega os dados diretamente na memória sem paginação no banco de dados (`FIRST / SKIP`). Para ambientes de produção com centenas de milhares de ordens, seria ideal implementar paginação a nível de banco de dados na query de consulta.

* **Uma melhoria de testes que faria?**  
  Criação de uma suíte de testes unitários com o **DUnitX** desacoplada da VCL para testar isoladamente a unit `uOrdemServico.pas` (cálculos de subtotal de itens, soma total da OS e validação booleana das condições de SLA).

---

## 🤖 Declaração de Uso de Inteligência Artificial

Em conformidade com as diretrizes e boas práticas éticas solicitadas na especificação do teste técnico:
- Ferramentas de Inteligência Artificial foram utilizadas como suporte auxiliar durante o desenvolvimento para acelerar a geração de esqueletos de código, revisão de consultas SQL agregadas e formatação estruturada de documentação.
- Toda a arquitetura do projeto, fluxo de componentes VCL, tratamento de transações FireDAC, leiaute do relatório FastReport e regras de negócio foram revisados, integrados e validados manualmente para assegurar o correto funcionamento da aplicação.