select distinct protic.obtener_rut(a.pers_ncorr) as rut_docente,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente,
protic.obtener_grado_docente(a.pers_ncorr,'G') as grado, protic.obtener_grado_docente(a.pers_ncorr,'D') as descripcion_grado,
protic.obtener_titulos_docente(a.pers_ncorr) as titulos_obtenidos,
sede_tdesc as sede, facu_tdesc as facultad,carr_tdesc as carrera, jorn_tdesc as jornada
from contratos_docentes_upa a, anexos b, personas c, carreras d, sedes e, 
areas_academicas f, facultades g, jornadas h
where ano_contrato=2011
and a.cdoc_ncorr=b.cdoc_ncorr
and b.eane_ccod not in (3)
and a.pers_ncorr=c.pers_ncorr
and b.carr_ccod=d.carr_ccod
and b.sede_ccod=e.sede_ccod
and d.area_ccod=f.area_ccod
and f.facu_ccod=g.facu_ccod
and b.jorn_ccod=h.jorn_ccod

