CREATE DATABASE IF NOT EXISTS aula13;
USE aula13;

CREATE TABLE IF NOT EXISTS textos (
    id    INT AUTO_INCREMENT PRIMARY KEY,
    texto TEXT NOT NULL
);

INSERT INTO textos (texto) VALUES ('Primeiro texto salvo no banco.');
INSERT INTO textos (texto) VALUES ('Trump admite que guerra contribuiu para a derrota.');
