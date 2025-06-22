SELECT simuladorMT('(a)');

SELECT estado_actual FROM traza_ejecucion WHERE id_movimiento = (SELECT MAX(id_movimiento) FROM traza_ejecucion);

SELECT * FROM traza_ejecucion;

SELECT obtenerDIs();

