select * from contratos 
where peri_ccod=204 
and audi_tusuario not like '%CREAR_MATRICULA_SEG_SEMESTRE%'
and econ_ccod=1
and cont_fcontrato between '24/07/2006' and '04/08/2006'

16656552-9


select protic.obtener_rut(a.pers_ncorr) as rut,
protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente,
a.susu_tlogin,a.susu_tclave, b.tipo_profe
 from sis_usuarios a, 
    ( 
    select distinct pers_ncorr,
    case datepart(year,cdoc_ffin) when 2007 then 'P' else 'H' end as tipo_profe
    from contratos_docentes_upa
    where ano_contrato=2006
    ) b
where a.pers_ncorr=b.pers_ncorr


