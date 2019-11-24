--@Autor:           Ana Laura Reynoso Gálvez
--@Fecha creación:  18/11/2019
--@Descripción:     Creación de objetos


--TABLE:USUARIO

connect barg_proy_admin

CREATE TABLE USUARIO(
  USUARIO_ID            NUMBER(18,0)    NOT NULL,
  NOMBRE                VARCHAR2(20)    NOT NULL,
  APELLIDO_PATERNO      VARCHAR2(20)    NOT NULL,
  APELLIDO_MATERNO      VARCHAR2(20),
  FECHA_NACIMINETO      DATE,           NOT NULL,
  CORREO                VARCHAR2(20)    NOT NULL,
  CLAVE_ACCESO          VARCHAR2(20)    NOT NULL,
  ES_CONDUCTOR          NUMBER(1,0)     NOT NULL,
  ES_ADMIN              NUMBER(1,0)     NOT NULL,
  ES_CLIENTE            NUMBER(1,0)     NOT NULL,
  USUARIO_EXISTENTE_ID  NUMBER(18,0),
  EDAD                  AS    (EXTRACT(YEAR FROM(SYSDATE - FECHA_NACIMIENTO))),   -- ATRIBUTO DERIVADO 
  CONSTRAINT USUARIO_PK PRIMARY KEY (USUARIO_ID),                                 -- Y COLUMNA VIRTUAL
  CONSTRAINT USU_USUARIO_EXISTENTE_ID_FK FOREIGN KEY (USUARIO_EXISTENTE_ID)
  REFERENCES USUARIO(USUARIO_ID),
  CONSTRAINT ES_CONDUCTOR_CHK CHECK (ES_CONDUCTOR IN (1,0)),
  CONSTRAINT ES_ADMIN_CHK CHECK (ES_ADMIN IN (1,0)),                              
  CONSTRAINT ES_CLIENTE_CHK CHECK (ES_CLIENTE IN (1,0)),
  CONSTRAINT ES_ADMIN_ES_CONDUCTOR_CHK CHECK 
  (NOT(ES_ADMIN = 1 AND ES_CONDUCTOR=1))
);

--TABLE: CLIENTE

CREATE TABLE CLIENTE(
  FECHA_REGISTRO    DATE            NOT NULL,
  NUMERO_CELULAR    VARCHAR2(10)    NOT NULL,
  USUARIO_ID        NUMBER(18,0)    NOT NULL,
  CONSTRAINT USUARIO_PK PRIMARY KEY (USUARIO_ID),
  CONSTRAINT USU_USUARIO_ID_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID)
);

--TABLE: ADMINISTRADOR

CREATE TABLE ADMINISTRADOR(
  CODIGO                NUMBER(18,0)    NOT NULL,
  CERTIFICADO_DIGITAL   BLOB(100)       NOT NULL,
  USUARIO_ID            NUMBER(18,0)    NOT NULL,
  CONSTRAINT USUARIO_PK PRIMARY KEY (USUARIO_ID),
  CONSTRAINT USU_USUARIO_ID_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID)
);

--TABLE: CONDUCTOR

CREATE TABLE CONDUCTOR(
  NUMERO_LICENCIA   NUMBER(30,0)    NOT NULL,
  NUMERO_CEDULA     VARCHAR2(18)    NOT NULL,
  FOTO              BLOB(40)        NOT NULL,
  DESCRIPCION       VARCHAR2(3000)  NOT NULL,
  USUARIO_ID        NUMBER(18,0)    NOT NULL,
  CONSTRAINT CONDUCTOR_PK PRIMARY KEY (USUARIO_ID),
  CONSTRAINT USU_USUARIO_ID_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID)  
);

--TABLE: MARCA

CREATE TABLE MARCA(
  MARCA_ID      NUMBER(15,0)    NOT NULL,
  NOMBRE_MARCA  VARCHAR2(15)    NOT NULL,
  CATEGORIA     NUMBER(1,0)     NOT NULL,
  DESCRIPCION   VARCHAR2(300)   NOR NULL,
  CONSTRAINT MARCA_PK PRIMARY KEY (MARCA_ID)
);

--TABLE: MODELO

CREATE TABLE MODELO(
  MODELO_ID         NUMBER(15,0)    NOT NULL,
  NOMBRE_MODELO     VARCHAR2(20)    NOT NULL,
  DESCRIPCION       VARCHAR2(300)   NOT NULL,
  MARCA_ID          NUMBER(15,0)    NOT NULL,
  CONSTRAINT MODELO_PK PRIMARY KEY (MODELO_ID),
  CONSTRAINT MARCA_MARCA_ID_FK FOREIGN KEY (MARCA_ID)
  REFERENCES MARCA(MARCA_ID)
);

--TABLE: AUTO

CREATE TABLE AUTO(
  AUTO_ID       NUMBER(20,0)    NOT NULL,
  AÑO_AUTO      DATE            NOT NULL,
  NUMERO_PLACAS VARCHAR2(10)    NOT NULL,
  USUARIO_ID    NUMBER(18,0)    NOT NULL,
  MODELO_ID     NUMBER(15,0)    NOT NULL, 
  CONSTRAINT AUTO_PK PRIMARY KEY (AUTO_ID),
  CONSTRAINT USU_USUARIO_ID_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID),
  CONSTRAINT MOD_MODELO_ID_FK FOREIGN KEY (MODELO_ID)
  REFERENCES MODELO(MODELO_ID)
);

--TABLE: UBICACION

CREATE TABLE UBICACION(
  UBICACION_ID      NUMBER(40,0)    NOT NULL,
  LATITUD           VARCHAR2(20)    NOT NULL,
  LONGITUD          VARCHAR2(20)    NOT NULL,
  FECHA_Y_HORA      DATE            NOT NULL,
  DISPONIBLE        NUMBER(1,0)     NOT NULL,
  AUTO_ID           NUMBER(20,0)    NOT NULL,
  CONSTRAINT UBICACION_PK PRIMARY KEY (UBUCACION_ID),
  CONSTRAINT AUTO_AUTO_ID_FK FOREIGN KEY (AUTO_ID)
  REFERENCES AUTO(AUTO_ID),
  CONSTRAINT DISPONIBLE_CHK CHECK (DISPONIBLE IN (1,0))
);

--TABLE: PAGO

CREATE TABLE PAGO(
  FOLIO_PAGO    NUMBER(8,0)     NOT NULL,
  MONTO_TOTAL   NUMBER(10,2)    NOT NULL,
  FECHA_DE_PAGO DATE            NOT NULL,
  USUARIO_ID    NUMBER(18,0)    NOT NULL,
  CONSTRAINT PAGO_PK PRIMARY KEY (FOLIO_PAGO),
  CONSTRAINT USU_USUARIO_ID_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID)
);

--TABLE: TARJETA

CREATE TABLE TARJETA(
  TARJETA_ID        NUMBER(20,0)    NOT NULL,
  AÑO_EXPIRACION    DATE            NOT NULL,
  MES_EXPIRACION    DATE            NOT NULL,
  USUARIO_ID        DATE            NOT NULL,  
  CONSTRAINT TARJETA_PK PRIMARY KEY (TARJETA_ID), 
  CONSTRAINT USU_USUARIO_ID_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID)
);
  
--TABLE: FACTURA

CREATE TABLE FACTURA(
  FACTURA_ID    NUMBER(20,0)    NOT NULL,
  FECHA_FACTURA DATE            NOT NULL,
  IMPORTE_TOTAL NUMBER(20,2)    NOT NULL,
  ARCHIVO_SAT   XML             NOT NULL,
  USUARIO_ID    NUMBER(18,0)    NOT NULL,
  CONSTRAINT FACTURA_PK PRIMARY KEY (FACTURA_ID),
  CONSTRAINT USU_USUARIO_ID_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES USUARIO(USUARIO_ID)
);

--TABLE: STATUS

CREATE TABLE STATUS(
  STATUS_ID NUMBER(5,0)    NOT NULL,
  CLAVE       VARCHAR2(11)  NOT NULL,
  DESCRIPCION VARCHAR2(300) NOT NULL,
  CONSTRAINT STATUS_PK PRIMARY KEY (STATUS_ID)
);

--TABLE: VIAJE

CREATE TABLE VIAJE(
  VIAJE_ID          NUMBER(40,0)    NOT NULL,
  FECHA             DATE            DEFAULT SYSDATE,
  HORA_INICIO       DATE,
  HORA_FIN      DATE,
  LATITUD_ORIGEN    VARCHAR2(40)    NOT NULL,
  IMPORTE           NUMBER(10,2),
  LONGITUD_ORIGEN   VARCHAR2(40)    NOT NULL,
  LATITUD_DESTINO   VARCHAR2(40)    NOT NULL,
  LONGITUD_DESTINO  VARCHAR2(40)    NOT NULL,
  CALIFICACION      NUMBER(1,0),
  PROPINA           NUMBER(10,2),
  COMENTARIOS       VARCHAR2(300),
  FECHA_STATUS      DATE            NOT NULL,
  STATUS_ID         VARCHAR2(5)     NOT NULL,
  USUARIO_ID        NUMBER(18,0)    NOT NULL,
  FACTURA_ID        NUMBER(20,0),
  AUTO_ID           NUMBER(20,0)    NOT NULL,
  CONSTRAINT VIAJE_PK PRIMARY KEY 
  (VIAJE_ID),
  CONSTRAINT  STATUS_STATUS_ID_FK FOREIGN KEY (STATUS_ID)
  REFERENCES  STATUS( STATUS_ID),
  CONSTRAINT  USUARIO_ USUARIO_ID_FK FOREIGN KEY (USUARIO_ID)
  REFERENCES  USUARIO(USUARIO_ID),
  CONSTRAINT  FACTURA_ FACTURA_ID_FK FOREIGN KEY (FACTURA_ID)
  REFERENCES  FACTURA(FACTURA_ID),
  CONSTRAINT  AUTO_AUTO_ID_FK FOREIGN KEY (AUTO_ID)
  REFERENCES  AUTO(AUTO_ID)
);

--TABLE: HISTORICO_VIAJE_STATUS

CREATE TABLE HISTORICO_VIAJE_STATUS(
  HISTORICO_VIAJE_STATUS_ID NUMBER(40,0) NOT NULL,
  FECHA_STATUS              DATE         NOT NULL,
  CLAVE_STATUS              NUMERIC(5,0) NOT NULL,
  VIAJE_ID                  NUMBER(40,0) NOT NULL,
  AUTO_ID                   NUMBER(40,0) NOT NULL,
  CONSTRAINT HISTORICO_VIAJE_STATUS_PK PRIMARY KEY 
  (HISTORICO_VIAJE_STATUS_ID),
  CONSTRAINT VIAJE_VIAJE_ID_FK FOREIGN KEY (VIAJE_ID)
  REFERENCES VIAJE(VIAJE_ID),
  CONSTRAINT AUTO_AUTO_ID_FK FOREIGN KEY (AUTO_ID)
  REFERENCES AUTO(AUTO_ID)
);


  
  
  
  
  
  
  
