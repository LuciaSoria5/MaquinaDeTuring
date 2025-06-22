ROLLBACK;

DROP TABLE IF EXISTS pruebas_temp;
CREATE TEMP TABLE pruebas_temp (
    expresion TEXT,
    acepta BOOLEAN
);

-- Tabla de pruebas
INSERT INTO pruebas_temp (expresion, acepta) VALUES

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
('+a', false),
('a+', false),
('a b', false),
('a++b', false),
('(a', false),
('a)', false),
('((a+b)', false),
('a+(b', false),
('a+(b+c))', false),
('a+(+b)', false),
('(a)+(b)+(c', false),
('a+(b)(c)', false),
('a(b)', false),
('a+(b+c)(d)', false);

-- Testing
DO $$
DECLARE
    expr TEXT;
    esperado BOOLEAN;
    resultado RECORD;
BEGIN
    FOR expr, esperado IN SELECT expresion, acepta FROM pruebas_temp LOOP
        RAISE NOTICE 'Probando expresión: % (esperado: %)', expr, esperado;

        PERFORM simuladorMT(expr);

        SELECT string_aceptado INTO resultado
        FROM traza_ejecucion
        WHERE id_movimiento = (SELECT MAX(id_movimiento) FROM traza_ejecucion);

        RAISE NOTICE 'Resultado: aceptado = %,  esperado = %',
            resultado.string_aceptado, esperado;

        IF resultado.string_aceptado <> esperado THEN
            RAISE EXCEPTION 'Error: Resultado inesperado para expresión "%". Esperado: % pero obtenido %',
                    expr, esperado, resultado.string_aceptado;
        END IF;

    END LOOP;
END $$;

DROP TABLE IF EXISTS pruebas_temp;
