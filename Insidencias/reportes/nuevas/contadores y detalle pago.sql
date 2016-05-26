select distinct num,protic.obtener_rut(b.pers_ncorr) as rut_alumno,protic.obtener_nombre_completo(b.pers_ncorr,'n') as alumno,
f.ingr_nfolio_referencia as comprobante, i.emat_tdesc as estado_alumno, 
l.tcom_tdesc as compromiso,j.ting_tdesc as documento, h.edin_tdesc as estado, 
case when g.ding_ndocto is null and f.ingr_mefectivo is not null then 0 else g.ding_ndocto end as num_docto,
case when g.ding_ndocto is null and f.ingr_mefectivo is not null then f.ingr_mefectivo else cast(g.ding_mdetalle as numeric) end as monto,  
protic.trunc(g.ding_fdocto) as fecha_docto,
protic.obtener_nombre_carrera(c.ofer_ncorr,'CEJ') as carrera,k.peri_tdesc as periodo_academico
from fox..sd_det_pag_contadores a 
join personas b
    on a.rut=b.pers_nrut
join alumnos c
    on b.pers_ncorr=c.pers_ncorr
join estados_matriculas i
    on c.emat_ccod=i.emat_ccod    
join contratos d
     on c.matr_ncorr=d.matr_ncorr
join abonos e
    on d.cont_ncorr=e.comp_ndocto
join ingresos f
    on e.ingr_ncorr=f.ingr_ncorr
    and f.ting_ccod=7
left outer join detalle_ingresos g
    on f.ingr_ncorr=g.ingr_ncorr
join estados_detalle_ingresos h
    on g.edin_ccod=h.edin_ccod
join tipos_ingresos j
    on isnull(g.ting_ccod,6)=j.ting_ccod
join periodos_academicos k
    on d.peri_ccod=k.peri_ccod 
join tipos_compromisos l
    on e.tcom_ccod=l.tcom_ccod                               
where d.peri_ccod=200
UNION
select distinct num,protic.obtener_rut(b.pers_ncorr) as rut_alumno,protic.obtener_nombre_completo(b.pers_ncorr,'n') as alumno,
f.ingr_nfolio_referencia as comprobante, i.emat_tdesc as estado_alumno, 
l.tcom_tdesc as compromiso,j.ting_tdesc as documento, h.edin_tdesc as estado, 
case when g.ding_ndocto is null and f.ingr_mefectivo is not null then 0 else g.ding_ndocto end as num_docto,
case when g.ding_ndocto is null and f.ingr_mefectivo is not null then f.ingr_mefectivo else cast(g.ding_mdetalle as numeric) end as monto,  
protic.trunc(g.ding_fdocto) as fecha_docto,
protic.obtener_nombre_carrera(c.ofer_ncorr,'CEJ') as carrera, k.peri_tdesc as periodo_academico
from fox..sd_det_pag_contadores a 
join personas b
    on a.rut=b.pers_nrut
join alumnos c
    on b.pers_ncorr=c.pers_ncorr
join estados_matriculas i
    on c.emat_ccod=i.emat_ccod    
join contratos d
     on c.matr_ncorr=d.matr_ncorr
join abonos e
    on d.cont_ncorr=e.comp_ndocto
join ingresos f
    on e.ingr_ncorr=f.ingr_ncorr
    and f.ting_ccod=7
left outer join detalle_ingresos g
    on f.ingr_ncorr=g.ingr_ncorr
left outer join estados_detalle_ingresos h
    on g.edin_ccod=h.edin_ccod
left outer join tipos_ingresos j
    on isnull(g.ting_ccod,6)=j.ting_ccod                       
join periodos_academicos k
    on d.peri_ccod=k.peri_ccod
join tipos_compromisos l
    on e.tcom_ccod=l.tcom_ccod         
where d.peri_ccod=164
--and b.pers_ncorr=12706
