Select b.ting_ccod,a.pers_ncorr,sum(cast(k.abon_mabono as integer)) as monto_descontado,cast(sum(l.dcom_mneto) as numeric) as total,
 c.ting_tdesc, f.carr_tdesc,case e.jorn_ccod when 1 then 'Diurno' when 2 then 'Vespertino' end as jornada,
 j.emat_tdesc, protic.obtener_rut(a.pers_ncorr) as rut, protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_alumno,
 protic.obtener_nombre_completo(n.pers_ncorr,'n') as nombre_apoderado,protic.obtener_rut(n.pers_ncorr) as rut_apoderado,
 isnull(protic.obtener_direccion_letra(n.pers_ncorr,1,'CNPB'),protic.obtener_direccion_letra(n.pers_ncorr,2,'CNPB')) direccion_apoderado
From ingresos a
join  detalle_ingresos b 
    on a.ingr_ncorr=b.ingr_ncorr
join  tipos_ingresos c
    on b.ting_ccod=c.ting_ccod
join  postulantes i  
    on a.pers_ncorr=i.pers_ncorr    
join  alumnos d 
    on i.post_ncorr=d.post_ncorr
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
   group by  e.jorn_ccod ,n.pers_ncorr,b.ting_ccod,c.ting_tdesc,a.pers_ncorr,f.carr_tdesc,j.emat_tdesc
    




--select * from alumnos where pers_ncorr=13315