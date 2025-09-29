BEGIN 
    EXECUTE IMMEDIATE 'DROP TABLE COMUNA CASCADE CONSTRAINTS'; 
EXCEPTION WHEN OTHERS THEN NULL; 
END;
/

BEGIN 
    EXECUTE IMMEDIATE 'DROP TABLE REGION CASCADE CONSTRAINTS'; 
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

BEGIN 
    EXECUTE IMMEDIATE 'DROP TABLE IDIOMA CASCADE CONSTRAINTS'; 
EXCEPTION WHEN OTHERS THEN NULL; 
END;
/

BEGIN 
    EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_COMUNA'; 
EXCEPTION WHEN OTHERS THEN NULL; 
END;
/
BEGIN 
EXECUTE IMMEDIATE 'DROP SEQUENCE SEQ_COMPANIA'; 
EXCEPTION WHEN OTHERS THEN NULL; 
END;
/



CREATE TABLE REGION(
    id_region       NUMBER GENERATED ALWAYS AS IDENTITY
                    (START WITH 7 INCREMENT BY 2),
    nombre          VARCHAR2(50)    NOT NULL,
CONSTRAINT  pk_region           PRIMARY KEY (id_region),
CONSTRAINT  uq_region_nombre    UNIQUE (nombre)
    );
    
    
    
    
CREATE TABLE COMUNA(
  id_comuna      NUMBER,
  nombre         VARCHAR2(50) NOT NULL,
  id_region      NUMBER NOT NULL,
  CONSTRAINT pk_comuna         PRIMARY KEY (id_comuna),
  CONSTRAINT uq_comuna_nombre  UNIQUE (nombre),
  CONSTRAINT fk_comuna_region  FOREIGN KEY (id_region) REFERENCES REGION(id_region)
);

CREATE SEQUENCE SEQ_COMUNA START WITH 1101 INCREMENT BY 1;




CREATE TABLE IDIOMA(
    id_idioma       NUMBER GENERATED ALWAYS AS IDENTITY
                    (START WITH 25 INCREMENT BY 3),
    nombre          VARCHAR2(50)    NOT NULL,
CONSTRAINT pk_idioma                PRIMARY KEY (id_idioma),
CONSTRAINT uq_idioma_nombre         UNIQUE (nombre)
);




CREATE TABLE ESTADO_CIVIL(
  id_estado         NUMBER GENERATED ALWAYS AS IDENTITY,
  nombre            VARCHAR2(30) NOT NULL,
  CONSTRAINT pk_estado_civil PRIMARY KEY (id_estado),
  CONSTRAINT uq_estado_civil UNIQUE (nombre)
);


CREATE TABLE GENERO(
    id_genero       NUMBER GENERATED ALWAYS AS IDENTITY,
    nombre          VARCHAR2(30)    NOT NULL,
CONSTRAINT pk_genero PRIMARY KEY (id_genero),
CONSTRAINT uq_genero UNIQUE (nombre)
);
    

CREATE TABLE TITULACION(
    id_titulacion   NUMBER GENERATED ALWAYS AS IDENTITY,
    nombre          VARCHAR2(60)    NOT NULL,
CONSTRAINT pk_titulacion PRIMARY KEY (id_titulacion),
CONSTRAINT uq_titulacion UNIQUE (nombre)
);    


CREATE TABLE TITULO(
    id_titulo       NUMBER GENERATED ALWAYS AS IDENTITY,
    nombre          VARCHAR2(60)    NOT NULL,
    id_titulacion   NUMBER          NOT NULL,
CONSTRAINT pk_titulo PRIMARY KEY (id_titulo),
CONSTRAINT uq_titulo UNIQUE (nombre),
CONSTRAINT fk_titulo_titulacion FOREIGN KEY (id_titulacion) REFERENCES TITULACION(id_titulacion)
);


CREATE TABLE DOMINIO(
    id_dominio      NUMBER GENERATED ALWAYS AS IDENTITY,
    nombre          VARCHAR2(60)    NOT NULL,
 CONSTRAINT pk_dominio PRIMARY KEY (id_dominio),
 CONSTRAINT uq_dominio UNIQUE (nombre)
);



CREATE TABLE COMPANIA(
    id_compania     NUMBER,
    nombre          VARCHAR2(100)   NOT NULL,
    direccion       VARCHAR2(120)   NOT NULL,
    id_comuna       NUMBER,
    renta_promedio  NUMBER(10,2)    NOT NULL,
    porcen_aumento    NUMBER(5,2)     NOT NULL,
CONSTRAINT pk_compania           PRIMARY KEY (id_compania),
CONSTRAINT uq_compania_nombre    UNIQUE (nombre),
CONSTRAINT fk_compania_comuna    FOREIGN KEY (id_comuna) REFERENCES COMUNA(id_comuna)
);


CREATE SEQUENCE SEQ_COMPANIA START WITH 1 INCREMENT BY 1;


CREATE TABLE PERSONAL(
  id_personal    NUMBER GENERATED ALWAYS AS IDENTITY,
  rut            VARCHAR2(12),
  dv             CHAR(1),
  nombres        VARCHAR2(60),
  apellidos      VARCHAR2(60),
  id_compania    NUMBER NOT NULL,
  id_genero      NUMBER,
  id_estado      NUMBER,
  id_idioma      NUMBER,
  id_titulo      NUMBER,
  id_dominio     NUMBER,
  CONSTRAINT pk_personal PRIMARY KEY (id_personal),
  CONSTRAINT fk_pers_compania FOREIGN KEY (id_compania) REFERENCES COMPANIA(id_compania),
  CONSTRAINT fk_pers_genero   FOREIGN KEY (id_genero)   REFERENCES GENERO(id_genero),
  CONSTRAINT fk_pers_estado   FOREIGN KEY (id_estado)   REFERENCES ESTADO_CIVIL(id_estado),
  CONSTRAINT fk_pers_idioma   FOREIGN KEY (id_idioma)   REFERENCES IDIOMA(id_idioma),
  CONSTRAINT fk_pers_titulo   FOREIGN KEY (id_titulo)   REFERENCES TITULO(id_titulo),
  CONSTRAINT fk_pers_dominio  FOREIGN KEY (id_dominio)  REFERENCES DOMINIO(id_dominio)
);


INSERT INTO REGION (nombre) VALUES ('Metropolitana');
INSERT INTO REGION (nombre) VALUES ('Valparaiso');
INSERT INTO REGION (nombre) VALUES ('Biobio');


INSERT INTO COMUNA (id_comuna, nombre, id_region)
VALUES (SEQ_COMUNA.NEXTVAL, 'Santiago Centro',
       (SELECT id_region FROM REGION WHERE nombre = 'Metropolitana'));

INSERT INTO COMUNA (id_comuna, nombre, id_region)
VALUES (SEQ_COMUNA.NEXTVAL, 'Providencia',
       (SELECT id_region FROM REGION WHERE nombre = 'Metropolitana'));

INSERT INTO COMUNA (id_comuna, nombre, id_region)
VALUES (SEQ_COMUNA.NEXTVAL, 'Valparaiso',
       (SELECT id_region FROM REGION WHERE nombre = 'Valparaiso'));

INSERT INTO COMUNA (id_comuna, nombre, id_region)
VALUES (SEQ_COMUNA.NEXTVAL, 'Concepcion',
       (SELECT id_region FROM REGION WHERE nombre = 'Biobio'));




INSERT INTO IDIOMA (nombre) VALUES ('Español');
INSERT INTO IDIOMA (nombre) VALUES ('Ingles');
INSERT INTO IDIOMA (nombre) VALUES ('Portugues');



INSERT INTO ESTADO_CIVIL (nombre) VALUES ('Soltero');
INSERT INTO ESTADO_CIVIL (nombre) VALUES ('Casado');
INSERT INTO ESTADO_CIVIL (nombre) VALUES ('Divorciado');




INSERT INTO GENERO (nombre) VALUES ('Femenino');
INSERT INTO GENERO (nombre) VALUES ('Masculino');
INSERT INTO GENERO (nombre) VALUES ('No binario');




INSERT INTO TITULACION (nombre) VALUES ('Administracion');
INSERT INTO TITULACION (nombre) VALUES ('Salud');
INSERT INTO TITULACION (nombre) VALUES ('Informatica');



INSERT INTO TITULO (nombre, id_titulacion)
VALUES ('Administracion de empresas',
       (SELECT id_titulacion FROM TITULACION WHERE nombre = 'Administracion'));


INSERT INTO TITULO (nombre, id_titulacion)
VALUES ('Enfermeria',
       (SELECT id_titulacion FROM TITULACION WHERE nombre = 'Salud'));


INSERT INTO TITULO (nombre, id_titulacion)
VALUES ('Analista programador',
       (SELECT id_titulacion FROM TITULACION WHERE nombre = 'Informatica'));




INSERT INTO DOMINIO (nombre) VALUES ('Office');
INSERT INTO DOMINIO (nombre) VALUES ('SAP');
INSERT INTO DOMINIO (nombre) VALUES ('SQL');


INSERT INTO COMPANIA (id_compania, nombre, direccion, id_comuna, renta_promedio, porcen_aumento)
VALUES (SEQ_COMPANIA.NEXTVAL, 'Clínica Central', 'Av. Salud 123',
       (SELECT id_comuna FROM COMUNA WHERE nombre = 'Santiago Centro'),
       1500000, 5.0);

INSERT INTO COMPANIA (id_compania, nombre, direccion, id_comuna, renta_promedio, porcen_aumento)
VALUES (SEQ_COMPANIA.NEXTVAL, 'TecnoSoft', 'Providencia 456',
       (SELECT id_comuna FROM COMUNA WHERE nombre = 'Providencia'),
       1800000, 7.5);

INSERT INTO COMPANIA (id_compania, nombre, direccion, id_comuna, renta_promedio, porcen_aumento)
VALUES (SEQ_COMPANIA.NEXTVAL, 'PuertoLog', 'Calle Puerto 10',
       (SELECT id_comuna FROM COMUNA WHERE nombre = 'Valparaiso'),
       1200000, 4.0);
       
INSERT INTO COMPANIA (id_compania, nombre, direccion, id_comuna, renta_promedio, porcen_aumento)
VALUES (SEQ_COMPANIA.NEXTVAL, 'TecnoLogical', 'Cerro Portezuelo 012',
       (SELECT id_comuna FROM COMUNA WHERE nombre = 'Colina'),
       2400000, 5.4);
       

INSERT INTO COMPANIA (id_compania, nombre, direccion, id_comuna, renta_promedio, porcen_aumento)
VALUES (SEQ_COMPANIA.NEXTVAL, 'SAludDent', 'Av Providencia 1556',
       (SELECT id_comuna FROM COMUNA WHERE nombre = 'Providencia'),
       500000, 8.4);

INSERT INTO COMPANIA (id_compania, nombre, direccion, id_comuna, renta_promedio, porcen_aumento)
VALUES (SEQ_COMPANIA.NEXTVAL, 'MediSAl', 'Av Santa Rosa 156',
       (SELECT id_comuna FROM COMUNA WHERE nombre = 'Santiago'),
       5000000, 3.4);
       
INSERT INTO COMPANIA (id_compania, nombre, direccion, id_comuna, renta_promedio, porcen_aumento)
VALUES (SEQ_COMPANIA.NEXTVAL, 'GraficDsg', 'Av las condes 562',
       (SELECT id_comuna FROM COMUNA WHERE nombre = 'Las Condes'),
       1500000, 7.4);       
       
COMMIT;



INSERT INTO PERSONAL
(rut, dv, nombres, apellidos, id_compania, id_genero, id_estado, id_idioma, id_titulo, id_dominio)
VALUES
('12345678', 'K', 'María', 'Pérez',
 (SELECT id_compania FROM COMPANIA WHERE nombre = 'Clínica Central'),
 (SELECT id_genero   FROM GENERO   WHERE nombre = 'Femenino'),
 (SELECT id_estado   FROM ESTADO_CIVIL WHERE nombre = 'Soltero'),
 (SELECT id_idioma   FROM IDIOMA   WHERE nombre = 'Español'),
 (SELECT id_titulo   FROM TITULO   WHERE nombre = 'Enfermeria'),
 (SELECT id_dominio  FROM DOMINIO  WHERE nombre = 'Office'));
 
 INSERT INTO PERSONAL
(rut, dv, nombres, apellidos, id_compania, id_genero, id_estado, id_idioma, id_titulo, id_dominio)
VALUES
('98765432', '9', 'Juan', 'Gómez',
 (SELECT id_compania FROM COMPANIA WHERE nombre = 'TecnoSoft'),
 (SELECT id_genero   FROM GENERO   WHERE nombre = 'Masculino'),
 (SELECT id_estado   FROM ESTADO_CIVIL WHERE nombre = 'Casado'),
 (SELECT id_idioma   FROM IDIOMA   WHERE nombre = 'Ingles'),
 (SELECT id_titulo   FROM TITULO   WHERE nombre = 'Administracion de empresas'),
 (SELECT id_dominio  FROM DOMINIO  WHERE nombre = 'SQL'));

INSERT INTO PERSONAL
(rut, dv, nombres, apellidos, id_compania, id_genero, id_estado, id_idioma, id_titulo, id_dominio)
VALUES
('11223344', '7', 'Alex', 'Rivas',
 (SELECT id_compania FROM COMPANIA WHERE nombre = 'PuertoLog'),
 (SELECT id_genero   FROM GENERO   WHERE nombre = 'No binario'),
 (SELECT id_estado   FROM ESTADO_CIVIL WHERE nombre = 'Divorciado'),
 (SELECT id_idioma   FROM IDIOMA   WHERE nombre = 'Portugues'),
 (SELECT id_titulo   FROM TITULO   WHERE nombre = 'Administracion de empresas'),
 (SELECT id_dominio  FROM DOMINIO  WHERE nombre = 'SAP'));

COMMIT;

CREATE SEQUENCE SEQ_COMUNA   START WITH 1101 INCREMENT BY 6; 
CREATE SEQUENCE SEQ_COMPANIA START WITH 10   INCREMENT BY 5;


---CASO 2---


ALTER TABLE PERSONAL ADD (email VARCHAR2(120));
ALTER TABLE PERSONAL ADD CONSTRAINT uq_personal_email UNIQUE (email);


ALTER TABLE PERSONAL
  ADD CONSTRAINT ck_personal_dv CHECK (dv IN ('0','1','2','3','4','5','6','7','8','9','K'));


ALTER TABLE PERSONAL ADD (sueldo NUMBER(10,2));
ALTER TABLE PERSONAL
  ADD CONSTRAINT ck_personal_sueldo_min CHECK (sueldo >= 450000);



----INFORME 1----




SELECT
  c.nombre AS "Nombre Empresa",
  c.direccion || ', ' || co.nombre || ', ' || r.nombre AS "Dirección Completa",
  c.renta_promedio AS "Renta Promedio",
  ROUND(c.renta_promedio * (1 + c.porcen_aumento/100), 0) AS "Renta Promedio Simulada"
FROM COMPANIA c
JOIN COMUNA  co ON co.id_comuna = c.id_comuna
JOIN REGION  r  ON r.id_region  = co.id_region
ORDER BY "Renta Promedio" DESC, "Nombre Empresa" ASC;




----INFORME 2----

SELECT
  c.id_compania AS "ID Empresa",
  c.nombre      AS "Nombre Empresa",
  c.renta_promedio AS "Renta Promedio Actual",
  (c.porcen_aumento + 15) AS "% Aumentado (Base+15%)",
  ROUND(c.renta_promedio * (1 + (c.porcen_aumento + 15)/100), 0) AS "Renta Promedio Incrementada"
FROM COMPANIA c
ORDER BY "Renta Promedio Actual" ASC, "Nombre Empresa" DESC;





















SELECT USER FROM DUAL;

CREATE TABLE zzz_prueba (id NUMBER);
DROP TABLE zzz_prueba PURGE;