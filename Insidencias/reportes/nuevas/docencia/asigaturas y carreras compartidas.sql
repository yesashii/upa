select a.*,b.asig_ccod,f.asig_tdesc,d.plan_tdesc,j.sede_tdesc,i.carr_tdesc,e.espe_tdesc, g.duas_tdesc, h.nive_tdesc
from 
    (select c.carr_tdesc,d.sede_tdesc,e.jorn_tdesc,a.secc_ccod , h.ccos_tcompuesto 
    from SECCION_CARRERA_PLAN_COMUN a, secciones b, carreras c, sedes d, jornadas e,centros_costos_asignados g, centros_costo h 
    where a.secc_ccod=b.secc_ccod 
    and a.carr_ccod=c.carr_ccod
    and a.sede_ccod=d.sede_ccod
    and a.jorn_ccod=e.jorn_ccod
    and a.sede_ccod=g.cenc_ccod_sede
    and a.carr_ccod=g.cenc_ccod_carrera
    and a.jorn_ccod=g.cenc_ccod_jornada
    and g.ccos_ccod=h.ccos_ccod
    ) a, secciones b, malla_curricular c, planes_estudio d, 
    especialidades e, asignaturas f, duracion_asignatura g, niveles h, carreras i, sedes j
where a.secc_ccod=b.secc_ccod
and b.mall_ccod=c.mall_ccod
and c.plan_ccod=d.plan_ccod
and d.espe_ccod=e.espe_ccod
and b.asig_ccod=f.asig_ccod
and f.duas_ccod=g.duas_ccod
and c.nive_ccod=h.nive_ccod
and e.carr_ccod=i.carr_ccod
and b.sede_ccod=j.sede_ccod