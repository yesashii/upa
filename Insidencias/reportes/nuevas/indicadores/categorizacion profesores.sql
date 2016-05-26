-- cantidad de profesores
select count(*) as cantitad 
    from (
        select  distinct a.pers_ncorr,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente
        from contratos_docentes_upa a, anexos b, personas c, profesores d
        where ano_contrato=2006
        and a.cdoc_ncorr=b.cdoc_ncorr
        and a.pers_ncorr=c.pers_ncorr
        and a.ecdo_ccod not in (3)
        and c.pers_ncorr=d.pers_ncorr
        and d.tpro_ccod=1
        and a.tpro_ccod=1
    ) as tabla


--*******************************
-- Academicos por categoria

-- Profesor Titular (A)
select distinct d.jdoc_ccod,e.jdoc_tdesc as jerarquia,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente
from contratos_docentes_upa a, anexos b, personas c, profesores d, jerarquias_docentes e
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and a.pers_ncorr=c.pers_ncorr
and a.ecdo_ccod not in (3)
and c.pers_ncorr=d.pers_ncorr
and d.tpro_ccod=1
and a.tpro_ccod=1
and d.jdoc_ccod=e.jdoc_ccod
and d.jdoc_ccod=1

-- Profesor Titular (B)
select distinct d.jdoc_ccod,e.jdoc_tdesc as jerarquia,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente
from contratos_docentes_upa a, anexos b, personas c, profesores d, jerarquias_docentes e
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and a.pers_ncorr=c.pers_ncorr
and a.ecdo_ccod not in (3)
and c.pers_ncorr=d.pers_ncorr
and d.tpro_ccod=1
and a.tpro_ccod=1
and d.jdoc_ccod=e.jdoc_ccod
and d.jdoc_ccod=2

-- Profesor Asociado (A)
select distinct d.jdoc_ccod,e.jdoc_tdesc as jerarquia,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente
from contratos_docentes_upa a, anexos b, personas c, profesores d, jerarquias_docentes e
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and a.pers_ncorr=c.pers_ncorr
and a.ecdo_ccod not in (3)
and c.pers_ncorr=d.pers_ncorr
and d.tpro_ccod=1
and a.tpro_ccod=1
and d.jdoc_ccod=e.jdoc_ccod
and d.jdoc_ccod=3

-- Profesor Asociado (B)
select distinct d.jdoc_ccod,e.jdoc_tdesc as jerarquia,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente
from contratos_docentes_upa a, anexos b, personas c, profesores d, jerarquias_docentes e
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and a.pers_ncorr=c.pers_ncorr
and a.ecdo_ccod not in (3)
and c.pers_ncorr=d.pers_ncorr
and d.tpro_ccod=1
and a.tpro_ccod=1
and d.jdoc_ccod=e.jdoc_ccod
and d.jdoc_ccod=4

-- Profesor Asistente (A)
select distinct d.jdoc_ccod,e.jdoc_tdesc as jerarquia,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente
from contratos_docentes_upa a, anexos b, personas c, profesores d, jerarquias_docentes e
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and a.pers_ncorr=c.pers_ncorr
and a.ecdo_ccod not in (3)
and c.pers_ncorr=d.pers_ncorr
and d.tpro_ccod=1
and a.tpro_ccod=1
and d.jdoc_ccod=e.jdoc_ccod
and d.jdoc_ccod=5

-- Profesor Asistente (B)
select distinct d.jdoc_ccod,e.jdoc_tdesc as jerarquia,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente
from contratos_docentes_upa a, anexos b, personas c, profesores d, jerarquias_docentes e
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and a.pers_ncorr=c.pers_ncorr
and a.ecdo_ccod not in (3)
and c.pers_ncorr=d.pers_ncorr
and d.tpro_ccod=1
and a.tpro_ccod=1
and d.jdoc_ccod=e.jdoc_ccod
and d.jdoc_ccod=6

-- Profesor Instructor (A)
select distinct d.jdoc_ccod,e.jdoc_tdesc as jerarquia,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente
from contratos_docentes_upa a, anexos b, personas c, profesores d, jerarquias_docentes e
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and a.pers_ncorr=c.pers_ncorr
and a.ecdo_ccod not in (3)
and c.pers_ncorr=d.pers_ncorr
and d.tpro_ccod=1
and a.tpro_ccod=1
and d.jdoc_ccod=e.jdoc_ccod
and d.jdoc_ccod=7

-- Profesor Instructor (B)
select distinct d.jdoc_ccod,e.jdoc_tdesc as jerarquia,protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente
from contratos_docentes_upa a, anexos b, personas c, profesores d, jerarquias_docentes e
where ano_contrato=2007
and a.cdoc_ncorr=b.cdoc_ncorr
and a.pers_ncorr=c.pers_ncorr
and a.ecdo_ccod not in (3)
and c.pers_ncorr=d.pers_ncorr
and d.tpro_ccod=1
and a.tpro_ccod=1
and d.jdoc_ccod=e.jdoc_ccod
and d.jdoc_ccod=8