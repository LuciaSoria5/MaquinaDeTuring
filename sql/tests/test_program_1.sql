-- debe ser uno por programa

SELECT '------------- Ejecutando Tests de Programa 1: w = a(a**r) -------------' AS test_info;

SELECT '--- Ejecutando Test 1: Cadena "110011" ---' AS test_1;
SELECT simuladorMT('110011');

SELECT estado_actual, cinta_antes, posicion_cabezal, caracter_leido, caracter_escrito, desplazamiento_realizado, es_estado_final, string_aceptado
FROM traza_ejecucion
ORDER BY id_movimiento;

SELECT 'Resultado final del Test 1 - String aceptado: ' || string_aceptado FROM traza_ejecucion ORDER BY id_movimiento DESC LIMIT 1;
SELECT * FROM obtenerDIs() AS resultado_1;

SELECT '--- Ejecutando Test 2: Cadena "11001" ---';
SELECT simuladorMT('11001');

SELECT estado_actual, cinta_antes, posicion_cabezal, caracter_leido, caracter_escrito, desplazamiento_realizado, es_estado_final, string_aceptado
FROM traza_ejecucion
ORDER BY id_movimiento;

SELECT 'Resultado final del Test 2 - String aceptado: ' || string_aceptado FROM traza_ejecucion ORDER BY id_movimiento DESC LIMIT 1;
SELECT * FROM obtenerDIs();
