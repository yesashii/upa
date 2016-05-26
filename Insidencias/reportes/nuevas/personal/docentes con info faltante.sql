select distinct a.pers_ncorr,a.pers_nrut,a.pers_xdv,a.pers_tnombre,a.pers_tape_paterno,a.pers_tape_materno, 
protic.trunc(a.pers_fnacimiento) as fecha_nacimiento,b.prof_ingreso_uas  as anio_ingreso,
protic.obtener_grado_docente(a.pers_ncorr,'G') as grado,
case (select count(*) from contratos_docentes_upa where ano_contrato=2007 and pers_ncorr=a.pers_ncorr and ecdo_ccod in (1)) when 0 then 'sin contrato'
else 'contratado' end as Activo
from personas a, profesores b
where a.pers_ncorr=b.pers_ncorr