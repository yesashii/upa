-- Datos de movimientos para un cajero por mes

-- Marzo
select cast(datepart(hh,a.audi_fmodificacion) as varchar)+':'+cast(datepart(minute,a.audi_fmodificacion) as varchar) as hora,a.mcaj_ncorr as caja,a.ingr_nfolio_referencia as Comprobante,protic.trunc(b.mcaj_finicio) as fecha_caja,
protic.obtener_nombre_completo(d.pers_ncorr, 'N') as cajero, e.ting_tdesc as tipo_ingreso,
a.audi_fmodificacion as ingreso_transaccion,  mes_tdesc as mes
from ingresos a, movimientos_cajas b, cajeros c, personas d, tipos_ingresos e, meses f
where a.mcaj_ncorr=b.mcaj_ncorr
and b.caje_ccod=c.caje_ccod
and c.pers_ncorr=d.pers_ncorr
and a.ting_ccod=e.ting_ccod
and convert(datetime,b.mcaj_finicio,103) 
BETWEEN  convert(datetime,'01/03/2012',103) 
and convert(datetime,'01/04/2012',103) 
and b.tcaj_ccod in (1000,1001)
and a.ting_ccod in (16,33,7,34)
and a.eing_ccod not in (3)
and b.sede_ccod=4
and c.caje_ccod=49
and f.mes_ccod=datepart(month,mcaj_finicio)
and (datepart(hour,a.audi_fmodificacion)*60+datepart(minute,a.audi_fmodificacion)) between 1080 and 1170 -- entre las 18:30 y las 19:30
group by a.mcaj_ncorr,a.ingr_nfolio_referencia,b.mcaj_finicio,d.pers_ncorr,e.ting_tdesc,a.audi_fmodificacion,mes_tdesc
order by a.mcaj_ncorr, a.audi_fmodificacion asc


-- Junio
select cast(datepart(hh,a.audi_fmodificacion) as varchar)+':'+cast(datepart(minute,a.audi_fmodificacion) as varchar) as hora,a.mcaj_ncorr as caja,a.ingr_nfolio_referencia as Comprobante,protic.trunc(b.mcaj_finicio) as fecha_caja,
protic.obtener_nombre_completo(d.pers_ncorr, 'N') as cajero, e.ting_tdesc as tipo_ingreso,
a.audi_fmodificacion as ingreso_transaccion,  mes_tdesc as mes
from ingresos a, movimientos_cajas b, cajeros c, personas d, tipos_ingresos e, meses f
where a.mcaj_ncorr=b.mcaj_ncorr
and b.caje_ccod=c.caje_ccod
and c.pers_ncorr=d.pers_ncorr
and a.ting_ccod=e.ting_ccod
and convert(datetime,b.mcaj_finicio,103) 
BETWEEN  convert(datetime,'01/06/2012',103) 
and convert(datetime,'01/07/2012',103) 
and b.tcaj_ccod in (1000,1001)
and a.ting_ccod in (16,33,7,34)
and a.eing_ccod not in (3)
and b.sede_ccod=4
and c.caje_ccod=49
and f.mes_ccod=datepart(month,mcaj_finicio)
and (datepart(hour,a.audi_fmodificacion)*60+datepart(minute,a.audi_fmodificacion)) between 1080 and 1170 -- entre las 18:30 y las 19:30
group by a.mcaj_ncorr,a.ingr_nfolio_referencia,b.mcaj_finicio,d.pers_ncorr,e.ting_tdesc,a.audi_fmodificacion,mes_tdesc
order by a.mcaj_ncorr, a.audi_fmodificacion asc


-- Octubre
select cast(datepart(hh,a.audi_fmodificacion) as varchar)+':'+cast(datepart(minute,a.audi_fmodificacion) as varchar) as hora,a.mcaj_ncorr as caja,a.ingr_nfolio_referencia as Comprobante,protic.trunc(b.mcaj_finicio) as fecha_caja,
protic.obtener_nombre_completo(d.pers_ncorr, 'N') as cajero, e.ting_tdesc as tipo_ingreso,
a.audi_fmodificacion as ingreso_transaccion,  mes_tdesc as mes
from ingresos a, movimientos_cajas b, cajeros c, personas d, tipos_ingresos e, meses f
where a.mcaj_ncorr=b.mcaj_ncorr
and b.caje_ccod=c.caje_ccod
and c.pers_ncorr=d.pers_ncorr
and a.ting_ccod=e.ting_ccod
and convert(datetime,b.mcaj_finicio,103) 
BETWEEN  convert(datetime,'01/10/2012',103) 
and convert(datetime,'01/11/2012',103) 
and b.tcaj_ccod in (1000,1001)
and a.ting_ccod in (16,33,7,34)
and a.eing_ccod not in (3)
and b.sede_ccod=4
and c.caje_ccod=49
and f.mes_ccod=datepart(month,mcaj_finicio)
and (datepart(hour,a.audi_fmodificacion)*60+datepart(minute,a.audi_fmodificacion)) between 1080 and 1170 -- entre las 18:30 y las 19:30
group by a.mcaj_ncorr,a.ingr_nfolio_referencia,b.mcaj_finicio,d.pers_ncorr,e.ting_tdesc,a.audi_fmodificacion,mes_tdesc
order by a.mcaj_ncorr, a.audi_fmodificacion asc

