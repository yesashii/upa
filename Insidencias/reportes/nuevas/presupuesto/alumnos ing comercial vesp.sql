select a.ofer_ncorr,i.peri_tdesc as periodo,g.post_bnuevo as nuevo,
protic.obtener_rut(a.pers_ncorr) as rut_alumno,b.pers_tnombre,b.pers_tape_paterno,pers_tape_materno,
protic.trunc(alum_fmatricula) as fecha_matricula ,protic.obtener_nombre_carrera(a.ofer_ncorr,'CEJ') as carrera
from alumnos a, personas b, ofertas_academicas c, aranceles d, contratos e, 
postulantes g,especialidades h, periodos_academicos i
where --a.ofer_ncorr in (14442,14441)and 
a.emat_ccod not in (9)
and a.pers_ncorr=b.pers_ncorr
and a.ofer_ncorr=c.ofer_ncorr
and c.aran_ncorr=d.aran_ncorr
and a.matr_ncorr=e.matr_ncorr
and a.post_ncorr=e.post_ncorr
--and c.post_bnuevo='S'
--and g.post_bnuevo='S'
and c.jorn_ccod=2
and g.peri_ccod=i.peri_ccod
and a.post_ncorr=g.post_ncorr
and g.peri_ccod in (160,164,202,206)
and c.espe_ccod=h.espe_ccod
and h.carr_ccod in ('51')
order by peri_tdesc,g.post_bnuevo


select * from carreras
