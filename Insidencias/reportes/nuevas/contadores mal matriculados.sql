select c.carr_tdesc,b.espe_tdesc,c.carr_ccod,a.*,* 
from ofertas_academicas a,especialidades b,carreras c 
where ofer_ncorr in (14282,14158,14383)
and a.espe_ccod=b.espe_ccod 
and b.carr_ccod=c.carr_ccod
order by a.peri_ccod asc


--63: PLAN COMUN (V) SANTIAGO
select protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno,
protic.obtener_nombre_carrera(c.ofer_ncorr,'CEJ') as carrera 
from alumnos a, postulantes b , ofertas_academicas c
where c.espe_ccod in (63)
and a.post_ncorr=b.post_ncorr
and a.ofer_ncorr=c.ofer_ncorr
and b.peri_ccod=202

--286: CONTADOR AUDITOR (V) PLAN DE CONTINUIDAD DE ESTUDIOS PARA CONTADORES GENERALES
select protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno,
protic.obtener_nombre_carrera(c.ofer_ncorr,'CEJ') as carrera
 from alumnos a, postulantes b, ofertas_academicas c
where c.espe_ccod in (286)
and a.post_ncorr=b.post_ncorr
and a.ofer_ncorr=c.ofer_ncorr
and b.peri_ccod=200

-- alumnos que estaban en continuidad el segundo semestre y ahora estan en plan comun
select a.post_ncorr,a.ofer_ncorr,protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno,
protic.obtener_nombre_carrera(c.ofer_ncorr,'CEJ') as carrera, protic.ano_ingreso_carrera(a.pers_ncorr,'12') as año_carrera 
from alumnos a, postulantes b , ofertas_academicas c
where c.espe_ccod in (63)
and a.post_ncorr=b.post_ncorr
and a.ofer_ncorr=c.ofer_ncorr
and b.peri_ccod=202
and a.pers_ncorr in(
         select a.pers_ncorr from alumnos a, postulantes b, ofertas_academicas c
        where c.espe_ccod in (286)
        and a.post_ncorr=b.post_ncorr
        and a.ofer_ncorr=c.ofer_ncorr
        and b.peri_ccod=200
)

-- alumnos continuidad que no estaban en santiago antes
select protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno,
protic.obtener_nombre_carrera(c.ofer_ncorr,'CEJ') as carrera 
from alumnos a, postulantes b , ofertas_academicas c
where c.espe_ccod in (63)
and a.post_ncorr=b.post_ncorr
and a.ofer_ncorr=c.ofer_ncorr
and b.peri_ccod=202
and a.pers_ncorr not in(
        select a.pers_ncorr from alumnos a, postulantes b, ofertas_academicas c
        where c.espe_ccod in (286)
        and a.post_ncorr=b.post_ncorr
        and a.ofer_ncorr=c.ofer_ncorr
        and b.peri_ccod=200
)


-- Cajas involucradas
select mcaj_ncorr, protic.trunc(mcaj_finicio) as fecha_apertura,eren_ccod
 from movimientos_cajas  
 where mcaj_ncorr in (
select distinct  c.mcaj_ncorr, protic.obtener_rut(c.pers_ncorr)
 from contratos a, abonos b, ingresos c 
where a.post_ncorr in (60996,58309,58314,60994,60995,60998,61003,61004,61005,61007,61008,61009,61010,61011,61012,61018)
and a.cont_ncorr=b.comp_ndocto
and b.ingr_ncorr=c.ingr_ncorr
and c.ting_ccod=7
)

select distinct protic.obtener_rut(c.pers_ncorr) as rut_alumno, c.mcaj_ncorr, c.ingr_nfolio_referencia as comprobante, protic.trunc(ingr_fpago) as fecha
 from contratos a, abonos b, ingresos c 
where a.post_ncorr in (58309,58314,60994,60995,60998,61003,61004,61005,61007,61008,61009,61010,61011,61012,61018)
and a.cont_ncorr=b.comp_ndocto
and b.ingr_ncorr=c.ingr_ncorr
and c.ting_ccod=7

select * from detalle_ingresos where ding_ndocto=127 and ting_ccod=3 and envi_ncorr=6655
select * from detalle_ingresos_historial where ingr_ncorr_origen=221907 and ting_ccod=3 and envi_ncorr=6655


--CAJAS COLEGIOS DE CONTADORES CHILE
select distinct c.mcaj_ncorr, PROTIC.TRUNC(INGR_FPAGO) AS FECHA 
 from contratos a, abonos b, ingresos c 
where a.post_ncorr in (
    select b.post_ncorr 
    from alumnos a, postulantes b, ofertas_academicas c
    where c.espe_ccod in (63,187,186)
    and a.post_ncorr=b.post_ncorr
    and a.ofer_ncorr=c.ofer_ncorr
    and b.peri_ccod=202
    and convert(datetime,a.alum_fmatricula,103)>=convert(datetime,'01/05/2006',103)
)
and a.cont_ncorr=b.comp_ndocto
and b.ingr_ncorr=c.ingr_ncorr
and c.ting_ccod=7

select fecha,rut,alumno,caja,comprobante,tipo_beneficio,descuento_arancel,descuento_matricula,
max(matricula_bruto) as matricula_bruta,max(arancel_bruto) as arancel_bruto,carrera
 from (
select distinct protic.trunc(ingr_fpago) as fecha,protic.obtener_rut(c.pers_ncorr) as rut,protic.obtener_nombre_completo(c.pers_ncorr,'n') as alumno,
c.mcaj_ncorr as caja,c.ingr_nfolio_referencia as comprobante,e.tdet_tdesc as tipo_beneficio,
cast(sdes_mcolegiatura as numeric) as descuento_arancel,cast(sdes_mmatricula as numeric) as descuento_matricula,
case when f.tcom_ccod=1 then  cast(f.comp_mneto as integer) end as matricula_bruto,
case when f.tcom_ccod=2 then  cast(f.comp_mneto as integer) end as arancel_bruto,
case when f.tcom_ccod=2 then  cast(f.comp_mdocumento as integer) end as arancel_pagado,
protic.obtener_nombre_carrera((select top 1 ofer_ncorr from alumnos where matr_ncorr=a.matr_ncorr),'CEJ') as carrera 
 from contratos a 
 join abonos b
    on  a.cont_ncorr=b.comp_ndocto
 join ingresos c
    on b.ingr_ncorr=c.ingr_ncorr
 left outer join sdescuentos d
    on a.post_ncorr=d.post_ncorr
 left outer join tipos_detalle e
    on d.stde_ccod=e.tdet_ccod
    join compromisos f
    on a.cont_ncorr=f.comp_ndocto
where a.post_ncorr in (
    select b.post_ncorr 
    from alumnos a, postulantes b, ofertas_academicas c
    where c.espe_ccod in (63,187,186)
    and a.post_ncorr=b.post_ncorr
    and a.ofer_ncorr=c.ofer_ncorr
    and b.peri_ccod=202
    --and convert(datetime,a.alum_fmatricula,103)>=convert(datetime,'01/05/2006',103)
)
and c.ting_ccod=7
) as tabla
group by fecha,rut,alumno,caja,comprobante,tipo_beneficio,descuento_arancel,descuento_matricula,carrera
order by convert(datetime,fecha,103)


