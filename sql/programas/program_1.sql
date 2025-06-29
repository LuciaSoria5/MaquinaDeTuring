-- Strings de la forma w = a(a^)r)

-- Estados:
-- q0: captura el primer valor. Si el mismo es 0, invoca al estado q4. Si es 1, invoca al estado q5.
-- q1: captura el segundo valor. Si es 0, invoca a q3.
-- q2: captura el segundo valor. Si es 1, invoca a q3.
-- q3: regresa al principio del string.
-- q4: avanza hasta al final. Luego invoca a q1.
-- q5: avanza hasta al final. Luego invoca a q2.
-- qT: rechaza
-- qF: acepta

DELETE FROM programa;

INSERT INTO programa VALUES
('q0', '0', 'q4', 'X', 'R'),
('q0', '1', 'q5', 'X', 'R'),
('q0', 'X', 'q0', 'X', 'R'),
('q0', 'B', 'qF', 'B', 'R'),

('q1', '0', 'q3', 'X', 'L'),
('q1', '1', 'qT', '1', 'R'),
('q1', 'X', 'qT', 'X', 'R'),
('q1', 'B', 'qT', 'B', 'R'),

('q2', '0', 'qT', 'X', 'R'),
('q2', '1', 'q3', 'X', 'L'),
('q2', 'X', 'qT', 'X', 'R'),
('q2', 'B', 'qT', 'B', 'R'),

('q3', '0', 'q3', '0', 'L'),
('q3', '1', 'q3', '1', 'L'),
('q3', 'X', 'q0', 'X', 'R'),
('q3', 'B', 'q0', 'B', 'R'),

('q4', '0', 'q4', '0', 'R'),
('q4', '1', 'q4', '1', 'R'),
('q4', 'X', 'q1', 'X', 'L'),
('q4', 'B', 'q1', 'B', 'L'),

('q5', '0', 'q5', '0', 'R'),
('q5', '1', 'q5', '1', 'R'),
('q5', 'X', 'q2', 'X', 'L'),
('q5', 'B', 'q2', 'B', 'L'),

('qT', '0', 'qT', '0', 'R'),
('qT', '1', 'qT', '1', 'R'),
('qT', 'X', 'qT', 'X', 'R'),
('qT', 'B', 'qT', 'B', 'R'),

('qF', '0', '', '', ''),
('qF', '1', '', '', ''),
('qF', 'X', '', '', ''),
('qF', 'B', '', '', '');

DELETE FROM alfabeto;
INSERT INTO alfabeto VALUES
('0'),
('1'),
('X');