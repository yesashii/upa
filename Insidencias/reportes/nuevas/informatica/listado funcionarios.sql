select distinct protic.obtener_nombre_completo(a.pers_ncorr,'n') as nombre, 
protic.obtener_rut(a.pers_ncorr), susu_tlogin as login, a.pers_ncorr as clave
from sis_usuarios a, sis_roles_usuarios b, personas c
where a.pers_ncorr=b.pers_ncorr
and b.srol_ncorr not in (3,4,83)
and a.pers_ncorr=c.pers_ncorr
and a.pers_ncorr in (select distinct pers_ncorr from login_usuarios)

