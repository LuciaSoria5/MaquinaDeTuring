-- expresiones ternarias basicas con 4 variables: a, b, c, d; y operadores: >, <, =, !
-- q0: busca una variable
-- q1: busca un operador o un ?. si lo encuentra, lo marca con X
-- q2: busca el else (:) y lo marca con Y
-- q3: retrocede al operador marcado con X
-- qT: rechaza
-- qF: acepta

DELETE FROM programa;

INSERT INTO programa (estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento) VALUES

-- q0: busca variable para condición
('q0', 'a', 'q1', 'a', 'R'),
('q0', 'b', 'q1', 'b', 'R'),
('q0', 'c', 'q1', 'c', 'R'),
('q0', 'd', 'q1', 'd', 'R'),

-- rechazos desde q0 (no puede venir ?, :, operadores o blanco)
('q0', '?', 'qT', '?', 'R'),
('q0', ':', 'qT', ':', 'R'),
('q0', '=', 'qT', '=', 'R'),
('q0', '!', 'qT', '!', 'R'),
('q0', '<', 'qT', '<', 'R'),
('q0', '>', 'qT', '>', 'R'),
('q0', 'B', 'qT', 'B', 'R'),

-- q1: procesa operadores o fin
('q1', '=', 'q0', '=', 'R'),
('q1', '!', 'q0', '!', 'R'),
('q1', '<', 'q0', '<', 'R'),
('q1', '>', 'q0', '>', 'R'),

-- acepta si fin
('q1', 'B', 'qF', 'B', 'R'),

-- marca ? con X y busca :
('q1', '?', 'q2', 'X', 'R'),

-- permite seguir con variables o marcas X, Y para expresiones anidadas
('q1', 'X', 'q0', 'X', 'R'),
('q1', 'Y', 'q0', 'Y', 'R'),

('q1', ':', 'qT', ':', 'R'),    -- no puede haber :, ya deberia estar marcado

-- q2: busca :
('q2', 'a', 'q2', 'a', 'R'),
('q2', 'b', 'q2', 'b', 'R'),
('q2', 'c', 'q2', 'c', 'R'),
('q2', 'd', 'q2', 'd', 'R'),

('q2', '=', 'q2', '=', 'R'),
('q2', '!', 'q2', '!', 'R'),
('q2', '<', 'q2', '<', 'R'),
('q2', '>', 'q2', '>', 'R'),

('q2', '?', 'q2', '?', 'R'), -- permite anidación dentro

('q2', 'X', 'q2', 'X', 'R'), -- ignora lo que fue procesado
('q2', 'Y', 'q2', 'Y', 'R'),

-- si llega fin sin : rechaza
('q2', 'B', 'qT', 'B', 'R'),

-- si encuentra :, los marca con Y y retrocede
('q2', ':', 'q3', 'Y', 'L'),

-- q3: retrocede hasta ? marcado con X
('q3', 'a', 'q3', 'a', 'L'),
('q3', 'b', 'q3', 'b', 'L'),
('q3', 'c', 'q3', 'c', 'L'),
('q3', 'd', 'q3', 'd', 'L'),

('q3', '=', 'q3', '=', 'L'),
('q3', '!', 'q3', '!', 'L'),
('q3', '<', 'q3', '<', 'L'),
('q3', '>', 'q3', '>', 'L'),

('q3', '?', 'q3', '?', 'L'),
('q3', ':', 'q3', ':', 'L'),
('q3', 'Y', 'q3', 'Y', 'L'),

('q3', 'X', 'q0', 'X', 'R'),    -- reanuda la evaluación de la expresión

-- aceptación
('qF', 'B', '', '', 'R'),
('qF', 'a', '', '', 'R'),
('qF', 'b', '', '', 'R'),
('qF', 'c', '', '', 'R'),
('qF', 'd', '', '', 'R'),
('qF', '=', '', '', 'R'),
('qF', '!', '', '', 'R'),
('qF', '<', '', '', 'R'),
('qF', '>', '', '', 'R'),
('qF', '?', '', '', 'R'),
('qF', ':', '', '', 'R'),
('qF', 'X', '', '', 'R'),
('qF', 'Y', '', '', 'R'),

-- rechazo
('qT', 'B', '', '', 'R'),
('qT', 'a', '', '', 'R'),
('qT', 'b', '', '', 'R'),
('qT', 'c', '', '', 'R'),
('qT', 'd', '', '', 'R'),
('qT', '=', '', '', 'R'),
('qT', '!', '', '', 'R'),
('qT', '<', '', '', 'R'),
('qT', '>', '', '', 'R'),
('qT', '?', '', '', 'R'),
('qT', ':', '', '', 'R'),
('qT', 'X', '', '', 'R'),
('qT', 'Y', '', '', 'R');

DELETE FROM alfabeto;

INSERT INTO alfabeto (caracter) VALUES
('a'), ('b'), ('c'), ('d'),
('='), ('!'), ('<'), ('>'),
('?'), (':'),
('X'),  -- marca '?'
('Y');  -- marca ':'
