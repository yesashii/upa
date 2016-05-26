DROP TABLE protic.DETALLE_BOLETAS 
DROP TABLE protic.BOLETAS
DROP TABLE protic.RANGOS_BOLETAS_CAJEROS
DROP TABLE protic.RANGOS_BOLETAS_SEDES 


CREATE TABLE protic.BOLETAS 
(
    BOLE_NCORR             numeric(10,0) NOT NULL,
    BOLE_NBOLETA           numeric(10,0) NULL,
    EBOL_CCOD              int           NULL,
    TBOL_CCOD              int           NULL,
    BOLE_MTOTAL            numeric(38,0) NULL,
    BOLE_FBOLETA           datetime      NULL,
    INGR_NFOLIO_REFERENCIA numeric(38,0) NULL,
    SEDE_CCOD              numeric(10,0) NULL,
    PERS_NCORR             numeric(38,0) NULL,
    PERS_NCORR_AVAL        numeric(38,0) NULL,
    MCAJ_NCORR             numeric(10,0) NULL,
    AUDI_TUSUARIO          varchar(150)  NULL,
    AUDI_FMODIFICACION     datetime      NULL,
    CONSTRAINT PK__BOLETAS__28B8D3FE
    PRIMARY KEY CLUSTERED (BOLE_NCORR) 
                                                                ON [PRIMARY]
)
go
IF OBJECT_ID('protic.BOLETAS') IS NOT NULL
    PRINT '<<< CREATED TABLE protic.BOLETAS >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE protic.BOLETAS >>>'
go


CREATE TABLE protic.DETALLE_BOLETAS 
(
    BOLE_NCORR         numeric(10,0) NOT NULL,
    TDET_CCOD          numeric(10,0) NOT NULL,
    DBOL_MIVA          numeric(10,0) NULL,
    DBOL_MTOTAL        numeric(10,0) NULL,
    AUDI_TUSUARIO      varchar(150)  NULL,
    AUDI_FMODIFICACION datetime      NULL,
    CONSTRAINT PK__DETALLE_BOLETAS__37FB178E
    PRIMARY KEY CLUSTERED (BOLE_NCORR,TDET_CCOD) 
                                                                        ON [PRIMARY]
)
go
IF OBJECT_ID('protic.DETALLE_BOLETAS') IS NOT NULL
    PRINT '<<< CREATED TABLE protic.DETALLE_BOLETAS >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE protic.DETALLE_BOLETAS >>>'
go


CREATE TABLE protic.RANGOS_BOLETAS_CAJEROS 
(
    RBCA_NCORR         numeric(10,0) NOT NULL,
    RBCA_NINICIO       numeric(10,0) NOT NULL,
    RBCA_NFIN          numeric(10,0) NOT NULL,
    RBCA_NACTUAL       numeric(10,0) NULL,
    SEDE_CCOD          numeric(10,0) NOT NULL,
    PERS_NCORR         numeric(10,0) NOT NULL,
    ERBO_CCOD          int           NOT NULL,
    TBOL_CCOD          numeric(10,0) NULL,
    AUDI_TUSUARIO      varchar(100)  NULL,
    AUDI_FMODIFICACION datetime      NULL,
    CONSTRAINT PK__RANGOS_BOLETAS_C__4CF63474
    PRIMARY KEY CLUSTERED (RBCA_NCORR) 
                                                                         ON [PRIMARY]
)
go
IF OBJECT_ID('protic.RANGOS_BOLETAS_CAJEROS') IS NOT NULL
    PRINT '<<< CREATED TABLE protic.RANGOS_BOLETAS_CAJEROS >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE protic.RANGOS_BOLETAS_CAJEROS >>>'
go


CREATE TABLE protic.RANGOS_BOLETAS_SEDES 
(
    RBOL_NCORR         numeric(10,0) NOT NULL,
    RBOL_NINICIO       numeric(10,0) NOT NULL,
    RBOL_NFIN          numeric(10,0) NOT NULL,
    RBOL_NACTUAL       numeric(10,0) NULL,
    SEDE_CCOD          numeric(10,0) NOT NULL,
    ERBO_CCOD          int           NOT NULL,
    TBOL_CCOD          numeric(10,0) NULL,
    AUDI_TUSUARIO      varchar(100)  NULL,
    AUDI_FMODIFICACION datetime      NULL,
    CONSTRAINT PK__RANGOS_BOLETAS_S__3059F5C6
    PRIMARY KEY CLUSTERED (RBOL_NCORR) 
                                                                         ON [PRIMARY]
)
go
IF OBJECT_ID('protic.RANGOS_BOLETAS_SEDES') IS NOT NULL
    PRINT '<<< CREATED TABLE protic.RANGOS_BOLETAS_SEDES >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE protic.RANGOS_BOLETAS_SEDES >>>'
go


CREATE TABLE protic.tipos_boletas 
(
    tbol_ccod          numeric(10,0) NOT NULL,
    tbol_tdesc         varchar(100)  NULL,
    audi_tusuario      varchar(100)  NULL,
    audi_fmodificacion datetime      NULL,
    CONSTRAINT PK__tipos_boletas__3706F355
    PRIMARY KEY CLUSTERED (tbol_ccod) 
                                                                      ON [PRIMARY]
)
go
IF OBJECT_ID('protic.tipos_boletas') IS NOT NULL
    PRINT '<<< CREATED TABLE protic.tipos_boletas >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE protic.tipos_boletas >>>'
go


CREATE TABLE protic.estados_boletas 
(
    ebol_ccod          numeric(10,0) NOT NULL,
    ebol_tdesc         varchar(100)  NULL,
    audi_tusuario      varchar(100)  NULL,
    audi_fmodificacion datetime      NULL,
    CONSTRAINT PK__estados_boletas__38EF3BC7
    PRIMARY KEY CLUSTERED (ebol_ccod) 
                                                                        ON [PRIMARY]
)
go
IF OBJECT_ID('protic.estados_boletas') IS NOT NULL
    PRINT '<<< CREATED TABLE protic.estados_boletas >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE protic.estados_boletas >>>'
go

-- Secuencias

INSERT INTO protic.SECUENCIAS ( cod_tabla, valor, secu_ttabla, secu_tcampo ) VALUES ( 'boletas', 1, 'boletas', 'bole_ncorr' ) 
INSERT INTO protic.SECUENCIAS ( cod_tabla, valor, secu_ttabla, secu_tcampo ) VALUES ( 'rangos_boletas', 1, 'rangos_boletas_sedes', 'rbol_ncorr' ) 
INSERT INTO protic.SECUENCIAS ( cod_tabla, valor, secu_ttabla, secu_tcampo ) VALUES ( 'rangos_boletas_cajeros   ', 1, 'rangos_boletas_cajeros', 'rbca_ncorr' ) 


select * from secuencias