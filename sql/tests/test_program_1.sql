SELECT '------------- Ejecutando Tests de Programa 1: w = a(a**r) -------------' AS test_info;

SELECT '--- Ejecutando Test 1: Cadena "110011" ---' AS test_1;
SELECT simuladorMT('110011');
SELECT * FROM obtenerMovimientos();
SELECT 'Resultado final del Test 1 - String aceptado: ' || string_aceptado FROM traza_ejecucion ORDER BY id_movimiento DESC LIMIT 1;
SELECT * FROM obtenerDIs();

SELECT '--- Ejecutando Test 2: Cadena "1100001" ---' AS test_2;
SELECT simuladorMT('1100001');
SELECT * FROM obtenerMovimientos();
SELECT 'Resultado final del Test 2 - String aceptado: ' || string_aceptado FROM traza_ejecucion ORDER BY id_movimiento DESC LIMIT 1;
SELECT * FROM obtenerDIs();
