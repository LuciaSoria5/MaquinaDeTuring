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
    blanco CHAR(1) := 'B';

BEGIN
    TRUNCATE TABLE traza_ejecucion;

    IF EXISTS (
        SELECT 1 FROM regexp_split_to_table(input_string, '') AS c
        WHERE NOT EXISTS (SELECT 1 FROM alfabeto WHERE caracter = c) AND c != blanco
    ) THEN
        INSERT INTO traza_ejecucion (estado_actual, cinta_antes, posicion_cabezal, caracter_leido, caracter_escrito, desplazamiento_realizado, cinta_despues, es_estado_final, string_aceptado)
        VALUES ('ERROR', input_string, 0, '', '', '', '', TRUE, FALSE);
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

        -- Buscar la transición en la tabla 'programa' 
        SELECT estado_nue, caracter_nue, desplazamiento
        INTO transicion
        FROM programa
        WHERE estado_ori = estado_actual AND caracter_ori = caracter_leido;

        --  Detectar cuando la máquina se apaga
        esta_detenida := transicion.estado_nue IS NULL;

        -- Grabar el movimiento antes de ejecutarlo 
        INSERT INTO traza_ejecucion
        VALUES (DEFAULT, estado_actual, array_to_string(cinta, ''), posicion_cabezal, caracter_leido, transicion.caracter_nue, transicion.desplazamiento, '', FALSE, NOT esta_detenida); -- cinta_despues se actualiza después

        IF esta_detenida THEN
            UPDATE traza_ejecucion
            SET cinta_despues = array_to_string(cinta, '')
            WHERE id_movimiento = (SELECT MAX(id_movimiento) FROM traza_ejecucion);
            EXIT;
        END IF;

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

        UPDATE traza_ejecucion
        SET cinta_despues = array_to_string(cinta, '')
        WHERE id_movimiento = (SELECT MAX(id_movimiento) FROM traza_ejecucion);

    END LOOP;

    IF estado_actual = 'qF' THEN
        UPDATE traza_ejecucion
        SET es_estado_final = TRUE, string_aceptado = TRUE
        WHERE id_movimiento = (SELECT MAX(id_movimiento) FROM traza_ejecucion);
    ELSIF estado_actual = 'qT' THEN
        UPDATE traza_ejecucion
        SET es_estado_final = FALSE, string_aceptado = FALSE
        WHERE id_movimiento = (SELECT MAX(id_movimiento) FROM traza_ejecucion);
    END IF;

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