select d.mes_tdesc as mes,a.mcaj_ncorr as caja,protic.trunc(a.mcaj_finicio) as fecha,b.sede_tdesc as sede,
protic.obtener_nombre_completo(c.pers_ncorr,'n') as nombre,
(select max(ingr_ncorrelativo_caja) from ingresos where mcaj_ncorr=a.mcaj_ncorr) as comprobantes,
cast((select sum(ingr_mtotal) from ingresos where mcaj_ncorr=a.mcaj_ncorr and ingr_ncorrelativo_caja is not null) as numeric) as monto
--,e.tcaj_tdesc as tipo_caja
from movimientos_cajas a, sedes b, cajeros c, meses d --, tipos_caja e
where a.sede_ccod=b.sede_ccod
and a.caje_ccod=c.caje_ccod
and a.sede_ccod=c.sede_ccod
and d.mes_ccod=datepart(month,mcaj_finicio)
--and a.tcaj_ccod=e.tcaj_ccod
and a.mcaj_ncorr in (
            select distinct mcaj_ncorr from ingresos where ingr_ncorrelativo_caja is not null 
            and convert(datetime,ingr_fpago,103) 
            BETWEEN  convert(datetime,'01/01/2006',103) and convert(datetime,'31/01/2006',103)
        )
and convert(datetime,a.mcaj_finicio,103) 
BETWEEN  convert(datetime,'01/01/2006',103) and convert(datetime,'01/02/2006',103)
and c.pers_ncorr not in (27720)
order by a.mcaj_finicio




-- sin correlativo de caja
select d.mes_tdesc as mes,a.mcaj_ncorr as caja,protic.trunc(a.mcaj_finicio) as fecha,b.sede_tdesc as sede,
protic.obtener_nombre_completo(c.pers_ncorr,'n') as nombre,
(select distinct count(ingr_nfolio_referencia) from ingresos where mcaj_ncorr=a.mcaj_ncorr and ting_ccod in (7,15,16,17,33,34)) as comprobantes,
cast((select sum(ingr_mtotal) from ingresos where mcaj_ncorr=a.mcaj_ncorr and ting_ccod in (7,15,16,17,33,34)) as numeric) as monto
from movimientos_cajas a, sedes b, cajeros c, meses d 
where a.sede_ccod=b.sede_ccod
and a.caje_ccod=c.caje_ccod
and a.sede_ccod=c.sede_ccod
and d.mes_ccod=datepart(month,mcaj_finicio)
and a.mcaj_ncorr in (
            select distinct mcaj_ncorr from ingresos  
            where convert(datetime,ingr_fpago,103) 
            BETWEEN  convert(datetime,'01/10/2005',103) and convert(datetime,'31/12/2005',103)
            and ting_ccod in (7,15,16,17,33,34)
        )
and convert(datetime,a.mcaj_finicio,103) 
BETWEEN  convert(datetime,'01/10/2005',103) and convert(datetime,'31/12/2005',103)
and c.pers_ncorr not in (27720)
order by a.mcaj_finicio



--***********************************--
-- por año y mes
select d.mes_tdesc as mes,a.mcaj_ncorr as caja,protic.trunc(a.mcaj_finicio) as fecha,b.sede_tdesc as sede,
protic.obtener_nombre_completo(c.pers_ncorr,'n') as nombre,
(select max(ingr_ncorrelativo_caja) from ingresos where mcaj_ncorr=a.mcaj_ncorr) as comprobantes,
cast((select sum(ingr_mtotal) from ingresos where mcaj_ncorr=a.mcaj_ncorr and ingr_ncorrelativo_caja is not null) as numeric) as monto
from movimientos_cajas a, sedes b, cajeros c, meses d --, tipos_caja e
where a.sede_ccod=b.sede_ccod
and a.caje_ccod=c.caje_ccod
and a.sede_ccod=c.sede_ccod
and d.mes_ccod=datepart(month,mcaj_finicio)
and datepart(year,mcaj_finicio)='2007'
and a.mcaj_ncorr in (
            select distinct mcaj_ncorr from ingresos 
            where ingr_ncorrelativo_caja is not null 
            and datepart(year,mcaj_finicio)='2007'
        )
and c.pers_ncorr not in (27720)
order by a.mcaj_finicio

--*******************************************
--*******************************************
-- sin correlativo de caja
select d.mes_tdesc as mes,a.mcaj_ncorr as caja,protic.trunc(a.mcaj_finicio) as fecha,b.sede_tdesc as sede,
protic.obtener_nombre_completo(c.pers_ncorr,'n') as nombre,
(select distinct count(ingr_nfolio_referencia) from ingresos where mcaj_ncorr=a.mcaj_ncorr and ting_ccod in (7,15,16,17,33,34)) as comprobantes,
cast((select sum(ingr_mtotal) from ingresos where mcaj_ncorr=a.mcaj_ncorr and ting_ccod in (7,15,16,17,33,34)) as numeric) as monto
from movimientos_cajas a, sedes b, cajeros c, meses d 
where a.sede_ccod=b.sede_ccod
and a.caje_ccod=c.caje_ccod
and a.sede_ccod=c.sede_ccod
and d.mes_ccod=datepart(month,mcaj_finicio)
and a.mcaj_ncorr in (
            select distinct mcaj_ncorr from ingresos  
            where datepart(year,mcaj_finicio)='2006'
            and ting_ccod in (7,15,16,17,33,34)
        )
and datepart(year,mcaj_finicio)='2006'
and c.pers_ncorr not in (27720)
order by a.mcaj_finicio