-- ===============================================
-- Script DDL - Projeto Equilibra
-- ===============================================

-- -----------------------------------------------------
-- Tabelas de Catálogo / Padronização para o Questionário
-- -----------------------------------------------------

-- Tabela para cadastrar os tipos de objetivos possíveis
CREATE TABLE objetivos_usuario (
    id_objetivos INT PRIMARY KEY,
    nm_objetivos VARCHAR(100) NOT NULL UNIQUE
);

-- Tabela para cadastrar os tipos de restrições alimentares
CREATE TABLE restricao_alimentar (
    id_restricoes INT PRIMARY KEY,
    nm_restricoes VARCHAR(100) NOT NULL UNIQUE
);

-- Tabela para cadastrar as preferências alimentares
CREATE TABLE preferencia_alimentar (
    id_preferencias INT PRIMARY KEY,
    nm_preferencias VARCHAR(100) NOT NULL UNIQUE
);

-- Tabela para cadastrar o nível e frequência de atividade física
CREATE TABLE atividade_fisica_usuario (
    id_atividade INT PRIMARY KEY,
    nivel_atividade VARCHAR(100) NOT NULL UNIQUE
);

-- -----------------------------------------------------
-- Tabela Questionário do Usuário (Anamnese)
-- -----------------------------------------------------

CREATE TABLE questionario_usuario (
    id_questionarios INT PRIMARY KEY,
    peso DECIMAL(5,2) NOT NULL DEFAULT 0.00, -- EM KG
    altura DECIMAL(3,2) NOT NULL DEFAULT 0.00, -- EM METROS
    
    -- Chaves Estrangeiras para as tabelas de padronização
    objetivo_id_objetivos INT NOT NULL,
    restricao_alimentar_id_restricoes INT NOT NULL,
    preferencia_alimentar_id_preferencias INT NOT NULL,
    atividade_fisica_usuario_id_atividade INT NOT NULL,
    
    FOREIGN KEY (objetivo_id_objetivos) REFERENCES objetivos_usuario(id_objetivos),
    FOREIGN KEY (restricao_alimentar_id_restricoes) REFERENCES restricao_alimentar(id_restricoes),
    FOREIGN KEY (preferencia_alimentar_id_preferencias) REFERENCES preferencia_alimentar(id_preferencias),
    FOREIGN KEY (atividade_fisica_usuario_id_atividade) REFERENCES atividade_fisica_usuario(id_atividade)
);

-- -----------------------------------------------------
-- Tabela Usuário (Paciente)
-- -----------------------------------------------------

CREATE TABLE usuario (
    id_usuarios INT PRIMARY KEY,
    nm_usuarios VARCHAR(100) NOT NULL,
    emails VARCHAR(100) UNIQUE NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL, 
    senhas VARCHAR(100) NOT NULL,
    dt_cadastros DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Ajustado para padrão SQL
    
    -- FK para o Questionário (NULLable)
    questionario_usuario_id_questionarios INT NULL,
    
    FOREIGN KEY (questionario_usuario_id_questionarios) REFERENCES questionario_usuario(id_questionarios)
);

-- -----------------------------------------------------
-- Tabela Tipo de Plano Assinatura (Mestra de Detalhes do Plano)
-- -----------------------------------------------------

CREATE TABLE tipo_plano_assinatura (
    id_plano_assina INT PRIMARY KEY,
    nm_planos VARCHAR(100) NOT NULL UNIQUE,
    vl_assinaturas DECIMAL(5,2) NOT NULL, 
    
    -- Correção de sintaxe e inclusão de CHECK para qt_moedas
    qt_moedas INT NOT NULL DEFAULT 0 CHECK(qt_moedas >= 0), 
    
    ds_planos VARCHAR(255) NOT NULL
);

-- -----------------------------------------------------
-- Tabela Plano Assinatura (Instância e Histórico da Subscrição)
-- -----------------------------------------------------

CREATE TABLE plano_assinatura (
    id_plano_assinatura INT PRIMARY KEY,
    usuario_id_usuarios INT NOT NULL,
    tipo_plano_assinatura_id_plano_assina INT NOT NULL, 
    
    dt_inicio DATE NOT NULL,
    dt_fim DATE NULL, -- (NULL significa ativo)
    
    FOREIGN KEY (usuario_id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (tipo_plano_assinatura_id_plano_assina) REFERENCES tipo_plano_assinatura(id_plano_assina)
);


-- -----------------------------------------------------
-- Tabela Dias da Semana (Para Agendas)
-- -----------------------------------------------------

CREATE TABLE dias_da_semana (
    id_dias INT PRIMARY KEY,
    nm_dias_semana VARCHAR(30) NOT NULL UNIQUE
);

-- -----------------------------------------------------
-- Tabela Agenda do Nutricionista (Disponibilidade)
-- -----------------------------------------------------

CREATE TABLE agenda_nutricionista (
    id_agenda_nutricionista INT PRIMARY KEY,
    dias_da_semana_id_dias INT NOT NULL, -- FK para o dia da semana
    
    -- Campos TINYINT(1) indicam a disponibilidade (1=Disponível, 0=Indisponível)
    atende_06_07 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_07_08 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_08_09 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_09_10 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_10_11 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_11_12 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_12_13 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_13_14 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_14_15 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_15_16 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_16_17 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_17_18 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_18_19 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_19_20 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_20_21 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_21_22 TINYINT(1) DEFAULT 0 NOT NULL,
    atende_22_23 TINYINT(1) DEFAULT 0 NOT NULL,
    
    FOREIGN KEY (dias_da_semana_id_dias) REFERENCES dias_da_semana(id_dias)
);

-- -----------------------------------------------------
-- Tabela Nutricionista
-- -----------------------------------------------------

CREATE TABLE nutricionista (
    id_nutricionistas INT PRIMARY KEY,
    nm_nutricionistas VARCHAR(100) NOT NULL,
    nr_crn VARCHAR(20) UNIQUE NOT NULL, 
    emails_nutricionistas VARCHAR(100) UNIQUE NOT NULL,
    senhas_nutricionistas VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    nr_telefones VARCHAR(30) NOT NULL, 
    dt_cadastros_nutricionistas DATETIME NOT NULL DEFAULT GETDATE(),
    
    -- FK para a Agenda (NULLable)
    agenda_nutricionista_id_agenda_nutricionista INT NULL,
    
    FOREIGN KEY (agenda_nutricionista_id_agenda_nutricionista) REFERENCES agenda_nutricionista(id_agenda_nutricionista)
);

-- -----------------------------------------------------
-- Tabela Consulta (Agendamentos)
-- -----------------------------------------------------

CREATE TABLE consulta (
    id_consultas INT PRIMARY KEY,
    
    -- Usando DATETIME para que hr_inicio e hr_fim incluam a data do agendamento
    hr_inicio DATETIME NOT NULL, 
    hr_fim DATETIME NOT NULL, 
    
    avaliacao_consultas INT NULL,
    comentarios VARCHAR(255) NULL,
    
    -- Chaves Estrangeiras
    usuario_id_usuarios INT NOT NULL,
    nutricionista_id_nutricionistas INT NOT NULL,
    
    FOREIGN KEY (usuario_id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (nutricionista_id_nutricionistas) REFERENCES nutricionista(id_nutricionistas)
);

-- -----------------------------------------------------
-- Tabela Alimento
-- -----------------------------------------------------

CREATE TABLE alimento (
    id_alimentos INT PRIMARY KEY,
    nm_alimentos VARCHAR(100) NOT NULL,
    
    -- Campo para o Scanner (Perspectiva Futura)
    codigo_barras VARCHAR(50) UNIQUE NULL, 
    
    -- Valores Nutricionais (Macros)
    calorias DECIMAL(6,2) NOT NULL DEFAULT 0.00,
    proteinas DECIMAL(6,2) NOT NULL DEFAULT 0.00,
    carboidratos DECIMAL(6,2) NOT NULL DEFAULT 0.00,
    gorduras DECIMAL(6,2) NOT NULL DEFAULT 0.00,
    fibras DECIMAL(6,2) NOT NULL DEFAULT 0.00,
    sodio DECIMAL(6,2) NOT NULL DEFAULT 0.00
);

-- -----------------------------------------------------
-- Tabela Tipo de Refeição (Ex: Café da Manhã, Almoço)
-- -----------------------------------------------------

CREATE TABLE tipo_refeicao (
    id_tipos INT PRIMARY KEY,
    nm_tipo_refeicoes VARCHAR(50) NOT NULL UNIQUE
);

-- -----------------------------------------------------
-- Tabela Plano Alimentar (Capa)
-- -----------------------------------------------------

CREATE TABLE plano_alimentar (
    id_planos_alimentares INT PRIMARY KEY,
    nm_planos VARCHAR(100) NOT NULL,
    
    -- Correção de sintaxe: DATETIME e DEFAULT
    dt_inicios DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    
    dt_fins DATE NULL,
    observacoes VARCHAR(255) null,
    
    -- Chaves Estrangeiras (NÃO podem ser NULL)
    usuario_id_usuarios INT NOT NULL,
    nutricionista_id_nutricionistas INT NOT NULL,
    
    FOREIGN KEY (usuario_id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (nutricionista_id_nutricionistas) REFERENCES nutricionista(id_nutricionistas)
);

-- -----------------------------------------------------
-- Tabela Plano Alimento Detalhe (Itens do Plano)
-- -----------------------------------------------------

CREATE TABLE plano_alimento_detalhe (
    id_detalhes_alimentos INT PRIMARY KEY,
    porcao_recomendada DECIMAL(6,2) NOT NULL,
    
    -- Chaves Estrangeiras (NÃO podem ser NULL)
    plano_alimentar_id_planos_alimentares INT NOT NULL,
    alimento_id_alimentos INT NOT NULL,
    tipo_refeicao_id_tipos INT NOT NULL,
    
    FOREIGN KEY (plano_alimentar_id_planos_alimentares) REFERENCES plano_alimentar(id_planos_alimentares),
    FOREIGN KEY (alimento_id_alimentos) REFERENCES alimento(id_alimentos),
    FOREIGN KEY (tipo_refeicao_id_tipo_refeicoes) REFERENCES tipo_refeicao(id_tipo_refeicoes)
);

-- -----------------------------------------------------
-- Tabela Desafio
-- -----------------------------------------------------

CREATE TABLE desafio (
    id_desafios INT PRIMARY KEY,
    nm_desafios VARCHAR(100) NOT NULL UNIQUE,
    vl_recompensa_definida INT NOT NULL
);

-- -----------------------------------------------------
-- Tabela Desafio Usuário Check-in (Gamificação)
-- -----------------------------------------------------

-- Corrigido nome da tabela e PK para refletir o uso de check-in
CREATE TABLE desafio_usuario (
    id_desafios INT PRIMARY KEY,
    vl_ganho_checkin INT NOT NULL CHECK (vl_ganho_checkin >= 0),
    dt_conclusoes DATETIME NOT NULL DEFAULT GETDATE(), -- Ajustado para padrão SQL
    
    -- Chaves Estrangeiras (NÃO podem ser NULL)
    usuario_id_usuarios INT NOT NULL,
    desafio_id_desafios INT NOT NULL,
    
    FOREIGN KEY (usuario_id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (desafio_id_desafios) REFERENCES desafio(id_desafios)
);

-- -----------------------------------------------------
-- Tabela Ebook (Loja)
-- -----------------------------------------------------

CREATE TABLE ebook (
    id_ebooks INT PRIMARY KEY,
    nm_ebook VARCHAR(100) NOT NULL,
    ds_ebooks VARCHAR(255),
    vl_moedas_definidas INT NOT NULL CHECK(vl_moedas_definidas=>0) 
);

-- -----------------------------------------------------
-- Tabela Compra Ebook (Registro de Transação da Loja)
-- -----------------------------------------------------

CREATE TABLE compra_ebook (
    id_compra_ebook INT PRIMARY KEY,
    dt_compra_ebook DATETIME NOT NULL DEFAULT GETDATE(),
    
    -- Chaves Estrangeiras (NÃO podem ser NULL)
    usuario_id_usuarios INT NOT NULL,
    ebook_id_ebooks INT NOT NULL,
    
    -- Correção de sintaxe e inclusão de DEFAULT/NOT NULL
    qt_moedas_gastas INT NOT NULL DEFAULT 0,
    
    FOREIGN KEY (usuario_id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (ebook_id_ebooks) REFERENCES ebook(id_ebooks)
);
