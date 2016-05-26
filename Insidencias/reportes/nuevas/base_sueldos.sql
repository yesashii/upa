select '71704700' as rut_empresa,'1' as dv_e,
STUFF(rut_trabajador, 1, 0,REPLICATE('0',cast(8-len(rut_trabajador) as numeric))) as rut_trabajador,dv_t,
'00000' as correlativo_t ,
substring(paterno_t,0,60) as paterno_t,substring(materno_t,0,40) as materno_t,substring(nombres_t,0,40) as nombres_t,
STUFF(mes_renta, 1, 0,REPLICATE('0',cast(2-len(mes_renta) as numeric))) as mes_renta,
STUFF(total_sueldo, 1, 0,REPLICATE('0',cast(12-len(total_sueldo) as numeric))) as total_sueldo,
STUFF(total_imponible, 1, 0,REPLICATE('0',cast(12-len(total_imponible) as numeric))) as total_imponible,
STUFF(total_retenido, 1, 0,REPLICATE('0',cast(12-len(total_retenido) as numeric))) as total_retenido,
STUFF(mayor_retencion, 1, 0,REPLICATE('0',cast(12-len(mayor_retencion) as numeric))) as mayor_retencion,
STUFF(renta_total_exenta, 1, 0,REPLICATE('0',cast(12-len(renta_total_exenta) as numeric))) as renta_total_exenta,
STUFF(rebajas_zonas, 1, 0,REPLICATE('0',cast(12-len(rebajas_zonas) as numeric))) as rebajas_zonas,
STUFF(numero_certificado, 1, 0,REPLICATE('0',cast(7-len(numero_certificado) as numeric))) as numero_certificado
from sd_base_sueldos
order by rut_trabajador asc,mes_renta asc

