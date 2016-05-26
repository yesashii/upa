-- morosos en general con matricula seg semestre 2008 sin carga

    select distinct pers_ncorr, protic.es_moroso_monto(pers_ncorr,getdate()) as  morosidad, 
    protic.obtener_rut(pers_ncorr) as rut,protic.obtener_nombre_completo(pers_ncorr, 'n') as nombre_alumno 
    from alumnos a, ofertas_academicas b, especialidades c, carreras d
    where a.ofer_ncorr=b.ofer_ncorr
    and b.espe_ccod=c.espe_ccod
    and c.carr_ccod=d.carr_ccod
    and d.tcar_ccod=1
    and b.peri_ccod=212
    and alum_nmatricula not in (7777)
    and protic.es_moroso(pers_ncorr,getdate())='S'
    and not exists (select 1 from cargas_academicas where matr_ncorr=a.matr_ncorr)

-- morosos com matricula el primer semestre y morosos sin matricula para el segundo
select distinct pers_ncorr, protic.obtener_rut(pers_ncorr) as rut,
b.sede_ccod as sede, b.jorn_ccod as jornada, d.carr_tdesc as carrera 
from alumnos a, ofertas_academicas b, especialidades c, carreras d
where a.ofer_ncorr=b.ofer_ncorr
and b.espe_ccod=c.espe_ccod
and c.carr_ccod=d.carr_ccod
and d.tcar_ccod=1
and b.peri_ccod=210
and emat_ccod not in (3,4,5,8,9,10,14)
and a.pers_ncorr not in (
                    select distinct b.pers_ncorr 
                    from cargas_academicas a, alumnos b, ofertas_academicas c
                    where a.matr_ncorr=b.matr_ncorr
                    and b.ofer_ncorr=c.ofer_ncorr
                    and c.peri_ccod=212)
and protic.es_moroso(a.pers_ncorr, getdate())='S'
and protic.retorna_tipo_contrato(a.post_ncorr,b.peri_ccod,'T')='C'


--alumnos morosos de publicidad  
  
    select distinct pers_ncorr,protic.obtener_rut(pers_ncorr) as rut, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre
    from alumnos a, ofertas_academicas b, especialidades c, carreras d
    where a.ofer_ncorr=b.ofer_ncorr
    and b.espe_ccod=c.espe_ccod
    and c.carr_ccod=d.carr_ccod
    and d.tcar_ccod=1
    and b.peri_ccod=212
    and d.carr_ccod=45
    and alum_nmatricula not in (7777)
    and emat_ccod in (1)
    and protic.es_moroso(pers_ncorr,getdate())='S'
    --and not exists (select 1 from cargas_academicas where matr_ncorr=a.matr_ncorr)




--alumnos morosos de publicidad  sin carga
    select distinct pers_ncorr,protic.obtener_rut(pers_ncorr) as rut, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre
    from alumnos a, ofertas_academicas b, especialidades c, carreras d
    where a.ofer_ncorr=b.ofer_ncorr
    and b.espe_ccod=c.espe_ccod
    and c.carr_ccod=d.carr_ccod
    and d.tcar_ccod=1
    and b.peri_ccod=212
    and d.carr_ccod=45
    and alum_nmatricula not in (7777)
    and emat_ccod in (1)
    and protic.es_moroso(pers_ncorr,getdate())='S'
    and not exists (select 1 from cargas_academicas where matr_ncorr=a.matr_ncorr)
    


-- Morosos solo con contrato anual

    select distinct protic.retorna_tipo_contrato(a.post_ncorr,210,'T'),pers_ncorr 
    from alumnos a, ofertas_academicas b, especialidades c, carreras d
    where a.ofer_ncorr=b.ofer_ncorr
    and b.espe_ccod=c.espe_ccod
    and c.carr_ccod=d.carr_ccod
    and d.tcar_ccod=1
    and b.peri_ccod=210
    and alum_nmatricula not in (7777)
    and protic.es_moroso(pers_ncorr,getdate())='S'
    and protic.retorna_tipo_contrato(b.post_ncorr,210,'T')='C'
    and not exists (select 1 from cargas_academicas where matr_ncorr=a.matr_ncorr)

