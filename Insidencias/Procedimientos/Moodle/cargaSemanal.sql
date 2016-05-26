-- /*************************************************************************/
-- /*****************		Carga Semanal	********************************/
-- /*************************************************************************/


-- 1: Crear accesos Pacífico online alumnos nuevos:

/*
Base de datos: sigaupa
Servidor: 172.16.254.4 
Usuario base de datos: cualquiera con permisos de escritura en tabla.



Inserta en la tabla sis_usuarios (Es la tabla que maneja los usuarios del sistema).
los alumnos además de asignarle usuario y contraseña.
*/


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
       and b.peri_ccod in ( var_periodo ) 
       and a.pers_ncorr = c.pers_ncorr 
       and a.emat_ccod in ( 1 ) 
       and a.pers_ncorr = d.pers_ncorr 
       and not exists (select 1 
                       from   sis_usuarios aa 
                       where  aa.pers_ncorr = a.pers_ncorr) 
					   
					   
-- asignación de los roles

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
       and b.peri_ccod in ( var_periodo ) 
       and a.pers_ncorr = c.pers_ncorr 
       and a.emat_ccod in ( 1 ) 
       and not exists (select 1 
                       from   sis_roles_usuarios aa 
                       where  aa.pers_ncorr = a.pers_ncorr 
                              and srol_ncorr = 4) 	




-- 2: Crear cuentas de email alumnos y docentes:

/*
Para la creación de email se debe ingresar al sistema de gestión bajo un perfil de “Administrador” y
luego ingresar al módulo:

“Mantenedor académico” - > “alumnos cursos moodle”

se carga en la siguiente url: “http://fangorn.upacifico.cl/sigaupa/PRUEBA/ALUMNOS_MOODLE.ASP” 

y en ella debemos cambiar la página “alumnos_moodle.asp” por las páginas
“cuentas_nuevas_docentes_upa.asp” y “cuentas_nuevas_alumnos_upa.asp”.


http://fangorn.upacifico.cl/sigaupa/PRUEBA/cuentas_nuevas_docentes_upa.asp

http://fangorn.upacifico.cl/sigaupa/PRUEBA/cuentas_nuevas_alumnos_upa.asp



*/	 

/*
Revisar que las cuentas de alumnos no contengan puntos en su creación, para ello ejecutamos la
siguiente query:
*/

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
       and fecha_creacion >= convert(datetime, 'var_DD/MM/AAAA', 103) -- 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo not like '%docentes%' 
       and email_nuevo like '%.%@alumnos.upacifico.cl' 
	   
	   
-- Revisión cuentas docentes

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
       and fecha_creacion >= convert(datetime, 'var_dd/mm/aaaa', 103) 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo like '%docentes%' 
       and b.susu_tclave = Cast(c.pers_nrut as varchar) 
	   and email_nuevo like '%.%@docentes.upacifico.cl' 
	   
-- 3: Quitar marcas a los últimos cursos cargados:

update sd_cursos_moodle_sin_bloques 
set    con_bloque = 'SI' 
where  con_bloque = 'NO' 	   

-- 4: Revisar si existen asignaturas nuevas a cargar:

select facu_ccod, 
       sede_ccod, 
       carr_ccod, 
       jorn_ccod, 
       asig_ccod, 
       seccion, 
       asig_tdesc + ' (' + seccion + ')' as nombre_largo, 
       asig_ccod + '(' + seccion + ')'   as nombre_corto, 
       Cast(sede_ccod as varchar) + '-' + carr_ccod 
       + '-' + Cast(jorn_ccod as varchar) + '-' 
       + asig_ccod + '-' + seccion       as id 
from   (select distinct Ltrim(Rtrim(a.sede_ccod))                   as sede_ccod, 
                        Ltrim(Rtrim(a.carr_ccod))                   as carr_ccod, 
                        Ltrim(Rtrim(a.jorn_ccod))                   as jorn_ccod, 
                        Ltrim(Rtrim(a.asig_ccod))                   as asig_ccod, 
                        Ltrim(Rtrim(c.asig_tdesc))                  as asig_tdesc, 
                        Substring(Ltrim(Rtrim(a.secc_tdesc)), 1, 1) as seccion, 
                        f.facu_ccod 
        from   secciones a, 
               periodos_academicos b, 
               asignaturas c, 
               carreras d, 
               areas_academicas e, 
               facultades f 
        where  a.peri_ccod = b.peri_ccod 
               and Cast(b.peri_ccod as varchar) = 'var_peri_ccod' 
               and a.asig_ccod = c.asig_ccod 
               and a.carr_ccod = d.carr_ccod 
               and d.area_ccod = e.area_ccod 
               and e.facu_ccod = f.facu_ccod 
               and exists (select 1 
                           from   moodle_course_categories bb 
                           where  bb.facu_ccod = f.facu_ccod) 
               and exists (select 1 
                           from   bloques_horarios cc 
                           where  a.secc_ccod = cc.secc_ccod) 
               and c.asig_tdesc not like '%seleccion%' 
               and c.asig_tdesc not like '%reserva%' 
               and not exists (select 1 
                               from   moodle_course tt 
                               where  tt.asig_ccod = a.asig_ccod 
                                      and tt.sede_ccod = a.sede_ccod 
                                      and tt.jorn_ccod = a.jorn_ccod 
                                      and tt.carr_ccod = a.carr_ccod 
                                      and Cast(tt.seccion as varchar) = Substring(a.secc_tdesc, 1, 1)
                                      and isnull(tt.periodo, '0') = '0'))table1 
order  by sede_ccod, 
          jorn_ccod, 
          asig_ccod, 
          seccion 
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

-- luego copiar como insert y dirigirse al servido sigaupa sql server

/*
ejemplo:
INSERT INTO carga_semanal_moodle_aux 
            (categoria, 
             n_categoria, 
             curso, 
             n_curso, 
             seccion, 
             n_seccion, 
             contexto, 
             n_contexto, 
             cache_flacs, 
             n_cache_flacs, 
             logg, 
             n_logg, 
             forum, 
             n_forum, 
             modules, 
             n_modules, 
             display, 
             n_display, 
             block, 
             n_block,
			 fecha) 
VALUES      (620, 
             600, 
             37554, 
             37454, 
             195159, 
             195059, 
             562992, 
             562892, 
             NULL, 
             NULL, 
             17018989, 
             17018889, 
             46973, 
             46873, 
             268094, 
             267994, 
             361562, 
             361462, 
             223252, 
             223152,
			 getDate()); 
			 
select * from carga_semanal_moodle_aux	



*/



/*
Se debe acceder al servidor Fangorn en el directorio Sigaupa/prueba 

http://fangorn.upacifico.cl/sigaupa/PRUEBA/

en este caso:

moodle19_2016_18.asp

esto imprimirá unos updates que hay que ejecutarlos en la base mysql de moodle 

y luego hay que guardar estas consultas en : carga_semanal_dd_mm_aaaa.txt


luego : ingresar a: http://fangorn.upacifico.cl/sigaupa/PRUEBA/reporte_total_moodle.asp 

preocupandoce que el periodo 

al archivo resultante se le pone: reporte_gnral_dd_mm_aaaa.txt y remmplazar los caracteres ´ 

*/

/*
Sistema Moodle (Perfil Administrador)

Usuario		: admin 
contraseña	: M00dl3.dt1 

http://pacificovirtual.cl/



ir a:

Administración del sitio -> Usuarios -> Cuentas -> Subir usuarios.


Cambiar el ; por ,

seleccionar el archivo generado 


luego en la otra ventana:

“Tipo de subida”, seleccionamos “agregar nuevos y actualizar usuarios existentes” y
luego vamos a la parte inferior del formulario y presionamos el botón “Subir usuarios”.

despues de un momento debería mostrar algo como esto:

 
Usuarios creados: 0
Usuarios actualizados: 0
Usuarios con contraseña débil: 0
Errores: 0

*/	


-- 6: Entrega de informe de trabajo:

-- Base de datos: sigaupa

-- Aulas creadas:
select a.id_curso, 
       sede_tdesc     as sede, 
       carr_tdesc     as carrera, 
       jorn_tdesc     as jornada, 
       Cast(f.asig_ccod as varchar) + ' - ' 
       + f.asig_tdesc as asignatura, 
       b.seccion, 
       b.idnumber     as cod_curso 
from   sd_cursos_moodle_sin_bloques a, 
       moodle_course b, 
       sedes c, 
       carreras d, 
       jornadas e, 
       asignaturas f 
where  con_bloque = 'NO' 
       and a.id_curso = b.id 
       and b.sede_ccod = c.sede_ccod 
       and Cast(b.carr_ccod as varchar) = d.carr_ccod 
       and b.jorn_ccod = e.jorn_ccod 
       and b.asig_ccod = f.asig_ccod 
order  by sede, 
          carrera, 
          jornada, 
          asignatura, 
          seccion 
		  
-- Docentes creados:

select c.pers_tnombre      as nombres, 
       c.pers_tape_paterno as apellido_paterno, 
       c.pers_tape_materno as apellido_materno, 
       rut 
from   cuentas_email_upa a, 
       sis_usuarios b, 
       personas c 
where  a.pers_ncorr = b.pers_ncorr 
       and fecha_creacion >= convert(datetime, 'var_DD/MM/AAAA', 103) 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo like '%docentes%' 
	   
-- Alumnos creados
select c.pers_tnombre      as nombres, 
       c.pers_tape_paterno as apellido_paterno, 
       c.pers_tape_materno as apellido_materno, 
       rut 
from   cuentas_email_upa a, 
       sis_usuarios b, 
       personas c 
where  a.pers_ncorr = b.pers_ncorr 
       and fecha_creacion >= convert(datetime, 'var_DD/MM/AAAA', 103) 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo not like '%docentes%' 
	   
	
/*
Correo reporte (TIPO):

para: Bernardita Loreto Contreras Arevalo <bcontreras@upacifico.cl>

cc: Fernando Cifuentes <fcifuentes@upacifico.cl>; Sinezio Antonio Da Silva Junior <sdasilva@upacifico.cl>; Oscar Bravo Lara <obravo@upacifico.cl>; Luis Torres Pizarro <ltorres@upacifico.cl>; Ricardo Pavez Gonzalez <rpavez@upacifico.cl>

asunto: Carga Moodle 18-01-2016



Estimada Bernardita, la carga fue realizada con la siguiente información:

Aulas creadas: 0

Docentes creados: 0

Alumnos creados: 0


Saludos Cordiales.

*/	


/*

luego subir los archivos

Y:\Archivos Moodle\

*/






	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	