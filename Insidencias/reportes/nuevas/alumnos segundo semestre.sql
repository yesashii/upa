-- alumnos matriculados para segundo semestre
select protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,
protic.trunc(g.cont_fcontrato) as fecha_matricula,e.sede_tdesc as sede,f.jorn_tdesc as jornada,
protic.obtener_nombre_carrera(b.ofer_ncorr,'CE') as carrera, protic.es_nuevo_carrera(a.pers_ncorr,d.carr_ccod,200) as nuevo
from postulantes a, alumnos b, ofertas_academicas c, especialidades d, sedes e, jornadas f, contratos g
where a.peri_ccod=204
and a.post_ncorr=b.post_ncorr
and b.ofer_ncorr=c.ofer_ncorr
and b.matr_ncorr=g.matr_ncorr
and c.espe_ccod=d.espe_ccod
and c.sede_ccod=e.sede_ccod
and c.jorn_ccod=f.jorn_ccod
and a.post_bnuevo='S'
--and protic.es_nuevo_carrera(a.pers_ncorr,d.carr_ccod,204)='S'
and b.emat_ccod not in (9)
and g.audi_tusuario not in ('contrato -CREAR_MATRICULA_SEG_SEMESTRE')
and (select count(*) from contratos aa, alumnos bb 
                where aa.matr_ncorr=bb.matr_ncorr
                and aa.peri_ccod in(
                    select b.peri_ccod from periodos_academicos a, periodos_academicos b
                    where a.anos_ccod=b.anos_ccod
                    and a.peri_ccod=204
                )
                and bb.pers_ncorr=a.pers_ncorr
                and aa.audi_tusuario not in ('contrato -CREAR_MATRICULA_SEG_SEMESTRE')
        ) = 1
order by g.cont_fcontrato asc



