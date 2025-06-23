SELECT '------------- Ejecutando Tests de Programa 1: w = a(a**r) -------------' AS test_info;

SELECT '--- Ejecutando Test 1: Cadena "" ---' AS test_1;
SELECT simuladorMT('1110#1110#');
SELECT * FROM obtenerMovimientos();
SELECT 'Resultado final del Test 1 - String aceptado: ' || string_aceptado FROM traza_ejecucion ORDER BY id_movimiento DESC LIMIT 1;
SELECT * FROM obtenerDIs();

-- Anda con:
-- 10+10, 100+100, 100+101, 101+100, 101+111, 111+111, 

