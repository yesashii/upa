-- Listado de descuentos activos en SGA
select tdet_ccod, tdet_tdesc as nombre_beneficio, tben_tdesc as tipo_beneficio,tdet_cuenta_softland, tdet_detalle_softland, udes_tdesc as uso 
from tipos_detalle a, tipos_beneficios b, usos_descuentos c 
where a.tben_ccod=b.tben_ccod
and a.tben_ccod in (2,3) 
and a.udes_ccod=c.udes_ccod -- usos de los descuentos
and tdet_bvigente like 'S'