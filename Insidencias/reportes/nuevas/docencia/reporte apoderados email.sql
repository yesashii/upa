select distinct b.pers_temail as email, cast(pers_nrut as varchar)+'-'+pers_xdv as rut, 
pers_tnombre as nombres, pers_tape_paterno as apellido_paterno, pers_tape_paterno as apellido_materno,
protic.obtener_direccion_letra(b.pers_ncorr,'')
from sis_usuarios a, personas b, sis_roles_usuarios c
where a.pers_ncorr=b.pers_ncorr
and a.pers_ncorr=c.pers_ncorr
and c.srol_ncorr=5
and pers_temail is not null
and len(pers_temail)>1
--and pers_temail not in ('[NULL]')
and a.audi_tusuario like '%2010%'


13373573

13501162

 select pote_ncorr,cast(a.pers_nrut as varchar)+'-'+a.pers_xdv as rut,a.pers_nrut,a.pers_xdv, 
 pers_tnombre +' '+ pers_tape_paterno + ' ' + pers_tape_materno as alumno, 
 c.epot_tdesc as estado_postulacion, 
 case fpot_ccod when 1 then 'Persona Natural' when 2  then 'Empresa sin Sence' when 3 then 'Empresa con Sence' when 4 then 'Empresa y Otic' end as forma_pago, 
 protic.trunc(fecha_postulacion)as fecha_postulacion 
 from personas a, postulacion_otec b,estados_postulacion_otec c 
 where a.pers_ncorr=b.pers_ncorr and b.epot_ccod=c.epot_ccod 
 and cast(dgso_ncorr as varchar)='219'  