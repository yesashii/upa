select distinct b.post_ncorr,b.pers_ncorr,d.tdet_tdesc as beca,protic.trunc(c.cont_fcontrato) as fecha_asignacion,cast(a.sdes_mmatricula as numeric)as matricula,cast(a.sdes_mcolegiatura as numeric) as monto_beca,
protic.obtener_nombre_carrera(b.ofer_ncorr,'CJ') as carrera,protic.obtener_nombre(b.pers_ncorr,'n') as nombre_alumno,protic.obtener_rut(b.pers_ncorr) as rut_alumno   
from sdescuentos a, postulantes b, contratos c, tipos_detalle d, alumnos e
where a.post_ncorr=b.post_ncorr
and b.post_ncorr=c.post_ncorr
and c.matr_ncorr=e.matr_ncorr
and b.post_ncorr=e.post_ncorr
and a.stde_ccod=d.tdet_ccod
and b.peri_ccod in (222)
and d.tben_ccod in (2,3)
and c.econ_ccod not in (2,3)
and a.esde_ccod in (1,2)
order by beca , fecha_asignacion