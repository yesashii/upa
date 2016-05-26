select distinct case f.tcom_ccod when 1 then 'MATRICULA' when 2 then 'ARANCEL' end as concepto,cast(f.comp_mneto as integer) as monto_bruto,
i.ingr_nfolio_referencia as comprobante,protic.trunc(ingr_fpago) as fecha_ingreso,
protic.obtener_rut(a.pers_ncorr) as rut,protic.obtener_nombre_completo(a.pers_ncorr,'n') as alumno,j.sede_tdesc  as sede,
protic.obtener_nombre_carrera(d.ofer_ncorr,'CEJ') as carrera,ccos_tcompuesto as centro_costo
from alumnos a
join postulantes b
    on a.pers_ncorr=b.pers_ncorr
    and a.post_ncorr=b.post_ncorr
join contratos c
    on a.matr_ncorr=c.matr_ncorr
    and c.econ_ccod=1 
join ofertas_academicas d
    on b.ofer_ncorr=d.ofer_ncorr
join especialidades e
    on d.espe_ccod=e.espe_ccod
join compromisos f
    on c.cont_ncorr=f.comp_ndocto
    and f.tcom_ccod in (1,2)
join abonos h
    on f.comp_ndocto=h.comp_ndocto
    and h.tcom_ccod in (1,2)
left outer join ingresos i
    on h.ingr_ncorr=i.ingr_ncorr
    and i.ting_ccod=7
join sedes j
    on d.sede_ccod=j.sede_ccod
left outer join centros_costos_asignados z    	
	on z.cenc_ccod_carrera  =e.carr_ccod       
	and z.cenc_ccod_sede    =d.sede_ccod       
	and z.cenc_ccod_jornada =d.jorn_ccod    	
left outer join centros_costo za    			
	on za.ccos_ccod=z.ccos_ccod          
where b.peri_ccod in (218)
and a.emat_ccod in (1,4,8,2,13)
and convert(datetime,ingr_fpago,103) between  convert(datetime,'01/02/2010',103) and convert(datetime,getdate(),103)
order by protic.trunc(ingr_fpago),protic.obtener_rut(a.pers_ncorr)desc