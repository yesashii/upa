--CONSULTAR
Declare @contador_compromisos int;
set @contador_compromisos = ( select count(*) from COMPROMISOS
                              where TCOM_CCOD in (1,2) -->>1 MATRICULA, 2 ARANCEL 
                              and   year(AUDI_FMODIFICACION) in (2016)
                              and   COMP_MNETO is NULL
                              and   ECOM_CCOD <> 3 )-->>ECOM_CCOD = 3 -->> esta anulado
select @contador_compromisos as COMPROMISOS

--RESPALDAMOS LOS DATOS
insert into COMPROMISOS_ANTES_DE_UPDATE
select getdate() as FECHA_RESPALDO, tip.TCOM_TDESC, per.PERS_NRUT, per.PERS_XDV, com.*, --com.COMP_FDOCTO, com.PERS_NCORR, com.POST_NCORR, com.COMP_NDOCTO, com.TCOM_CCOD, com.COMP_MNETO, com.OFER_NCORR, 
       ara.ARAN_MMATRICULA, ara.ARAN_MCOLEGIATURA 
--into COMPROMISOS_ANTES_DE_UPDATE
from COMPROMISOS        com,
     OFERTAS_ACADEMICAS ofe,
     ARANCELES          ara,
     PERSONAS           per,
     TIPOS_COMPROMISOS  tip
where com.TCOM_CCOD in (1,2) -->>1 MATRICULA, 2 ARANCEL 
and year(com.AUDI_FMODIFICACION) in (2016)
and com.COMP_MNETO is NULL
and com.ECOM_CCOD     <> 3 -->>ECOM_CCOD = 3 -->> esta anulado
and com.OFER_NCORR   = ofe.OFER_NCORR
and ofe.ARAN_NCORR   = ara.ARAN_NCORR
and com.PERS_NCORR   = per.PERS_NCORR
and com.TCOM_CCOD    = tip.TCOM_CCOD
--and com.PERI_CCOD    = 242
order by com.OFER_NCORR, com.PERS_NCORR, com.COMP_NDOCTO, com.TCOM_CCOD
--  select * from COMPROMISOS_ANTES_DE_UPDATE where FECHA_RESPALDO = getdate()
--22-12-2015: (2 filas afectadas)

      
select * from COMPROMISOS_ANTES_DE_UPDATE where convert(varchar(10),FECHA_RESPALDO,110) = convert(varchar(10),getdate(),110)
--2015-12-22: (2 filas afectadas)
--2015-12-24: (2 filas afectadas)
--2015-12-27: (4 filas afectadas)
--2015-12-28: (2 filas afectadas)

--------------------------------
---------- COMENZAMOS ----------
--------------------------------
--1 MATRICULA, 2 ARANCEL
--  drop table #compromisos
select com.COMP_FDOCTO, com.PERS_NCORR, com.POST_NCORR, com.COMP_NDOCTO, com.TCOM_CCOD, com.COMP_MNETO, com.OFER_NCORR, ara.ARAN_MMATRICULA, ara.ARAN_MCOLEGIATURA 
into #compromisos
from COMPROMISOS        com,
     OFERTAS_ACADEMICAS ofe,
     ARANCELES          ara
where com.TCOM_CCOD in (1,2) -->>1 MATRICULA, 2 ARANCEL 
  and year(com.AUDI_FMODIFICACION) in (2016)
  and com.COMP_MNETO is NULL
  and com.ECOM_CCOD     <> 3 -->>ECOM_CCOD = 3 -->> esta anulado
  and com.OFER_NCORR   = ofe.OFER_NCORR
  and ofe.ARAN_NCORR   = ara.ARAN_NCORR
order by com.OFER_NCORR, com.PERS_NCORR, com.COMP_NDOCTO, com.TCOM_CCOD

--MATRICULA
update com
set com.COMP_MNETO = xxx.ARAN_MMATRICULA
--  select com.COMP_MNETO, xxx.ARAN_MMATRICULA, com.COMP_NDOCTO, xxx.COMP_NDOCTO, com.TCOM_CCOD, xxx.TCOM_CCOD
from COMPROMISOS  com,
     #compromisos xxx
where com.COMP_NDOCTO = xxx.COMP_NDOCTO -->>numero de contrato que aparece el la URL del SGA
  and com.TCOM_CCOD   = xxx.TCOM_CCOD
  and com.TCOM_CCOD  in (1) --1 MATRICULA

--ARANCEL
update com
set com.COMP_MNETO = xxx.ARAN_MCOLEGIATURA
--  select com.COMP_MNETO, xxx.ARAN_MCOLEGIATURA, com.COMP_NDOCTO, xxx.COMP_NDOCTO, com.TCOM_CCOD, xxx.TCOM_CCOD
from COMPROMISOS  com,
     #compromisos xxx
where com.COMP_NDOCTO = xxx.COMP_NDOCTO -->>numero de contrato que aparece el la URL del SGA
  and com.TCOM_CCOD   = xxx.TCOM_CCOD
  and com.TCOM_CCOD  in (2) --2 ARANCEL
