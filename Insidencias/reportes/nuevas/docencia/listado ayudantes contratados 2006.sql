select distinct h.carr_tdesc as carrera,i.espe_tdesc as especialidad,c.asig_ccod as asignatura,e.secc_tdesc as seccion,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_ayudante,
    niay_ccod as nivel_ayudante,cast(c.dane_nsesiones/2 as integer) as numero_sesiones,
    cast((c.dane_nsesiones/2)*c.dane_msesion as numeric) as valor--,c.*
from contratos_docentes_upa a, anexos b, detalle_anexos c, bloques_profesores d, 
     secciones e, malla_curricular f, planes_estudio g, carreras h, especialidades i
where a.cdoc_ncorr=b.cdoc_ncorr
and b.anex_ncorr=c.anex_ncorr
and c.bloq_ccod=d.bloq_ccod
and b.tpro_ccod=d.tpro_ccod
and c.secc_ccod=e.secc_ccod
and e.mall_ccod=f.mall_ccod
and f.plan_ccod=g.plan_ccod
and b.carr_ccod=h.carr_ccod
and g.espe_ccod=i.espe_ccod
and a.ano_contrato=2006
and b.tpro_ccod=2
and b.eane_ccod=1


select * from movimientos_cajas WHERE     (MCAJ_NCORR = 3416)

select * from cajeros where caje_ccod=43