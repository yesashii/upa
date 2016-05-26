SELECT
	*
FROM
	detalle_ingresos
WHERE
	ding_ndocto = 4210
AND
	ding_fdocto = '2015-12-02'
ORDER BY
	ding_fdocto DESC
/*
DOCUMENTO 4210 EN detalle_ingresos

[TING_CCOD]='13', 
[DING_NDOCTO]='4210', 
[INGR_NCORR]='1511725', 
[DING_NSECUENCIA]='999692669', 
[DING_NCORRELATIVO]='1', 
[PLAZ_CCOD]=NULL, 
[BANC_CCOD]='14', 
[DING_FDOCTO]='2015-12-02 00:00:00.000', 
[DING_MDETALLE]='367500.00', 
[DING_MDOCTO]='367500.00', 
[DING_TCUENTA_CORRIENTE]='4210', 
[EDIN_CCOD]='1', 
[ENVI_NCORR]=NULL, 
[REPA_NCORR]=NULL, 
[DING_BPACTA_CUOTA]='S', 
[PERS_NCORR_CODEUDOR]='276381', 
[AUDI_TUSUARIO]='ACTIVAR CONTRATO', 
[AUDI_FMODIFICACION]='2015-12-02 11:29:57.990', 
[ding_tplaza_sbif]='0', 
[esed_ncorr]=NULL, 
[sede_actual]=NULL 

*/


select * from ingresos where ingr_ncorr = 1511725

-- reservamos 2 codigos para ingresos 


execute obtenersecuencia 'ingresos'

1519062
1519063


-- ejecuto para obtener valores y clonar con valores cambiados

select * from ingresos where ingr_ncorr = 1511725

INSERT INTO ingresos 
            ([ingr_ncorr], 
             [mcaj_ncorr], 
             [eing_ccod], 
             [ingr_fpago], 
             [ingr_mefectivo], 
             [ingr_mdocto], 
             [ingr_mtotal], 
             [ingr_nestado], 
             [ingr_nfolio_referencia], 
             [ting_ccod], 
             [audi_tusuario], 
             [audi_fmodificacion], 
             [inst_ccod], 
             [ingr_mintereses], 
             [ingr_mmultas], 
             [pers_ncorr], 
             [ingr_manticipado], 
             [inem_ccod], 
             [tmov_ccod], 
             [glosa_fox], 
             [ingr_ncorrelativo_caja], 
             [mcaj_ncorr_origen]) 
VALUES      ('1519063', 
             '22676', 
             '4', 
             '2016-02-02 11:29:03.953', 
             '.00', 
             '122500.00', 
             '122500.00', 
             NULL, 
             '763029', 
             '7', 
             'ACTIVAR CONTRATO', 
             '2015-12-02 11:29:57.990', 
             '1', 
             NULL, 
             NULL, 
             '275358', 
             NULL, 
             NULL, 
             NULL, 
             NULL, 
             '3', 
             NULL); 

-- se verifican los tres ingresos 
select * from ingresos where ingr_ncorr in(1511725, 1519062, 1519063)

UPDATE top(1) ingresos
set ingr_mdocto = 122500,
ingr_mtotal =122500 
where ingr_ncorr = 1511725
-- se verifican los tres ingresos 
select * from ingresos where ingr_ncorr in(1511725, 1519062, 1519063)


-- 

select * from detalle_ingresos where ingr_ncorr in(1511725, 1519062, 1519063)

-- reservamos 2 codigos para detalle_ingresos 


execute obtenersecuencia 'detalle_ingresos'
999699361
999699362

-- para clonar

select * from detalle_ingresos where ingr_ncorr in(1511725, 1519062, 1519063)

-- segundo pago
INSERT INTO detalle_ingresos
            ( 
                        [TING_CCOD], 
                        [DING_NDOCTO], 
                        [INGR_NCORR], 
                        [DING_NSECUENCIA], 
                        [DING_NCORRELATIVO], 
                        [PLAZ_CCOD], 
                        [BANC_CCOD], 
                        [DING_FDOCTO], 
                        [DING_MDETALLE], 
                        [DING_MDOCTO], 
                        [DING_TCUENTA_CORRIENTE], 
                        [EDIN_CCOD], 
                        [ENVI_NCORR], 
                        [REPA_NCORR], 
                        [DING_BPACTA_CUOTA], 
                        [PERS_NCORR_CODEUDOR], 
                        [AUDI_TUSUARIO], 
                        [AUDI_FMODIFICACION], 
                        [ding_tplaza_sbif], 
                        [esed_ncorr], 
                        [sede_actual] 
            ) 
            VALUES 
            ( 
                        '13', 
                        '4210', 
                        '1519062', 
                        '999699361', 
                        '1', 
                        NULL, 
                        '14', 
                        '2016-01-02 00:00:00.000', 
                        '122500.00', 
                        '122500.00', 
                        '4210', 
                        '1', 
                        NULL, 
                        NULL, 
                        'S', 
                        '276381', 
                        'ACTIVAR CONTRATO', 
                        '2015-12-02 11:29:57.990', 
                        '0', 
                        NULL, 
                        NULL 
            );

-- tercer pago 

-- segundo pago
INSERT INTO detalle_ingresos
            ( 
                        [TING_CCOD], 
                        [DING_NDOCTO], 
                        [INGR_NCORR], 
                        [DING_NSECUENCIA], 
                        [DING_NCORRELATIVO], 
                        [PLAZ_CCOD], 
                        [BANC_CCOD], 
                        [DING_FDOCTO], 
                        [DING_MDETALLE], 
                        [DING_MDOCTO], 
                        [DING_TCUENTA_CORRIENTE], 
                        [EDIN_CCOD], 
                        [ENVI_NCORR], 
                        [REPA_NCORR], 
                        [DING_BPACTA_CUOTA], 
                        [PERS_NCORR_CODEUDOR], 
                        [AUDI_TUSUARIO], 
                        [AUDI_FMODIFICACION], 
                        [ding_tplaza_sbif], 
                        [esed_ncorr], 
                        [sede_actual] 
            ) 
            VALUES 
            ( 
                        '13', 
                        '4210', 
                        '1519063', 
                        '999699362', 
                        '1', 
                        NULL, 
                        '14', 
                        '2016-02-02 00:00:00.000', 
                        '122500.00', 
                        '122500.00', 
                        '4210', 
                        '1', 
                        NULL, 
                        NULL, 
                        'S', 
                        '276381', 
                        'ACTIVAR CONTRATO', 
                        '2015-12-02 11:29:57.990', 
                        '0', 
                        NULL, 
                        NULL 
            );

-- verificando los detalles del ingreso
select * from detalle_ingresos where ingr_ncorr in(1511725, 1519062, 1519063)

-- actualizando el primer pago

update top (1) detalle_ingresos
set DING_MDOCTO=122500 ,
DING_MDETALLE = 122500
where ingr_ncorr = 1511725

-- verificando los detalles del ingreso
select * from detalle_ingresos where ingr_ncorr in(1511725, 1519062, 1519063)


-- caso documento 1052

SELECT
	*
FROM
	detalle_ingresos
WHERE
	ding_ndocto = 1052
AND
	ding_fdocto = '2015-12-02'
ORDER BY
	ding_fdocto DESC


-- ingr_ncorr = 1511725

select * from ingresos where ingr_ncorr = 1512011

-- reservamos 2 codigos para ingresos 

execute obtenersecuencia 'ingresos'

-- 1519115
-- 1519116

-- ejecuto para obtener valores y clonar con valores cambiados

select * from ingresos where ingr_ncorr = 1512011

-- cambiar
-- INGR_NCORR		: 1519115
-- INGR_FPAGO		: 193000
-- INGR_MTOTAL	: 193000
-- INGR_MDOCTO	: 2016-01-02 00:00:00.000
INSERT INTO ingresos 
            ( 
                        [INGR_NCORR], 
                        [MCAJ_NCORR], 
                        [EING_CCOD], 
                        [INGR_FPAGO], 
                        [INGR_MEFECTIVO], 
                        [INGR_MDOCTO], 
                        [INGR_MTOTAL], 
                        [INGR_NESTADO], 
                        [INGR_NFOLIO_REFERENCIA], 
                        [TING_CCOD], 
                        [AUDI_TUSUARIO], 
                        [AUDI_FMODIFICACION], 
                        [INST_CCOD], 
                        [INGR_MINTERESES], 
                        [INGR_MMULTAS], 
                        [PERS_NCORR], 
                        [INGR_MANTICIPADO], 
                        [INEM_CCOD], 
                        [TMOV_CCOD], 
                        [GLOSA_FOX], 
                        [INGR_NCORRELATIVO_CAJA], 
                        [MCAJ_NCORR_ORIGEN] 
            ) 
            VALUES 
            ( 
                        '1519115', 
                        '22676', 
                        '4', 
                        '2016-01-02 00:00:00.000', 
                        '.00', 
                        '193000.00', 
                        '193000.00', 
                        '1', 
                        '763111', 
                        '34', 
                        '11667970', 
                        getdate(), 
                        '1', 
                        NULL, 
                        NULL, 
                        '267188', 
                        '.00', 
                        '1', 
                        '1', 
                        NULL, 
                        '12', 
                        NULL 
            );

-- trecer documento
-- cambiar
-- INGR_NCORR		: 1519116
-- INGR_FPAGO		: 193000
-- INGR_MTOTAL	: 193000
-- INGR_MDOCTO	: 2016-02-02 00:00:00.000
INSERT INTO ingresos 
            ( 
                        [INGR_NCORR], 
                        [MCAJ_NCORR], 
                        [EING_CCOD], 
                        [INGR_FPAGO], 
                        [INGR_MEFECTIVO], 
                        [INGR_MDOCTO], 
                        [INGR_MTOTAL], 
                        [INGR_NESTADO], 
                        [INGR_NFOLIO_REFERENCIA], 
                        [TING_CCOD], 
                        [AUDI_TUSUARIO], 
                        [AUDI_FMODIFICACION], 
                        [INST_CCOD], 
                        [INGR_MINTERESES], 
                        [INGR_MMULTAS], 
                        [PERS_NCORR], 
                        [INGR_MANTICIPADO], 
                        [INEM_CCOD], 
                        [TMOV_CCOD], 
                        [GLOSA_FOX], 
                        [INGR_NCORRELATIVO_CAJA], 
                        [MCAJ_NCORR_ORIGEN] 
            ) 
            VALUES 
            ( 
                        '1519116', 
                        '22676', 
                        '4', 
                        '2016-02-02 00:00:00.000', 
                        '.00', 
                        '193000.00', 
                        '193000.00', 
                        '1', 
                        '763111', 
                        '34', 
                        '11667970', 
                        getdate(), 
                        '1', 
                        NULL, 
                        NULL, 
                        '267188', 
                        '.00', 
                        '1', 
                        '1', 
                        NULL, 
                        '12', 
                        NULL 
            );

-- se verifican los tres ingresos 
select * from ingresos where ingr_ncorr in(1512011, 1519115, 1519116)

-- se actualiza el valor de la primera cuota

UPDATE top(1) ingresos
set ingr_mdocto = 193000,
ingr_mtotal =193000 
where ingr_ncorr = 1512011

-- se verifican los tres ingresos  
select * from detalle_ingresos where ingr_ncorr in(1512011, 1519115, 1519116)

-- reservamos 2 codigos para detalle_ingresos 
execute obtenersecuencia 'detalle_ingresos'

-- 999699415
-- 999699416

-- para clonar
select * from detalle_ingresos where ingr_ncorr in(1512011, 1519115, 1519116)


-- segundo documento detalle_ingresos
-- cambiar
-- INGR_NCORR				: 1519115
-- DING_NSECUENCIA	: 999699415

-- DING_MDETALLE		: 193000
-- DING_MDOCTO			: 193000
-- DING_FDOCTO			: 2016-01-02 00:00:00.000


INSERT INTO detalle_ingresos
            ( 
                        [TING_CCOD], 
                        [DING_NDOCTO], 
                        [INGR_NCORR], 
                        [DING_NSECUENCIA], 
                        [DING_NCORRELATIVO], 
                        [PLAZ_CCOD], 
                        [BANC_CCOD], 
                        [DING_FDOCTO], 
                        [DING_MDETALLE], 
                        [DING_MDOCTO], 
                        [DING_TCUENTA_CORRIENTE], 
                        [EDIN_CCOD], 
                        [ENVI_NCORR], 
                        [REPA_NCORR], 
                        [DING_BPACTA_CUOTA], 
                        [PERS_NCORR_CODEUDOR], 
                        [AUDI_TUSUARIO], 
                        [AUDI_FMODIFICACION], 
                        [ding_tplaza_sbif], 
                        [esed_ncorr], 
                        [sede_actual] 
            ) 
            VALUES 
            ( 
                        '13', 
                        '1052', 
                        '1519115', 
                        '999699415', 
                        '1', 
                        '2', 
                        '27', 
                        '2016-01-02 00:00:00.000', 
                        '193000.00', 
                        '193000.00', 
                        '1052', 
                        '1', 
                        NULL, 
                        NULL, 
                        'N', 
                        NULL, 
                        '11667970', 
                        getdate(), 
                        '', 
                        NULL, 
                        NULL 
            );
-- tercer documento detalle_ingresos
-- cambiar
-- INGR_NCORR				: 1519116
-- DING_NSECUENCIA	: 999699416

-- DING_MDETALLE		: 193000
-- DING_MDOCTO			: 193000
-- DING_FDOCTO			: 2016-02-02 00:00:00.000


INSERT INTO detalle_ingresos
            ( 
                        [TING_CCOD], 
                        [DING_NDOCTO], 
                        [INGR_NCORR], 
                        [DING_NSECUENCIA], 
                        [DING_NCORRELATIVO], 
                        [PLAZ_CCOD], 
                        [BANC_CCOD], 
                        [DING_FDOCTO], 
                        [DING_MDETALLE], 
                        [DING_MDOCTO], 
                        [DING_TCUENTA_CORRIENTE], 
                        [EDIN_CCOD], 
                        [ENVI_NCORR], 
                        [REPA_NCORR], 
                        [DING_BPACTA_CUOTA], 
                        [PERS_NCORR_CODEUDOR], 
                        [AUDI_TUSUARIO], 
                        [AUDI_FMODIFICACION], 
                        [ding_tplaza_sbif], 
                        [esed_ncorr], 
                        [sede_actual] 
            ) 
            VALUES 
            ( 
                        '13', 
                        '1052', 
                        '1519116', 
                        '999699416', 
                        '1', 
                        '2', 
                        '27', 
                        '2016-02-02 00:00:00.000', 
                        '193000.00', 
                        '193000.00', 
                        '1052', 
                        '1', 
                        NULL, 
                        NULL, 
                        'N', 
                        NULL, 
                        '11667970', 
                        getdate(), 
                        '', 
                        NULL, 
                        NULL 
            );

--
select * from detalle_ingresos where ingr_ncorr in(1512011, 1519115, 1519116)


-- actualizando el primer pago detalle_ingresos

update top (1) detalle_ingresos
set DING_MDOCTO=193000 ,
DING_MDETALLE = 193000
where ingr_ncorr = 1512011

--
select * from detalle_ingresos where ingr_ncorr in(1512011, 1519115, 1519116)






























