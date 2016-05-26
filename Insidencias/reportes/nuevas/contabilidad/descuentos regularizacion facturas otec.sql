select distinct aplicado_sobre,monto_descontado,sobre_monto,promocion,comprobante,caja,beneficio,
fecha as fecha_asignacion,rut,nombre_alumno,cast(isnull(max(arancel),0) as numeric) as arancel, carrera, ting_tdesc as documento
from (
Select distinct a.mcaj_ncorr as caja,a.ingr_nfolio_referencia as comprobante ,m.tcom_tdesc as aplicado_sobre,
 protic.trunc(a.ingr_fpago) as fecha,a.pers_ncorr,sum(cast(k.abon_mabono as integer)) as monto_descontado,cast(sum(l.dcom_mneto) as numeric) as sobre_monto, c.ting_tdesc as beneficio, 
 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno,
( select top 1 aran_mcolegiatura from aranceles where ofer_ncorr in (select top 1 ofer_ncorr from alumnos where matr_ncorr=d.matr_ncorr and emat_ccod not in (9))) as arancel,
protic.obtener_nombre_carrera((select top 1 ofer_ncorr from alumnos where matr_ncorr=d.matr_ncorr and emat_ccod not in (9)),'CJ') as carrera,
( select top 1 aran_nano_ingreso from aranceles where ofer_ncorr in (select top 1 ofer_ncorr from alumnos where matr_ncorr=d.matr_ncorr and emat_ccod not in (9))) as promocion,
protic.documento_asociado_cuota(k.tcom_ccod,k.inst_ccod,k.comp_ndocto,k.dcom_ncompromiso,'ting_ccod') as tipo
From ingresos a
    join  detalle_ingresos b 
        on a.ingr_ncorr=b.ingr_ncorr
    join  tipos_ingresos c
        on b.ting_ccod=c.ting_ccod
    join  postulantes i  
        on a.pers_ncorr=i.pers_ncorr    
    join  alumnos d 
        on i.post_ncorr=d.post_ncorr
        and d.emat_ccod not in (9)
    join  ofertas_academicas e 
        on d.ofer_ncorr=e.ofer_ncorr
    join  especialidades g  
        on e.espe_ccod=g.espe_ccod
    join  carreras f  
        on g.carr_ccod=f.carr_ccod 
    join  estados_matriculas j  
        on d.emat_ccod=j.emat_ccod
    join  abonos k  
        on a.ingr_ncorr=k.ingr_ncorr
    join  detalle_compromisos l  
        on k.tcom_ccod=l.tcom_ccod
        and k.inst_ccod=l.inst_ccod
        and k.comp_ndocto=l.comp_ndocto
        and k.dcom_ncompromiso=l.dcom_ncompromiso
    left outer join tipos_compromisos m
        on l.tcom_ccod=m.tcom_ccod
    Where b.ting_ccod in (123,124,125)
        and a.eing_ccod not in (3,6)
       group by m.tcom_tdesc,l.tcom_ccod,a.mcaj_ncorr,d.matr_ncorr,a.ingr_nfolio_referencia,a.ingr_fpago,b.ting_ccod,c.ting_tdesc,a.pers_ncorr
       ,k.tcom_ccod,k.inst_ccod,k.comp_ndocto,k.dcom_ncompromiso
)  as tabla left outer join tipos_ingresos b
on tabla.tipo=b.ting_ccod
group by fecha,aplicado_sobre,monto_descontado,sobre_monto,beneficio,
nombre_alumno, rut,carrera, caja,comprobante,promocion, ting_tdesc