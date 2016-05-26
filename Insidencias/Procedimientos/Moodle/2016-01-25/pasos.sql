

insert into sis_usuarios 
select distinct a.pers_ncorr, 
                Cast(c.pers_nrut as varchar) + '- ' + c.pers_xdv        as susu_tlogin, 
                (select Max(matr_ncorr) 
                 from   alumnos aaa 
                 where  aaa.pers_ncorr = a.pers_ncorr) 					as susu_tclave, 
                Getdate()                              					as susu_fmodificacion, 
                'asignación usuarios'                 					as audi_tusuario, 
                Getdate()                              					as audi_fmodificacion, 
                null                                   					as actualizado_por 
from   alumnos a, 
       ofertas_academicas b, 
       personas_postulante c, 
       personas d 
where  a.ofer_ncorr = b.ofer_ncorr 
       and b.peri_ccod in ( 242 ) 
       and a.pers_ncorr = c.pers_ncorr 
       and a.emat_ccod in ( 1 ) 
       and a.pers_ncorr = d.pers_ncorr 
       and not exists (select 1 
                       from   sis_usuarios aa 
                       where  aa.pers_ncorr = a.pers_ncorr) 
					   
-- 	(44 filas afectadas)				   



insert into sis_roles_usuarios 
select distinct 						a.pers_ncorr, 
                4                      	as srol_ncorr, 
                Getdate()              	as srus_fmodificacion, 
                'asignación usuarios' 	as audi_tusuario, 
                Getdate()              	as audi_fmodificacion 
from   alumnos a, 
       ofertas_academicas b, 
       personas c 
where  a.ofer_ncorr = b.ofer_ncorr 
       and b.peri_ccod in ( 242 ) 
       and a.pers_ncorr = c.pers_ncorr 
       and a.emat_ccod in ( 1 ) 
       and not exists (select 1 
                       from   sis_roles_usuarios aa 
                       where  aa.pers_ncorr = a.pers_ncorr 
                              and srol_ncorr = 4) 
							  
-- (44 filas afectadas)


http://fangorn.upacifico.cl/sigaupa/PRUEBA/cuentas_nuevas_docentes_upa.asp

-- Total de cuentas incorporadas: 1 cuentas para el periodo: 242		


http://fangorn.upacifico.cl/sigaupa/PRUEBA/cuentas_nuevas_alumnos_upa.asp

-- Total de cuentas incorporadas: 659 cuentas para el periodo: 242	


-- Revisión cuentas de alumnos

-- se encontraron 7 casos.

select a.*
from   cuentas_email_upa a, 
       sis_usuarios b, 
       personas c 
where  a.pers_ncorr = b.pers_ncorr 
       and fecha_creacion >= convert(datetime, '25/01/2016', 103) -- 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo not like '%docentes%' 
       and email_nuevo like '%.%@alumnos.upacifico.cl' 
       

-- respaldo:cuentas_email_upa: (17473 filas afectadas)
select *
into #temp_cuentas_email_upa
from cuentas_email_upa
-- ----------------------------------------------------

Update cuentas_email_upa 
Set email_nuevo = replace(email_nuevo, '.', '')
where PERS_NCORR in (
278256
,280075
,280100
,280238
,280786
,281018
,281228
)
-- (7 filas afectadas)

-- Revisión cuentas de alumnos

select Lower(email_nuevo)   as email_nuevo, 
       Upper(b.susu_tclave) as clave, 
       c.pers_tnombre       as nombres, 
       c.pers_tape_paterno  as apellido_paterno, 
       c.pers_tape_materno  as apellido_materno, 
       rut, 
       Lower(pers_temail)   as email_particular, 
       clave_email, 
       a.pers_ncorr, 
       fecha_creacion, 
       case Substring(b.susu_tclave, 1, 1) 
         when '0' then '*' + b.susu_tclave 
         else '' 
       end                  as clave_original_sin_asterisco 
from   cuentas_email_upa a, 
       sis_usuarios b, 
       personas c 
where  a.pers_ncorr = b.pers_ncorr 
       and fecha_creacion >= convert(datetime, '25/01/2016', 103) -- 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo not like '%docentes%' 
       and email_nuevo like '%.%@alumnos.upacifico.cl' 		
	   
-- docentes 

select Lower(email_nuevo)   as email_nuevo, 
       Upper(b.susu_tclave) as clave, 
       c.pers_tnombre       as nombres, 
       c.pers_tape_paterno  as apellido_paterno, 
       c.pers_tape_materno  as apellido_materno, 
       rut, 
       Lower(pers_temail)   as email_particular, 
       clave_email, 
       a.pers_ncorr, 
       fecha_creacion, 
       case Substring(b.susu_tclave, 1, 1) 
         when '0' then '*' + b.susu_tclave 
         else '' 
       end                  as clave_original_sin_asterisco 
from   cuentas_email_upa a, 
       sis_usuarios b, 
       personas c 
where  a.pers_ncorr = b.pers_ncorr 
       and fecha_creacion >= convert(datetime, '25/01/2016', 103) 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo like '%docentes%' 
       and b.susu_tclave = Cast(c.pers_nrut as varchar) 
       
/*
email_nuevo	clave	nombres	apellido_paterno	apellido_materno	rut	email_particular	clave_email	pers_ncorr	fecha_creacion	clave_original_sin_asterisco
cnunezp@docentes.upacifico.cl	8108670	CARLOS ALBERTO	NUÑEZ	POBLETE	8108670-2		CNP9118	279118	2016-01-25 10:01:37.387	
*/     





select a.*
from   cuentas_email_upa a, 
       sis_usuarios b, 
       personas c 
where  a.pers_ncorr = b.pers_ncorr 
       and fecha_creacion >= convert(datetime, '25/01/2016', 103) 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo like '%docentes%' 
       and b.susu_tclave = Cast(c.pers_nrut as varchar) 

Update cuentas_email_upa 
Set email_nuevo = replace(email_nuevo, '.', '')
where PERS_NCORR in (select a.PERS_NCORR
from   cuentas_email_upa a, 
       sis_usuarios b, 
       personas c 
where  a.pers_ncorr = b.pers_ncorr 
       and fecha_creacion >= convert(datetime, '25/01/2016', 103) 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo like '%docentes%' 
       and b.susu_tclave = Cast(c.pers_nrut as varchar) )
       
-- (1 filas afectadas)

select Lower(email_nuevo)   as email_nuevo, 
       Upper(b.susu_tclave) as clave, 
       c.pers_tnombre       as nombres, 
       c.pers_tape_paterno  as apellido_paterno, 
       c.pers_tape_materno  as apellido_materno, 
       rut, 
       Lower(pers_temail)   as email_particular, 
       clave_email, 
       a.pers_ncorr, 
       fecha_creacion, 
       case Substring(b.susu_tclave, 1, 1) 
         when '0' then '*' + b.susu_tclave 
         else '' 
       end                  as clave_original_sin_asterisco 
from   cuentas_email_upa a, 
       sis_usuarios b, 
       personas c 
where  a.pers_ncorr = b.pers_ncorr 
       and fecha_creacion >= convert(datetime, '25/01/2016', 103) 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo like '%docentes%' 
       and b.susu_tclave = Cast(c.pers_nrut as varchar) 
       
-- 
Update cuentas_email_upa 
Set email_nuevo = replace(email_nuevo, 'DOCENTESUPACIFICOCL', 'DOCENTES.UPACIFICO.CL')
where PERS_NCORR in (select a.PERS_NCORR
from   cuentas_email_upa a, 
       sis_usuarios b, 
       personas c 
where  a.pers_ncorr = b.pers_ncorr 
       and fecha_creacion >= convert(datetime, '25/01/2016', 103) 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo like '%docentes%' 
       and b.susu_tclave = Cast(c.pers_nrut as varchar) )  

-- 


update sd_cursos_moodle_sin_bloques 
set    con_bloque = 'SI' 
where  con_bloque = 'NO' 


-- (0 filas afectadas)

-- 5: ejecutar script de carga de datos.-
/*
Servidor		: 172.16.254.8
Usuario			: root
Base de datos	: moodle19
*/
-- Extracción de correlativos máximos Moodle

select
(select max(id) + 20 from mdl_course_categories)  		as categoria
, (select max(id) from mdl_course_categories)  			as n_categoria

, (select max(id) + 100 from mdl_course) 				as curso
, (select max(id) from mdl_course) 						as n_curso

, (select max(id) + 100 from mdl_course_sections) 		as seccion
, (select max(id) from mdl_course_sections)				as n_seccion

, (select max(id) + 100 from mdl_context) 				as contexto
, (select max(id) from mdl_context)						as n_contexto

, (select max(id) + 100 from mdl_cache_flags) 			as cache_flacs
, (select max(id) from mdl_cache_flags)					as n_cache_flacs

, (select max(id) + 100 from mdl_log)  					as logg
, (select max(id) from mdl_log)  						as n_logg

, (select max(id) + 100 from mdl_forum)					as forum
, (select max(id) from mdl_forum) 						as n_forum

, (select max(id) + 100 from mdl_course_modules) 		as modules
, (select max(id) from mdl_course_modules) 				as n_modules

, (select max(id) + 100 from mdl_course_display) 		as display
, (select max(id) from mdl_course_display) 				as n_display

, (select max(id) + 100 from mdl_block_instance) 		as block
, (select max(id) from mdl_block_instance) 				as n_block


-- luego copiar 



-- updates

/* Affected rows: 52  Filas encontradas: 0  Advertencias: 0  Duración para 97 queries: 0,375 sec. */
	   
       














  	   


























































	   