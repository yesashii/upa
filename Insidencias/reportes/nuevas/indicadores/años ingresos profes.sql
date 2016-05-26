-- años ingresos profesores
select sum (cantidad), sum (producto) from (
select ingreso,count(*) as cantidad,  (ingreso*count(*)) as producto
from  (
    select distinct isnull(prof_ingreso_uas,0) as ingreso,
    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente
    from contratos_docentes_upa a, anexos b, personas c, profesores d
    where ano_contrato=2007
    and a.cdoc_ncorr=b.cdoc_ncorr
    and a.pers_ncorr=c.pers_ncorr
    and a.ecdo_ccod not in (3)
    and c.pers_ncorr=d.pers_ncorr
    and d.tpro_ccod=1
    and a.tpro_ccod=1
) as tabla
group by ingreso
) as tabla_2


-- Edad de profesores
select edad,count(*) as cantidad,  (edad*count(*)) as producto
from  (
    select distinct DATEDIFF(year,isnull(c.pers_fnacimiento,getdate()),getdate()) as edad,
    protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente
    from contratos_docentes_upa a, anexos b, personas c, profesores d
    where ano_contrato=2007
    and a.cdoc_ncorr=b.cdoc_ncorr
    and a.pers_ncorr=c.pers_ncorr
    and a.ecdo_ccod not in (3)
    and c.pers_ncorr=d.pers_ncorr
    and d.tpro_ccod=1
    and a.tpro_ccod=1
) as tabla
group by edad