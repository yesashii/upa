select ting_tdesc,protic.obtener_rut(d.pers_ncorr) as rut_alumno,protic.obtener_rut(b.pers_ncorr_codeudor) as apoderado,rut,
nombre as nombre_apoderado,monto,num_oper,fec_venc,ding_mdocto as monto_SGA, ding_ndocto as numero_SGA, protic.trunc(ding_fdocto) as fecha_SGA, edin_tdesc
from sd_letras_cobranza_no_sga a,detalle_ingresos b, tipos_ingresos c, ingresos d, estados_detalle_ingresos e
where b.ting_ccod=c.ting_ccod
and a.monto=b.ding_mdocto
--a.num_oper=b.ding_ndocto
and b.ingr_ncorr=d.ingr_ncorr
and b.edin_ccod=e.edin_ccod
and convert(datetime,protic.trunc(a.fec_venc),103)=convert(datetime,protic.trunc(b.ding_fdocto),103)
 --and b.ting_ccod=8
and  a.num_oper not in (
    select ding_ndocto
    from sd_letras_cobranza_no_sga a, detalle_ingresos b, estados_detalle_ingresos c, ingresos d
    where a.num_oper=b.ding_ndocto
    and b.ting_ccod=4
    and b.edin_ccod=c.edin_ccod
    and b.ingr_ncorr=d.ingr_ncorr
)