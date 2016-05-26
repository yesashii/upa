--*****************************************
-- DESCUENTOS POR CONTRATOS
select * from (
select protic.obtener_rut(d.pers_ncorr) as rut,protic.obtener_nombre_completo(d.pers_ncorr,'n') as alumno,
protic.obtener_nombre_carrera(d.ofer_ncorr,'CJ') as carrera,
protic.trunc(cont_fcontrato) fecha_descuento,case b.peri_ccod when '202' then 'Admision 2006' else 'Admision 2005' end as admision,
c.tdet_tdesc as tipo_descuento,cast(a.sdes_mcolegiatura as numeric) as arancel, cast(a.sdes_mmatricula as numeric) as matricula,
f.ingr_nfolio_referencia as comprobante,f.mcaj_ncorr as caja
from sdescuentos  a, contratos b, tipos_detalle c, alumnos d, abonos e, ingresos f
where a.post_ncorr=b.post_ncorr
and b.peri_ccod in (164,200,202)
and b.econ_ccod not in (2,3)
and a.stde_ccod=c.tdet_ccod
and b.post_ncorr=d.post_ncorr
and b.matr_ncorr=d.matr_ncorr
and b.cont_ncorr=e.comp_ndocto
and e.tcom_ccod in (1,2)
and e.ingr_ncorr=f.ingr_ncorr
and f.ting_ccod=7
and convert(datetime,cont_fcontrato,103) between  convert(datetime,'01/07/2005',103) and convert(datetime,'31/12/2005',103)
) as tabla
group by rut,alumno,carrera,admision,fecha_descuento,tipo_descuento,arancel,matricula,comprobante,caja


--*****************************************
-- DESCUENTOS POR REGULARIZACION

Select  protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno,
protic.obtener_nombre_carrera(e.ofer_ncorr,'CJ') as carrera,
protic.trunc(ingr_fpago) fecha_descuento,
case l.peri_ccod when '202' then 'Admision 2006' else 'Admision 2005' end as admision,
c.ting_tdesc as tipo_descuento,
case k.tcom_ccod when 2 then sum(cast(k.abon_mabono as integer)) end as arancel,
case k.tcom_ccod when 1 then sum(cast(k.abon_mabono as integer)) end as matricula,
a.ingr_nfolio_referencia as comprobante,a.mcaj_ncorr as caja 
From ingresos a
join  detalle_ingresos b 
    on a.ingr_ncorr=b.ingr_ncorr
join  tipos_ingresos c
    on b.ting_ccod=c.ting_ccod
join  abonos k  
    on a.ingr_ncorr=k.ingr_ncorr
    and k.tcom_ccod in (1,2)
join  detalle_compromisos l  
    on k.tcom_ccod=l.tcom_ccod
    and k.inst_ccod=l.inst_ccod
    and k.comp_ndocto=l.comp_ndocto
    and k.dcom_ncompromiso=l.dcom_ncompromiso
    and l.tcom_ccod in (1,2)
join  postulantes i  
    on a.pers_ncorr=i.pers_ncorr
    and protic.obtener_post_ncorr(a.pers_ncorr,k.comp_ndocto,a.ingr_ncorr)=i.post_ncorr    
join  alumnos d 
    on i.post_ncorr=d.post_ncorr
join  ofertas_academicas e 
    on d.ofer_ncorr=e.ofer_ncorr
left outer join  codeudor_postulacion m  
    on i.post_ncorr=m.post_ncorr 
left outer join  personas_postulante n 
    on m.pers_ncorr=n.pers_ncorr
Where b.ting_ccod in (
                    select ting_ccod 
                    from tipos_ingresos 
                    where ting_bregularizacion='S'
                    )
    and a.eing_ccod not in (3,6)
    and d.emat_ccod not in (9) 
    and i.peri_ccod in (164,200,202)
    and convert(datetime,a.ingr_fpago,103) between  convert(datetime,'01/07/2005',103) and convert(datetime,'31/12/2005',103)
   group by  k.tcom_ccod,a.mcaj_ncorr,a.ingr_nfolio_referencia,a.ingr_fpago,e.ofer_ncorr,l.peri_ccod,n.pers_ncorr,b.ting_ccod,c.ting_tdesc,a.pers_ncorr, d.ofer_ncorr


