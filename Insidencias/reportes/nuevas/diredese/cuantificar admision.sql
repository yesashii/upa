/*######################################################################*/
/***********************  ADMISION 2008 *********************************/


/* Cantidad de contratos segun admision*/
select count(mcaj_ncorr) as cantidad,sede_tdesc as sede,fecha from (
 Select isnull(a.mcaj_ncorr,0) as mcaj_ncorr,d.econ_ccod,d.contrato as n_contrato,
 g.sede_tdesc, i.econ_tdesc, protic.trunc(d.cont_fcontrato) as fecha 
 From  
 ingresos a  
 join abonos b  
     on a.ingr_ncorr=b.ingr_ncorr 
 join compromisos c 
     on b.comp_ndocto=c.comp_ndocto 
     and b.tcom_ccod=c.tcom_ccod 
     and b.inst_ccod=c.inst_ccod 
 	  and c.tcom_ccod in (1,2) 
 join contratos d 
     on c.comp_ndocto=d.cont_ncorr 
 join postulantes e 
     on d.post_ncorr=e.post_ncorr 
 join ofertas_academicas f 
     on e.ofer_ncorr=f.ofer_ncorr    
 join sedes g 
     on f.sede_ccod=g.sede_ccod    
 join estados_contrato i 
     on d.econ_ccod=i.econ_ccod   
 join movimientos_cajas j 
    on a.mcaj_ncorr=j.mcaj_ncorr 
 where a.ting_ccod=7 
 and d.econ_ccod not in (2,3)
  and  convert(datetime,j.mcaj_finicio,103) BETWEEN  convert(datetime,'01/11/2007',103) and convert(datetime,'31/01/2008',103) 
  and cast(d.peri_ccod as varchar)='210'  
 group by e.post_bnuevo,d.cont_fcontrato,i.econ_tdesc,a.mcaj_ncorr,d.econ_ccod,d.cont_ncorr, d.contrato,g.sede_tdesc
 ) as tabla
 group by sede_tdesc,fecha



/* Cantidad de Letras segun admision */
select count(ding_ndocto) as cantidad_letras,fecha,sede_tdesc as sede from (
    select ding_ndocto,protic.trunc(ingr_fpago) as fecha, sede_tdesc 
    from ingresos a, detalle_ingresos b, movimientos_cajas c, sedes d
    where a.ting_ccod=7
    and a.ingr_ncorr=b.ingr_ncorr
    and b.ting_ccod=4
    and a.eing_ccod=4
    and a.mcaj_ncorr=c.mcaj_ncorr
    and c.sede_ccod=d.sede_ccod
    and convert(datetime,protic.trunc(ingr_fpago),103) <= convert(datetime,'31/01/2008',103)
    and convert(datetime,protic.trunc(ingr_fpago),103) >= convert(datetime,'01/11/2007',103)
) as tabla
group by fecha,sede_tdesc
order by convert(datetime,fecha,103)




/* comprobantes por caja segun mes */
SELECT mes,fecha,sede, SUM(comprobantes) AS comprobantes, SUM(monto) AS MONTO 
FROM  (
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
            BETWEEN  convert(datetime,'01/11/2007',103) and convert(datetime,'31/01/2008',103)
            and ting_ccod in (7,15,16,17,33,34)
        )
and convert(datetime,a.mcaj_finicio,103) 
BETWEEN  convert(datetime,'01/11/2007',103) and convert(datetime,'31/01/2008',103)
and c.pers_ncorr not in (27720)
) AS TABLA
GROUP BY mes,fecha,sede
order by mes DESC,fecha,sede


/*######################################################################*/
/***********************  ADMISION 2009 *********************************/

/* Cantidad de contratos segun admision*/
select count(mcaj_ncorr) as cantidad,sede_tdesc as sede,fecha from (
 Select isnull(a.mcaj_ncorr,0) as mcaj_ncorr,d.econ_ccod,d.contrato as n_contrato,
 g.sede_tdesc, i.econ_tdesc, protic.trunc(d.cont_fcontrato) as fecha 
 From  
 ingresos a  
 join abonos b  
     on a.ingr_ncorr=b.ingr_ncorr 
 join compromisos c 
     on b.comp_ndocto=c.comp_ndocto 
     and b.tcom_ccod=c.tcom_ccod 
     and b.inst_ccod=c.inst_ccod 
 	  and c.tcom_ccod in (1,2) 
 join contratos d 
     on c.comp_ndocto=d.cont_ncorr 
 join postulantes e 
     on d.post_ncorr=e.post_ncorr 
 join ofertas_academicas f 
     on e.ofer_ncorr=f.ofer_ncorr    
 join sedes g 
     on f.sede_ccod=g.sede_ccod    
 join estados_contrato i 
     on d.econ_ccod=i.econ_ccod   
 join movimientos_cajas j 
    on a.mcaj_ncorr=j.mcaj_ncorr 
 where a.ting_ccod=7 
 and d.econ_ccod not in (2,3)
  and  convert(datetime,j.mcaj_finicio,103) BETWEEN  convert(datetime,'01/11/2008',103) and convert(datetime,'31/01/2009',103) 
  and cast(d.peri_ccod as varchar)='214'  
 group by e.post_bnuevo,d.cont_fcontrato,i.econ_tdesc,a.mcaj_ncorr,d.econ_ccod,d.cont_ncorr, d.contrato,g.sede_tdesc
 ) as tabla
 group by sede_tdesc,fecha



/* Cantidad de Letras segun admision */
select count(ding_ndocto) as cantidad_letras,fecha,sede_tdesc as sede from (
    select ding_ndocto,protic.trunc(ingr_fpago) as fecha, sede_tdesc 
    from ingresos a, detalle_ingresos b, movimientos_cajas c, sedes d
    where a.ting_ccod=7
    and a.ingr_ncorr=b.ingr_ncorr
    and b.ting_ccod=4
    and a.eing_ccod=4
    and a.mcaj_ncorr=c.mcaj_ncorr
    and c.sede_ccod=d.sede_ccod
    and convert(datetime,protic.trunc(ingr_fpago),103) <= convert(datetime,'31/01/2009',103)
    and convert(datetime,protic.trunc(ingr_fpago),103) >= convert(datetime,'01/11/2008',103)
) as tabla
group by fecha,sede_tdesc
order by convert(datetime,fecha,103)




/* comprobantes por caja segun mes */
SELECT mes,fecha,sede, SUM(comprobantes) AS comprobantes, SUM(monto) AS MONTO 
FROM  (
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
            BETWEEN  convert(datetime,'01/11/2008',103) and convert(datetime,'31/01/2009',103)
            and ting_ccod in (7,15,16,17,33,34)
        )
and convert(datetime,a.mcaj_finicio,103) 
BETWEEN  convert(datetime,'01/11/2008',103) and convert(datetime,'31/01/2009',103)
and c.pers_ncorr not in (27720)
) AS TABLA
GROUP BY mes,fecha,sede
order by mes DESC,fecha,sede



