select a.ofer_ncorr,g.peri_ccod,g.post_bnuevo,f.susu_tlogin as usuario,susu_tclave as clave,
protic.obtener_rut(a.pers_ncorr) as rut_alumno,b.pers_tnombre,b.pers_tape_paterno,pers_tape_materno,
protic.trunc(alum_fmatricula) as fecha_matricula ,protic.obtener_nombre_carrera(a.ofer_ncorr,'CEJ') as carrera
from alumnos a, personas b, ofertas_academicas c, aranceles d, contratos e, sis_usuarios f, postulantes g,especialidades h
where a.emat_ccod not in (9)
and a.pers_ncorr=b.pers_ncorr
and a.ofer_ncorr=c.ofer_ncorr
and c.aran_ncorr=d.aran_ncorr
and a.matr_ncorr=e.matr_ncorr
and a.post_ncorr=e.post_ncorr
and a.pers_ncorr=f.pers_ncorr
--and c.post_bnuevo='S'
--and g.post_bnuevo='S'
and a.post_ncorr=g.post_ncorr
and g.peri_ccod=210
and c.espe_ccod=h.espe_ccod
and h.carr_ccod in ('930','920','51','33')


select * from carreras
