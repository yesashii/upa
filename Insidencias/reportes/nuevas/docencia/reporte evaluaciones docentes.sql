-- Reporte de Evaluaciones docentes 
select distinct protic.obtener_rut(pers_ncorr_encuestado) as rut,c.sede_tdesc as sede, e.carr_tdesc as carrera, d.jorn_tdesc as jornada,f.nive_ccod as nivel, 
b.asig_ccod as asignatura,h.asig_tdesc as asignatura,b.secc_tdesc as seccion, g.peri_tdesc as periodo_academico,
protic.obtener_nombre_completo(pers_ncorr_destino,'n') as profesor,
preg_1-99 as preg_1,
preg_2-99 as preg_2,
preg_3-99 as preg_3,
preg_4-99 as preg_4,
preg_5-99 as preg_5,
preg_6-99 as preg_6,
preg_7-99 as preg_7,
preg_8-99 as preg_8,
preg_9-99 as preg_9,
preg_10-99 as preg_10,
preg_11-99 as preg_11,
preg_12-99 as preg_12,
preg_13-99 as preg_13,
preg_14-99 as preg_14,
preg_15-99 as preg_15,
preg_16-99 as preg_16,
preg_17-99 as preg_17,
preg_18-99 as preg_18,
preg_19-99 as preg_19,
preg_20-99 as preg_20,
preg_21-99 as preg_21,
preg_22-99 as preg_22,
preg_23-99 as preg_23,
preg_24-99 as preg_24,
preg_25-99 as preg_25,
preg_26-99 as preg_26,
preg_27-99 as preg_27,
preg_28-99 as preg_28,
preg_29-99 as preg_29,
preg_30-99 as preg_30,
a.observaciones
from evaluacion_docente a, secciones b , sedes c, jornadas d, carreras e, malla_curricular f, periodos_academicos g, asignaturas h
where a.peri_ccod in (206,208,209)
and a.secc_ccod=b.secc_ccod
and b.sede_ccod=c.sede_ccod
and b.jorn_ccod=d.jorn_ccod
and b.carr_ccod=e.carr_ccod
and b.mall_ccod=f.mall_ccod
and a.peri_ccod=g.peri_ccod
and b.asig_ccod=h.asig_ccod
order by periodo_academico,profesor,asignatura


