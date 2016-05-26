/* *************************************************************** */
/*					CAMBIO DE MONTO EN CHEQUE					  */
/* ************************************************************* */

-- Datos proporcionados

-- Cod. Banco	Nº Docto.	Fecha Docto.	Monto Dice 	Monto Debe Decir	Rut Alumno	Rut Apoderado
-- 12			3408434		05/05/2016		$ 188.562	$ 188.563			17236372-5	17236372-5
-- 12			3408435		05/06/2016		$ 188.562	$ 188.563			17236372-5	17236372-5
-- 12			3408436		05/07/2016		$ 188.562	$ 188.563			17236372-5	17236372-5
-- 12			3408437		05/08/2016		$ 188.564	$ 188.561			17236372-5	


-- Cambio Monto cheque 3408434 cambio de $ 188.562 a $ 188.563	
select * from DETALLE_INGRESOS where ding_ndocto =  3408434

update top(2) ingresos 
set    ingr_mdocto = 188563, 
       ingr_mtotal = 188563 
where  ingr_ncorr = 1516950 

update top(2) detalle_ingresos 
set    ding_mdetalle = 188563, 
       ding_mdocto = 188563 
where  ingr_ncorr = 1516950 

update top(2) abonos 
set    abon_mabono = 188563 
where  ingr_ncorr = 1516950 

-- Cambio Monto cheque 3408435 cambio de $ 188.562 a $ 188.563	
select * from DETALLE_INGRESOS where ding_ndocto =  3408435

update top(2) ingresos 
set    ingr_mdocto = 188563, 
       ingr_mtotal = 188563 
where  ingr_ncorr = 1516951 

update top(2) detalle_ingresos 
set    ding_mdetalle = 188563, 
       ding_mdocto = 188563 
where  ingr_ncorr = 1516951 

update top(2) abonos 
set    abon_mabono = 188563 
where  ingr_ncorr = 1516951 

-- Cambio Monto cheque 3408436 cambio de $ 188.562 a $ 188.563	
select * from DETALLE_INGRESOS where ding_ndocto =  3408436

update top(2) ingresos 
set    ingr_mdocto = 188563, 
       ingr_mtotal = 188563 
where  ingr_ncorr = 1516952 

update top(2) detalle_ingresos 
set    ding_mdetalle = 188563, 
       ding_mdocto = 188563 
where  ingr_ncorr = 1516952 

update top(2) abonos 
set    abon_mabono = 188563 
where  ingr_ncorr = 1516952 

-- Cambio Monto cheque 3408437 cambio de $ 188.564 a $ 188.561	
select * from DETALLE_INGRESOS where ding_ndocto =  3408437

update top(2) ingresos 
set    ingr_mdocto = 188561, 
       ingr_mtotal = 188561 
where  ingr_ncorr = 1516953 

update top(2) detalle_ingresos 
set    ding_mdetalle = 188561, 
       ding_mdocto = 188561 
where  ingr_ncorr = 1516953 

update top(2) abonos 
set    abon_mabono = 188561 
where  ingr_ncorr = 1516953 
