select protic.obtener_rut(a.pers_ncorr) as rut,c.pers_tnombre, c.pers_tape_paterno,c.pers_tape_materno,
epos_tdesc as estado_postulacion,eepo_tdesc as estado_examen,protic.obtener_nombre_carrera(b.ofer_ncorr,'CJ') as carrera
from postulantes a, detalle_postulantes b, personas_postulante c, estados_postulantes d, estado_examen_postulantes e
where a.post_ncorr=b.post_ncorr
and a.peri_ccod=230
and a.post_bnuevo='S'
and b.eepo_ccod in (1,2)
and a.pers_ncorr=c.pers_ncorr
and a.epos_ccod=d.epos_ccod
and b.eepo_ccod=e.eepo_ccod
and a.post_ncorr not in (select distinct post_ncorr from alumnos)
and a.pers_ncorr not in (select distinct pers_ncorr from alumnos) 
order by rut desc

