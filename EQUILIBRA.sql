-- BANCO DE DADOS: Equilibra
--NOMES: Lianara Vitoria e Maria Eduarda Luconi
-- PADRÃO UTILIZADO: snake case
--views: do usuário para mostrar as moedas ganhas ao total
-- View: vw_usuario_total_moedas
-- Mostra cada usuário e a quantidade total de moedas que ele possui
--CREATE VIEW vw_usuario_total_moedas AS
--SELECT 
--    u.id_usuarios,                    -- ID do usuário
 --   u.nm_usuarios,                    -- Nome do usuário
--IS NULL(SUM(d.qt_moedas), 0) AS total_moedas  -- Soma de todas as moedas dos desafios concluídos pelo usuário
--FROM usuario u
--LEFT JOIN desafio d
  --  ON u.id_usuarios = d.id_usuarios  -- Junta os desafios correspondentes ao usuário
--GROUP BY u.id_usuarios, u.nm_usuarios; -- Agrupa por usuário para somar corretamente








--------------------------------------------------------------------------------------------------------------------------------------
USUARIO E PERFIL
-------------------------------------------------------------------------------------------------------------------------------------

    
    
-- 1. usuario
-- Cadastro principal dos usuários do sistema
    
CREATE TABLE usuario (
    id_usuarios INT  PRIMARY KEY,                             -- PK
    nm_usuarios NVARCHAR(100) NOT NULL,                       -- Nome completo do usuário
    ds_emails NVARCHAR(100) UNIQUE NOT NULL,                  -- Email único de login
    ds_senhas NVARCHAR(100) NOT NULL,                         -- Senha de acesso
    dt_cadastros DATETIME DEFAULT GETDATE()                   -- Data e hora do cadastro);



    
-- 2. perfil_usuario
-- vai puxar os dados dos questionários, como um perfil onde os nutricionistas conseguem ver
CREATE TABLE perfil_usuario (
    id_perfil INT IDENTITY PRIMARY KEY,                      -- PK
    id_usuarios INT NOT NULL,                                -- FK -> usuario.id_usuarios
    id_preferencias INT NOT NULL                             --FK -> preferencia alimentar
    id_questionarios INT NOT NULL                            -- FK - > questionario_usuario
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
    FOREIGN KEY (id_preferencias) REFERENCES preferencia_alimentar(id_preferencias)
     FOREIGN KEY (id_questionarios) REFERENCES questionario_usuario(id_questionarios)
);




-- 19. preferencia_alimentar
  -- Preferências do usuário (ex: vegetariano, intolerante à lactose) - vai estar ligada a seu perfil
CREATE TABLE preferencia_alimentar (
    id_preferencias INT IDENTITY PRIMARY KEY,
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







--------------------------------------------------------------------------------------------------------------
Nutricionista e consultas
--------------------------------------------------------------------------------------------------------------    


    
-- 2. nutricionista
-- Cadastro Pessoal dos nutricionistas

CREATE TABLE nutricionista (
    id_nutricionistas INT PRIMARY KEY,                        -- PK
    nm_nutricionistas NVARCHAR(100),                          -- Nome completo
    nr_crns NVARCHAR(20) UNIQUE,                              -- CRN profissional
    ds_emails NVARCHAR(100),                                  -- Email de contato
    nr_telefones NVARCHAR(20)                                 -- Telefone);
    --endereços ADICIONAR
    

    
-- 7. cadastro_nutricionista
-- Dados complementares dos nutricionistas, usuários possuem acesso, para ver o perfil do nutricionista

CREATE TABLE perfil_nutricionista (
    id_cadastros INT  PRIMARY KEY,                            -- PK
    id_nutricionistas INT NOT NULL,                           -- FK -> nutricionista.id_nutricionistas
    ds_especializacoes NVARCHAR(100),                         -- Especializações do profissional
    ds_experiencias NVARCHAR(255),                            -- Experiências profissionais    ADICIONAR ENDEREÇOOO
    FOREIGN KEY (id_nutricionistas) REFERENCES nutricionista(id_nutricionistas));




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


--------------------------------------------------------------------------------------------------------------
Gamificação e moedas
--------------------------------------------------------------------------------------------------------------


    
-- 21. desafio
-- Desafios de gamificação para usuários
CREATE TABLE desafio (
    id_desafios INT IDENTITY PRIMARY KEY,      -- PK única do desafio
    id_usuarios INT NOT NULL,                  -- FK -> usuario.id_usuarios
    nm_desafios NVARCHAR(100) NOT NULL,       -- Nome do desafio
    ds_desafios NVARCHAR(MAX) NULL,           -- Descrição detalhada do desafio
    qt_moedas INT DEFAULT 0,                   -- Moedas ganhas ao completar o desafio
    dt_conclusao DATETIME DEFAULT GETDATE(),   -- Data de conclusão do desafio
    FOREIGN KEY (id_usuarios) REFERENCES usuario(id_usuarios)
);




-- 11. Recompensas associadas aos desafios
CREATE TABLE recompensa_moeda (
    id_recompensa_moeda INT IDENTITY PRIMARY KEY,
    id_desafio INT NOT NULL,
    FOREIGN KEY (id_desafio) REFERENCES desafio(id_desafios)
);


-- 13. View para mostrar o total de moedas por usuário



--------------------------------------------------------------------------------------------------------------
Alimentação e planos
--------------------------------------------------------------------------------------------------------------


    
 -- Tipos de refeição
--Define os tipos de refeição (Café da manhã, Almoço, Jantar, Lanche).
--Cada plano vai ter um tipo de refeição associado.
CREATE TABLE refeicao_tipo (
    id_refeicao_tipo INT IDENTITY PRIMARY KEY,
    ds_tipo NVARCHAR(50) NOT NULL
);




-- Plano alimentar 
--Contém o plano do usuário por refeição.
--Puxa o usuário (id_usuario) e o tipo de refeição (id_refeicao_tipo).
--Tem o campo ds_observacoes para o nutricionista colocar instruções ou receitas resumidas, sem duplicar alimentos

CREATE TABLE plano_alimentar (
    id_plano INT IDENTITY PRIMARY KEY,
    id_usuario INT NOT NULL,                  -- FK -> usuario.id_usuarios
    id_refeicao_tipo INT NOT NULL,            -- FK -> refeicao_tipo.id_refeicao_tipo
    nm_plano NVARCHAR(100),                   -- Nome do plano
    ds_objetivos NVARCHAR(100),               -- Objetivo do plano
    dt_inicio DATE,
    dt_fim DATE,
    ds_observacoes NVARCHAR(500) NULL,        -- Observações adicionais do nutricionista
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuarios),
    FOREIGN KEY (id_refeicao_tipo) REFERENCES refeicao_tipo(id_refeicao_tipo)
);





-- Alimento
--Tabela base de todos os alimentos, mesmo os que não têm código de barras.
--codigo_barras só se existir
CREATE TABLE alimento (
    id_alimento INT IDENTITY PRIMARY KEY,
    nm_alimento NVARCHAR(100) NOT NULL,
    id_tipo_alimento INT NOT NULL,            -- FK -> categoria_alimento.id_tipo_alimento
    codigo_barras NVARCHAR(50) NULL,
    FOREIGN KEY (id_tipo_alimento) REFERENCES categoria_alimento(id_tipo_alimento)
);




-- Relacionamento entre plano alimentar e alimentos (uma refeição pode ter vários alimentos)
--Aqui você consegue adicionar quantidade, ex: “2 ovos” ou “1 fatia de pão”.
--Cada linha representa um alimento específico de uma refeição do plano.
CREATE TABLE plano_alimento (
    id_plano_alimento INT IDENTITY PRIMARY KEY,
    id_plano INT NOT NULL,                     -- FK -> plano_alimentar.id_plano
    id_alimento INT NOT NULL,                  -- FK -> alimento.id_alimento
    quantidade NVARCHAR(50) NULL,             -- Ex: "2 ovos", "1 fatia de pão"
    FOREIGN KEY (id_plano) REFERENCES plano_alimentar(id_plano),
    FOREIGN KEY (id_alimento) REFERENCES alimento(id_alimento)
);






-- 3. alimento_detalhado
-- Alimentos que podem ser escaneados, com informações nutricionais completas
--Para os alimentos que podem ser escaneados
--Cada alimento detalhado puxa o id_alimento da tabela base, mas adiciona:
--nm_alimento_detalhado → nome mais completo, ex: “Banana prata madura 100g”
--codigo_barras → obrigatório, para o scanner funcionar
--Nutrientes detalhados (calorias, proteínas, carboidratos etc.)
--id_tipo_alimento → mantém o tipo de categoria
    
CREATE TABLE alimento_detalhado (
    id_alimento_detalhado INT IDENTITY PRIMARY KEY,  -- PK
    id_alimento INT NOT NULL,                        -- FK -> alimento.id_alimento
    nm_alimento_detalhado NVARCHAR(100) NULL,       -- Nome detalhado opcional, ex: "Banana prata madura 100g"
    codigo_barras NVARCHAR(50) UNIQUE NOT NULL,     -- Código de barras obrigatório para o scanner
    vl_calorias DECIMAL(6,2) NULL,                 -- Calorias
    vl_proteinas DECIMAL(6,2) NULL,                -- Proteínas em gramas
    vl_carboidratos DECIMAL(6,2) NULL,             -- Carboidratos em gramas
    vl_gorduras DECIMAL(6,2) NULL,                 -- Gorduras totais em gramas
    vl_fibras DECIMAL(6,2) NULL,                   -- Fibras em gramas
    vl_sodio DECIMAL(6,2) NULL,                    -- Sódio em mg
    id_tipo_alimento INT NOT NULL,                  -- FK -> categoria_alimento.id_tipo_alimento
    FOREIGN KEY (id_alimento) REFERENCES alimento(id_alimento),
    FOREIGN KEY (id_tipo_alimento) REFERENCES categoria_alimento(id_tipo_alimento)





    
--------------------------------------------------------------------------------------------------------------
Assinaturas e pagamentos
--------------------------------------------------------------------------------------------------------------

    
-- 23. plano_assinatura
-- Planos de assinatura disponíveis no app

CREATE TABLE plano_assinatura (
    id_planos INT IDENTITY PRIMARY KEY,               -- PK
    nm_planos NVARCHAR(100),                          -- Nome do plano (Mensal, Anual)
    ds_planos NVARCHAR(255),                          -- Descrição do plano
    vl_valores DECIMAL(10,2),                         -- Valor do plano
    qt_duracao_meses INT                              -- Duração do plano em meses
    qt_moedas INT DEFAULT 0                       -- Quantidade de moedas que o plano dá
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











--------------------------------------------------------------------------------------------------------------
Ebooks
--------------------------------------------------------------------------------------------------------------
    
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





--------------------------------------------------------------------------------------------------------------
Scanner de produtos com código
--------------------------------------------------------------------------------------------------------------
    
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
