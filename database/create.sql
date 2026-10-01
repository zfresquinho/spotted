-- =============================================================
-- Spotted — criação da base de dados (MySQL 8)
-- Versão inicial (Sprint 1). Rever com o modelo ER final.
-- Uso: mysql -u root -p < database/create.sql
-- =============================================================

SET NAMES utf8mb4;
DROP DATABASE IF EXISTS spotted;
CREATE DATABASE spotted CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE spotted;

-- -------------------------------------------------------------
-- Utilizadores
-- -------------------------------------------------------------
CREATE TABLE utilizador (
  id_utilizador     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome              VARCHAR(80)  NOT NULL,
  email             VARCHAR(120) NOT NULL UNIQUE,
  password_hash     CHAR(60)     NOT NULL,                  -- bcrypt
  data_nascimento   DATE         NOT NULL,                  -- validar >= 18 anos na API
  peso_kg           DECIMAL(5,1) NULL,                      -- opcional (estimativa)
  sexo              ENUM('M','F') NULL,                     -- opcional (fator de Widmark)
  aceitou_rgpd_em   DATETIME     NOT NULL,
  criado_em         DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_peso CHECK (peso_kg IS NULL OR peso_kg BETWEEN 30 AND 300)
);

-- -------------------------------------------------------------
-- Spots
-- -------------------------------------------------------------
CREATE TABLE zona (
  id_zona  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome     VARCHAR(60) NOT NULL UNIQUE                      -- ex.: Bairro Alto, Cais do Sodré
);

CREATE TABLE tipo_spot (
  id_tipo  TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome     VARCHAR(30) NOT NULL UNIQUE                      -- Bar, Discoteca, Rooftop…
);

CREATE TABLE spot (
  id_spot        INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome           VARCHAR(100) NOT NULL,
  descricao      VARCHAR(500) NULL,
  morada         VARCHAR(200) NOT NULL,
  latitude       DECIMAL(9,6) NOT NULL,
  longitude      DECIMAL(9,6) NOT NULL,
  nivel_preco    TINYINT UNSIGNED NOT NULL,                 -- 1 a 4 (€ a €€€€)
  hora_abertura  TIME NULL,
  hora_fecho     TIME NULL,
  codigo_qr      CHAR(36) NOT NULL UNIQUE,                  -- UUID impresso no QR
  id_zona        INT UNSIGNED NOT NULL,
  id_tipo        TINYINT UNSIGNED NOT NULL,
  CONSTRAINT fk_spot_zona FOREIGN KEY (id_zona) REFERENCES zona(id_zona),
  CONSTRAINT fk_spot_tipo FOREIGN KEY (id_tipo) REFERENCES tipo_spot(id_tipo),
  CONSTRAINT chk_preco CHECK (nivel_preco BETWEEN 1 AND 4)
);

-- -------------------------------------------------------------
-- Check-in (entidade central: desbloqueia avaliação e chat)
-- -------------------------------------------------------------
CREATE TABLE checkin (
  id_checkin     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_utilizador  INT UNSIGNED NOT NULL,
  id_spot        INT UNSIGNED NOT NULL,
  metodo         ENUM('QR','GPS') NOT NULL,
  feito_em       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_checkin_utilizador FOREIGN KEY (id_utilizador) REFERENCES utilizador(id_utilizador) ON DELETE CASCADE,
  CONSTRAINT fk_checkin_spot       FOREIGN KEY (id_spot)       REFERENCES spot(id_spot),
  INDEX idx_checkin_spot_data (id_spot, feito_em)
);

-- -------------------------------------------------------------
-- Avaliação do spot (4 critérios, só com check-in)
-- -------------------------------------------------------------
CREATE TABLE avaliacao_spot (
  id_avaliacao   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_checkin     INT UNSIGNED NOT NULL UNIQUE,              -- 1 avaliação por check-in
  ambiente       TINYINT UNSIGNED NOT NULL,
  musica         TINYINT UNSIGNED NOT NULL,
  preco          TINYINT UNSIGNED NOT NULL,
  servico        TINYINT UNSIGNED NOT NULL,
  comentario     VARCHAR(500) NULL,
  criada_em      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_aval_checkin FOREIGN KEY (id_checkin) REFERENCES checkin(id_checkin) ON DELETE CASCADE,
  CONSTRAINT chk_aval_notas CHECK (ambiente BETWEEN 1 AND 5 AND musica BETWEEN 1 AND 5
                                   AND preco BETWEEN 1 AND 5 AND servico BETWEEN 1 AND 5)
);

-- -------------------------------------------------------------
-- Bebidas: catálogo geral + carta de cada spot
-- -------------------------------------------------------------
CREATE TABLE bebida (
  id_bebida      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nome           VARCHAR(80) NOT NULL,
  categoria      ENUM('Cerveja','Vinho','Cocktail','Shot','Destilado','Sem alcool') NOT NULL,
  volume_ml      SMALLINT UNSIGNED NOT NULL,
  teor_alcool    DECIMAL(4,1) NOT NULL,                     -- % vol.
  CONSTRAINT chk_teor CHECK (teor_alcool BETWEEN 0 AND 80)
);

CREATE TABLE bebida_spot (
  id_bebida_spot INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_spot        INT UNSIGNED NOT NULL,
  id_bebida      INT UNSIGNED NOT NULL,
  nome_na_carta  VARCHAR(80) NULL,                          -- ex.: "Mojito da Casa"
  preco_eur      DECIMAL(5,2) NULL,
  CONSTRAINT fk_bs_spot   FOREIGN KEY (id_spot)   REFERENCES spot(id_spot)     ON DELETE CASCADE,
  CONSTRAINT fk_bs_bebida FOREIGN KEY (id_bebida) REFERENCES bebida(id_bebida),
  UNIQUE KEY uq_bebida_spot (id_spot, id_bebida, nome_na_carta)
);

CREATE TABLE avaliacao_bebida (
  id_avaliacao_bebida INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_checkin          INT UNSIGNED NOT NULL,
  id_bebida_spot      INT UNSIGNED NOT NULL,
  nota                TINYINT UNSIGNED NOT NULL,
  comentario          VARCHAR(300) NULL,
  criada_em           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_ab_checkin FOREIGN KEY (id_checkin)     REFERENCES checkin(id_checkin)         ON DELETE CASCADE,
  CONSTRAINT fk_ab_bs      FOREIGN KEY (id_bebida_spot) REFERENCES bebida_spot(id_bebida_spot) ON DELETE CASCADE,
  UNIQUE KEY uq_ab (id_checkin, id_bebida_spot),
  CONSTRAINT chk_ab_nota CHECK (nota BETWEEN 1 AND 5)
);

-- -------------------------------------------------------------
-- A minha noite (privado)
-- -------------------------------------------------------------
CREATE TABLE noite (
  id_noite       INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_utilizador  INT UNSIGNED NOT NULL,
  iniciada_em    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  terminada_em   DATETIME NULL,                             -- NULL = noite ativa
  CONSTRAINT fk_noite_utilizador FOREIGN KEY (id_utilizador) REFERENCES utilizador(id_utilizador) ON DELETE CASCADE
);

CREATE TABLE consumo (
  id_consumo     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_noite       INT UNSIGNED NOT NULL,
  id_bebida      INT UNSIGNED NOT NULL,
  id_spot        INT UNSIGNED NULL,                         -- onde bebeu (opcional)
  consumido_em   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_consumo_noite  FOREIGN KEY (id_noite)  REFERENCES noite(id_noite)   ON DELETE CASCADE,
  CONSTRAINT fk_consumo_bebida FOREIGN KEY (id_bebida) REFERENCES bebida(id_bebida),
  CONSTRAINT fk_consumo_spot   FOREIGN KEY (id_spot)   REFERENCES spot(id_spot)     ON DELETE SET NULL
);

-- -------------------------------------------------------------
-- Chat do spot (mensagens apagadas às 06:00 por tarefa agendada)
-- -------------------------------------------------------------
CREATE TABLE mensagem (
  id_mensagem    BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_spot        INT UNSIGNED NOT NULL,
  id_utilizador  INT UNSIGNED NOT NULL,
  texto          VARCHAR(500) NOT NULL,
  enviada_em     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_msg_spot       FOREIGN KEY (id_spot)       REFERENCES spot(id_spot)             ON DELETE CASCADE,
  CONSTRAINT fk_msg_utilizador FOREIGN KEY (id_utilizador) REFERENCES utilizador(id_utilizador) ON DELETE CASCADE,
  INDEX idx_msg_spot_data (id_spot, enviada_em)
);

CREATE TABLE denuncia (
  id_denuncia    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_mensagem    BIGINT UNSIGNED NULL,                      -- fica NULL quando a mensagem expira
  id_denunciante INT UNSIGNED NOT NULL,
  id_denunciado  INT UNSIGNED NOT NULL,
  texto_copia    VARCHAR(500) NOT NULL,                     -- cópia para moderação
  motivo         VARCHAR(200) NULL,
  criada_em      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_den_msg   FOREIGN KEY (id_mensagem)    REFERENCES mensagem(id_mensagem)       ON DELETE SET NULL,
  CONSTRAINT fk_den_autor FOREIGN KEY (id_denunciante) REFERENCES utilizador(id_utilizador) ON DELETE CASCADE,
  CONSTRAINT fk_den_alvo  FOREIGN KEY (id_denunciado)  REFERENCES utilizador(id_utilizador) ON DELETE CASCADE
);

CREATE TABLE bloqueio (
  id_utilizador  INT UNSIGNED NOT NULL,
  id_bloqueado   INT UNSIGNED NOT NULL,
  criado_em      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_utilizador, id_bloqueado),
  CONSTRAINT fk_bl_autor FOREIGN KEY (id_utilizador) REFERENCES utilizador(id_utilizador) ON DELETE CASCADE,
  CONSTRAINT fk_bl_alvo  FOREIGN KEY (id_bloqueado)  REFERENCES utilizador(id_utilizador) ON DELETE CASCADE,
  CONSTRAINT chk_bl CHECK (id_utilizador <> id_bloqueado)
);
