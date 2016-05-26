select protic.obtener_rut(a.pers_ncorr) as rut,
protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre_docente,
a.susu_tlogin as login,a.susu_tclave as clave, b.tipo_profe as tipo_contrato, carr_tdesc as carrera
 from sis_usuarios a, 
    ( 
    select distinct cd.pers_ncorr,
    case datepart(year,cd.cdoc_ffin) when 2008 then 'P' else 'H' end as tipo_profe , carr_ccod
    from contratos_docentes_upa cd, anexos an, detalle_anexos da
    where ano_contrato=2007
    and cd.cdoc_ncorr=an.cdoc_ncorr
    and an.anex_ncorr=da.anex_ncorr
    ) b, carreras c
where a.pers_ncorr=b.pers_ncorr
and b.carr_ccod=c.carr_ccod


vicente perez rosales 1028 casa A