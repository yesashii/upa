
-- -------------------------------------------------------------

-- VERIFICAR CUALES SON LOS ingr_ncorr ASOCIADOS A LA TRANSACCION.

-- en el ejemplo se trata n° documento: 5144

-- se consulta entonces:


SELECT
	*
FROM
	detalle_ingresos
WHERE
	ding_ndocto = 5144
AND
	ding_fdocto = '2015-12-02'
ORDER BY
	ding_fdocto DESC

--
--[TING_CCOD]='13', [DING_NDOCTO]='5144', [INGR_NCORR]='1511955', [DING_NSECUENCIA]='999692872', [DING_NCORRELATIVO]='16', [PLAZ_CCOD]='1', [BANC_CCOD]='1', [DING_FDOCTO]='2015-12-02 00:00:00.000', [DING_MDETALLE]='271000.00', [DING_MDOCTO]='5205283.00', [DING_TCUENTA_CORRIENTE]='5144', [EDIN_CCOD]='1', [ENVI_NCORR]=NULL, [REPA_NCORR]=NULL, [DING_BPACTA_CUOTA]='N', [PERS_NCORR_CODEUDOR]=NULL, [AUDI_TUSUARIO]='10047304', [AUDI_FMODIFICACION]='2015-12-02 16:22:35.233', [ding_tplaza_sbif]='', [esed_ncorr]=NULL, [sede_actual]=NULL WHERE ([TING_CCOD]='13') AND ([DING_NDOCTO]='5144') AND ([INGR_NCORR]='1511955') AND ([DING_NSECUENCIA]='999692872') AND ([DING_NCORRELATIVO]='16') AND ([PLAZ_CCOD]='1') AND ([BANC_CCOD]='1') AND ([DING_FDOCTO]='2015-12-02 00:00:00.000') AND ([DING_MDETALLE]='271000.00') AND ([DING_MDOCTO]='5205283.00') AND ([DING_TCUENTA_CORRIENTE]='5144') AND ([EDIN_CCOD]='1') AND ([ENVI_NCORR] IS NULL) AND ([REPA_NCORR] IS NULL) AND ([DING_BPACTA_CUOTA]='N') AND ([PERS_NCORR_CODEUDOR] IS NULL) AND ([AUDI_TUSUARIO]='10047304') AND ([AUDI_FMODIFICACION]='2015-12-02 16:22:35.233') AND ([ding_tplaza_sbif]='') AND ([esed_ncorr] IS NULL) AND ([sede_actual] IS NULL);
--[TING_CCOD]='13', [DING_NDOCTO]='5144', [INGR_NCORR]='1511957', [DING_NSECUENCIA]='999692874', [DING_NCORRELATIVO]='1', [PLAZ_CCOD]=NULL, [BANC_CCOD]='1', [DING_FDOCTO]='2015-12-02 00:00:00.000', [DING_MDETALLE]='283500.00', [DING_MDOCTO]='283500.00', [DING_TCUENTA_CORRIENTE]='5144', [EDIN_CCOD]='1', [ENVI_NCORR]=NULL, [REPA_NCORR]=NULL, [DING_BPACTA_CUOTA]='S', [PERS_NCORR_CODEUDOR]='256709', [AUDI_TUSUARIO]='ACTIVAR CONTRATO', [AUDI_FMODIFICACION]='2015-12-02 16:24:57.567', [ding_tplaza_sbif]='0', [esed_ncorr]=NULL, [sede_actual]=NULL WHERE ([TING_CCOD]='13') AND ([DING_NDOCTO]='5144') AND ([INGR_NCORR]='1511957') AND ([DING_NSECUENCIA]='999692874') AND ([DING_NCORRELATIVO]='1') AND ([PLAZ_CCOD] IS NULL) AND ([BANC_CCOD]='1') AND ([DING_FDOCTO]='2015-12-02 00:00:00.000') AND ([DING_MDETALLE]='283500.00') AND ([DING_MDOCTO]='283500.00') AND ([DING_TCUENTA_CORRIENTE]='5144') AND ([EDIN_CCOD]='1') AND ([ENVI_NCORR] IS NULL) AND ([REPA_NCORR] IS NULL) AND ([DING_BPACTA_CUOTA]='S') AND ([PERS_NCORR_CODEUDOR]='256709') AND ([AUDI_TUSUARIO]='ACTIVAR CONTRATO') AND ([AUDI_FMODIFICACION]='2015-12-02 16:24:57.567') AND ([ding_tplaza_sbif]='0') AND ([esed_ncorr] IS NULL) AND ([sede_actual] IS NULL);

--

-- modificando el primer documento 

select * from ingresos where ingr_ncorr = 1511957


-- [INGR_NCORR]='1511955', [MCAJ_NCORR]='22675', [EING_CCOD]='4', [INGR_FPAGO]='2015-12-02 00:00:00.000', [INGR_MEFECTIVO]='.00', [INGR_MDOCTO]='271000.00', [INGR_MTOTAL]='271000.00', [INGR_NESTADO]='1', [INGR_NFOLIO_REFERENCIA]='763096', [TING_CCOD]='34', [AUDI_TUSUARIO]='10047304', [AUDI_FMODIFICACION]='2015-12-02 16:22:35.100', [INST_CCOD]='1', [INGR_MINTERESES]=NULL, [INGR_MMULTAS]=NULL, [PERS_NCORR]='256267', [INGR_MANTICIPADO]='.00', [INEM_CCOD]='1', [TMOV_CCOD]='1', [GLOSA_FOX]=NULL, [INGR_NCORRELATIVO_CAJA]='17', [MCAJ_NCORR_ORIGEN]=NULL WHERE ([INGR_NCORR]='1511955') AND ([MCAJ_NCORR]='22675') AND ([EING_CCOD]='4') AND ([INGR_FPAGO]='2015-12-02 00:00:00.000') AND ([INGR_MEFECTIVO]='.00') AND ([INGR_MDOCTO]='271000.00') AND ([INGR_MTOTAL]='271000.00') AND ([INGR_NESTADO]='1') AND ([INGR_NFOLIO_REFERENCIA]='763096') AND ([TING_CCOD]='34') AND ([AUDI_TUSUARIO]='10047304') AND ([AUDI_FMODIFICACION]='2015-12-02 16:22:35.100') AND ([INST_CCOD]='1') AND ([INGR_MINTERESES] IS NULL) AND ([INGR_MMULTAS] IS NULL) AND ([PERS_NCORR]='256267') AND ([INGR_MANTICIPADO]='.00') AND ([INEM_CCOD]='1') AND ([TMOV_CCOD]='1') AND ([GLOSA_FOX] IS NULL) AND ([INGR_NCORRELATIVO_CAJA]='17') AND ([MCAJ_NCORR_ORIGEN] IS NULL);

-- en este caso se requiere ingresar en tres cuotas y el total es [INGR_MDOCTO]='283500.00' dividido en 3 : 94500 c/u
-- se insertan las cuotas, con los montos y las fechas correspondientes. 

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
                        (select max(ingr_ncorr + 1) from ingresos), 
                        '22675', 
                        '4', 
                        '2016-01-02 16:24:28.347', 
                        '.00', 
                        '94500.00', 
                        '94500.00', 
                        NULL, 
                        '763098', 
                        '7', 
                        'ACTIVAR CONTRATO', 
                        '2015-12-02 16:24:57.563', 
                        '1', 
                        NULL, 
                        NULL, 
                        '256267', 
                        NULL, 
                        NULL, 
                        NULL, 
                        NULL, 
                        '18', 
                        NULL 
            );
select max(ingr_ncorr ) from ingresos

-- 1516036

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
                        (select max(ingr_ncorr + 1) from ingresos), 
                        '22675', 
                        '4', 
                        '2016-02-02 16:24:28.347', 
                        '.00', 
                        '94500.00', 
                        '94500.00', 
                        NULL, 
                        '763098', 
                        '7', 
                        'ACTIVAR CONTRATO', 
                        '2016-02-02 16:24:28.347', 
                        '1', 
                        NULL, 
                        NULL, 
                        '256267', 
                        NULL, 
                        NULL, 
                        NULL, 
                        NULL, 
                        '18', 
                        NULL 
            );
select max(ingr_ncorr ) from ingresos

-- 1516047




select max(ingr_ncorr ) from ingresos
select max(ingr_ncorr - 1) from ingresos



select * from ingresos where ingr_ncorr = 1516036

select * from ingresos where ingr_ncorr = 1516047


-- se confirma entonces que los ingr_ncorr son 1515976 y 1515977
-- luego actualizamos el existente 1511955

update ingresos 
set ingr_mdocto = '94500.00',
ingr_mtotal = '94500.00'
where ingr_ncorr = 1511957


-- verificamos informacion 

select * 
from ingresos
where ingr_ncorr in (1511957, 1516036, 1516047)


select * 
from  detalle_ingresos
where ingr_ncorr in (1511957, 1516036, 1516047)

-- se puede ver que hay un triger que ejecuta la insercion de los detalles

-- solo queda actualizar los numero documento, montos y fecha de pago 


-- 

-- 

UPDATE TOP(1) detalle_ingresos 
set    [DING_MDETALLE]='94500.00', 
       [DING_MDOCTO]='94500.00'       
where INGR_NCORR='1511957'

-- segunda CUOTA

UPDATE TOP(1) detalle_ingresos
set    [DING_NDOCTO]='5144', 
       [DING_NCORRELATIVO]='1', 
       [PLAZ_CCOD]=NULL, 
       [BANC_CCOD]='1', 
       [DING_FDOCTO]='2016-01-02 00:00:00.000', 
       [DING_MDETALLE]='94500.00', 
       [DING_MDOCTO]='94500.00', 
       [DING_TCUENTA_CORRIENTE]='5144', 
       [EDIN_CCOD]='1', 
       [ENVI_NCORR]=NULL, 
       [REPA_NCORR]=NULL, 
       [DING_BPACTA_CUOTA]='S', 
       [PERS_NCORR_CODEUDOR]='256709', 
       [AUDI_TUSUARIO]='ACTIVAR CONTRATO', 
       [AUDI_FMODIFICACION]='2015-12-02 16:24:57.567', 
       [ding_tplaza_sbif]='0', 
       [esed_ncorr]=NULL, 
       [sede_actual]=NULL 
where INGR_NCORR='1516036'

-- tercera cuota

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
                        (select max(TING_CCOD + 1) from detalle_ingresos), 
                        '5144', 
                        '1516047', 
                        (select max(DING_NSECUENCIA + 1) from detalle_ingresos), 
                        '1', 
                        NULL, 
                        '1', 
                        '2016-02-02 00:00:00.000', 
                        '94500.00', 
                        '94500.00', 
                        '5144', 
                        '1', 
                        NULL, 
                        NULL, 
                        'S', 
                        '256709', 
                        'ACTIVAR CONTRATO', 
                        getdate(), 
                        '0', 
                        NULL, 
                        NULL 
            );

-- luego el original 

UPDATE TOP(1) detalle_ingresos
set   [DING_MDETALLE]='90333.00'      
where ingr_ncorr = 1511955







































