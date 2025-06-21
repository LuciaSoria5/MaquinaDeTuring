CREATE OR REPLACE FUNCTION simuladorMT(programa TEXT) RETURNS VOID AS $$
DECLARE
    cinta TEXT;
    estado_actual TEXT;
    caracter_actual CHAR(1);
    caracter_nuevo CHAR(1);
    posicion_cabezal INTEGER := 1;
    movimiento RECORD;
BEGIN

    cinta := programa || '$';
    caracter_actual := SUBSTRING(cinta FROM 1 FOR 1);
    estado_actual := 'q0';
    posicion_cabezal := 1;

    WHILE estado_actual != 'qf' LOOP
        SELECT * INTO movimiento FROM programa WHERE estado_ori = estado_actual AND caracter_ori = caracter_actual;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'No se encontró una transición para el estado % y caracter %', estado_actual, caracter_actual;
        END IF;

        caracter_nuevo := movimiento.caracter_nue;

        cinta := OVERLAY(cinta PLACING caracter_nuevo FROM posicion_cabezal FOR 1);

        IF movimiento.desplazamiento = 'L' THEN
            posicion_cabezal := posicion_cabezal - 1;
        ELSE IF movimiento.desplazamiento = 'R' THEN
            posicion_cabezal := posicion_cabezal + 1;
        ELSE
            RAISE EXCEPTION 'Desplazamiento inválido: %', movimiento.desplazamiento;
        END IF;

    END LOOP;

END;
$$ LANGUAGE plpgsql;