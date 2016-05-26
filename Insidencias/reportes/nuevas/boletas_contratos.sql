select mcaj_ncorr,cont_ncorr, max(cast(total_matricula as numeric)) as matricula, max(cast(total_arancel as numeric)) as arancel, cont_fcontrato,econ_tdesc,rut_alumno,alumno, rut_codeudor, codeudor 
from (
select e.mcaj_ncorr,a.post_ncorr,a.cont_ncorr,b.tcom_ccod,h.tcom_tdesc,case b.tcom_ccod when 1 then sum(e.ingr_mtotal) end as total_matricula,case b.tcom_ccod when 2 then sum(e.ingr_mtotal) end as total_arancel ,a.cont_fcontrato, a.econ_ccod,g.econ_tdesc,b.pers_ncorr, 
protic.obtener_rut(b.pers_ncorr) as rut_alumno, protic.obtener_nombre_completo(b.pers_ncorr,'n') as alumno,
protic.obtener_rut(f.pers_ncorr) as rut_codeudor,protic.obtener_nombre_completo(f.pers_ncorr,'n') as codeudor
from 
contratos a 
join compromisos b
    on a.cont_ncorr=b.comp_ndocto
join detalle_compromisos c
    on b.comp_ndocto    = c.comp_ndocto
    and b.tcom_ccod     = c.tcom_ccod
    and b.inst_ccod     = c.inst_ccod
join abonos d
    on  c.comp_ndocto       = d.comp_ndocto
    and c.tcom_ccod         = d.tcom_ccod
    and c.inst_ccod         = d.inst_ccod
    and c.dcom_ncompromiso  = d.dcom_ncompromiso
join ingresos e
    on d.ingr_ncorr=e.ingr_ncorr
join codeudor_postulacion  f
    on a.post_ncorr=f.post_ncorr
join estados_contrato   g
    on a.econ_ccod= g.econ_ccod
join tipos_compromisos h
    on b.tcom_ccod=h.tcom_ccod    
where e.ting_ccod=7  
and a.econ_ccod is not null 
and a.matr_ncorr is not null
and a.cont_fcontrato between convert(datetime,'12/12/2004',103) and convert(datetime,'12/01/2005',103)
group by a.cont_ncorr,a.cont_fcontrato, b.tcom_ccod,a.econ_ccod,
b.pers_ncorr,f.pers_ncorr,a.post_ncorr,h.tcom_tdesc,g.econ_tdesc, e.mcaj_ncorr
--order by a.cont_fcontrato, rut_alumno, a.cont_ncorr
) a
group by cont_ncorr,cont_fcontrato,econ_tdesc,rut_alumno,alumno, rut_codeudor, codeudor,mcaj_ncorr


/*
select * from estados_contrato where cont_ncorr=26290 

select  * from codeudor_postulacion where post_ncorr=16349

select top 10 * from compromisos where tcom_ccod in (1,2)

select protic.obtener_nombre_completo(97395,'n')

select protic.obtener_rut(97395)

select *
from contratos a
where  a.cont_fcontrato 
between convert(datetime,'12/12/2004',103) 
and convert(datetime,'12/01/2005',103)
and a.econ_ccod  is not null
and a.matr_ncorr is not null
--group by post_ncorr--,econ_ccod
*/