CREATE OR REPLACE FUNCTION simuladorMT(input_string TEXT)
RETURNS VOID AS $$
DECLARE
    estado_actual VARCHAR(50);
    cinta TEXT;
    posicion_cabezal INTEGER;
    cinta TEXT[];
    cinta_length INTEGER;
    caracter_leido CHAR(1);
    transicion RECORD;
    contador_pasos INTEGER := 0;
    esta_detenida BOOLEAN := FALSE;
    blanco CHAR(1) := 'B';

BEGIN
    TRUNCATE TABLE traza_ejecucion;

    -- Vemos si el string es válido
    IF EXISTS (
        SELECT 1 FROM regexp_split_to_table(input_string, '') AS c
        WHERE NOT EXISTS (SELECT 1 FROM alfabeto WHERE caracter = c) AND c != blanco
    ) THEN
        INSERT INTO traza_ejecucion (paso, estado_actual, cinta_antes, posicion_cabezal, caracter_leido, caracter_escrito, desplazamiento_realizado, cinta_despues, es_estado_final, string_aceptado)
        VALUES (0, 'ERROR', input_string, 0, '', '', '', '', TRUE, FALSE);
        RETURN;
    END IF;

    -- Inicialización de la cinta
    -- Añadimos un Blanco al principio y varios al final
    cinta := blanco || input_string || RPAD('', 100, blanco);
    posicion_cabezal := 1;
    estado_actual := 'q0';

    LOOP
        contador_pasos := contador_pasos + 1;
        cinta := regexp_split_to_array(cinta, '');
        cinta_length := array_length(cinta, 1);

        -- Ajuste de la cinta
        IF posicion_cabezal < 1 THEN
            cinta := blanco || cinta;
            posicion_cabezal := 1;
        END IF;

        IF posicion_cabezal > cinta_length THEN
            cinta := cinta || blanco;
            cinta_length := cinta_length + 1;
        END IF;

        caracter_leido := cinta[posicion_cabezal];

        -- Buscar la transición en la tabla 'programa' 
        SELECT estado_nue, caracter_nue, desplazamiento
        INTO transicion
        FROM programa
        WHERE estado_ori = estado_actual AND caracter_ori = caracter_leido;

        --  Detectar cuando la máquina se apaga
        IF transicion.estado_nue IS NULL THEN
            esta_detenida := TRUE;
            INSERT INTO traza_ejecucion (paso, estado_actual, cinta_antes, posicion_cabezal, caracter_leido, caracter_escrito, desplazamiento_realizado, cinta_despues, es_estado_final, string_aceptado)
            VALUES (contador_pasos, estado_actual, cinta, posicion_cabezal, caracter_leido, '', '', cinta, FALSE, FALSE);
            EXIT;
        END IF;

        -- Grabar el movimiento antes de ejecutarlo 
        INSERT INTO traza_ejecucion (paso, estado_actual, cinta_antes, posicion_cabezal, caracter_leido, caracter_escrito, desplazamiento_realizado, cinta_despues, es_estado_final, string_aceptado)
        VALUES (contador_pasos, estado_actual, cinta, posicion_cabezal, caracter_leido, transicion.caracter_nue, transicion.desplazamiento, '', FALSE, TRUE); -- cinta_despues se actualiza después

        -- Ejecutar la transición
        cinta[posicion_cabezal] := transicion.caracter_nue;
        cinta := array_to_string(cinta, '');
        estado_actual := transition.estado_nue;

        IF transition.desplazamiento = 'R' THEN
            posicion_cabezal := posicion_cabezal + 1;
        ELSIF transition.desplazamiento = 'L' THEN
            posicion_cabezal := posicion_cabezal - 1;
        END IF;

        -- Actualizar cinta_despues
        UPDATE traza_ejecucion
        SET cinta_despues = cinta
        WHERE id_movimiento = (SELECT MAX(id_movimiento) FROM traza_ejecucion);

        -- Condición de parada
        IF contador_pasos > 1000 THEN
            esta_detenida := TRUE;
            INSERT INTO traza_ejecucion (paso, estado_actual, cinta_antes, posicion_cabezal, caracter_leido, caracter_escrito, desplazamiento_realizado, cinta_despues, es_estado_final, string_aceptado)
            VALUES (contador_pasos, estado_actual, cinta, posicion_cabezal, caracter_leido, transition.caracter_nue, transition.desplazamiento, cinta, FALSE, FALSE);
            EXIT;
        END IF;

    END LOOP;

    IF esta_detenida AND estado_actual = 'qF' THEN
        UPDATE traza_ejecucion
        SET es_estado_final = TRUE, string_aceptado = TRUE
        WHERE id_movimiento = (SELECT MAX(id_movimiento) FROM traza_ejecucion);
    ELSIF esta_detenida AND estado_actual = 'qT' THEN
        UPDATE traza_ejecucion
        SET es_estado_final = FALSE, string_aceptado = FALSE
        WHERE id_movimiento = (SELECT MAX(id_movimiento) FROM traza_ejecucion);
    END IF;

END;
$$ LANGUAGE plpgsql;

-- TODO - Función para obtener descripciones instantáneas 