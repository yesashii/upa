select  distinct c.pers_tape_paterno, c.pers_tape_materno,c.pers_tnombre, protic.obtener_rut(c.pers_ncorr) as rut_profe,
protic.obtener_grado_docente(a.pers_ncorr,'G') as grado, protic.obtener_grado_docente(a.pers_ncorr,'D') as descripcion_grado,
(select min(prof_ingreso_uas)  from profesores where pers_ncorr=a.pers_ncorr group by pers_ncorr)as año_ingreso_upacifico,
(select max(cudo_titulo)  from curriculum_docente where pers_ncorr=a.pers_ncorr group by pers_ncorr)as profesion
from bloques_profesores a, bloques_horarios b, personas c, profesores d,
     tipos_profesores e, sedes f, secciones g, asignaturas h
where a.bloq_ccod=b.bloq_ccod
and a.bloq_ccod is not null
and a.cdoc_ncorr is not null
and a.pers_ncorr = c.pers_ncorr
and b.sede_ccod  = d.sede_ccod
and a.pers_ncorr = d.pers_ncorr
and a.tpro_ccod  = d.tpro_ccod
and d.tpro_ccod  = e.tpro_ccod
and b.sede_ccod  = f.sede_ccod
and b.secc_ccod  = g.secc_ccod
and g.asig_ccod  = h.asig_ccod
and h.duas_ccod=3
and g.peri_ccod=202
and e.tpro_ccod=1
Union
select  distinct c.pers_tape_paterno, c.pers_tape_materno,c.pers_tnombre, protic.obtener_rut(c.pers_ncorr) as rut_profe,
protic.obtener_grado_docente(a.pers_ncorr,'G') as grado, protic.obtener_grado_docente(a.pers_ncorr,'D') as descripcion_grado,
(select min(prof_ingreso_uas)  from profesores where pers_ncorr=a.pers_ncorr group by pers_ncorr)as año_ingreso_upacifico,
(select max(cudo_titulo)  from curriculum_docente where pers_ncorr=a.pers_ncorr group by pers_ncorr)as profesion
from bloques_profesores a, bloques_horarios b, personas c, profesores d,
     tipos_profesores e, sedes f, secciones g, asignaturas h
where a.bloq_ccod=b.bloq_ccod
and a.bloq_ccod is not null
and a.cdoc_ncorr is not null
and a.pers_ncorr = c.pers_ncorr
and b.sede_ccod  = d.sede_ccod
and a.pers_ncorr = d.pers_ncorr
and a.tpro_ccod  = d.tpro_ccod
and d.tpro_ccod  = e.tpro_ccod
and b.sede_ccod  = f.sede_ccod
and b.secc_ccod  = g.secc_ccod
and g.asig_ccod  = h.asig_ccod
--and h.duas_ccod=3
and g.peri_ccod=204
order by c.pers_tape_paterno, c.pers_tape_materno,c.pers_tnombre

