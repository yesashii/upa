select distinct a.ding_ndocto_origen,a.ding_ndocto_destino,
b.edin_tdesc+' - '+isnull(cast(g.sede_tdesc as varchar),case 
            when d.ingr_fpago < '03/12/2006' then (select sede_tdesc from sedes where sede_ccod=1) 
            else f.sede_tdesc end) as estado_origen,
c.edin_tdesc+' - '+isnull(cast(g.sede_tdesc as varchar),case 
            when d.ingr_fpago < '03/12/2006' then (select sede_tdesc from sedes where sede_ccod=1) 
            else f.sede_tdesc end)  as estado_destino,
protic.trunc(a.ding_fdocto_origen) as fecha_origen,protic.trunc(a.ding_fdocto_destino) as fecha_destino,
a.ding_mdocto_origen,a.ding_mdocto_destino, 
edin_ccod_origen,edin_ccod_destino,audi_tusuario_origen,audi_tusuario_destino,dist_ncorr, a.dist_fhistorial, 
envi_ncorr_origen,envi_ncorr_destino,protic.obtener_envio(a.ingr_ncorr_origen)
from detalle_ingresos_historial a, estados_detalle_ingresos b, estados_detalle_ingresos c, ingresos d, movimientos_cajas e, sedes f, sedes g
where a.ingr_ncorr_origen=d.ingr_ncorr
    and d.mcaj_ncorr=e.mcaj_ncorr
    and e.sede_ccod=f.sede_ccod
    and a.sede_actual_destino*=g.sede_ccod
    and a.edin_ccod_origen=b.edin_ccod
    and a.edin_ccod_destino=c.edin_ccod
    --and ding_ndocto_origen=2371
    --and ding_ncorrelativo_destino=1
    and ingr_ncorr_origen=1053998
   -- and ding_mdocto_origen=242000
   -- and ting_ccod_origen=51
    order by dist_ncorr asc        
    
17044617

select a.*,b.edin_tdesc as estado_origen,c.edin_tdesc as estado_destino,
protic.trunc(a.ding_fdocto_origen) as fecha_origen,protic.trunc(a.ding_fdocto_destino) as fecha_destino,
edin_ccod_origen,edin_ccod_destino,dist_ncorr , dist_fhistorial
from detalle_ingresos_historial a, estados_detalle_ingresos b, estados_detalle_ingresos c
where a.edin_ccod_origen=b.edin_ccod
    and a.edin_ccod_destino=c.edin_ccod
    --and ding_ndocto_origen=166
    and ting_ccod_origen=3
    and ingr_ncorr_origen=973434
    order by dist_ncorr asc    
    
    
select  * from detalle_ingresos_historial where ingr_ncorr_origen=516763
select  * from detalle_ingresos_historial where ding_ndocto_origen=1322 and ting_ccod_origen=3  order by dist_ncorr desc

select * from detalle_ingresos where ding_ndocto=99374034
--update detalle_ingresos set sede_actual=1 where ding_ndocto=191817
select * from ingresos where ingr_ncorr=333228

51800-52000

52869867
21552214

select * from movimiento_cheque_softland where moch_ndocref=80

exec CREAR_MATRICULA_SEG_SEMESTRE_VERSION_2 1,16098494,224