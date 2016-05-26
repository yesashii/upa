select ting_tdesc as documento, protic.documento_asociado_cuota(a.tcom_ccod, 1, a.comp_ndocto, a.dcom_ncompromiso, 'ding_ndocto') as numero,
protic.obtener_rut(pers_ncorr) as rut, protic.obtener_nombre_completo(pers_ncorr,'n') as nombre_alumno,year(dcom_fcompromiso) as año_deuda, 
dcom_fcompromiso as vencimiento, imup_monto_deuda as deuda, imup_monto_saldo as saldo,imup_carrera  as carrera
from 
indicador_morosidad_upa a, tipos_ingresos b       
where 1=1      
 and convert(datetime,dcom_fcompromiso,103) >= convert(datetime,'01/01/2008',103) 
 and a.ting_ccod not in (38,3,4,52,51,13)
 and a.ting_ccod=b.ting_ccod