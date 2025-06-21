CREATE OR REPLACE FUNCTION simuladorMT(programa TEXT) RETURNS VOID AS $$
DECLARE
    cinta_antes TEXT;
    cinta_despues TEXT;
    estado_actual TEXT;
    caracter_actual CHAR(1);
    caracter_nuevo CHAR(1);
    posicion_cabezal INTEGER := 1;
    movimiento RECORD;
BEGIN

    cinta_antes := programa || '$';
    caracter_actual := SUBSTRING(cinta_antes FROM 1 FOR 1);
    estado_actual := 'q0';
    posicion_cabezal := 1;

    WHILE estado_actual != 'qf' LOOP
        SELECT * INTO movimiento FROM programa WHERE estado_ori = estado_actual AND caracter_ori = caracter_actual;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró una transición para el estado % y caracter %', estado_actual, caracter_actual;
        END IF;

        caracter_nuevo := movimiento.caracter_nue;

        IF movimiento.desplazamiento = 'L' THEN
            posicion_cabezal := posicion_cabezal - 1;
        ELSE IF movimiento.desplazamiento = 'R' THEN
            posicion_cabezal := posicion_cabezal + 1;
        ELSE
            RAISE EXCEPTION 'Desplazamiento inválido: %', movimiento.desplazamiento;
        END IF;

        INSERT INTO traza_ejecucion (estado, caracter, cinta, posicion, desplazamiento)
        VALUES (estado_actual, caracter_actual, cinta, posicion_cabezal, movimiento.desplazamiento);

        cinta_despues := OVERLAY(cinta_antes PLACING caracter_nuevo FROM posicion_cabezal FOR 1);

        INSERT INTO traza_ejecucion (paso, estado_actual, cinta_antes, posicion_cabezal, caracter_leido, caracter_escrito, desplazamiento_realizado, cinta_despues, es_estado_final, string_actual, maquina_encendida)
        VALUES (
            1,  -- no se que va
            estado_actual,
            cinta_antes,
            posicion_cabezal,
            caracter_actual,
            caracter_nuevo,
            movimiento.desplazamiento,
            cinta_despues,
            (estado_actual = 'qf'),
            cinta_antes,
            '' -- no se que va
        );

        caracter_actual := SUBSTRING(cinta FROM posicion_cabezal FOR 1);
        cinta_antes := cinta_despues;
        estado_actual := movimiento.estado_nue;

    END LOOP;

END;
$$ LANGUAGE plpgsql;