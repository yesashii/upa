select distinct f.tcom_ccod,cast(f.comp_mneto as integer) as monto_bruto,cast(isnull(sdes_mcolegiatura,0) as integer) as descuento_arancel,
cast(isnull(sdes_mmatricula,0) as integer) as descuento_matricula,
cast(f.comp_mdocumento as integer) as monto_pagado,i.ingr_nfolio_referencia as comprobante,
isnull((select tdet_tdesc from tipos_detalle where tdet_ccod=g.stde_ccod),'Sin Beneficio') as beneficio,
protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno,j.sede_tdesc  as sede,
protic.obtener_nombre_carrera(d.ofer_ncorr,'CEJ') as carrera, convert(datetime,protic.trunc(alum_fmatricula),103) as fecha
from alumnos a
join postulantes b
    on a.pers_ncorr=b.pers_ncorr
    and a.post_ncorr=b.post_ncorr
join contratos c
    on a.matr_ncorr=c.matr_ncorr
    and c.econ_ccod=1 
join ofertas_academicas d
    on b.ofer_ncorr=d.ofer_ncorr
    and d.ofer_ncorr=32130
join especialidades e
    on d.espe_ccod=e.espe_ccod
left outer join compromisos f
    on c.cont_ncorr=f.comp_ndocto
    and f.tcom_ccod in (1,2)
left outer join sdescuentos g
    on a.post_ncorr=g.post_ncorr
    and d.ofer_ncorr=g.ofer_ncorr
    /*and case when sdes_mmatricula> 0 then 1 else 0 end = f.tcom_ccod
    and case when sdes_mcolegiatura> 0 then 2 else 0 end = f.tcom_ccod*/
left outer join abonos h
    on f.comp_ndocto=h.comp_ndocto
    and h.tcom_ccod in (1,2)
left outer join ingresos i
    on h.ingr_ncorr=i.ingr_ncorr
    and i.ting_ccod=7
join sedes j
    on d.sede_ccod=j.sede_ccod    
where  e.carr_ccod in ('110')
and d.sede_ccod=9
--and d.jorn_ccod in (1)
and b.peri_ccod in (226)
and a.emat_ccod in (1,4,8,2,13)
and i.ingr_nfolio_referencia is not null
--and convert(datetime,protic.trunc(alum_fmatricula),103)<= convert(datetime,'31/07/2006',103)
order by convert(datetime,protic.trunc(alum_fmatricula),103) desc