select distinct protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre,a.pers_ncorr 
from cajeros a, personas b
where a.pers_ncorr=b.pers_ncorr
and caje_cestado=1

