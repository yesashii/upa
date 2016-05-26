select distinct protic.obtener_rut(d.pers_ncorr) as rut,protic.obtener_nombre_completo(d.pers_ncorr,'n') as nombre_docente,
jdoc_tdesc as jerarquia,tcat_tdesc,c.peri_tdesc, carr_tdesc as carrera,jorn_tdesc as jornada,sede_tdesc as sede,
tcdo_tdesc as tipo_contrato,   protic.obtener_grado_docente(d.pers_ncorr,'G') as grado,protic.obtener_grado_docente(d.pers_ncorr,'D') as descripcion_grado
from tipos_categoria a, jerarquias_docentes b, periodos_academicos c, carreras_docente d, 
contratos_docentes_upa e, tipos_contratos_docentes f, carreras g, jornadas h, sedes i
where a.jdoc_ccod=b.jdoc_ccod
and a.peri_ccod=c.peri_ccod
and a.anos_ccod=2008
and a.tcat_ccod=d.tcat_ccod
and a.peri_ccod=d.peri_ccod
and d.pers_ncorr=e.pers_ncorr
and a.anos_ccod=e.ano_contrato
and e.ecdo_ccod=1
and e.tcdo_ccod=f.tcdo_ccod
and d.carr_ccod=g.carr_ccod
and d.jorn_ccod=h.jorn_ccod
and d.sede_ccod=i.sede_ccod
and a.jdoc_ccod not in (0)



protic.obtener_grado_docente(aa.pers_ncorr,'G') as grado,protic.obtener_grado_docente(aa.pers_ncorr,'D') as descripcion_grado,

select top 1 * from tipos_contratos_docentes