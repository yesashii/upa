-- Listado de docentes en carreras de pedagogias
select pers_ncorr,email_nuevo from cuentas_email_upa where pers_ncorr in (
    select distinct pers_ncorr from contratos_docentes_upa a, anexos b
    where a.cdoc_ncorr=b.cdoc_ncorr
    and carr_ccod in (25,29,30,880,950,940,870)
    and ano_contrato=2011
)
order by pers_ncorr


--select carr_ccod,carr_tdesc from carreras where carr_ccod in (880,950,940,870)