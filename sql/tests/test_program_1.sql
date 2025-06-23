DROP TABLE IF EXISTS pruebas_temp;
CREATE TEMP TABLE pruebas_temp (
    expresion TEXT,
    acepta BOOLEAN
);

-- Casos de pruebas
INSERT INTO pruebas_temp VALUES

-- Expresiones válidas
('110011', true),
('00', true),
('010010', true),
('011110', true),

-- Expresiones inválidas
('100', false),
('010', false),
('01101', false);
('01011', false);

-- Testing
CALL testMT();

DROP TABLE IF EXISTS pruebas_temp;
