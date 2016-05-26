--** INTERESES CON SALDO ****
    select protic.obtener_rut(a.pers_ncorr)as rut,a.COMP_NDOCTO as num_compromiso,protic.trunc(comp_fdocto) as fecha,cast(a.comp_mneto as numeric) as pactado,
    protic.total_recepcionar_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso) AS SALDO
    from compromisos a join detalle_compromisos b
    on a.TCOM_CCOD=b.tcom_ccod
    and a.COMP_NDOCTO= b.comp_ndocto 
    where a.tcom_ccod=6 
    and a.ecom_ccod=1 
    and year(comp_fdocto)>2006
    and a.audi_tusuario not like '%camb%'
    and protic.total_recepcionar_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso)> 0
    and cast(a.comp_mneto as numeric) - protic.total_recepcionar_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso) <>0
    and convert(datetime,comp_fdocto,103) <= convert(datetime,'12/12/2012',103)



--*********** ANULADOS LOS COMPROMSISOS DE INTERESES *****
--update compromisos set ecom_ccod=3, audi_tusuario=audi_tusuario+' nulo'
where comp_ndocto in (
    select a.COMP_NDOCTO
    from compromisos a join detalle_compromisos b
    on a.TCOM_CCOD=b.tcom_ccod
    and a.COMP_NDOCTO= b.comp_ndocto 
    where a.tcom_ccod=6 
    and a.ecom_ccod=1 
    and year(comp_fdocto)>2006
    and a.audi_tusuario not like '%camb%'
    --and protic.total_recepcionar_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso)> 0
    and cast(a.comp_mneto as numeric) - protic.total_recepcionar_cuota(b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso) =0
    and convert(datetime,comp_fdocto,103) <= convert(datetime,'10/12/2012',103)
)
and tcom_ccod=6


