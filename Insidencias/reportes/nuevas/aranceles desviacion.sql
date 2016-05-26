select rut,alumno,carrera,admision,fecha_contrato,max(arancel) as arancel,max(matricula) as matricula,comprobante,caja 
from (
        select  protic.obtener_rut(d.pers_ncorr) as rut,protic.obtener_nombre_completo(d.pers_ncorr,'n') as alumno,
        protic.obtener_nombre_carrera(d.ofer_ncorr,'CJ') as carrera,
        protic.trunc(cont_fcontrato) fecha_contrato,case b.peri_ccod when '202' then 'Admision 2006' else 'Admision 2005' end as admision,
        case a.tcom_ccod when 2 then cast(a.comp_mneto as numeric) end as arancel,
        case a.tcom_ccod when 1 then cast(a.comp_mneto as numeric) end as matricula,
        f.ingr_nfolio_referencia as comprobante,f.mcaj_ncorr as caja
        from compromisos  a, contratos b, alumnos d, abonos e, ingresos f
        where a.comp_ndocto=b.cont_ncorr
        and b.peri_ccod in (164,200,202)
        and b.econ_ccod not in (2,3)
        and b.post_ncorr=d.post_ncorr
        and b.matr_ncorr=d.matr_ncorr
        and b.cont_ncorr=e.comp_ndocto
        and e.tcom_ccod in (1,2)
        and e.ingr_ncorr=f.ingr_ncorr
        and f.ting_ccod=7
        and convert(datetime,cont_fcontrato,103) between  convert(datetime,'01/07/2005',103) and convert(datetime,'31/12/2005',103)
) as tabla
group by rut,alumno,carrera,admision,fecha_contrato,comprobante,caja



select * from estados_rangos_boletas

select protic.obtener_rut(pers_ncorr),* 
from alumnos a, ofertas_academicas b 
where a.ofer_ncorr=b.ofer_ncorr
and b.espe_ccod=286
and b.peri_ccod=202

select * from especialie