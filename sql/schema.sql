DROP TABLE IF EXISTS traza_ejecucion;
DROP TABLE IF EXISTS programa;
DROP TABLE IF EXISTS alfabeto;

CREATE TABLE alfabeto (
    caracter CHAR(1) PRIMARY KEY
);

CREATE TABLE programa (
    estado_ori VARCHAR(50) NOT NULL,
    caracter_ori CHAR(1) NOT NULL,
    estado_nue VARCHAR(50) NOT NULL,
    caracter_nue CHAR(1) NOT NULL,
    desplazamiento CHAR(1) NOT NULL CHECK (desplazamiento IN ('L', 'R')),
    PRIMARY KEY (estado_ori, caracter_ori)
);

CREATE TABLE traza_ejecucion (
    id_movimiento SERIAL PRIMARY KEY,
    paso INTEGER NOT NULL,
    estado_actual VARCHAR(50) NOT NULL,
    cinta_antes TEXT NOT NULL,
    posicion_cabezal INTEGER NOT NULL,
    caracter_leido CHAR(1) NOT NULL,
    caracter_escrito CHAR(1) NOT NULL,
    desplazamiento_realizado CHAR(1) NOT NULL,
    cinta_despues TEXT NOT NULL,
    es_estado_final BOOLEAN DEFAULT FALSE,
    mensaje VARCHAR(255)
);