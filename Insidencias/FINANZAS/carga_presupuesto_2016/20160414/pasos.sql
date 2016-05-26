
select * from protic.paso_presupuesto_upa_2016 

select * from protic.presupuesto_upa_2016 


delete protic.presupuesto_upa_2016 


insert into protic.presupuesto_upa_2016 select * from protic.paso_presupuesto_upa_2016 



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