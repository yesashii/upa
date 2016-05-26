select protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_completo,
cast(a.ingr_mtotal as numeric) as monto,protic.trunc(a.ingr_fpago) as fecha_pago,
protic.obtener_nombre_carrera((select top 1 ofer_ncorr from alumnos where pers_ncorr=a.pers_ncorr order by matr_ncorr desc),'CJ') as carrera 
from ingresos a, detalle_ingresos b
where a.ingr_ncorr=b.ingr_ncorr
and b.ting_ccod=100 