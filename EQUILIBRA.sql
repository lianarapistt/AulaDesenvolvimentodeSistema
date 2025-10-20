-- BANCO DE DADOS: Equilibra
-- 31 TABELAS
--NOMES: Lianara Vitoria e Maria Eduarda Luconi
-- PADRÃO UTILIZADO: snake case
-- COMENTÁRIOS DETALHADOS

-- 1. usuario
-- Cadastro principal dos usuários do sistema

CREATE TABLE usuario (
    id_usuarios INT  PRIMARY KEY,                             -- PK
    nm_usuarios NVARCHAR(100) NOT NULL,                       -- Nome completo do usuário
    ds_emails NVARCHAR(100) UNIQUE NOT NULL,                  -- Email único de login
    ds_senhas NVARCHAR(100) NOT NULL,                         -- Senha de acesso
    dt_cadastros DATETIME DEFAULT GETDATE()                   -- Data e hora do cadastro);


-- 2. nutricionista
-- Cadastro dos nutricionistas que atendem usuários

CREATE TABLE nutricionista (
    id_nutricionistas INT PRIMARY KEY,                        -- PK
    nm_nutricionistas NVARCHAR(100),                          -- Nome completo
    nr_crns NVARCHAR(20) UNIQUE,                              -- CRN profissional
    ds_emails NVARCHAR(100),                                  -- Email de contato
    nr_telefones NVARCHAR(20)                                 -- Telefone);


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
-- Avaliações feitas pelos usuários

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
    id_nutricionistas INT NOT NULL,                           -- FK -> nutricionista.id_nutricionistas
    ds_dias_semana NVARCHAR(20),                              -- Dia da semana
    hr_inicios TIME,                                          -- Hora de início
    hr_fins TIME,                                             -- Hora de término
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas));


-- 7. cadastro_nutricionista
-- Dados complementares dos nutricionistas, usuários possuem acesso

CREATE TABLE cadastro_nutricionista (
    id_cadastros INT  PRIMARY KEY,                            -- PK
    id_nutricionistas INT NOT NULL,                           -- FK -> nutricionista.id_nutricionistas
    nr_crns NVARCHAR(20) UNIQUE,                              -- FK -> nutricionista.nr_crns
    ds_especializacoes NVARCHAR(100),                         -- Especializações do profissional
    ds_experiencias NVARCHAR(255),                            -- Experiências profissionais
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas),
    FOREIGN KEY (nr_crns) REFERENCES nutricionista(nr_crns));


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

-- 9. plano_semana
-- Dias da semana de cada plano alimentar

CREATE TABLE plano_semana (
    id_plano_semana INT  PRIMARY KEY,                     -- PK
    id_planos INT NOT NULL,                               -- FK -> plano_alimentar.id_planos
    ds_dia_semana NVARCHAR(20),                           -- Segunda, Terça
    FOREIGN KEY (id_planos) REFERENCES plano_alimentar(id_planos)
);

-- 10. refeicao_tipo
-- Tipos de refeição (Café da manhã, Almoço etc.)
CREATE TABLE refeicao_tipo (
    id_refeicao_tipo INT  PRIMARY KEY,                       -- PK
    ds_tipo NVARCHAR(50) NOT NULL                            -- Café da manhã, Almoço, Jantar, Lanche
);

-- 11. tipo_receita
-- Classificação das receitas
CREATE TABLE tipo_receita (
    id_tipos INT PRIMARY KEY,                                -- PK
    ds_tipos NVARCHAR(100)                                   -- Doce, Salgado..
);

-- 12. receita
-- Receitas cadastradas no sistema
CREATE TABLE receita (
    id_receitas INT  PRIMARY KEY,                            -- PK
    nm_receitas NVARCHAR(100),                               -- Nome da receita
    ds_descricoes NVARCHAR(500),                             -- Descrição detalhada, modo de preparo
    id_tipos INT,                                            -- FK -> tipo_receita.id_tipos
    FOREIGN KEY (id_tipos) REFERENCES tipo_receita(id_tipos)
);

-- 13. categoria_ingrediente
-- Classificação dos ingredientes
CREATE TABLE categoria_ingrediente (                      
    id_categorias INT PRIMARY KEY,                          -- PK
    nm_categorias NVARCHAR(100)                             -- Ex: Frutas, Verduras, Cereais
);

-- 14. ingrediente
-- Ingredientes utilizados nas receitas
CREATE TABLE ingrediente (
    id_ingredientes INT IDENTITY PRIMARY KEY,                 -- PK
    nm_ingredientes NVARCHAR(100),                            -- Nome do ingrediente
    id_categorias INT,                                        -- FK -> categoria_ingrediente.id_categorias
    FOREIGN KEY (id_categorias) REFERENCES categoria_ingrediente(id_categorias)
);

-- 15. receita_ingrediente
-- Relação N:N entre receitas e ingredientes
CREATE TABLE receita_ingrediente (
    id_receitas INT NOT NULL,                                  -- FK -> receita.id_receitas
    id_ingredientes INT NOT NULL,                              -- FK -> ingrediente.id_ingredientes
    qt_quantidades DECIMAL(10,2),                              -- Quantidade
    ds_unidades NVARCHAR(20),                                  -- Unidade de medida(g, kg)
    PRIMARY KEY (id_receitas, id_ingredientes),
    FOREIGN KEY (id_receitas) REFERENCES receita(id_receitas),
    FOREIGN KEY (id_ingredientes) REFERENCES ingrediente(id_ingredientes)
);

-- 16. categoria_produto
-- Categoria dos produtos industrializados
CREATE TABLE categoria_produto (                          
    id_categorias INT  PRIMARY KEY,                          -- PK
    nm_categorias NVARCHAR(100)                              -- Frios, Bebidas 
);

-- 17. produto
-- Produtos industrializados com rótulos e scanner
CREATE TABLE produto (
    id_produtos INT PRIMARY KEY,                            -- PK
    nm_produtos NVARCHAR(100),                              -- Nome do produto                         
    id_categorias INT,                                      -- FK -> categoria_produto.id_categorias
    cd_barras NVARCHAR(50) UNIQUE,                          -- Código de barras
    FOREIGN KEY (id_categorias) REFERENCES categoria_produto(id_categorias)
);

-- 18. refeicao_plano
-- Liga plano, dia, tipo de refeição, receita/produto
CREATE TABLE refeicao_plano (
    id_refeicao_plano INT PRIMARY KEY,                     -- PK
    id_plano_semana INT NOT NULL,                         -- FK -> plano_semana.id_plano_semana
    id_refeicao_tipo INT NOT NULL,                            -- FK -> refeicao_tipo.id_refeicao_tipo
    id_receita INT NULL,                                       -- FK -> receita.id_receitas
    id_produto INT NULL,                                           -- FK -> produto.id_produtos
    vl_quantidade DECIMAL(10,2),                                -- Quantidade sugerida
    ds_unidade NVARCHAR(20),                                        -- Unidade de medida       
    FOREIGN KEY (id_plano_semana) REFERENCES plano_semana(id_plano_semana),
    FOREIGN KEY (id_refeicao_tipo) REFERENCES refeicao_tipo(id_refeicao_tipo),
    FOREIGN KEY (id_receita) REFERENCES receita(id_receitas),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produtos)
);

-- 19. preferencia_alimentar
  -- Preferências do usuário (ex: vegetariano, lactose)
CREATE TABLE preferencia_alimentar (
    id_preferencias INT PRIMARY KEY,
    id_usuarios INT NOT NULL,                                -- FK -> usuario.id_usuarios
    ds_preferencias NVARCHAR(100),
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);


-- 20. questionario_usuario
-- Questionário inicial para personalização de perfil
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
    vl_pontos INT,
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);


-- 22. recompensa_moeda
-- Catálogo de recompensas e moedas
CREATE TABLE recompensa_moeda (
    id_recompensas INT IDENTITY PRIMARY KEY,                  -- PK
    ds_recompensas NVARCHAR(100),
    vl_recompensas INT                                         -- Valor em moedas
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
    ativo BIT DEFAULT 1,
    PRIMARY KEY (id_usuario, id_plano),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_plano) REFERENCES plano_assinatura(id_planos)
);

-- 28. pagamento_assinatura
-- Pagamentos dos planos de assinatura

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
    vl_ebooks DECIMAL(10,2),                            -- Valor
    ds_links_download NVARCHAR(255)                     -- Link de download ou armazenamento
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


-- 26. desafio_recompensa
-- Recompensas associadas aos desafios
CREATE TABLE desafio_recompensa (
    id_desafio INT NOT NULL,                                   -- FK -> desafio.id_desafios
    id_recompensa INT NOT NULL,                                 -- FK -> recompensa_moeda.id_recompensas
    PRIMARY KEY (id_desafio, id_recompensa),
    FOREIGN KEY (id_desafio) REFERENCES desafio(id_desafios),
    FOREIGN KEY (id_recompensa) REFERENCES recompensa_moeda(id_recompensas)
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























-- BANCO DE DADOS: Equilibra
-- 31 TABELAS
-- NOMES: Lianara Vitoria e Maria Eduarda Luconi
-- PADRÃO UTILIZADO: snake_case
-- COMENTÁRIOS DETALHADOS


-- 1. usuario
-- Cadastro principal dos usuários do sistema

CREATE TABLE usuario (
    id_usuarios INT IDENTITY(1,1) PRIMARY KEY,               -- PK
    nm_usuarios NVARCHAR(100) NOT NULL,                      -- Nome completo do usuário
    ds_emails NVARCHAR(100) UNIQUE NOT NULL,                 -- Email único de login
    ds_senhas NVARCHAR(100) NOT NULL,                        -- Senha de acesso
    dt_cadastros DATETIME DEFAULT GETDATE()                  -- Data e hora do cadastro
);


-- 2. nutricionista
-- Cadastro dos nutricionistas que atendem usuários

CREATE TABLE nutricionista (
    id_nutricionistas INT IDENTITY(1,1) PRIMARY KEY,         -- PK
    nm_nutricionistas NVARCHAR(100),                         -- Nome completo
    nr_crns NVARCHAR(20) UNIQUE,                             -- CRN profissional
    ds_emails NVARCHAR(100),                                 -- Email de contato
    nr_telefones NVARCHAR(20)                                -- Telefone
);


-- 3. consulta
-- Registro de consultas entre usuário e nutricionista

CREATE TABLE consulta (
    id_consultas INT IDENTITY(1,1) PRIMARY KEY,              -- PK
    id_usuarios INT NOT NULL,                                -- FK -> usuario.id_usuarios
    id_nutricionistas INT NOT NULL,                          -- FK -> nutricionista.id_nutricionistas
    dt_consultas DATETIME,                                   -- Data e hora da consulta
    ds_status NVARCHAR(50),                                  -- Status (agendada, concluída, cancelada)
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas)
);


-- 4. historico_consulta
-- Observações e detalhes pós-consulta

CREATE TABLE historico_consulta (
    id_historicos INT IDENTITY(1,1) PRIMARY KEY,             -- PK
    id_consultas INT NOT NULL,                               -- FK -> consulta.id_consultas
    ds_observacoes NVARCHAR(MAX),                            -- Observações pós-consulta
    FOREIGN KEY (id_consultas) REFERENCES consulta(id_consultas)
);


-- 5. avaliacao_nutricionista
-- Avaliações feitas pelos usuários

CREATE TABLE avaliacao_nutricionista (
    id_avaliacoes INT IDENTITY(1,1) PRIMARY KEY,             -- PK
    id_usuarios INT NOT NULL,                                -- FK -> usuario.id_usuarios
    id_nutricionistas INT NOT NULL,                          -- FK -> nutricionista.id_nutricionistas
    nr_notas INT CHECK (nr_notas BETWEEN 1 AND 5),           -- Nota de 1 a 5
    ds_comentarios NVARCHAR(255),                            -- Comentários do usuário
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas)
);


-- 6. disponibilidade_nutricionista
-- Horários disponíveis para consultas

CREATE TABLE disponibilidade_nutricionista (
    id_disponibilidades INT IDENTITY(1,1) PRIMARY KEY,       -- PK
    id_nutricionistas INT NOT NULL,                          -- FK -> nutricionista.id_nutricionistas
    ds_dias_semana NVARCHAR(20),                             -- Dia da semana
    hr_inicios TIME,                                         -- Hora de início
    hr_fins TIME,                                            -- Hora de término
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas)
);


-- 7. cadastro_nutricionista
-- Dados complementares dos nutricionistas

CREATE TABLE cadastro_nutricionista (
    id_cadastros INT IDENTITY(1,1) PRIMARY KEY,              -- PK
    id_nutricionistas INT NOT NULL,                          -- FK -> nutricionista.id_nutricionistas
    nr_crns NVARCHAR(20) UNIQUE,                             -- FK -> nutricionista.nr_crns
    ds_especializacoes NVARCHAR(100),                        -- Especializações
    ds_experiencias NVARCHAR(255),                           -- Experiências profissionais
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas),
    FOREIGN KEY (nr_crns) REFERENCES nutricionista(nr_crns)
);


-- 8. plano_alimentar
-- Plano personalizado de cada usuário

CREATE TABLE plano_alimentar (
    id_planos INT IDENTITY(1,1) PRIMARY KEY,                 -- PK
    id_usuarios INT NOT NULL,                                -- FK -> usuario.id_usuarios
    ds_objetivos NVARCHAR(100),                              -- Objetivo
    dt_inicios DATE,                                         -- Data de início
    dt_fins DATE,                                            -- Data de término
    nm_plano NVARCHAR(100),                                  -- Nome do plano
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);


-- 9. plano_semana
-- Dias da semana de cada plano alimentar

CREATE TABLE plano_semana (
    id_plano_semana INT IDENTITY(1,1) PRIMARY KEY,           -- PK
    id_planos INT NOT NULL,                                  -- FK -> plano_alimentar.id_planos
    ds_dia_semana NVARCHAR(20),                              -- Segunda, Terça...
    FOREIGN KEY (id_planos) REFERENCES plano_alimentar(id_planos)
);


-- 10. refeicao_tipo
-- Tipos de refeição

CREATE TABLE refeicao_tipo (
    id_refeicao_tipo INT IDENTITY(1,1) PRIMARY KEY,          -- PK
    ds_tipo NVARCHAR(50) NOT NULL                            -- Café da manhã, Almoço


-- 11. tipo_receita
-- Classificação das receitas

CREATE TABLE tipo_receita (
    id_tipos INT IDENTITY(1,1) PRIMARY KEY,                  -- PK
    ds_tipos NVARCHAR(100)                                   -- Doce, Salgado
);


-- 12. receita
-- Receitas cadastradas

CREATE TABLE receita (
    id_receitas INT IDENTITY(1,1) PRIMARY KEY,               -- PK
    nm_receitas NVARCHAR(100),                               -- Nome
    ds_descricoes NVARCHAR(500),                             -- Descrição
    id_tipos INT,                                            -- FK -> tipo_receita
    FOREIGN KEY (id_tipos) REFERENCES tipo_receita(id_tipos)
);


-- 13. categoria_ingrediente
-- Classificação dos ingredientes

CREATE TABLE categoria_ingrediente (
    id_categorias INT IDENTITY(1,1) PRIMARY KEY,             -- PK
    nm_categorias NVARCHAR(100)                              -- Frutas, Verduras
);


-- 14. ingrediente
-- Ingredientes utilizados nas receitas

CREATE TABLE ingrediente (
    id_ingredientes INT IDENTITY(1,1) PRIMARY KEY,           -- PK
    nm_ingredientes NVARCHAR(100),                           -- Nome do ingrediente
    id_categorias INT,                                       -- FK -> categoria_ingrediente
    FOREIGN KEY (id_categorias) REFERENCES categoria_ingrediente(id_categorias)
);


-- 15. receita_ingrediente
-- Relação N:N entre receitas e ingredientes

CREATE TABLE receita_ingrediente (
    id_receitas INT NOT NULL,                                -- FK -> receita
    id_ingredientes INT NOT NULL,                            -- FK -> ingrediente
    qt_quantidades DECIMAL(10,2),                            -- Quantidade
    ds_unidades NVARCHAR(20),                                -- Unidade (g, ml)
    PRIMARY KEY (id_receitas, id_ingredientes),
    FOREIGN KEY (id_receitas) REFERENCES receita(id_receitas),
    FOREIGN KEY (id_ingredientes) REFERENCES ingrediente(id_ingredientes)
);


-- 16. categoria_produto
-- Categoria dos produtos industrializados

CREATE TABLE categoria_produto (
    id_categorias INT IDENTITY(1,1) PRIMARY KEY,             -- PK
    nm_categorias NVARCHAR(100)                              -- Frios, Bebidas
);


-- 17. produto
-- Produtos industrializados com rótulos

CREATE TABLE produto (
    id_produtos INT IDENTITY(1,1) PRIMARY KEY,               -- PK
    nm_produtos NVARCHAR(100),                               -- Nome
    id_categorias INT,                                       -- FK -> categoria_produto
    cd_barras NVARCHAR(50) UNIQUE,                           -- Código de barras
    FOREIGN KEY (id_categorias) REFERENCES categoria_produto(id_categorias)
);


-- 18. refeicao_plano
-- Liga plano, tipo de refeição e receita/produto

CREATE TABLE refeicao_plano (
    id_refeicao_plano INT IDENTITY(1,1) PRIMARY KEY,         -- PK
    id_plano_semana INT NOT NULL,                            -- FK -> plano_semana
    id_refeicao_tipo INT NOT NULL,                           -- FK -> refeicao_tipo
    id_receita INT NULL,                                     -- FK -> receita
    id_produto INT NULL,                                     -- FK -> produto
    vl_quantidade DECIMAL(10,2),                             -- Quantidade sugerida
    ds_unidade NVARCHAR(20),                                 -- Unidade
    FOREIGN KEY (id_plano_semana) REFERENCES plano_semana(id_plano_semana),
    FOREIGN KEY (id_refeicao_tipo) REFERENCES refeicao_tipo(id_refeicao_tipo),
    FOREIGN KEY (id_receita) REFERENCES receita(id_receitas),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produtos)
);


-- 19. preferencia_alimentar
-- Preferências alimentares dos usuários

CREATE TABLE preferencia_alimentar (
    id_preferencias INT IDENTITY(1,1) PRIMARY KEY,           -- PK
    id_usuarios INT NOT NULL,                                -- FK -> usuario
    ds_preferencias NVARCHAR(100),                           -- Ex: vegetariano
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);


-- 20. questionario_usuario
-- Questionário inicial para personalização do usuario

CREATE TABLE questionario_usuario (
    id_questionarios INT IDENTITY(1,1) PRIMARY KEY,          -- PK
    id_usuarios INT NOT NULL,                                -- FK -> usuario
    vl_pesos DECIMAL(5,2),
    vl_alturas DECIMAL(5,2),
    ds_objetivos NVARCHAR(100),
    ds_atividades_fisicas NVARCHAR(100),
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);


-- 21. desafio
-- Desafios de gamificação

CREATE TABLE desafio (
    id_desafios INT IDENTITY(1,1) PRIMARY KEY,               -- PK
    id_usuarios INT NOT NULL,                                -- FK -> usuario
    nm_desafios NVARCHAR(100),
    ds_desafios NVARCHAR(MAX),
    vl_pontos INT,
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);


-- 22. recompensa_moeda
-- Catálogo de recompensas

CREATE TABLE recompensa_moeda (
    id_recompensas INT IDENTITY(1,1) PRIMARY KEY,            -- PK
    ds_recompensas NVARCHAR(100),
    vl_recompensas INT
);


-- 23. desafio_recompensa
-- Relação entre desafios e recompensas

CREATE TABLE desafio_recompensa (
    id_desafio INT NOT NULL,                                 -- FK -> desafio
    id_recompensa INT NOT NULL,                              -- FK -> recompensa_moeda
    PRIMARY KEY (id_desafio, id_recompensa),
    FOREIGN KEY (id_desafio) REFERENCES desafio(id_desafios),
    FOREIGN KEY (id_recompensa) REFERENCES recompensa_moeda(id_recompensas)
);


-- 24. plano_assinatura
-- Planos de assinatura do app

CREATE TABLE plano_assinatura (
    id_planos INT IDENTITY(1,1) PRIMARY KEY,                 -- PK
    nm_planos NVARCHAR(100),
    ds_planos NVARCHAR(255),
    vl_valores DECIMAL(10,2),
    qt_duracao_meses INT
);


-- 25. usuario_plano_assinatura
-- Associação entre usuário e plano ativo

CREATE TABLE usuario_plano_assinatura (
    id_usuario INT NOT NULL,                                 -- FK -> usuario
    id_plano INT NOT NULL,                                   -- FK -> plano_assinatura
    data_inicio DATE,
    data_fim DATE,
    ativo BIT DEFAULT 1,
    PRIMARY KEY (id_usuario, id_plano),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_plano) REFERENCES plano_assinatura(id_planos)
);


-- 26. pagamento_assinatura
-- Pagamentos dos planos

CREATE TABLE pagamento_assinatura (
    id_pagamentos INT IDENTITY(1,1) PRIMARY KEY,             -- PK
    id_usuario INT NOT NULL,                                 -- FK -> usuario
    id_plano INT NOT NULL,                                   -- FK -> plano_assinatura
    vl_pagamento DECIMAL(10,2),
    ds_forma_pagamento NVARCHAR(50),
    ds_status NVARCHAR(50),
    dt_pagamento DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_plano) REFERENCES plano_assinatura(id_planos)
);


-- 27. historico_pagamento_assinatura
-- Histórico de pagamentos

CREATE TABLE historico_pagamento_assinatura (
    id_historico INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_pagamento INT NOT NULL,
    valor_pago DECIMAL(10,2),
    data_transacao DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_pagamento) REFERENCES pagamento_assinatura(id_pagamentos)
);


-- 28. ebook
-- Ebooks disponíveis para compra

CREATE TABLE ebook (
    id_ebooks INT IDENTITY(1,1) PRIMARY KEY,
    nm_ebooks NVARCHAR(150),
    nm_autores NVARCHAR(100),
    ds_ebooks NVARCHAR(255),
    vl_ebooks DECIMAL(10,2),
    ds_links_download NVARCHAR(255)
);


-- 29. compra_ebook
-- Registro de compra de ebooks

CREATE TABLE compra_ebook (
    id_compra INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_ebook INT NOT NULL,
    data_compra DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_ebook) REFERENCES ebook(id_ebooks)
);


-- 30. historico_scanner
-- Registro de scans de produtos por usuário

CREATE TABLE historico_scanner (
    id_scanner INT IDENTITY(1,1) PRIMARY KEY,
    id_usuarios INT NOT NULL,
    id_produtos INT NOT NULL,
    dt_scan DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_produtos) REFERENCES produto(id_produtos)
);




