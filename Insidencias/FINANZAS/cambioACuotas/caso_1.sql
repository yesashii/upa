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

select * from ingresos where ingr_ncorr = 1511955


-- [INGR_NCORR]='1511955', [MCAJ_NCORR]='22675', [EING_CCOD]='4', [INGR_FPAGO]='2015-12-02 00:00:00.000', [INGR_MEFECTIVO]='.00', [INGR_MDOCTO]='271000.00', [INGR_MTOTAL]='271000.00', [INGR_NESTADO]='1', [INGR_NFOLIO_REFERENCIA]='763096', [TING_CCOD]='34', [AUDI_TUSUARIO]='10047304', [AUDI_FMODIFICACION]='2015-12-02 16:22:35.100', [INST_CCOD]='1', [INGR_MINTERESES]=NULL, [INGR_MMULTAS]=NULL, [PERS_NCORR]='256267', [INGR_MANTICIPADO]='.00', [INEM_CCOD]='1', [TMOV_CCOD]='1', [GLOSA_FOX]=NULL, [INGR_NCORRELATIVO_CAJA]='17', [MCAJ_NCORR_ORIGEN]=NULL WHERE ([INGR_NCORR]='1511955') AND ([MCAJ_NCORR]='22675') AND ([EING_CCOD]='4') AND ([INGR_FPAGO]='2015-12-02 00:00:00.000') AND ([INGR_MEFECTIVO]='.00') AND ([INGR_MDOCTO]='271000.00') AND ([INGR_MTOTAL]='271000.00') AND ([INGR_NESTADO]='1') AND ([INGR_NFOLIO_REFERENCIA]='763096') AND ([TING_CCOD]='34') AND ([AUDI_TUSUARIO]='10047304') AND ([AUDI_FMODIFICACION]='2015-12-02 16:22:35.100') AND ([INST_CCOD]='1') AND ([INGR_MINTERESES] IS NULL) AND ([INGR_MMULTAS] IS NULL) AND ([PERS_NCORR]='256267') AND ([INGR_MANTICIPADO]='.00') AND ([INEM_CCOD]='1') AND ([TMOV_CCOD]='1') AND ([GLOSA_FOX] IS NULL) AND ([INGR_NCORRELATIVO_CAJA]='17') AND ([MCAJ_NCORR_ORIGEN] IS NULL);

-- en este caso se requiere ingresar en tres cuotas y el total es [INGR_MDOCTO]='271000.00' dividido en 3 : 90333 c/u
-- se insertan las cuotas, con los montos y las fechas correspondientes. 

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
VALUES      ((select max(ingr_ncorr + 1) from ingresos), 
             '22675', 
             '4', 
             '2016-02-02 00:00:00.000', 
             '.00', 
             '90333.00', 
             '90333.00', 
             '1', 
             '763096', 
             '34', 
             '10047304', 
             '2016-02-02 00:00:00.000', 
             '1', 
             NULL, 
             NULL, 
             '256267', 
             '.00', 
             '1', 
             '1', 
             NULL, 
             '17', 
             NULL); 





insert into ingresos values ()

select max(ingr_ncorr ) from ingresos
select max(ingr_ncorr - 1) from ingresos



select * from ingresos where ingr_ncorr = 1515977

select * from ingresos where ingr_ncorr = 1515976


-- se confirma entonces que los ingr_ncorr son 1515976 y 1515977
-- luego actualizamos el existente 1511955

update ingresos 
set ingr_mdocto = '90333.00',
ingr_mtotal = '90333.00'
where ingr_ncorr = 1511955


-- verificamos informacion 

select * 
from ingresos
where ingr_ncorr in (1511955, 1515976, 1515977)


select * 
from  detalle_ingresos
where ingr_ncorr in (1511955, 1515976, 1515977)

-- se puede ver que hay un triger que ejecuta la insercion de los detalles

-- solo queda actualizar los numero documento, montos y fecha de pago 


-- 
UPDATE TOP(1) detalle_ingresos
set    [DING_NDOCTO]='5144', 
       [DING_NCORRELATIVO]='16', 
       [PLAZ_CCOD]='1', 
       [BANC_CCOD]='1', 
       [DING_FDOCTO]='2016-01-02 00:00:00.000', 
       [DING_MDETALLE]='90333.00',
       [DING_MDOCTO]='5205283.00', 
       [DING_TCUENTA_CORRIENTE]='5144', 
       [EDIN_CCOD]='1', 
       [ENVI_NCORR]=NULL, 
       [REPA_NCORR]=NULL, 
       [DING_BPACTA_CUOTA]='N', 
       [PERS_NCORR_CODEUDOR]=NULL, 
       [AUDI_TUSUARIO]='10047304', 
       [ding_tplaza_sbif]='', 
       [esed_ncorr]=NULL, 
       [sede_actual]=NULL 
where ingr_ncorr = 1515976

-- 

UPDATE TOP(1) detalle_ingresos
set    [DING_NDOCTO]='5144', 
       [DING_NCORRELATIVO]='16', 
       [PLAZ_CCOD]='1', 
       [BANC_CCOD]='1', 
       [DING_FDOCTO]='2016-02-02 00:00:00.000', 
       [DING_MDETALLE]='90333.00',
       [DING_MDOCTO]='5205283.00', 
       [DING_TCUENTA_CORRIENTE]='5144', 
       [EDIN_CCOD]='1', 
       [ENVI_NCORR]=NULL, 
       [REPA_NCORR]=NULL, 
       [DING_BPACTA_CUOTA]='N', 
       [PERS_NCORR_CODEUDOR]=NULL, 
       [AUDI_TUSUARIO]='10047304', 
       [ding_tplaza_sbif]='', 
       [esed_ncorr]=NULL, 
       [sede_actual]=NULL 
where ingr_ncorr = 1515977

-- luego el original 

UPDATE TOP(1) detalle_ingresos
set   [DING_MDETALLE]='90333.00'      
where ingr_ncorr = 1511955







































