-- profesores profesionales
select carrera,jornada,grado, count(*) as cantidad, valor, cast(cast(count(*)*100 as decimal(6,2))/valor as decimal(4,2)) as indice
from (
select distinct carr_tdesc as carrera, jorn_tdesc as jornada,
protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente,
protic.obtener_grado_docente(a.pers_ncorr,'G') as grado,
(select count(*) from (
    select distinct a.pers_ncorr
    from contratos_docentes_upa a, anexos b, personas c, profesores d
    where ano_contrato=2007
    and a.cdoc_ncorr=b.cdoc_ncorr
    and a.pers_ncorr=c.pers_ncorr
    and a.ecdo_ccod not in (3)
    and c.pers_ncorr=d.pers_ncorr
    and d.tpro_ccod=1
    and a.tpro_ccod=1
) as profes) as valor
from contratos_docentes_upa a, anexos b, personas c, profesores d, carreras e, jornadas f
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and a.pers_ncorr=c.pers_ncorr
and a.ecdo_ccod not in (3)
and c.pers_ncorr=d.pers_ncorr
and d.tpro_ccod=1
and a.tpro_ccod=1
and b.carr_ccod=e.carr_ccod
and b.jorn_ccod=f.jorn_ccod
and protic.obtener_grado_docente(a.pers_ncorr,'G') in ('PROFESIONAL','LICENCIADO')
) as tabla
group by carrera,jornada,grado,valor

-- profesores MAGISTER
select distinct protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente,
protic.obtener_grado_docente(a.pers_ncorr,'G') as grado
from contratos_docentes_upa a, anexos b, personas c, profesores d
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and a.pers_ncorr=c.pers_ncorr
and a.ecdo_ccod not in (3)
and c.pers_ncorr=d.pers_ncorr
and d.tpro_ccod=1
and a.tpro_ccod=1
and protic.obtener_grado_docente(a.pers_ncorr,'G') in ('MAGISTER', 'MAESTRIA')



-- profesores DOCTORES
select distinct protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente,
protic.obtener_grado_docente(a.pers_ncorr,'G') as grado
from contratos_docentes_upa a, anexos b, personas c, profesores d
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and a.pers_ncorr=c.pers_ncorr
and a.ecdo_ccod not in (3)
and c.pers_ncorr=d.pers_ncorr
and d.tpro_ccod=1
and a.tpro_ccod=1
and protic.obtener_grado_docente(a.pers_ncorr,'G') in ('DOCTORADO')

-- PROFESORES QUE IMPRATEN CLASES EN CARRERAS PROFESIONALES
select count(*) from (
    select distinct a.pers_ncorr
    from contratos_docentes_upa a, anexos b, personas c, profesores d
    where ano_contrato=2007
    and a.cdoc_ncorr=b.cdoc_ncorr
    and a.pers_ncorr=c.pers_ncorr
    and a.ecdo_ccod not in (3)
    and c.pers_ncorr=d.pers_ncorr
    and d.tpro_ccod=1
    and a.tpro_ccod=1
    and b.carr_ccod in (select carr_ccod 
                        from carreras 
                        where tgra_ccod in (2,3,7))
) as tabla                    



select * from carreras

