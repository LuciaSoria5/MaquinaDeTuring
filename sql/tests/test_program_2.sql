DROP TABLE IF EXISTS pruebas_temp;
CREATE TEMP TABLE pruebas_temp (
    expresion TEXT,
    acepta BOOLEAN
);

-- Casos de pruebas
INSERT INTO pruebas_temp VALUES

-- Expresiones válidas
('a', true),
('a+b', true),
('a+b*c', true),
('(a)', true),
('(a+b)', true),
('(a)+(b)', true),
('((a))', true),
('(a+b)*(c-d)', true),
('a+b+(c)', true),
('a+(b*(c))', true),
('((a+b)*c)^d', true),

-- Expresiones inválidas
('+a', false),      -- empieza con +
('a+', false),      -- le falta una variable al final
('a b', false),     -- le falta el operador
('a++b', false),    -- doble operador
('(a', false),      -- falta parentesis de cierre
('a)', false),      -- falta parentesis de apertura
('((a+b)', false),  -- falta parentesis de cierre
('a+(b', false),    -- falta parentesis de cierre
('a+(b+c))', false),    -- falta parentesis de apertura
('a+(+b)', false),  -- falta un operando
('(a)+(b)+(c', false), -- falta parentesis de cierre
('a+(b)(c)', false), -- falta un operando
('a(b)', false),    -- falta un operando
('a+(b+c)(d)', false);  -- falta un operando

-- Testing
CALL testMT();

DROP TABLE IF EXISTS pruebas_temp;
