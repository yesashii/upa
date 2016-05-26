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


--***************************************************************************
--volver deposito a estado pendiente
update envios set eenv_ccod=1, audi_tusuario=audi_tusuario+'cambia estado' where envi_ncorr=11340
update detalle_envios set edin_ccod=1, audi_tusuario=audi_tusuario+'cambia estado' where envi_ncorr=11340
update detalle_ingresos set edin_ccod=1, audi_tusuario=audi_tusuario+'cambia estado' where envi_ncorr=11340

select * from envios where envi_ncorr=11340
select * from detalle_envios where envi_ncorr=11340
select * from detalle_ingresos where envi_ncorr in (11340)
select * from estados_envio 
--##############################################################


select * from envios where envi_ncorr in (18342,18282,18265,18754)

16209243-K

select * from codigos_plazas_corpbanca