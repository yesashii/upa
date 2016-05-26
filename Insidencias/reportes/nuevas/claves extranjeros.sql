select c.susu_tlogin as login, susu_tclave as clave,a.* 
from sd_alumnos_extranjeros a, personas b, sis_usuarios c
where a.rut=b.pers_nrut
and b.pers_ncorr=c.pers_ncorr