-- Listados ingresos por regularizacion
select protic.obtener_rut(a.pers_ncorr) as rut_alumno,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno,
c.ting_tdesc as motivo,protic.trunc(ingr_fpago) as fecha,a.ingr_mtotal as monto_desc,
protic.obtener_nombre_carrera((select ofer_ncorr from alumnos where post_ncorr=protic.obtener_post_ncorr(a.pers_ncorr,null,a.ingr_ncorr) and pers_ncorr=a.pers_ncorr and emat_ccod=1),'CJ') as carrera
from ingresos a, detalle_ingresos b, tipos_ingresos c
where a.ingr_ncorr=b.ingr_ncorr
and b.ting_ccod=c.ting_ccod
and a.ting_ccod=17
and c.ereg_ccod in (2,4)
and a.ingr_fpago between convert(datetime,'01/11/2009',103) and convert(datetime, '01/11/2010',103)
order by a.ingr_fpago, a.pers_ncorr

