-- ww^r
-- q0: marca el inicio del string
-- q1: se mueve, ignorando X e Y y marca el primer 0 con X o el primer 1 con Y
-- q2: busca el 0 correspondiente a la X
-- q3: busca el 1 correspondiente a la Y
-- q4: checkea que haya 0
-- q5: checkea que haya 1
-- q6: vuelve al inicio
-- qF: finaliza
-- qT: finaliza sin aceptar
-- B: espacio en blanco

DELETE FROM programa;

INSERT INTO programa (estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento) VALUES
('q0', 'B', 'q1', 'I', 'R'),
('q1', '0', 'q2', 'X', 'R'),
('q1', '1', 'q3', 'Y', 'R'),
('q1', 'B', 'qF', 'B', 'R'),

('q2', '0', 'q2', '0', 'R'),
('q2', '1', 'q2', '1', 'R'),
('q2', 'X', 'q4', 'X', 'L'),
('q2', 'Y', 'q4', 'Y', 'L'),
('q2', 'B', 'q4', 'B', 'L'),

('q4', '0', 'q6', 'X', 'L'),
('q4', '1', 'qT', '1', 'R'),

('q3', '0', 'q3', '0', 'R'),
('q3', '1', 'q3', '1', 'R'),
('q3', 'X', 'q5', 'X', 'L'),
('q3', 'Y', 'q5', 'Y', 'L'),
('q3', 'B', 'q5', 'B', 'L'),

('q5', '0', 'qT', '0', 'L'),
('q4', '1', 'q6', 'Y', 'R'),

('q6', '0', 'q6', '0', 'L'),
('q6', '1', 'q6', '1', 'L'),
('q6', 'X', 'q6', 'X', 'L'),
('q6', 'Y', 'q6', 'Y', 'L'),
('q6', 'I', 'q1', 'I', 'R');

DELETE FROM alfabeto;
INSERT INTO alfabeto (caracter) VALUES
('0'),
('1'),
('X'),
('I');