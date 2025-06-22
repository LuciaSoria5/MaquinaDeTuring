-- Crear tabla temporal con casos de prueba
DROP TABLE IF EXISTS pruebas_temp;
CREATE TEMP TABLE pruebas_temp (
    expresion TEXT,
    acepta BOOLEAN
);

-- Casos de prueba
INSERT INTO pruebas_temp (expresion, acepta) VALUES

-- Expresiones válidas
('a?b:c', TRUE),
('a>b?c:d', TRUE),
('a<b?b>c?a:c:d', TRUE),
('a!b?c<d?a:b:c', TRUE),
('a?b?c:d:a', TRUE),

-- Expresiones inválidas
('a?b', FALSE),                -- falta el :
('a:b?c:d', FALSE),            -- no empieza con condición válida
('a?b:c:d', FALSE),            -- dos : seguidos sin ternario válido
('a?b?c:d', FALSE),            -- falta el segundo :
('a>', FALSE),                 -- operador incompleto
('a?b:', FALSE),               -- falta valor falso
('a?b:c?d', FALSE);            -- falta valor falso para el segundo ternario

-- Testing
CALL test_maquina_turing();

DROP TABLE IF EXISTS pruebas_temp;

