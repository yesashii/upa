-- datos de movimientos por cajas
select protic.obtener_nombre_completo(e.pers_ncorr,'n') as cajero,a.mcaj_ncorr as caja, 
sede_tdesc as sede, ting_tdesc as tipo_comprobante,protic.trunc(mcaj_finicio) as fecha,
cast(isnull(ingr_mefectivo,0) as numeric) as efectivo, cast(isnull(ingr_mdocto,0) as numeric) as documentos, 
cast(isnull(ingr_mtotal,0) as numeric) as total,mes_tdesc as mes 
from ingresos a, movimientos_cajas b, tipos_ingresos c, sedes d, cajeros e, meses f 
where a.ting_ccod in (8,10,17,16,34)
and a.mcaj_ncorr=b.mcaj_ncorr
and datepart(year,mcaj_finicio)=2007
and datepart(month,mcaj_finicio)=mes_ccod
and a.ting_ccod=c.ting_ccod
and b.sede_ccod=d.sede_ccod
and b.caje_ccod=e.caje_ccod
and b.sede_ccod=e.sede_ccod
and a.eing_ccod not  in (3,6)
order by mcaj_finicio asc,cajero, tipo_comprobante


-- datos de ingresos de matriculas
select protic.obtener_nombre_completo(e.pers_ncorr,'n') as cajero,a.mcaj_ncorr as caja, 
sede_tdesc as sede, ting_tdesc as tipo_comprobante,protic.trunc(mcaj_finicio) as fecha,
cast(isnull(ingr_mefectivo,0) as numeric) as efectivo, cast(isnull(ingr_mdocto,0) as numeric) as documentos, 
cast(isnull(ingr_mtotal,0) as numeric) as total,mes_tdesc as mes 
from ingresos a, movimientos_cajas b, tipos_ingresos c, sedes d, cajeros e, meses f 
where a.ting_ccod in (7)
and a.mcaj_ncorr=b.mcaj_ncorr
and datepart(year,mcaj_finicio)=2007
and datepart(month,mcaj_finicio)=mes_ccod
and a.ting_ccod=c.ting_ccod
and b.sede_ccod=d.sede_ccod
and b.caje_ccod=e.caje_ccod
and b.sede_ccod=e.sede_ccod
and a.eing_ccod not  in (3,6)
order by mcaj_finicio asc,cajero, tipo_comprobante
