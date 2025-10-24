----------------------------------------------------------------------
USUARIO E PERFIL
----------------------------------------------------------------------

-- 1. usuario
-- Cadastro principal dos usuários do sistema
-- Contém informações básicas para login e identificação no app
CREATE TABLE usuario (
    id_usuarios INT PRIMARY KEY,                             -- PK: identificador único do usuário
    nm_usuarios NVARCHAR(100) NOT NULL,                     -- Nome completo do usuário
    ds_emails NVARCHAR(100) UNIQUE NOT NULL,               -- Email único de login
    ds_senhas NVARCHAR(100) NOT NULL,                      -- Senha de acesso
    dt_cadastros DATETIME DEFAULT GETDATE()                -- Data e hora do cadastro
);


-- 2. perfil_usuario
-- Conecta usuário com seu perfil nutricional, contendo preferências alimentares e respostas do questionário
CREATE TABLE perfil_usuario (
    id_perfil INT IDENTITY PRIMARY KEY,                    -- PK: identificador único do perfil
    id_usuarios INT NOT NULL,                               -- FK -> usuario.id_usuarios
    id_preferencias INT NOT NULL,                           -- FK -> preferencia_alimentar.id_preferencias
    id_questionarios INT NOT NULL,                          -- FK -> questionario_usuario.id_questionarios
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_preferencias) REFERENCES preferencia_alimentar(id_preferencias),
    FOREIGN KEY (id_questionarios) REFERENCES questionario_usuario(id_questionarios)
);


-- 3. preferencia_alimentar
-- Preferências alimentares do usuário, como vegetarianismo, intolerância à lactose, etc.
CREATE TABLE preferencia_alimentar (
    id_preferencias INT IDENTITY PRIMARY KEY,              -- PK: identificador único da preferência
    id_usuarios INT NOT NULL,                               -- FK -> usuario.id_usuarios
    ds_preferencias NVARCHAR(100),                          -- Descrição da preferência
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);


-- 4. questionario_usuario
-- Questionário inicial para personalização do plano do usuário
-- Contém informações de peso, altura, objetivo e nível de atividade física
CREATE TABLE questionario_usuario (
    id_questionarios INT IDENTITY PRIMARY KEY,             -- PK: identificador único do questionário
    id_usuarios INT NOT NULL,                               -- FK -> usuario.id_usuarios
    vl_pesos DECIMAL(5,2),                                 -- Peso do usuário em kg
    vl_alturas DECIMAL(5,2),                                -- Altura do usuário em metros
    ds_objetivos NVARCHAR(100),                             -- Objetivo do usuário (ex: emagrecer, ganhar massa)
    ds_atividades_fisicas NVARCHAR(100),                    -- Descrição da rotina de atividades físicas
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);


--------------------------------------------------------------------------------------------------------------
Nutricionista e consultas
--------------------------------------------------------------------------------------------------------------    

-- 5. nutricionista
-- Cadastro principal dos nutricionistas
CREATE TABLE nutricionista (
    id_nutricionistas INT PRIMARY KEY,                      -- PK: identificador único do nutricionista
    nm_nutricionistas NVARCHAR(100),                        -- Nome completo
    nr_crns NVARCHAR(20) UNIQUE,                             -- Número do CRN
    ds_emails NVARCHAR(100) NOT NULL,                        -- Email de contato
    nr_telefones NVARCHAR(20)                                -- Telefone de contato
    -- endereços podem ser adicionados em tabela separada
);


-- 6. perfil_nutricionista
-- Dados complementares dos nutricionistas para visualização pelos usuários
CREATE TABLE perfil_nutricionista (
    id_cadastros INT PRIMARY KEY,                           -- PK: identificador único do perfil
    id_nutricionistas INT NOT NULL,                          -- FK -> nutricionista.id_nutricionistas
    ds_especializacoes NVARCHAR(100),                        -- Especializações do profissional
    ds_experiencias NVARCHAR(255),                           -- Experiências profissionais resumidas
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas)
);


-- 7. consulta
-- Registro das consultas entre usuários e nutricionistas
CREATE TABLE consulta (
    id_consultas INT PRIMARY KEY,                            -- PK: identificador único da consulta
    id_usuarios INT NOT NULL,                                 -- FK -> usuario.id_usuarios
    id_nutricionistas INT NOT NULL,                           -- FK -> nutricionista.id_nutricionistas
    dt_consultas DATETIME,                                    -- Data e hora da consulta
    ds_status NVARCHAR(50),                                   -- Status: agendada, concluída, cancelada
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas)
);


-- 8. historico_consulta
-- Observações pós-consulta feitas pelo nutricionista
CREATE TABLE historico_consulta (
    id_historicos INT PRIMARY KEY,                            -- PK: identificador único do histórico
    id_consultas INT NOT NULL,                                 -- FK -> consulta.id_consultas
    ds_observacoes NVARCHAR(MAX),                               -- Observações detalhadas da consulta
    FOREIGN KEY (id_consultas) REFERENCES consulta(id_consultas)
);


-- 9. avaliacao_nutricionista
-- Avaliação do nutricionista feita pelos usuários
CREATE TABLE avaliacao_nutricionista (
    id_avaliacoes INT PRIMARY KEY,                             -- PK: identificador único da avaliação
    id_usuarios INT NOT NULL,                                   -- FK -> usuario.id_usuarios
    id_nutricionistas INT NOT NULL,                             -- FK -> nutricionista.id_nutricionistas
    nr_notas INT CHECK (nr_notas BETWEEN 1 AND 5),              -- Nota de 1 a 5
    ds_comentarios NVARCHAR(255),                               -- Comentário do usuário
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas)
);


-- 10. disponibilidade_nutricionista
-- Horários disponíveis para agendamento de consultas
CREATE TABLE disponibilidade_nutricionista (
    id_disponibilidades INT PRIMARY KEY,                       -- PK: identificador único
    id_nutricionistas INT NOT NULL,                             -- FK -> nutricionista.id_nutricionistas
    ds_dias_semana NVARCHAR(20),                                 -- Dia da semana
    hr_inicios TIME,                                             -- Hora de início
    hr_fins TIME,                                                -- Hora de término
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas)
);

-- 11. desafio
-- Desafios que os usuários podem completar para ganhar moedas no aplicativo
CREATE TABLE desafio (
    id_desafios INT IDENTITY PRIMARY KEY,         -- PK: identificador único do desafio
    id_usuarios INT NOT NULL,                     -- FK -> usuario.id_usuarios: identifica o usuário que realizou o desafio
    nm_desafios NVARCHAR(100) NOT NULL,          -- Nome do desafio
    ds_desafios NVARCHAR(MAX) NULL,              -- Descrição detalhada do desafio
    qt_moedas INT DEFAULT 0,                      -- Quantidade de moedas concedidas ao completar o desafio
    dt_conclusao DATETIME DEFAULT GETDATE(),      -- Data em que o usuário concluiu o desafio
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);


-- 12. recompensa_moeda
-- Recompensas associadas a cada desafio, podendo ser resgatadas pelos usuários
CREATE TABLE recompensa_moeda (
    id_recompensa_moeda INT IDENTITY PRIMARY KEY, -- PK: identificador único da recompensa
    id_desafios INT NOT NULL,                     -- FK -> desafio.id_desafios
    ds_recompensa NVARCHAR(100),                 -- Nome ou descrição da recompensa (ex: "Vale 50 moedas", "Cupom de desconto")
    qt_moedas INT DEFAULT 0,                      -- Quantidade de moedas necessárias para resgatar a recompensa
    FOREIGN KEY (id_desafios) REFERENCES desafio(id_desafios)
);


-- 13. historico_moedas
-- Mantém o registro do total de moedas que cada usuário possui e seu histórico de ganhos
CREATE TABLE historico_moedas (
    id_historico_moedas INT IDENTITY PRIMARY KEY,  -- PK: identificador único do registro
    id_usuarios INT NOT NULL,                      -- FK -> usuario.id_usuarios
    id_desafios INT NULL,                          -- FK -> desafio.id_desafios (quando a moeda vem de um desafio)
    id_recompensa_moeda INT NULL,                  -- FK -> recompensa_moeda.id_recompensa_moeda (quando o usuário resgata moedas)
    qt_moedas INT NOT NULL,                        -- Quantidade de moedas adquiridas ou gastas
    ds_tipo_movimento NVARCHAR(50),               -- Tipo de movimento: 'ganho' ou 'resgate'
    dt_movimento DATETIME DEFAULT GETDATE(),       -- Data e hora do movimento
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_desafios) REFERENCES desafio(id_desafios),
    FOREIGN KEY (id_recompensa_moeda) REFERENCES recompensa_moeda(id_recompensa_moeda)
);

--------------------------------------------------------------------------------------------------------------
ALIMENTAÇÃO E PLANOS
--------------------------------------------------------------------------------------------------------------
-- 14. refeicao_tipo
-- Define os tipos de refeição que podem existir no app (ex: café da manhã, almoço, jantar, lanche)
CREATE TABLE refeicao_tipo (
    id_refeicao_tipo INT IDENTITY PRIMARY KEY,    -- PK: identificador único do tipo de refeição
    ds_tipo NVARCHAR(50) NOT NULL                -- Descrição do tipo de refeição (ex: "Almoço")
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


-- 16. alimento
-- Base de todos os alimentos disponíveis no app
CREATE TABLE alimento (
    id_alimento INT IDENTITY PRIMARY KEY,        -- PK: identificador único do alimento
    nm_alimento NVARCHAR(100) NOT NULL,          -- Nome do alimento (ex: "Ovo")
    id_tipo_alimento INT NOT NULL,               -- FK -> categoria_alimento.id_tipo_alimento: categoria do alimento
    codigo_barras NVARCHAR(50) NULL,            -- Código de barras, caso exista
    FOREIGN KEY (id_tipo_alimento) REFERENCES categoria_alimento(id_tipo_alimento)
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
CREATE TABLE alimento_detalhado (
    id_alimento_detalhado INT IDENTITY PRIMARY KEY,  -- PK: identificador único
    id_alimento INT NOT NULL,                        -- FK -> alimento.id_alimento
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


-- 21. historico_pagamento_assinatura
-- Histórico detalhado dos pagamentos efetuados
CREATE TABLE historico_pagamento_assinatura (
    id_historico INT IDENTITY PRIMARY KEY,        -- PK: identificador único do histórico
    id_usuarios INT NOT NULL,                      -- FK -> usuario.id_usuarios: usuário que realizou o pagamento
    id_pagamentos INT NOT NULL,                    -- FK -> pagamento_assinatura.id_pagamentos
    valor_pago DECIMAL(10,2),                     -- Valor pago na transação
    data_transacao DATETIME DEFAULT GETDATE(),    -- Data e hora da transação
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_pagamentos) REFERENCES pagamento_assinatura(id_pagamentos)
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

-- 24. historico_scanner
-- Registro de todos os produtos escaneados pelos usuários
CREATE TABLE historico_scanner (
    id_scanner INT IDENTITY PRIMARY KEY,           -- PK: identificador único do scan
    id_usuarios INT NOT NULL,                       -- FK -> usuario.id_usuarios: usuário que realizou o scan
    id_alimento_detalhado INT NOT NULL,            -- FK -> alimento_detalhado.id_alimento_detalhado: produto escaneado
    dt_scan DATETIME DEFAULT GETDATE(),            -- Data e hora do scan
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_alimento_detalhado) REFERENCES alimento_detalhado(id_alimento_detalhado)
);




















