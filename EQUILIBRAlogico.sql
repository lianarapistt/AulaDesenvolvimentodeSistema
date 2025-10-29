-
-- 1. usuario
-- Cadastro principal dos usuários do sistema
-- Contém informações básicas para login e identificação no app
CREATE TABLE usuario (
    id_usuarios INT PRIMARY KEY,                             -- PK: identificador único do usuário
    nm_usuarios VARCHAR(100) NOT NULL,                      -- Nome completo do usuário
    cpf VARCHAR(11) UNIQUE NOT NULL,                                        --     CPF usuario
    emails VARCHAR(100) UNIQUE NOT NULL,                     -- Email único de login
    senhas VARCHAR(100) NOT NULL,                            -- Senha de acesso
    dt_cadastros DATETIME
    FOREIGN KEY (id_questionarios) REFERENCES questionario_usuario(id_questionarios))                                   -- Data e hora do cadastr)
 

-- 4. questionario_usuario
-- Questionário inicial para personalização do plano do usuário
-- Contém informações de peso, altura, objetivo e nível de atividade física
CREATE TABLE questionario_usuario (
    id_questionarios INT IDENTITY PRIMARY KEY,             -- PK: identificador único do questionário
    pesos DECIMAL(5,2),                                 -- Peso do usuário em kg
    alturas DECIMAL(5,2),                                -- Altura do usuário em metros
    objetivos VARCHAR(100),                             -- Objetivo do usuário (ex: emagrecer, ganhar massa)
    atividades_fisicas VARCHAR(100),                    -- Descrição da rotina de atividades físicas
    preferencias_alimentares VARCHAR(255),
    restricoes_alimentares VARCHAR(255))


-- 5. nutricionista
-- Cadastro principal dos nutricionistas
CREATE TABLE nutricionista (
    id_nutricionistas INT PRIMARY KEY,                      -- PK: identificador único do nutricionista
    nm_nutricionistas VARCHAR(100) NOT NULL,                        -- Nome completo
    nr_crn VARCHAR(20) UNIQUE NOT NULL,                             -- Número do CRN
    emails VARCHAR(100) NOT NULL,                        -- Email de contato
    nr_telefones VARCHAR(20) NOT NULL,-- Telefone de contato
    especializações VARCHAR(255) NOT NULL
    experiencias VARCHAR(255) NOT NULL)
    -- endereços podem ser adicionados em tabela separada
);


-- 7. consulta
-- Registro das consultas entre usuários e nutricionistas
CREATE TABLE consulta (
    id_consultas INT PRIMARY KEY,                            -- PK: identificador único da consulta
    id_usuarios INT NOT NULL,                                 -- FK -> usuario.id_usuarios
    id_nutricionistas INT NOT NULL,                           -- FK -> nutricionista.id_nutricionistas
    hr_inicios DATETIME,
    hr_fins DATETIME,                                           -- Data e hora da consulta
    ds_status VARCHAR(50),                                   -- Status: agendada, concluída, cancelada
    avaliacao_consultas INT NULL,
    comentarios VARCHAR(255) NULL,
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas)
);


-- 11. desafio
-- Desafios que os usuários podem completar para ganhar moedas no aplicativo
CREATE TABLE desafio (
    id_desafios INT IDENTITY PRIMARY KEY,         -- PK: identificador único do desafio
    id_usuarios INT NOT NULL,                     -- FK -> usuario.id_usuarios: identifica o usuário que realizou o desafio
    nm_desafios NVARCHAR(100) NOT NULL,          -- Nome do desafio
    qt_moedas INT DEFAULT 0,                      -- Quantidade de moedas concedidas ao completar o desafio
    dt_conclusoes DATETIME DEFAULT GETDATE(),      -- Data em que o usuário concluiu o desafio
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);




--------------------------------------------------------------------------------------------------------------
ALIMENTAÇÃO E PLANOS
--------------------------------------------------------------------------------------------------------------
-- 14. refeicao_tipo
-- Define os tipos de refeição que podem existir no app (ex: café da manhã, almoço, jantar, lanche)
CREATE TABLE refeicao_tipo (
    id_refeicao_tipo INT IDENTITY PRIMARY KEY,    -- PK: identificador único do tipo de refeição
    tipos VARCHAR(50) NOT NULL                -- Descrição do tipo de refeição (ex: "Almoço")
);


-- 15. plano_alimentar
-- Contém os planos alimentares personalizados para cada usuário, organizados por refeição
CREATE TABLE plano_alimentar (
    id_plano INT IDENTITY PRIMARY KEY,           -- PK: identificador único do plano
    id_usuarios INT NOT NULL,                    -- FK -> usuario.id_usuarios: usuário que receberá o plano
    id_refeicao_tipo INT NOT NULL,               -- FK -> refeicao_tipo.id_refeicao_tipo: tipo de refeição associada
    nm_plano NVARCHAR(100),                      -- Nome do plano alimentar (ex: "Plano de Emagrecimento")
    ds_objetivos NVARCHAR(100),                  -- Objetivo do plano (ex: "Perda de peso", "Ganho de massa")
    dt_inicio DATE,                               -- Data de início do plano
    dt_fim DATE,                                  -- Data de término do plano
    ds_observacoes NVARCHAR(500) NULL,           -- Observações adicionais do nutricionista (ex: substituições, restrições)
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_refeicao_tipo) REFERENCES refeicao_tipo(id_refeicao_tipo)
);



-- 17. plano_alimento
-- Relaciona alimentos aos planos alimentares, permitindo detalhar quantidade e porção
CREATE TABLE plano_alimento (
    id_plano_alimento INT IDENTITY PRIMARY KEY,  -- PK: identificador único do registro
    id_plano INT NOT NULL,                       -- FK -> plano_alimentar.id_plano
    id_alimento INT NOT NULL,                    -- FK -> alimento.id_alimento
    quantidade NVARCHAR(50) NULL,               -- Quantidade ou descrição da porção (ex: "2 ovos", "1 fatia de pão")
    FOREIGN KEY (id_plano) REFERENCES plano_alimentar(id_plano),
    FOREIGN KEY (id_alimento) REFERENCES alimento(id_alimento)
);


-- 18. alimento_detalhado
-- Contém alimentos que podem ser escaneados via código de barras com informações nutricionais completas
CREATE TABLE alimento (
    id_alimentoS INT IDENTITY PRIMARY KEY,  -- PK: identificador único                    
    nm_alimento_detalhado NVARCHAR(100) NULL,       -- Nome detalhado do alimento (ex: "Banana prata madura 100g")
    codigo_barras NVARCHAR(50) UNIQUE NOT NULL,     -- Código de barras obrigatório
    vl_calorias DECIMAL(6,2) NULL,                 -- Calorias do alimento
    vl_proteinas DECIMAL(6,2) NULL,                -- Proteínas em gramas
    vl_carboidratos DECIMAL(6,2) NULL,             -- Carboidratos em gramas
    vl_gorduras DECIMAL(6,2) NULL,                 -- Gorduras totais em gramas
    vl_fibras DECIMAL(6,2) NULL,                   -- Fibras em gramas
    vl_sodio DECIMAL(6,2) NULL,                    -- Sódio em mg
    id_tipo_alimento INT NOT NULL,                  -- FK -> categoria_alimento.id_tipo_alimento
    FOREIGN KEY (id_alimento) REFERENCES alimento(id_alimento),
    FOREIGN KEY (id_tipo_alimento) REFERENCES categoria_alimento(id_tipo_alimento)
);
--------------------------------------------------------------------------------------------------------------
ASSINATURAS E PAGAMENTOS
--------------------------------------------------------------------------------------------------------------
-- 19. plano_assinatura
-- Define os planos de assinatura disponíveis no app (ex: Mensal, Anual)
CREATE TABLE plano_assinatura (
    id_planos INT IDENTITY PRIMARY KEY,           -- PK: identificador único do plano
    nm_planos NVARCHAR(100) NOT NULL,            -- Nome do plano (ex: "Mensal", "Anual")
    ds_planos NVARCHAR(255),                     -- Descrição detalhada do plano (ex: "Acesso completo a todos os recursos")
    vl_valores DECIMAL(10,2) NOT NULL,          -- Valor do plano
    qt_duracao_meses INT NOT NULL,               -- Duração do plano em meses
    qt_moedas INT DEFAULT 0                      -- Quantidade de moedas virtuais que o usuário recebe ao assinar
);


-- 20. pagamento_assinatura
-- Registro dos pagamentos realizados pelos usuários
CREATE TABLE pagamento_assinatura (
    id_pagamentos INT IDENTITY PRIMARY KEY,      -- PK: identificador único do pagamento
    id_usuarios INT NOT NULL,                     -- FK -> usuario.id_usuarios: usuário que realizou o pagamento
    id_planos INT NOT NULL,                        -- FK -> plano_assinatura.id_planos: plano que foi adquirido
    vl_pagamento DECIMAL(10,2),                  -- Valor efetivamente pago
    ds_forma_pagamento NVARCHAR(50),             -- Forma de pagamento utilizada (ex: "PIX", "Cartão de crédito")
    ds_status NVARCHAR(50),                      -- Status do pagamento (ex: "Pago", "Pendente", "Cancelado")
    dt_pagamento DATETIME DEFAULT GETDATE(),     -- Data e hora do pagamento
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_planos) REFERENCES plano_assinatura(id_planos)
);



-- 22. ebook
-- Cadastro dos ebooks disponíveis para compra ou download no app
CREATE TABLE ebook (
    id_ebooks INT IDENTITY PRIMARY KEY,             -- PK: identificador único do ebook
    nm_ebooks NVARCHAR(150) NOT NULL,              -- Título do ebook
    nm_autores NVARCHAR(100),                      -- Nome do(s) autor(es)
    ds_ebooks NVARCHAR(255),                       -- Descrição resumida do conteúdo
    vl_ebooks_moedas DECIMAL(10,2),               -- Valor em moedas virtuais para aquisição
    ds_links_download NVARCHAR(255)               -- Link para download ou armazenamento do ebook
);


-- 23. compra_ebook
-- Registro de compra de ebooks por usuários
CREATE TABLE compra_ebook (
    id_compra INT IDENTITY PRIMARY KEY,            -- PK: identificador único da compra
    id_usuarios INT NOT NULL,                       -- FK -> usuario.id_usuarios: usuário que comprou o ebook
    id_ebooks INT NOT NULL,                         -- FK -> ebook.id_ebooks: ebook adquirido
    dt_compra DATETIME DEFAULT GETDATE(),           -- Data e hora da compra
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_ebooks) REFERENCES ebook(id_ebooks)
);





















