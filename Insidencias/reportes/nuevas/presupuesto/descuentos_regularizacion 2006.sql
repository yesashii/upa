--#####################################################
-- descuentos segun comprobante
--#####################################################
Select distinct a.ingr_nfolio_referencia, protic.trunc(a.ingr_fpago) as fecha,a.pers_ncorr,m.tcom_tdesc as compromiso,
l.dcom_ncompromiso,cast(l.dcom_mcompromiso as numeric) as monto_pactado,cast(k.abon_mabono as integer) as monto_descontado,
c.ting_tdesc, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno
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
    join tipos_compromisos m
        on l.tcom_ccod=m.tcom_ccod       
    Where b.ting_ccod in (
                        select ting_ccod 
                        from tipos_ingresos 
                        where ting_bregularizacion='S'
                        and ereg_ccod=4
                        )
        and a.eing_ccod not in (2,3,6)
       and datepart(year,a.ingr_fpago)='2006'
       group by  m.tcom_tdesc,l.dcom_ncompromiso,k.abon_mabono,l.dcom_mcompromiso,a.ingr_nfolio_referencia,a.ingr_fpago,b.ting_ccod,c.ting_tdesc,a.pers_ncorr



--#####################################################
-- descuentos segun admision
--#####################################################
Select d.matr_ncorr,a.ingr_nfolio_referencia ,
 protic.trunc(a.ingr_fpago) as fecha,a.pers_ncorr,cast(sum(l.dcom_mneto) as numeric) as monto_pactado,sum(cast(k.abon_mabono as integer)) as monto_descontado, c.ting_tdesc, 
 protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno
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
    Where b.ting_ccod in (
                        select ting_ccod 
                        from tipos_ingresos 
                        where ting_bregularizacion='S'
                        and ereg_ccod=4
                        )
        and a.eing_ccod not in (2,3,6)
        --and a.ingr_nfolio_referencia=78319
        --and a.pers_ncorr in (23566,18881,22449,21225)
        and i.peri_ccod in (202)
        and k.comp_ndocto in (select cont_ncorr as comp_ndocto from contratos where peri_ccod=202
                                union 
                                select  comp_ndocto from compromisos where pers_ncorr=a.pers_ncorr and tcom_ccod in (3,14))
                              
       and convert(datetime,a.ingr_fpago,103) between  convert(datetime,'01/10/2005',103) and convert(datetime,getdate(),103)
       group by  d.matr_ncorr,a.ingr_nfolio_referencia,a.ingr_fpago,b.ting_ccod,c.ting_tdesc,a.pers_ncorr
  
