select * from contratos where protic.trunc(cont_fcontrato)='11/11/2005'
select * from contratos where post_ncorr in (54398)


-- update 
update compromisos set ecom_ccod=3 
where post_ncorr in (select post_ncorr from contratos where protic.trunc(cont_fcontrato)='11/11/2005')

update postulantes set ofer_ncorr=null where post_ncorr in (54398)


select top 1 ofer_ncorr,*  from sdescuentos where post_ncorr in (54398)
select top 1 ofer_ncorr,* from spagos where post_ncorr in (54398)
select top 1 ofer_ncorr,* from sdetalles_forma_pago where post_ncorr in (54398)
select top 1 ofer_ncorr,* from sdetalles_pagos where post_ncorr in (54398)
select top 1 * from pagares where cont_ncorr in (select cont_ncorr from contratos where protic.trunc(cont_fcontrato)='11/11/2005')
select top 1 * from contratos where post_ncorr in (54398)
select  ofer_ncorr,* from alumnos where post_ncorr in (54398)  

-- Actualiza Oferta
update sdescuentos set ofer_ncorr= 14340 where post_ncorr in (60942)
update spagos  set ofer_ncorr= 14340 where post_ncorr in (60942)
update sdetalles_forma_pago set ofer_ncorr= 14340 where post_ncorr in (60942)
update sdetalles_pagos set ofer_ncorr= 14340 where post_ncorr in (60942)
update alumnos set ofer_ncorr= 14340 where post_ncorr in (60942) 
update postulantes set ofer_ncorr= 14340 where post_ncorr in (60942)   
update detalle_postulantes set ofer_ncorr= 14340 where post_ncorr in (60942)   



          
--Elimina Contratos del dia
/*
delete from sdescuentos where post_ncorr in (54398)
delete from spagos where post_ncorr in (54398)
delete from sdetalles_forma_pago where post_ncorr in (54398)
delete from sdetalles_pagos where post_ncorr in (54398)
delete from pagares where cont_ncorr in (select cont_ncorr from contratos where protic.trunc(cont_fcontrato)='11/11/2005')
delete from contratos where post_ncorr in (54398)
delete from alumnos where post_ncorr in (54398)  
*/

-- listado alumnos
select protic.obtener_rut(a.pers_ncorr),pers_tnombre, b.pers_tape_paterno, pers_tape_materno 
from postulantes a, personas_postulante b 
where a.post_ncorr in (54398)
and a.pers_ncorr=b.pers_ncorr


-------
--Pitea cajas



/*
delete from detalle_ingresos where ingr_ncorr in (
    select ingr_ncorr from ingresos where mcaj_ncorr in (
        select mcaj_ncorr from movimientos_cajas a, cajeros b
        where a.caje_ccod=b.caje_ccod
        and b.pers_ncorr in (103167,17077,103168,103169,103170,103171,103187)
     )
)

delete from abonos where ingr_ncorr in (
    select ingr_ncorr from ingresos where mcaj_ncorr in (
        select mcaj_ncorr from movimientos_cajas a, cajeros b
        where a.caje_ccod=b.caje_ccod
        and b.pers_ncorr in (103167,17077,103168,103169,103170,103171,103187)
     )
)

delete from ingresos where mcaj_ncorr in (

select mcaj_ncorr from movimientos_cajas a, cajeros b
where a.caje_ccod=b.caje_ccod
and b.pers_ncorr in (103167,17077,103168,103169,103170,103171,103187)
 )
 */
 
 
0047 -- credito --05/12/2005
 