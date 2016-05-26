select distinct susu_tlogin as login, susu_tclave as clave, protic.obtener_rut(a.pers_ncorr) as  docente, 
protic.obtener_direccion(a.pers_ncorr,1,'CNPB') as direccion,protic.obtener_direccion(a.pers_ncorr,1,'C-C') as comuna,
(select min(prof_ingreso_uas)  from profesores where pers_ncorr=b.pers_ncorr group by pers_ncorr)as año_ingreso_upacifico
from carreras_docente a, sis_usuarios b, personas c
where a.peri_ccod=222
and a.pers_ncorr=b.pers_ncorr
and b.pers_ncorr=c.pers_ncorr
