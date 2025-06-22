DROP DATABASE IF EXISTS maquina_turing;

CREATE DATABASE maquina_turing;

\c maquina_turing

CREATE TABLE alfabeto (
    caracter CHAR(1) PRIMARY KEY
);

CREATE TABLE programa (
    estado_ori VARCHAR(50) NOT NULL,
    caracter_ori CHAR(1) NOT NULL,
    estado_nue VARCHAR(50),
    caracter_nue CHAR(1),
    desplazamiento CHAR(1) CHECK (desplazamiento IN ('L', 'R', '')),
    PRIMARY KEY (estado_ori, caracter_ori)
);

CREATE TABLE traza_ejecucion (
    id_movimiento SERIAL PRIMARY KEY,
    estado_actual VARCHAR(50) NOT NULL,
    cinta_antes TEXT NOT NULL,
    posicion_cabezal INTEGER NOT NULL,
    caracter_leido CHAR(1) NOT NULL,
    caracter_escrito CHAR(1) NOT NULL,
    desplazamiento_realizado CHAR(1) NOT NULL,
    cinta_despues TEXT NOT NULL,    -- creo que esto no es necesario, porque va a estar en cinta_antes en el siguiente movimiento
    es_estado_final BOOLEAN DEFAULT FALSE,
    string_aceptado BOOLEAN DEFAULT FALSE
);