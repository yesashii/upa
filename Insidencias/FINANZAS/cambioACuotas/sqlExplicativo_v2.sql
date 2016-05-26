select * from DETALLE_INGRESOS where DING_NDOCTO = 2260 and DING_MDOCTO = 367500

select * from INGRESOS where INGR_NCORR = 1542734

-- -----------------------------------------------
select *
into #ingresos
from ingresos
where INGR_NCORR = 1542734

-- -----------------------------------------------
select * from #ingresos
-- -----------------------------------------------
-- para tres cuotas se necesitan dos numeros
execute obtenersecuencia 'ingresos' -- 1550084
execute obtenersecuencia 'ingresos' -- 1550085
-- ------------------------------------------------
update #ingresos 
set    ingr_ncorr = 1550084, 
       ingr_mdocto = ( 367500 / 3 ), 
       ingr_mtotal = ( 367500 / 3 ), 
       ingr_fpago = '2016-14-02' 
where  ingr_ncorr = 1542734 
-- -----------------------------------------------
select * from #ingresos
-- -----------------------------------------------
insert into #ingresos select * from INGRESOS where INGR_NCORR = 1542734
-- -----------------------------------------------
select * from #ingresos
-- -----------------------------------------------
update #ingresos 
set    ingr_ncorr = 1550085, 
       ingr_mdocto = ( 367500 / 3 ), 
       ingr_mtotal = ( 367500 / 3 ), 
       ingr_fpago = '2016-14-03' 
where  ingr_ncorr = 1542734 
-- -----------------------------------------------
select * from #ingresos
-- -----------------------------------------------
-- INSERTANDO EN LA TABLA OFICIAL.
insert into ingresos select * from #ingresos
-- -----------------------------------------------
select * from ingresos where ingr_ncorr in (1542734, 1550084, 1550085);
-- -----------------------------------------------
update top(2) ingresos 
set    ingr_mdocto = ( 367500 / 3 ), 
       ingr_mtotal = ( 367500 / 3 ) 
where  ingr_ncorr = 1542734 
-- -----------------------------------------------
select * from ingresos where ingr_ncorr in (1542734, 1550084, 1550085);
-- -----------------------------------------------
-- FIN MODIFICACION INGRESOS.
-- -----------------------------------------------
select * from DETALLE_INGRESOS where ingr_ncorr = 1542734
-- -----------------------------------------------
select *
into #temp_detalle_ingresos
from detalle_ingresos
where INGR_NCORR = 1542734
-- -----------------------------------------------
select * from #temp_detalle_ingresos
-- -----------------------------------------------
-- para tres cuotas se necesitan dos numeros
execute obtenersecuencia 'detalle_ingresos' -- 999728391
execute obtenersecuencia 'detalle_ingresos' -- 999728392
-- ------------------------------------------------
update #temp_detalle_ingresos 
set    ding_nsecuencia = 999728391, 
       ingr_ncorr = 1550084, 
       ding_mdetalle = ( 367500 / 3 ), 
       ding_mdocto = ( 367500 / 3 ), 
       ding_fdocto = '2016-14-02' 
where  ingr_ncorr = 1542734 
-- -----------------------------------------------  
select * from #temp_detalle_ingresos
-- -----------------------------------------------   
insert into #temp_detalle_ingresos select * from detalle_ingresos where INGR_NCORR = 1542734   
-- -----------------------------------------------
select * from #temp_detalle_ingresos
-- ----------------------------------------------- 
update #temp_detalle_ingresos 
set    ding_nsecuencia = 999728392, 
       ingr_ncorr = 1550085, 
       ding_mdetalle = ( 367500 / 3 ), 
       ding_mdocto = ( 367500 / 3 ), 
       ding_fdocto = '2016-14-03' 
where  ingr_ncorr = 1542734 
-- ----------------------------------------------- 
select * from #temp_detalle_ingresos
-- ----------------------------------------------- 
-- INSERTANDO EN LA TABLA OFICIAL.
insert into detalle_ingresos select * from #temp_detalle_ingresos
-- ----------------------------------------------- 
select * from detalle_ingresos where ingr_ncorr in (1542734, 1550084, 1550085);
-- ----------------------------------------------- 
update top(2) detalle_ingresos 
set    ding_mdetalle = ( 367500 / 3 ), 
       ding_mdocto = ( 367500 / 3 )
where  ingr_ncorr = 1542734 
-- ----------------------------------------------- 
select * from detalle_ingresos where ingr_ncorr in (1542734, 1550084, 1550085);
-- ----------------------------------------------- 
-- FIN MODIFICACION detalle_ingresos.
select * from ABONOS where  ingr_ncorr = 1542734 
-- -----------------------------------------------
select *
into #temp_ABONOS
from ABONOS
where INGR_NCORR = 1542734
-- -----------------------------------------------
select * from #temp_ABONOS
-- -----------------------------------------------
update #temp_abonos 
set    abon_mabono = ( 367500 / 3 ), 
       abon_fabono = '2016-14-02', 
       ingr_ncorr = 1550084 
where  ingr_ncorr = 1542734 
-- ----------------------------------------------- 
insert into #temp_abonos select * from ABONOS where  ingr_ncorr = 1542734 
-- -----------------------------------------------
select * from #temp_ABONOS
-- -----------------------------------------------
update #temp_abonos 
set    abon_mabono = ( 367500 / 3 ), 
       abon_fabono = '2016-14-03', 
       ingr_ncorr = 1550085 
where  ingr_ncorr = 1542734 
-- -----------------------------------------------
select * from #temp_ABONOS
-- -----------------------------------------------
-- INSERTANDO EN LA TABLA OFICIAL.
insert into ABONOS select * from #temp_ABONOS
-- -----------------------------------------------
select * from ABONOS where  ingr_ncorr in(1542734, 1550084, 1550085);
-- -----------------------------------------------
update top(2) abonos 
set    abon_mabono = ( 367500 / 3 ) 
where  ingr_ncorr = 1542734 
-- -----------------------------------------------
select * from ABONOS where  ingr_ncorr in(1542734, 1550084, 1550085);
-- -----------------------------------------------
























