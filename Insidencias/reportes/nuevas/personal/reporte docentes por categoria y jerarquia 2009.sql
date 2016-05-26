select distinct  ccos_ccod,b.pers_nrut as rut,b.pers_xdv as digito, b.pers_tnombre, b.pers_tape_paterno, b.pers_tape_materno,
carr_tdesc as carrera, jorn_tdesc as jornada, sede_tdesc as sede,
f.tcat_valor as monto, jdoc_tdesc as jerarquia, (select ccos_tcompuesto from centros_costo where ccos_ccod=h.ccos_ccod) as centro_costo
from carreras_docente a, personas b, carreras c, jornadas d, sedes e, tipos_categoria f, jerarquias_docentes g,centros_costos_asignados h ,periodos_academicos i
where a.peri_ccod=i.peri_ccod
and a.pers_ncorr=b.pers_ncorr
and a.carr_ccod=c.carr_ccod
and a.jorn_ccod=d.jorn_ccod
and a.sede_ccod=e.sede_ccod
and a.tcat_ccod=f.tcat_ccod
and f.jdoc_ccod=g.jdoc_ccod
and a.carr_ccod*=h.cenc_ccod_carrera
and a.jorn_ccod*=h.cenc_ccod_jornada
and a.sede_ccod*=h.cenc_ccod_sede
and i.anos_ccod=2009

-- and h.ccos_ccod*=i.ccos_ccod


-- select top 1 * from centros_costos_asignados