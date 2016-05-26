select protic.obtener_rut(a.pers_ncorr) as rut_docente,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente,
k.jdoc_tdesc as jerarquia, 
(select tcat_valor from tipos_categoria where tcat_ccod in (protic.obtiene_categoria_carrera(a.pers_ncorr,e.sede_ccod,d.carr_ccod,h.jorn_ccod,206,0))) as valor_categoria,
sede_tdesc as sede, facu_tdesc as facultad,carr_tdesc as carrera, jorn_tdesc as jornada
from contratos_docentes_upa a, anexos b, personas c, carreras d, sedes e, 
areas_academicas f, facultades g, jornadas h, profesores i,jerarquias_docentes k
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and b.eane_ccod not in (3)
and a.pers_ncorr=c.pers_ncorr
and b.carr_ccod=d.carr_ccod
and b.sede_ccod=e.sede_ccod
and d.area_ccod=f.area_ccod
and f.facu_ccod=g.facu_ccod
and b.jorn_ccod=h.jorn_ccod
and b.sede_ccod=i.sede_ccod
and a.pers_ncorr=i.pers_ncorr
and i.jdoc_ccod=k.jdoc_ccod


