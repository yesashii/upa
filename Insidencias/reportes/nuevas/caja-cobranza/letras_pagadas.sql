select b.ding_ndocto as numero_letra,protic.trunc(b.ding_fdocto) as fecha_docto, cast(b.ding_mdocto as numeric) as monto_letra,
protic.documento_pagado_x_otro(a.ingr_ncorr,'S','A') as abonado,d.edin_tdesc as estado_letra,
protic.obtener_rut(pers_ncorr) as rut_alumno, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre_alumno,
protic.obtener_rut(pers_ncorr_codeudor) as rut_apoderado, protic.obtener_nombre_completo(pers_ncorr_codeudor,'n') as nombre_apoderado 
from detalle_envios a, detalle_ingresos b, ingresos c, estados_detalle_ingresos d 
where a.envi_ncorr in (16566)
and a.ingr_ncorr=b.ingr_ncorr
and b.ingr_ncorr=c.ingr_ncorr
and protic.documento_pagado_x_otro(a.ingr_ncorr,'S','P')>0
and b.edin_ccod=d.edin_ccod

--*****************************************************************


select * from detalle_ingresos where envi_ncorr=10163
select * from detalle_envios where envi_ncorr=10163
select * from estados_envio 

update detalle_ingresos set edin_ccod=1 where envi_ncorr=10163
update detalle_envios set edin_ccod=1 where envi_ncorr=10163
update envios set eenv_ccod=1 where envi_ncorr=10163


select * from detalle_ingresos where ding_ndocto in (104) and ting_ccod=3
select * from ingresos where ingr_ncorr=232725
select * from envios where envi_ncorr=11360

select * from detalle_envios where ingr_ncorr=223238

--**************************************************************************
-- ver letras por mes
select *,protic.trunc(ding_fdocto),ingr_ncorr,edin_ccod, ding_ndocto
from detalle_ingresos where envi_ncorr in (11340,11342,11360,11365,11397,11402)
and datepart(month,ding_fdocto)<5
and datepart(year,ding_fdocto)=2007


-- Quita letras por mes de un deposito
delete from detalle_envios 
    where ingr_ncorr in (
                select ingr_ncorr
                from detalle_ingresos where envi_ncorr=6326
                and datepart(month,ding_fdocto)=7
                and datepart(year,ding_fdocto)=2006
    )

update detalle_ingresos set audi_tusuario='quita mes julio', envi_ncorr=null
    where envi_ncorr=6326
      and datepart(month,ding_fdocto)=7
      and datepart(year,ding_fdocto)=2006

--***************************************************************************
--volver deposito a estado pendiente
update envios set eenv_ccod=1, audi_tusuario=audi_tusuario+'cambia estado' where envi_ncorr=11340
update detalle_envios set edin_ccod=1, audi_tusuario=audi_tusuario+'cambia estado' where envi_ncorr=11340
update detalle_ingresos set edin_ccod=1, audi_tusuario=audi_tusuario+'cambia estado' where envi_ncorr=11340

select * from envios where envi_ncorr=11340
select * from detalle_envios where envi_ncorr=11340
select * from detalle_ingresos where envi_ncorr in (11340)
--##############################################################


select protic.obtener_rut(pers_ncorr),* from ingresos where ingr_ncorr in (323144,301090,314420,329880)



select a.* from detalle_ingresos a, ingresos b 
where a.ingr_ncorr=b.ingr_ncorr
and b.ingr_nfolio_referencia=118889



select *,protic.trunc(ding_fdocto),ingr_ncorr,edin_ccod, ding_ndocto
from detalle_ingresos where envi_ncorr in (12063,12114,12144,12243)

197876


select * from envios where envi_ncorr=12114

select * from detalle_envios where envi_ncorr=12114 and ding_ndocto=197875