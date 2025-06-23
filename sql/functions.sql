CREATE OR REPLACE FUNCTION simuladorMT(input_string TEXT)
RETURNS VOID AS $$
DECLARE
    estado_actual VARCHAR(50);
    posicion_cabezal INTEGER;
    cinta TEXT[];
    cinta_length INTEGER;
    caracter_leido CHAR(1);
    transicion RECORD;
    esta_detenida BOOLEAN := FALSE;
    es_estado_final BOOLEAN := FALSE;
    string_aceptado BOOLEAN := FALSE;
    blanco CHAR(1) := 'B';

BEGIN
    TRUNCATE TABLE traza_ejecucion;

    IF EXISTS (
        SELECT 1 FROM regexp_split_to_table(input_string, '') AS c
        WHERE NOT EXISTS (SELECT 1 FROM alfabeto WHERE caracter = c) AND c != blanco
    ) THEN
        INSERT INTO traza_ejecucion (estado_actual, cinta_antes, posicion_cabezal, caracter_leido, caracter_escrito, desplazamiento_realizado, es_estado_final, string_aceptado)
        VALUES ('ERROR', input_string, 0, '', '', '', TRUE, FALSE);
        RETURN;
    END IF;


    cinta := regexp_split_to_array(input_string || blanco, '');
    posicion_cabezal := 1;
    estado_actual := 'q0';

    WHILE NOT esta_detenida LOOP
        cinta_length := array_length(cinta, 1);

        IF posicion_cabezal < 1 THEN
            cinta := array_prepend(blanco, cinta);
            posicion_cabezal := 1;
            cinta_length := cinta_length + 1;
        END IF;

        IF posicion_cabezal > cinta_length THEN
            cinta := array_append(cinta, blanco);
            cinta_length := cinta_length + 1;
        END IF;

        caracter_leido := cinta[posicion_cabezal];

        SELECT estado_nue, caracter_nue, desplazamiento
        INTO transicion
        FROM programa
        WHERE estado_ori = estado_actual AND caracter_ori = caracter_leido;

        esta_detenida := transicion.estado_nue IS NULL;

        es_estado_final := NOT esta_detenida;

        IF estado_actual = 'qF' THEN
            es_estado_final := TRUE;
            string_aceptado := TRUE;
        ELSIF estado_actual = 'qT' THEN
            es_estado_final := FALSE;
            string_aceptado := FALSE;
        END IF;

        INSERT INTO traza_ejecucion
        VALUES (DEFAULT, estado_actual, array_to_string(cinta, ''), posicion_cabezal, caracter_leido, transicion.caracter_nue, transicion.desplazamiento, es_estado_final, string_aceptado);
        
        IF estado_actual = 'qF' OR estado_actual = 'qT' THEN
            EXIT;
        END IF;

        cinta[posicion_cabezal] := transicion.caracter_nue;
        estado_actual := transicion.estado_nue;

        IF transicion.desplazamiento = 'R' THEN
            posicion_cabezal := posicion_cabezal + 1;
        ELSIF transicion.desplazamiento = 'L' THEN
            posicion_cabezal := posicion_cabezal - 1;
        END IF;
        
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtenerDIs() RETURNS TABLE(di TEXT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        left(cinta_antes, posicion_cabezal - 1) || '{' || estado_actual || '}' || substring(cinta_antes from posicion_cabezal)
    FROM traza_ejecucion;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtenerMovimientos()
RETURNS TABLE(
    estado_actual VARCHAR,
    cinta_antes TEXT,
    posicion_cabezal INT,
    caracter_leido CHAR,
    caracter_escrito CHAR,
    desplazamiento_realizado CHAR,
    es_estado_final BOOLEAN,
    string_aceptado BOOLEAN
)
AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.estado_actual,
        t.cinta_antes,
        t.posicion_cabezal,
        t.caracter_leido,
        t.caracter_escrito,
        t.desplazamiento_realizado,
        t.es_estado_final,
        t.string_aceptado
    FROM
        traza_ejecucion t
    ORDER BY
        t.id_movimiento;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE test_maquina_turing() AS $$
DECLARE
    expr TEXT;
    esperado BOOLEAN;
    resultado RECORD;
    di RECORD;
BEGIN
    FOR expr, esperado IN SELECT expresion, acepta FROM pruebas_temp LOOP
        RAISE NOTICE '------------------------';
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

        RAISE NOTICE 'Movimientos:';
        FOR di IN SELECT * FROM obtenerDIs() LOOP
            RAISE NOTICE 'DI: %', di.di;
        END LOOP;

    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE test_suma_binarios() AS $$
DECLARE
    expr TEXT;
    esperado BOOLEAN;
    resultado RECORD;
    di RECORD;
BEGIN
    FOR expr, esperado IN SELECT expresion, acepta FROM pruebas_temp LOOP
        RAISE NOTICE '------------------------';
        RAISE NOTICE 'Resolviendo suma: % (resultado esperado: %)', expr, esperado;

        PERFORM simuladorMT(expr);

        SELECT string_aceptado INTO resultado
        FROM traza_ejecucion
        WHERE id_movimiento = (SELECT MAX(id_movimiento) FROM traza_ejecucion);

        RAISE NOTICE 'Resultado: aceptado = %,  esperado = %',
            resultado.string_aceptado, esperado;

        IF resultado.string_aceptado <> esperado THEN
            RAISE EXCEPTION 'Error: Resultado inesperado para suma "%". Esperado: % pero obtenido %',
                    expr, esperado, resultado.string_aceptado;
        END IF;

        RAISE NOTICE 'Movimientos:';
        FOR di IN SELECT * FROM obtenerDIs() LOOP
            RAISE NOTICE 'DI: %', di.di;
        END LOOP;

    END LOOP;
END;
$$ LANGUAGE plpgsql;