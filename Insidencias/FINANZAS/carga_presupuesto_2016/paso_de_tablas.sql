select * into protic.paso_presupuesto_upa_2016_2 from protic.paso_presupuesto_upa_2016


drop table protic.paso_presupuesto_upa_2016


create table protic.paso_presupuesto_upa_2016
(
id int  
,cod_anio int 
,cod_pre varchar(500)
,cod_area int
,descripcion_area varchar(500)
,concepto varchar(500)
,detalle varchar(2000)
,enero int
,febrero int
,marzo int
,abril int
,mayo int
,junio int
,julio int
,agosto int
,septiembre int
,octubre int
,noviembre int
,diciembre int
,enero_prox int
,febrero_prox int
,total int
)

select * from protic.paso_presupuesto_upa_2016 

insert into protic.paso_presupuesto_upa_2016(id,cod_anio, cod_pre, cod_area, descripcion_area, concepto, detalle, enero, febrero, marzo, abril, mayo, junio, julio, agosto, septiembre, octubre, noviembre, diciembre)
select id
, cod_anio
, cod_pre
, cod_area
, descripcion_area
, concepto
, detalle
, enero
, febrero
, marzo
, abril
, mayo
, junio
, julio
, agosto
, septiembre
, octubre
, noviembre
, diciembre
from protic.paso_presupuesto_upa_2016_2



select * from protic.paso_presupuesto_upa_2016


drop table protic.paso_presupuesto_upa_2016_2

select * from protic.paso_presupuesto_upa_2016


select * from protic.presupuesto_upa_2016


delete protic.presupuesto_upa_2016


select * from protic.presupuesto_upa_2016

ALTER TABLE protic.presupuesto_upa_2016
ALTER COLUMN  "detalle" varchar(1500);





insert into protic.presupuesto_upa_2016(cod_anio, cod_pre, cod_area, descripcion_area, concepto, detalle, enero, febrero, marzo, abril, mayo, junio, julio, agosto, septiembre, octubre, noviembre, diciembre,enero_prox,febrero_prox,total)
select cod_anio
, cod_pre
, cod_area
, descripcion_area
, concepto
, detalle
, enero
, febrero
, marzo
, abril
, mayo
, junio
, julio
, agosto
, septiembre
, octubre
, noviembre
, diciembre
, enero_prox
, febrero_prox
, total
from protic.paso_presupuesto_upa_2016


select * from protic.presupuesto_upa_2016