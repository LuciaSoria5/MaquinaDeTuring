-- Expresiones matematicas basicas con 4 variables: a, b, c, d; parentesis: (, ); y operadores: +, -, *, /, ^

-- Estados:
-- q0: busca una variable o un (. si es (, lo marca con X
-- q1: busca un operador o el fin de la expresion
-- q2: busca el parentesis de cierre y lo marco con Y
-- q3: retrocede al parentesis marcado con X
-- qT: rechaza
-- qF: acepta

-- no permito dos variables seguidas, ni dos simbolos matematicos seguidos, ni un simbolo matematico al principio o al final
-- no permito dos parentesis seguidos
-- no permito un parentesis de cierre sin uno de apertura
-- no permito un parentesis de apertura sin uno de cierre

-- E → V | (E) | E O E
-- V → 'a' | 'b' | 'c' | 'd'
-- O → '+' | '-' | '*' | '/' | '^'

DELETE FROM programa;

INSERT INTO programa VALUES

-- q0: espera variable o (
('q0', 'a', 'q1', 'a', 'R'),
('q0', 'b', 'q1', 'b', 'R'),
('q0', 'c', 'q1', 'c', 'R'),
('q0', 'd', 'q1', 'd', 'R'),
('q0', '(', 'q2', 'X', 'R'),

-- caracteres inválidos al inicio
('q0', ')', 'qT', ')', 'R'),
('q0', 'Y', 'qT', 'Y', 'R'),
('q0', '+', 'qT', '+', 'R'),
('q0', '-', 'qT', '-', 'R'),
('q0', '*', 'qT', '*', 'R'),
('q0', '/', 'qT', '/', 'R'),
('q0', '^', 'qT', '^', 'R'),
('q0', 'B', 'qT', 'B', 'R'),

-- permitir paréntesis cerrados procesados
('q0', 'X', 'q0', 'X', 'R'),

-- q1: espera operador o fin de expresion
('q1', '+', 'q0', '+', 'R'),
('q1', '-', 'q0', '-', 'R'),
('q1', '*', 'q0', '*', 'R'),
('q1', '/', 'q0', '/', 'R'),
('q1', '^', 'q0', '^', 'R'),

-- permite parentesis procesados
('q1', 'X', 'qT', 'X', 'R'),    -- no puede haber aX porque es a( y no es valido
('q1', 'Y', 'q1', 'Y', 'R'),
('q1', ')', 'qT', ')', 'R'),

-- fin de expresion
('q1', 'B', 'qF', 'B', 'R'),

-- si viene otra variable o un parentesis de apertura, rechazo
('q1', 'a', 'qT', 'a', 'R'),
('q1', 'b', 'qT', 'b', 'R'),
('q1', 'c', 'qT', 'c', 'R'),
('q1', 'd', 'qT', 'd', 'R'),
('q1', '(', 'qT', '(', 'R'),

-- q2: busca el paréntesis de cierre
('q2', 'a', 'q2', 'a', 'R'),
('q2', 'b', 'q2', 'b', 'R'),
('q2', 'c', 'q2', 'c', 'R'),
('q2', 'd', 'q2', 'd', 'R'),
('q2', '+', 'q2', '+', 'R'),
('q2', '-', 'q2', '-', 'R'),
('q2', '*', 'q2', '*', 'R'),
('q2', '/', 'q2', '/', 'R'),
('q2', '^', 'q2', '^', 'R'),
('q2', '(', 'q2', '(', 'R'),
('q2', 'X', 'q2', 'X', 'R'),
('q2', 'Y', 'q2', 'Y', 'R'),
('q2', ')', 'q3', 'Y', 'L'),

-- si llego al final sin cerrar, error
('q2', 'B', 'qT', 'B', 'R'),

-- q3: retrocede hasta el (
('q3', 'a', 'q3', 'a', 'L'),
('q3', 'b', 'q3', 'b', 'L'),
('q3', 'c', 'q3', 'c', 'L'),
('q3', 'd', 'q3', 'd', 'L'),
('q3', '+', 'q3', '+', 'L'),
('q3', '-', 'q3', '-', 'L'),
('q3', '*', 'q3', '*', 'L'),
('q3', '/', 'q3', '/', 'L'),
('q3', '^', 'q3', '^', 'L'),
('q3', ')', 'q3', ')', 'L'),
('q3', '(', 'q3', '(', 'L'),
('q3', 'Y', 'q3', 'Y', 'L'),
('q3', 'X', 'q0', 'X', 'R'),  -- al volver al paréntesis de apertura, reanuda

-- aceptación
('qF', 'a', '', '', 'R'),
('qF', 'b', '', '', 'R'),
('qF', 'c', '', '', 'R'),
('qF', 'd', '', '', 'R'),
('qF', '(', '', '', 'R'),
('qF', ')', '', '', 'R'),
('qF', '+', '', '', 'R'),
('qF', '-', '', '', 'R'),
('qF', '*', '', '', 'R'),
('qF', '/', '', '', 'R'),
('qF', '^', '', '', 'R'),
('qF', 'B', '', '', 'R'),

-- rechazo
('qT', 'a', '', '', 'R'),
('qT', 'b', '', '', 'R'),
('qT', 'c', '', '', 'R'),
('qT', 'd', '', '', 'R'),
('qT', '(', '', '', 'R'),
('qT', ')', '', '', 'R'),
('qT', '+', '', '', 'R'),
('qT', '-', '', '', 'R'),
('qT', '*', '', '', 'R'),
('qT', '/', '', '', 'R'),
('qT', '^', '', '', 'R'),
('qT', 'B', '', '', 'R');

DELETE FROM alfabeto;
INSERT INTO alfabeto VALUES
('a'), ('b'), ('c'), ('d'),
('('), (')'), ('+'), ('-'),
('*'), ('/'), ('^');
