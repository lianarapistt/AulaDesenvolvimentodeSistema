-- BANCO DE DADOS: Equilibra
--NOMES: Lianara Vitoria e Maria Eduarda Luconi
-- PADRÃO UTILIZADO: snake case

-- 1. usuario
-- Cadastro principal dos usuários do sistema
    
CREATE TABLE usuario (
    id_usuarios INT  PRIMARY KEY,                             -- PK
    nm_usuarios NVARCHAR(100) NOT NULL,                       -- Nome completo do usuário
    ds_emails NVARCHAR(100) UNIQUE NOT NULL,                  -- Email único de login
    ds_senhas NVARCHAR(100) NOT NULL,                         -- Senha de acesso
    dt_cadastros DATETIME DEFAULT GETDATE()                   -- Data e hora do cadastro);

CREATE TABLE perfil_usuario -- vai puxar os dados dos questionários

-- 2. nutricionista
-- Cadastro Pessoal dos nutricionistas

CREATE TABLE nutricionista (
    id_nutricionistas INT PRIMARY KEY,                        -- PK
    nm_nutricionistas NVARCHAR(100),                          -- Nome completo
    nr_crns NVARCHAR(20) UNIQUE,                              -- CRN profissional
    ds_emails NVARCHAR(100),                                  -- Email de contato
    nr_telefones NVARCHAR(20)                                 -- Telefone);
    endereços ADICIONAR
    
-- 7. cadastro_nutricionista
-- Dados complementares dos nutricionistas, usuários possuem acesso, para ver o perfil do nutricionista

CREATE TABLE perfil_nutricionista (
    id_cadastros INT  PRIMARY KEY,                            -- PK
    id_nutricionistas INT NOT NULL,                           -- FK -> nutricionista.id_nutricionistas
    nr_crns NVARCHAR(20) UNIQUE,                              -- FK -> nutricionista.nr_crns
    ds_especializacoes NVARCHAR(100),                         -- Especializações do profissional
    ds_experiencias NVARCHAR(255),                            -- Experiências profissionais    ADICIONAR ENDEREÇOOO
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas),
    FOREIGN KEY (nr_crns) REFERENCES nutricionista(nr_crns));


-- 3. consulta
-- Registro de consultas entre usuário e nutricionista

CREATE TABLE consulta (
    id_consultas INT  PRIMARY KEY,                            -- PK
    id_usuarios INT NOT NULL,                                 -- FK -> usuario.id_usuarios
    id_nutricionistas INT NOT NULL,                           -- FK -> nutricionista.id_nutricionistas
    dt_consultas DATETIME,                                    -- Data e hora da consulta
    ds_status NVARCHAR(50),                                   -- Status (agendada, concluída, cancelada)
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas));


-- 4. historico_consulta
-- Observações e detalhes pós-consulta

CREATE TABLE historico_consulta (
    id_historicos INT  PRIMARY KEY,                           -- PK
    id_consultas INT NOT NULL,                                -- FK -> consulta.id_consultas
    ds_observacoes NVARCHAR(MAX),                             -- Observações pós-consulta
    FOREIGN KEY (id_consultas) REFERENCES consulta(id_consultas));


-- 5. avaliacao_nutricionista
-- Avaliações feitas pelos usuários, de 1 a 5

CREATE TABLE avaliacao_nutricionista (
    id_avaliacoes INT  PRIMARY KEY,                           -- PK
    id_usuarios INT NOT NULL,                                 -- FK -> usuario.id_usuarios
    id_nutricionistas INT NOT NULL,                           -- FK -> nutricionista.id_nutricionistas
    nr_notas INT CHECK (nr_notas BETWEEN 1 AND 5),            -- Nota de 1 a 5
    ds_comentarios NVARCHAR(255),                             -- Comentários do usuário sobre a consulta
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas));


-- 6. disponibilidade_nutricionista
-- Horários disponíveis para consultas

CREATE TABLE disponibilidade_nutricionista (
    id_disponibilidades INT  PRIMARY KEY,                     -- PK
    id_nutricionistas INT NOT NULL,                           -- FK -> perfil_nutricionista.id_cadastros
    ds_dias_semana NVARCHAR(20),                              -- Dia da semana
    hr_inicios TIME,                                          -- Hora de início
    hr_fins TIME,                                             -- Hora de término
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas));



-- 8. plano_alimentar
-- Plano personalizado de cada usuário

CREATE TABLE plano_alimentar (                            --PK
    id_planos INT  PRIMARY KEY,                           --FK -> usuario.id_usuarios
    id_usuarios INT NOT NULL,                             -- Objetivo (emagrecer, ganhar massa, etc)
    ds_objetivos NVARCHAR(100),                           -- Data de início do plano   
    dt_inicios DATE,                                      -- Data de término do plano  
    nm_plano NVARCHAR(100),
    dt_fins  DATE,                                             
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);


-- 10. refeicao_tipo
-- Tipos de refeição (Café da manhã, Almoço etc.)
CREATE TABLE refeicao_tipo (
    id_refeicao_tipo INT  PRIMARY KEY,                       -- PK
    ds_tipo NVARCHAR(50) NOT NULL                            -- Café da manhã, Almoço, Jantar, Lanche
);


-- 12. receita
-- Receitas cadastradas no sistema
CREATE TABLE refeição (
    id_receitas INT  PRIMARY KEY,                            -- PK
    nm_receitas NVARCHAR(100),                               -- Nome da receita
    ds_descricoes NVARCHAR(500),                             -- Descrição detalhada, modo de preparo
    id_tipos INT,                                            -- FK -> tipo_receita.id_tipos
    FOREIGN KEY (id_tipos) REFERENCES tipo_receita(id_tipos)
);

-- CRIAR TABELA TIPO ALIMENTO, E ALIMENTO, TUDO JUNTO
CREATE TABLE alimento(
    id_alimento                                            --PK
    nm_alimento                                            --Nome do alimento
    id_tipo_alimentos
    codigo_barras null                                        -- código para scannear alimento com a funcionalidade "Scanner"
);

CREATE TABLE categoria_alimento
    id_tipo_alimento                                    --PK
    ds_tipo_alimento                                    -- Industrializado ou Natural
);


-- 19. preferencia_alimentar
  -- Preferências do usuário (ex: vegetariano, intolerante à lactose) - vai estar ligada a seu perfil
CREATE TABLE preferencia_alimentar (
    id_preferencias INT PRIMARY KEY,
    id_usuarios INT NOT NULL,                                -- FK -> usuario.id_usuarios
    ds_preferencias NVARCHAR(100),
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);


-- 20. questionario_usuario
-- Questionário inicial para personalização de perfil - vai estar ligada ao perfil do usuario
CREATE TABLE questionario_usuario (
    id_questionarios INT IDENTITY PRIMARY KEY,                -- PK
    id_usuarios INT NOT NULL,                                 -- FK -> usuario.id_usuarios
    vl_pesos DECIMAL(5,2),
    vl_alturas DECIMAL(5,2),
    ds_objetivos NVARCHAR(100),
    ds_atividades_fisicas NVARCHAR(100),
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);

-- 21. desafio
-- Desafios de gamificação para usuários
CREATE TABLE desafio (
    id_desafios INT IDENTITY PRIMARY KEY,                     -- PK
    id_usuarios INT NOT NULL,                                 -- FK -> usuario.id_usuarios
    nm_desafios NVARCHAR(100),
    ds_desafios NVARCHAR(MAX),
    vl_pontos INT,                                   -- usar SUM para agregação
    quantidade_moedas INT                                         -- Valor em moedas
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);



-- 26. desafio_recompensa
-- Recompensas associadas aos desafios
CREATE TABLE desafio_recompensa (
    id_desafio INT NOT NULL,                                   -- FK -> desafio.id_desafios
    id_recompensa INT NOT NULL,                                 -- FK -> recompensa_moeda.id_recompensas
    PRIMARY KEY (id_desafio, id_recompensa),
    FOREIGN KEY (id_desafio) REFERENCES desafio(id_desafios),
    FOREIGN KEY (id_recompensa) REFERENCES recompensa_moeda(id_recompensas)
);

-- 23. plano_assinatura
-- Planos de assinatura disponíveis no app

CREATE TABLE plano_assinatura (
    id_planos INT IDENTITY PRIMARY KEY,               -- PK
    nm_planos NVARCHAR(100),                          -- Nome do plano (Mensal, Anual)
    ds_planos NVARCHAR(255),                          -- Descrição do plano
    vl_valores DECIMAL(10,2),                         -- Valor do plano
    qt_duracao_meses INT                              -- Duração do plano em meses
);

-- 24. usuario_plano_assinatura
-- Associação entre usuários e planos ativos
CREATE TABLE usuario_plano_assinatura (
    id_usuario INT NOT NULL,                                   -- FK -> usuario.id_usuarios
    id_plano INT NOT NULL,                                     -- FK -> plano_assinatura.id_planos
    data_inicio DATE,
    data_fim DATE,
    PRIMARY KEY (id_usuario, id_plano),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_plano) REFERENCES plano_assinatura(id_planos)
);

-- 28. pagamento_assinatura
-- Pagamentos dos planos de assinatura
--NOS PAGAMENTOS 

CREATE TABLE pagamento_assinatura (
    id_pagamentos INT IDENTITY PRIMARY KEY,             -- PK
    id_usuario INT NOT NULL,                            -- FK -> usuario.id_usuarios
    id_plano INT NOT NULL,                              -- FK -> plano_assinatura.id_planos
    vl_pagamento DECIMAL(10,2),                         -- Valor pago
    ds_forma_pagamento NVARCHAR(50),                    -- Cartão, PIX, etc.
    ds_status NVARCHAR(50),                             -- Pago, Pendente, Cancelado
    dt_pagamento DATETIME DEFAULT GETDATE(),            -- Data do pagamento
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_plano) REFERENCES plano_assinatura(id_planos)
);


-- 29. ebook
-- Ebooks disponíveis para compra no app

CREATE TABLE ebook (
    id_ebooks INT IDENTITY PRIMARY KEY,                 -- PK
    nm_ebooks NVARCHAR(150),                            -- Título do ebook
    nm_autores NVARCHAR(100),                           -- Autor
    ds_ebooks NVARCHAR(255),                            -- Descrição
    vl_ebooks_moedas DECIMAL(10,2),                            -- Valor
    ds_links_download NVARCHAR(255)                     -- Link de download ou armazenamento
);


-- 11. tipo_receita_ebook
-- Classificação das receitas dos ebooks
CREATE TABLE _receita (
    id_tipos INT PRIMARY KEY,                                -- PK
    ds_tipos NVARCHAR(100)                                   -- Doce, Salgado..
);

-- 25. compra_ebook
-- Registro de compra de ebooks
CREATE TABLE compra_ebook (
    id_compra INT IDENTITY PRIMARY KEY,                        -- PK
    id_usuario INT NOT NULL,                                    -- FK -> usuario.id_usuarios
    id_ebook INT NOT NULL,                                      -- FK -> ebook.id_ebooks
    data_compra DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_ebook) REFERENCES ebook(id_ebooks)
);



-- 27. historico_pagamento_assinatura
-- Histórico de pagamentos realizados pelos usuários
CREATE TABLE historico_pagamento_assinatura (
    id_historico INT IDENTITY PRIMARY KEY,                     -- PK
    id_usuario INT NOT NULL,                                    -- FK -> usuario.id_usuarios
    id_pagamento INT NOT NULL,                                  -- FK -> pagamento_assinatura.id_pagamentos
    valor_pago DECIMAL(10,2),
    data_transacao DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_pagamento) REFERENCES pagamento_assinatura(id_pagamentos)
);

-- 31. historico_scanner
-- Registro de scans de produtos por usuário
CREATE TABLE historico_scanner (
    id_scanner INT IDENTITY PRIMARY KEY,
    id_usuarios INT NOT NULL,                                  -- FK -> usuario.id_usuarios
    id_produtos INT NOT NULL,                                  -- FK -> produto.id_produtos
    dt_scan DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_produtos) REFERENCES produto(id_produtos)
);























-
