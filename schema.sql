-- ============================================================
--  PROJETO: Oficina Mecânica — Modelagem de Banco de Dados
--  DISCIPLINA: Modelagem de Banco de Dados — Semana 02
--  SGBD: PostgreSQL
-- ============================================================

-- ============================================================
--  1. TABELA: cliente (Entidade Forte)
-- ============================================================
CREATE TABLE cliente (
    id_cliente   SERIAL          PRIMARY KEY,
    nome         VARCHAR(100)    NOT NULL,
    cpf          VARCHAR(14)     NOT NULL UNIQUE,
    telefone     VARCHAR(20)     NOT NULL,
    email        VARCHAR(100),
    endereco     VARCHAR(200)
);

-- ============================================================
--  2. TABELA: veiculo (Entidade Forte)
--     Relacionamento: Cliente 1:N Veículo
-- ============================================================
CREATE TABLE veiculo (
    id_veiculo   SERIAL          PRIMARY KEY,
    placa        VARCHAR(10)     NOT NULL UNIQUE,
    marca        VARCHAR(50)     NOT NULL,
    modelo       VARCHAR(50)     NOT NULL,
    ano          INT             NOT NULL,
    cor          VARCHAR(30),
    id_cliente   INT             NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- ============================================================
--  3. TABELA: mecanico (Entidade Forte)
-- ============================================================
CREATE TABLE mecanico (
    id_mecanico   SERIAL          PRIMARY KEY,
    nome          VARCHAR(100)    NOT NULL,
    cpf           VARCHAR(14)     NOT NULL UNIQUE,
    especialidade VARCHAR(100)    NOT NULL,
    telefone      VARCHAR(20)     NOT NULL
);

-- ============================================================
--  4. TABELA: ordem_servico (Entidade Forte)
--     Relacionamentos:
--       Veículo 1:N Ordem de Serviço
--       Mecânico 1:N Ordem de Serviço
-- ============================================================
CREATE TABLE ordem_servico (
    id_ordem            SERIAL          PRIMARY KEY,
    data_abertura       DATE            NOT NULL,
    data_fechamento     DATE,
    status              VARCHAR(20)     NOT NULL DEFAULT 'Aberta',
    descricao_problema  TEXT            NOT NULL,
    valor_total         DECIMAL(10,2)  DEFAULT 0.00,
    id_veiculo          INT             NOT NULL,
    id_mecanico         INT             NOT NULL,
    FOREIGN KEY (id_veiculo)   REFERENCES veiculo(id_veiculo),
    FOREIGN KEY (id_mecanico)  REFERENCES mecanico(id_mecanico)
);

-- ============================================================
--  5. TABELA: servico (Entidade Forte)
-- ============================================================
CREATE TABLE servico (
    id_servico    SERIAL          PRIMARY KEY,
    nome          VARCHAR(100)    NOT NULL,
    descricao     VARCHAR(255),
    valor_padrao  DECIMAL(10,2)   NOT NULL
);

-- ============================================================
--  6. TABELA: peca (Entidade Forte)
-- ============================================================
CREATE TABLE peca (
    id_peca            SERIAL          PRIMARY KEY,
    nome               VARCHAR(100)    NOT NULL,
    descricao          VARCHAR(255),
    valor_unitario     DECIMAL(10,2)   NOT NULL,
    quantidade_estoque INT             NOT NULL DEFAULT 0
);

-- ============================================================
--  7. TABELA: item_servico (Entidade Associativa — N:N)
--     Relacionamento: Ordem de Serviço N:N Serviço
-- ============================================================
CREATE TABLE item_servico (
    id_ordem        INT             NOT NULL,
    id_servico      INT             NOT NULL,
    quantidade      INT             NOT NULL DEFAULT 1,
    valor_unitario  DECIMAL(10,2)   NOT NULL,
    PRIMARY KEY (id_ordem, id_servico),
    FOREIGN KEY (id_ordem)   REFERENCES ordem_servico(id_ordem),
    FOREIGN KEY (id_servico) REFERENCES servico(id_servico)
);

-- ============================================================
--  8. TABELA: item_peca (Entidade Associativa — N:N)
--     Relacionamento: Ordem de Serviço N:N Peça
-- ============================================================
CREATE TABLE item_peca (
    id_ordem        INT             NOT NULL,
    id_peca         INT             NOT NULL,
    quantidade      INT             NOT NULL,
    valor_unitario  DECIMAL(10,2)   NOT NULL,
    PRIMARY KEY (id_ordem, id_peca),
    FOREIGN KEY (id_ordem)  REFERENCES ordem_servico(id_ordem),
    FOREIGN KEY (id_peca)   REFERENCES peca(id_peca)
);
