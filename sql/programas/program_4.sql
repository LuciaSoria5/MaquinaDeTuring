-- Suma dos valores binarios.
-- Restricciones: 
--  * Los valores deben tener la misma cantidad de dígitos.
--  * Cada valor debe terminar con el dígito '#'
-- Ejemlplo: 10#10#

-- Estados:
-- q0: inicia el proceso de la máquina.
-- [q0, acarreo] y [q1, acarreo]: buscan el sumando 1.
-- [q2, acarreo, sumando1, sumando2], [q3, acarreo, sumando1, sumando2], [q3.5, acarreo, sumando1, sumando2]: buscan el sumando 2.
-- [q4, acarreo, sumando1, sumando2]: escribe el resultado de la suma.
-- [q5, acarreo]: regresa al inicio del string
-- [q6, acarreo], [q7, acarreo]: escriben el acarreo luego de sumar todos los dígitos.
-- q8, q9: completan el resultado escribiendo 0s sobre los #s residuales.
-- qT: rechaza
-- qF: acepta

DELETE FROM programa;

INSERT INTO programa (estado_ori, caracter_ori, estado_nue, caracter_nue, desplazamiento) VALUES

-- Para coincidir con lo que necesita el simulador:
('q0', '0', '[q0,0]', '0', ''),
('q0', '1', '[q0,0]', '1', ''),
('q0', '#', '[q0,0]', '#', ''),
('q0', 'B', '[q0,0]', 'B', ''),

-- Busco sumando 1 avanzando hasta un # (q0)
('[q0,0]', '0', '[q0,0]', '0', 'R'),
('[q0,0]', '1', '[q0,0]', '1', 'R'),
('[q0,0]', '#', '[q1,0]', '#', 'L'),
('[q0,0]', 'B', '[q6,0]', 'B', 'R'),

('[q0,1]', '0', '[q0,1]', '0', 'R'),
('[q0,1]', '1', '[q0,1]', '1', 'R'),
('[q0,1]', '#', '[q1,1]', '#', 'L'),
('[q0,1]', 'B', '[q6,1]', 'B', 'R'),

-- Obtengo sumando 1 (q1)
('[q1,0]', '0', '[q2,0,0]', '#', 'R'),
('[q1,0]', '1', '[q2,0,1]', '#', 'R'),
('[q1,0]', '#', '[q6,0]', '#', 'R'),
('[q1,0]', 'B', '[q6,0]', 'B', 'R'),

('[q1,1]', '0', '[q2,1,0]', '#', 'R'),
('[q1,1]', '1', '[q2,1,1]', '#', 'R'),
('[q1,1]', '#', '[q6,1]', '#', 'R'),
('[q1,1]', 'B', '[q6,1]', 'B', 'R'),

-- Busco sumando 2 avanzando hasta el blanco (q2)
('[q2,0,0]', '0', '[q2,0,0]', '0', 'R'),
('[q2,0,0]', '1', '[q2,0,0]', '1', 'R'),
('[q2,0,0]', '#', '[q2,0,0]', '#', 'R'),
('[q2,0,0]', 'B', '[q3,0,0]', 'B', 'L'),

('[q2,0,1]', '0', '[q2,0,1]', '0', 'R'),
('[q2,0,1]', '1', '[q2,0,1]', '1', 'R'),
('[q2,0,1]', '#', '[q2,0,1]', '#', 'R'),
('[q2,0,1]', 'B', '[q3,0,1]', 'B', 'L'),

('[q2,1,0]', '0', '[q2,1,0]', '0', 'R'),
('[q2,1,0]', '1', '[q2,1,0]', '1', 'R'),
('[q2,1,0]', '#', '[q2,1,0]', '#', 'R'),
('[q2,1,0]', 'B', '[q3,1,0]', 'B', 'L'),

('[q2,1,1]', '0', '[q2,1,1]', '0', 'R'),
('[q2,1,1]', '1', '[q2,1,1]', '1', 'R'),
('[q2,1,1]', '#', '[q2,1,1]', '#', 'R'),
('[q2,1,1]', 'B', '[q3,1,1]', 'B', 'L'),

-- Busco sumando 2 retrocediendo. Si despues del B hay un numero, hay que seguir retrocediento hasta llegar al # (q3)
('[q3,0,0]', '0', '[q3,0,0]', '0', 'L'),
('[q3,0,0]', '1', '[q3,0,0]', '1', 'L'),
('[q3,0,0]', '#', '[q3.5,0,0]', '#', 'L'),
('[q3,0,0]', 'B', '[q3,0,0]', 'B', 'L'),

('[q3,0,1]', '0', '[q3,0,1]', '0', 'L'),
('[q3,0,1]', '1', '[q3,0,1]', '1', 'L'),
('[q3,0,1]', '#', '[q3.5,0,1]', '#', 'L'),
('[q3,0,1]', 'B', '[q3,0,1]', 'B', 'L'),

('[q3,1,0]', '0', '[q3,1,0]', '0', 'L'),
('[q3,1,0]', '1', '[q3,1,0]', '1', 'L'),
('[q3,1,0]', '#', '[q3.5,1,0]', '#', 'L'),
('[q3,1,0]', 'B', '[q3,1,0]', 'B', 'L'),

('[q3,1,1]', '0', '[q3,1,1]', '0', 'L'),
('[q3,1,1]', '1', '[q3,1,1]', '1', 'L'),
('[q3,1,1]', '#', '[q3.5,1,1]', '#', 'L'),
('[q3,1,1]', 'B', '[q3,1,1]', 'B', 'L'),

-- Obtengo sumando 2 (q3.3)
('[q3.5,0,0]', '0', '[q4,0,0,0]', '#', 'R'),
('[q3.5,0,0]', '1', '[q4,0,0,1]', '#', 'R'),
('[q3.5,0,0]', '#', '[q3.5,0,0]', '#', 'L'),
('[q3.5,0,0]', 'B', 'qT', 'B', 'L'),

('[q3.5,0,1]', '0', '[q4,0,1,0]', '#', 'R'),
('[q3.5,0,1]', '1', '[q4,0,1,1]', '#', 'R'),
('[q3.5,0,1]', '#', '[q3.5,0,1]', '#', 'L'),
('[q3.5,0,1]', 'B', 'qT', 'B', 'L'),

('[q3.5,1,0]', '0', '[q4,1,0,0]', '#', 'R'),
('[q3.5,1,0]', '1', '[q4,1,0,1]', '#', 'R'),
('[q3.5,1,0]', '#', '[q3.5,1,0]', '#', 'L'),
('[q3.5,1,0]', 'B', 'qT', 'B', 'L'),

('[q3.5,1,1]', '0', '[q4,1,1,0]', '#', 'R'),
('[q3.5,1,1]', '1', '[q4,1,1,1]', '#', 'R'),
('[q3.5,1,1]', '#', '[q3.5,1,1]', '#', 'L'),
('[q3.5,1,1]', 'B', 'qT', 'B', 'L'),

-- Avanzo y escribo el resultado de la suma (q4)
('[q4,0,0,0]', '0', '[q4,0,0,0]', '0', 'R'),
('[q4,0,0,0]', '1', '[q4,0,0,0]', '1', 'R'),
('[q4,0,0,0]', '#', '[q5,0]', '0', 'L'),
('[q4,0,0,0]', 'B', '[q5,0]', '0', 'L'),

('[q4,0,0,1]', '0', '[q4,0,0,1]', '0', 'R'),
('[q4,0,0,1]', '1', '[q4,0,0,1]', '1', 'R'),
('[q4,0,0,1]', '#', '[q5,0]', '1', 'L'),
('[q4,0,0,1]', 'B', '[q5,0]', '1', 'L'),

('[q4,0,1,0]', '0', '[q4,0,1,0]', '0', 'R'),
('[q4,0,1,0]', '1', '[q4,0,1,0]', '1', 'R'),
('[q4,0,1,0]', '#', '[q5,0]', '1', 'L'),
('[q4,0,1,0]', 'B', '[q5,0]', '1', 'L'),

('[q4,0,1,1]', '0', '[q4,0,1,1]', '0', 'R'),
('[q4,0,1,1]', '1', '[q4,0,1,1]', '1', 'R'),
('[q4,0,1,1]', '#', '[q5,1]', '0', 'L'),
('[q4,0,1,1]', 'B', '[q5,1]', '0', 'L'),

('[q4,1,0,0]', '0', '[q4,1,0,0]', '0', 'R'),
('[q4,1,0,0]', '1', '[q4,1,0,0]', '1', 'R'),
('[q4,1,0,0]', '#', '[q5,0]', '1', 'L'),
('[q4,1,0,0]', 'B', '[q5,0]', '1', 'L'),

('[q4,1,0,1]', '0', '[q4,1,0,1]', '0', 'R'),
('[q4,1,0,1]', '1', '[q4,1,0,1]', '1', 'R'),
('[q4,1,0,1]', '#', '[q5,1]', '0', 'L'),
('[q4,1,0,1]', 'B', '[q5,1]', '0', 'L'),

('[q4,1,1,0]', '0', '[q4,1,1,0]', '0', 'R'),
('[q4,1,1,0]', '1', '[q4,1,1,0]', '1', 'R'),
('[q4,1,1,0]', '#', '[q5,1]', '0', 'L'),
('[q4,1,1,0]', 'B', '[q5,1]', '0', 'L'),

('[q4,1,1,1]', '0', '[q4,1,1,1]', '0', 'R'),
('[q4,1,1,1]', '1', '[q4,1,1,1]', '1', 'R'),
('[q4,1,1,1]', '#', '[q5,1]', '1', 'L'),
('[q4,1,1,1]', 'B', '[q5,1]', '1', 'L'),

-- Vuelvo al inicio (q5)
('[q5,0]', '0', '[q5,0]', '0', 'L'),
('[q5,0]', '1', '[q5,0]', '1', 'L'),
('[q5,0]', '#', '[q5,0]', '#', 'L'),
('[q5,0]', 'B', '[q0,0]', 'B', 'R'),

('[q5,1]', '0', '[q5,1]', '0', 'L'),
('[q5,1]', '1', '[q5,1]', '1', 'L'),
('[q5,1]', '#', '[q5,1]', '#', 'L'),
('[q5,1]', 'B', '[q0,1]', 'B', 'R'),

-- Busco donde escribir el acarreo (q6) (Voy hasta el final de los #)
('[q6,0]', '0', '[q7,0]', '0', 'L'),
('[q6,0]', '1', '[q7,0]', '1', 'L'),
('[q6,0]', '#', '[q6,0]', '#', 'R'),
('[q6,0]', 'B', '[q7,0]', 'B', 'L'),

('[q6,1]', '0', '[q7,1]', '0', 'L'),
('[q6,1]', '1', '[q7,1]', '1', 'L'),
('[q6,1]', '#', '[q6,1]', '#', 'R'),
('[q6,1]', 'B', '[q7,1]', 'B', 'L'),

-- Escribo el acarreo (q7)
('[q7,0]', '0', 'qT', '0', 'R'),
('[q7,0]', '1', 'qT', '1', 'R'),
('[q7,0]', '#', 'q8', '0', 'R'),
('[q7,0]', 'B', 'q8', '0', 'R'),

('[q7,1]', '0', 'qT', '0', 'R'),
('[q7,1]', '1', 'qT', '1', 'R'),
('[q7,1]', '#', 'q8', '1', 'R'),
('[q7,1]', 'B', 'q8', '1', 'R'),

-- Completo el resultado: voy adelante de todo.
('q8', '0', 'q8', '0', 'L'),
('q8', '1', 'q8', '1', 'L'),
('q8', '#', 'q8', '#', 'L'),
('q8', 'B', 'q9', 'B', 'R'),

-- Completo el resultado con 0s
('q9', '0', 'qF', '0', 'L'),
('q9', '1', 'qF', '1', 'L'),
('q9', '#', 'q9', '0', 'R'),
('q9', 'B', 'q9', 'B', 'R'),

--  Finales
('qT', '0', 'qT', '#', 'R'),
('qT', '1', 'qT', '#', 'R'),
('qT', '#', 'qT', '#', 'R'),
('qT', 'B', 'qT', '#', 'R'),

('qF', '0', '', '', ''),
('qF', '1', '', '', ''),
('qF', '#', '', '', ''),
('qF', 'B', '', '', '');

DELETE FROM alfabeto;
INSERT INTO alfabeto (caracter) VALUES
('0'),
('1'),
('#');