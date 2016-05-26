select cast(a.ding_mdocto as numeric) as monto, ting_tdesc as tipo_docto, protic.trunc(a.audi_fmodificacion) as fecha_cambio,
protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_nombre_completo(b.pers_ncorr, 'n') as nombre_alumno 
from detalle_ingresos a join ingresos b
on a.ingr_ncorr=b.ingr_ncorr
join tipos_ingresos c
on a.ting_ccod=c.ting_ccod
where edin_ccod=14 
and protic.trunc(convert(datetime,a.audi_fmodificacion,103))= protic.trunc(convert(datetime,'26/06/2012',103)) 


