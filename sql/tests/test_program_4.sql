DROP TABLE IF EXISTS pruebas_temp;
CREATE TEMP TABLE pruebas_temp (
    expresion TEXT,
    suma TEXT
);

-- Casos de pruebas
INSERT INTO pruebas_temp VALUES

('1#0#', '0001'),
('1#1#', '0010'),
('01#10#', '000011'),
('10#10#', '000100'),
('11#11#', '000110'),
('100#100#', '00001000'),
('100#101#', '00001001'),
('101#100#', '00001001'),
('101#111#', '00001100'),
('111#111#', '00001110');

-- Testing
CALL testMTB();

DROP TABLE IF EXISTS pruebas_temp;
