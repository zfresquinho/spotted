-- =============================================================
-- Spotted — dados de exemplo (TODOS FICTÍCIOS)
-- Versão inicial com poucos registos; alargar no Sprint 2
-- (meta: ~20 spots, ~30 utilizadores, ~200 check-ins).
-- Uso: mysql -u root -p spotted < database/populate.sql
-- Palavra-passe de todos os utilizadores de teste: Spotted2026!
-- =============================================================
USE spotted;
SET NAMES utf8mb4;

INSERT INTO zona (nome) VALUES
  ('Bairro Alto'), ('Cais do Sodré'), ('Príncipe Real'), ('Santos'), ('Intendente');

INSERT INTO tipo_spot (nome) VALUES
  ('Bar'), ('Discoteca'), ('Rooftop'), ('Bar de cocktails'), ('Tasca');

INSERT INTO spot (nome, descricao, morada, latitude, longitude, nivel_preco, hora_abertura, hora_fecho, codigo_qr, id_zona, id_tipo) VALUES
  ('Terraço Lua Nova', 'Rooftop com vista para o Tejo e DJ ao fim de semana.', 'Rua Fictícia do Alecrim, 12', 38.708900, -9.143300, 3, '18:00', '02:00', '7c1e4b2a-0001-4a1b-9c00-000000000001', 2, 3),
  ('Copo Torto',       'Bar pequeno, imperiais baratas e música indie.',      'Travessa Inventada, 5',      38.712600, -9.145100, 1, '20:00', '02:00', '7c1e4b2a-0002-4a1b-9c00-000000000002', 1, 1),
  ('Cave 404',         'Discoteca de música eletrónica numa cave antiga.',   'Rua dos Bytes, 404',         38.706800, -9.144900, 2, '23:30', '06:00', '7c1e4b2a-0003-4a1b-9c00-000000000003', 2, 2),
  ('Alquimia',         'Bar de cocktails de autor.',                          'Praça Imaginária, 3',        38.716000, -9.148200, 4, '19:00', '02:00', '7c1e4b2a-0004-4a1b-9c00-000000000004', 3, 4),
  ('Tasca do Zé Noite','Petiscos e ginjinha até tarde.',                      'Rua da Madrugada, 21',       38.721800, -9.135400, 1, '19:00', '01:00', '7c1e4b2a-0005-4a1b-9c00-000000000005', 5, 5);

-- hash bcrypt de 'Spotted2026!' (cost 10) — gerado com o servidor: npm run hash -- Spotted2026!
INSERT INTO utilizador (nome, email, password_hash, data_nascimento, peso_kg, sexo, aceitou_rgpd_em) VALUES
  ('Inês Martins',  'ines@exemplo.pt',   '$2b$10$2otjpP3T8JIKjUjtttg.JOM3EGifTusd.VQKMvawWuXCVXqd2C5ge', '2004-03-14', 58.0, 'F', '2026-09-20 20:00:00'),
  ('Lukas Becker',  'lukas@exemplo.pt',  '$2b$10$2otjpP3T8JIKjUjtttg.JOM3EGifTusd.VQKMvawWuXCVXqd2C5ge', '2002-07-02', 80.0, 'M', '2026-09-20 20:05:00'),
  ('Ricardo Sousa', 'ricardo@exemplo.pt','$2b$10$2otjpP3T8JIKjUjtttg.JOM3EGifTusd.VQKMvawWuXCVXqd2C5ge', '1998-11-20', 75.0, 'M', '2026-09-20 20:10:00');

INSERT INTO bebida (nome, categoria, volume_ml, teor_alcool) VALUES
  ('Imperial',          'Cerveja',    200,  5.0),
  ('Caneca',            'Cerveja',    500,  5.0),
  ('Copo de vinho',     'Vinho',      150, 13.0),
  ('Mojito',            'Cocktail',   250, 10.0),
  ('Gin tónico',        'Cocktail',   300,  9.0),
  ('Caipirinha',        'Cocktail',   200, 15.0),
  ('Shot de tequila',   'Shot',        40, 38.0),
  ('Ginjinha',          'Shot',        50, 20.0),
  ('Água',              'Sem alcool', 330,  0.0);

INSERT INTO bebida_spot (id_spot, id_bebida, nome_na_carta, preco_eur) VALUES
  (1, 4, 'Mojito da Casa', 9.00), (1, 5, 'Gin Lua Nova', 10.00),
  (2, 1, NULL, 1.50), (2, 2, NULL, 3.50),
  (3, 7, NULL, 3.00), (3, 5, NULL, 8.00),
  (4, 4, 'Mojito Alquímico', 12.00), (4, 6, 'Caipirinha de Maracujá', 11.00),
  (5, 8, 'Ginjinha com elas', 1.50), (5, 3, 'Tinto da casa', 2.50);

INSERT INTO checkin (id_utilizador, id_spot, metodo, feito_em) VALUES
  (1, 1, 'QR',  '2026-09-26 22:10:00'),
  (2, 1, 'GPS', '2026-09-26 22:40:00'),
  (3, 2, 'QR',  '2026-09-26 23:05:00'),
  (1, 3, 'QR',  '2026-09-27 01:15:00');

INSERT INTO avaliacao_spot (id_checkin, ambiente, musica, preco, servico, comentario) VALUES
  (1, 5, 4, 3, 5, 'Vista incrível, cocktails caros mas bons.'),
  (2, 4, 4, 3, 4, 'Muito cheio depois das 23h.'),
  (3, 4, 5, 5, 3, 'Imperiais a 1,50 € e boa música.');

INSERT INTO avaliacao_bebida (id_checkin, id_bebida_spot, nota, comentario) VALUES
  (1, 1, 5, 'Melhor mojito da zona.'),
  (2, 1, 4, NULL);

INSERT INTO noite (id_utilizador, iniciada_em, terminada_em) VALUES
  (3, '2026-09-26 22:30:00', '2026-09-27 03:00:00');

INSERT INTO consumo (id_noite, id_bebida, id_spot, consumido_em) VALUES
  (1, 2, 2, '2026-09-26 23:10:00'),
  (1, 2, 2, '2026-09-26 23:50:00'),
  (1, 9, 2, '2026-09-27 00:20:00'),
  (1, 7, 2, '2026-09-27 00:45:00');
