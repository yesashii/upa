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
       and b.peri_ccod in ( 240 ) 
       and a.pers_ncorr = c.pers_ncorr 
       and a.emat_ccod in ( 1 ) 
       and a.pers_ncorr = d.pers_ncorr 
       and not exists (select 1 
                       from   sis_usuarios aa 
                       where  aa.pers_ncorr = a.pers_ncorr) 
					   
/* Affected rows: 0  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,312 sec. */

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
       and b.peri_ccod in ( 240 ) 
       and a.pers_ncorr = c.pers_ncorr 
       and a.emat_ccod in ( 1 ) 
       and not exists (select 1 
                       from   sis_roles_usuarios aa 
                       where  aa.pers_ncorr = a.pers_ncorr 
                              and srol_ncorr = 4) 						   
							  
/* Affected rows: 612  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,109 sec. */

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
       and fecha_creacion >= convert(datetime, '18/01/2016', 103) -- 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo not like '%docentes%' 
       and email_nuevo like '%.%@alumnos.upacifico.cl' 

/* Affected rows: 0  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,031 sec. */

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
       and fecha_creacion >= convert(datetime, '18/01/2016', 103) 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo like '%docentes%' 
       and b.susu_tclave = Cast(c.pers_nrut as varchar) 

/* Affected rows: 0  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,016 sec. */
update sd_cursos_moodle_sin_bloques 
set    con_bloque = 'SI' 
where  con_bloque = 'NO' 	
/* Affected rows: 0  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,062 sec. */
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
               and Cast(b.peri_ccod as varchar) = '240' 
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
/* Affected rows: 0  Filas encontradas: 26  Advertencias: 0  Duración para 1 query: 0,437 sec. */

/*
"facu_ccod"		"sede_ccod"		"carr_ccod"		"jorn_ccod"		"asig_ccod"		"seccion"	"nombre_largo"																		"nombre_corto"			"id"
"7"				"1"				"220"			"1"				"DIPMPI001"		"1"			"ENFOQUES TEORICOS EN LA INVESTIGACIÓN Y DIS. DE PROYECTOS (1)"						"DIPMPI001(1)"			"1-220-1-DIPMPI001-1"
"7"				"1"				"220"			"1"				"DIPMPI002"		"1"			"HERRAMIENTAS PARA EL DESARROLLO DE PROYECTOS DE INVESTIGACION (1)"					"DIPMPI002(1)"			"1-220-1-DIPMPI002-1"
"7"				"1"				"220"			"1"				"DIPMPI003"		"1"			"GESTIÓN, DIFUSIÓN Y COMUNICACIÓN DE PROYECTOS (1)"	"DIPMPI003(1)"					"1-220-1-DIPMPI003-1"	"1"				"1"				"400"			"2"				"MAGMKT011"		"1"			"TESIS DE GRADO (1)"	"MAGMKT011(1)"												"1-400-2-MAGMKT011-1"
"4"				"1"				"500"			"2"				"MAGTS005"		"1"			"MODULO I: INTERACCION EN LAS RELACIONES HUMANAS (1)"								"MAGTS005(1)"			"1-500-2-MAGTS005-1"
"4"				"1"				"500"			"2"				"MAGTS006"		"1"			"MODULO II: PROBLEMATICAS DE LA FAMILIA CONTEMP. (1)"								"MAGTS006(1)"			"1-500-2-MAGTS006-1"
"4"				"1"				"500"			"2"				"MAGTS007"		"1"			"MODULO III: PENS. CIBERNETICO EN LA INTERV. FAMILIAR (1)"							"MAGTS007(1)"			"1-500-2-MAGTS007-1"
"4"				"1"				"500"			"2"				"MAGTS008"		"1"			"MODULO IV: INVESTIGACION SOCIAL II (1)"											"MAGTS008(1)"			"1-500-2-MAGTS008-1"
"4"				"1"				"500"			"2"				"MAGTS013"		"1"			"TESIS (1)"																			"MAGTS013(1)"			"1-500-2-MAGTS013-1"
"4"				"1"				"500"			"2"				"MAGTS013"		"2"			"TESIS (2)"																			"MAGTS013(2)"			"1-500-2-MAGTS013-2"
"4"				"1"				"500"			"2"				"MAGTS013"		"3"			"TESIS (3)"																			"MAGTS013(3)"			"1-500-2-MAGTS013-3"
"4"				"1"				"500"			"2"				"MAGTS013"		"4"			"TESIS (4)"																			"MAGTS013(4)"			"1-500-2-MAGTS013-4"
"4"				"1"				"500"			"2"				"MAGTS013"		"5"			"TESIS (5)"																			"MAGTS013(5)"			"1-500-2-MAGTS013-5"
"4"				"1"				"500"			"2"				"MAGTS013"		"6"			"TESIS (6)"																			"MAGTS013(6)"			"1-500-2-MAGTS013-6"
"4"				"1"				"500"			"2"				"MAGTS013"		"7"			"TESIS (7)"																			"MAGTS013(7)"			"1-500-2-MAGTS013-7"
"4"				"1"				"500"			"2"				"MAGTS013"		"8"			"TESIS (8)"																			"MAGTS013(8)"			"1-500-2-MAGTS013-8"
"4"				"1"				"500"			"2"				"MAGTS013"		"9"			"TESIS (9)"																			"MAGTS013(9)"			"1-500-2-MAGTS013-9"
"4"				"1"				"450"			"2"				"MAGTS019"		"1"			"MÓDULO I: TESIS (1)"																"MAGTS019(1)"			"1-450-2-MAGTS019-1"
"4"				"1"				"450"			"2"				"MAGTS019"		"2"			"MÓDULO I: TESIS (2)"																"MAGTS019(2)"			"1-450-2-MAGTS019-2"
"4"				"1"				"450"			"2"				"MAGTS019"		"3"			"MÓDULO I: TESIS (3)"																"MAGTS019(3)"			"1-450-2-MAGTS019-3"
"4"				"1"				"450"			"2"				"MAGTS019"		"4"			"MÓDULO I: TESIS (4)"																"MAGTS019(4)"			"1-450-2-MAGTS019-4"
"4"				"1"				"450"			"2"				"MAGTS019"		"5"			"MÓDULO I: TESIS (5)"																"MAGTS019(5)"			"1-450-2-MAGTS019-5"
"4"				"1"				"450"			"2"				"MAGTS019"		"6"			"MÓDULO I: TESIS (6)"																"MAGTS019(6)"			"1-450-2-MAGTS019-6"
"4"				"1"				"450"			"2"				"MAGTS019"		"7"			"MÓDULO I: TESIS (7)"																"MAGTS019(7)"			"1-450-2-MAGTS019-7"
"4"				"1"				"450"			"2"				"MAGTS019"		"8"			"MÓDULO I: TESIS (8)"																"MAGTS019(8)"			"1-450-2-MAGTS019-8"
"4"				"1"				"450"			"2"				"MAGTS019"		"9"			"MÓDULO I: TESIS (9)"																"MAGTS019(9)"			"1-450-2-MAGTS019-9"


*/

-- 5: ejecutar script de carga de datos.-
/*
Servidor		: 172.16.254.8
Usuario			: root
Base de datos	: moodle19
*/
-- Extracción de correlativos máximos Moodle


select
(select max(id) + 20 from mdl_course_categories)  	as categoria
, (select max(id) from mdl_course_categories)  		as n_categoria
, (select max(id) + 100 from mdl_course) 				as curso
, (select max(id) from mdl_course) 						as n_curso
, (select max(id) + 100 from mdl_course_sections) 	as seccion
, (select max(id) from mdl_course_sections)			as n_seccion
, (select max(id) + 100 from mdl_context) 			as contexto
, (select max(id) from mdl_context)						as n_contexto
, (select max(id) + 100 from mdl_cache_flags) 		as cache_flacs
, (select max(id) from mdl_cache_flags)				as n_cache_flacs
, (select max(id) + 100 from mdl_log)  				as logg
, (select max(id) from mdl_log)  						as n_logg
, (select max(id) + 100 from mdl_forum)				as forum
, (select max(id) from mdl_forum) 						as n_forum
, (select max(id) + 100 from mdl_course_modules) 	as modules
, (select max(id) from mdl_course_modules) 			as n_modules
, (select max(id) + 100 from mdl_course_display) 	as display
, (select max(id) from mdl_course_display) 			as n_display
, (select max(id) + 100 from mdl_block_instance) 	as block
, (select max(id) from mdl_block_instance) 			as n_block

/*
<?xml version="1.0" encoding="utf8"?>

<table_data name="TablaDesconocida">
	<row>
		<field name="categoria">620</field>
		<field name="n_categoria">600</field>
		
		<field name="curso">37554</field>
		<field name="n_curso">37454</field>
		
		<field name="seccion">195023</field>
		<field name="n_seccion">194923</field>
		
		<field name="contexto">562870</field>
		<field name="n_contexto">562770</field>
		
		<field name="cache_flacs" xsi:nil="true" />
		<field name="n_cache_flacs" xsi:nil="true" />
		
		<field name="logg">17015476</field>
		<field name="n_logg">17015376</field>
		
		<field name="forum">46972</field>
		<field name="n_forum">46872</field>
		
		<field name="modules">267975</field>
		<field name="n_modules">267875</field>
		
		<field name="display">361521</field>
		<field name="n_display">361421</field>
		
		<field name="block">223250</field>
		<field name="n_block">223150</field>
	</row>
</table_data>

 -- antes
ultima_categoria    = 620 '600
ultimo_curso        = 37434 '37334 
ultima_seccion      = 194736 '194636 195023
ultimo_contexto     = 562430 '562330
ultimo_cache_flacs  = 581044 '580944
ultimo_log          = 17002067 '17001967
path_contexto       = "/1"

id_forum        = 46865 '46765
course_modules  = 267750 '267650
course_display  = 361337 '361237
block_instance  = 222966 '222866

*/

/*
http://fangorn.upacifico.cl/sigaupa/PRUEBA/moodle19_2016_18.asp


update mdl_course_categories  set coursecount = 32
 where id=428;
 update mdl_course_categories  set coursecount = 0
 where id=429;
 update mdl_course_categories  set coursecount = 36
 where id=580;
 update mdl_course_categories  set coursecount = 30
 where id=444;
 update mdl_course_categories  set coursecount = 0
 where id=496;
 update mdl_course_categories  set coursecount = 0
 where id=443;
 update mdl_course_categories  set coursecount = 26
 where id=579;
 update mdl_course_categories  set coursecount = 59
 where id=423;
 update mdl_course_categories  set coursecount = 0
 where id=414;
 update mdl_course_categories  set coursecount = 63
 where id=415;
 update mdl_course_categories  set coursecount = 0
 where id=551;
 update mdl_course_categories  set coursecount = 67
 where id=411;
 update mdl_course_categories  set coursecount = 129
 where id=413;
 update mdl_course_categories  set coursecount = 31
 where id=424;
 update mdl_course_categories  set coursecount = 0
 where id=512;
 update mdl_course_categories  set coursecount = 0
 where id=501;
 update mdl_course_categories  set coursecount = 49
 where id=422;
 update mdl_course_categories  set coursecount = 152
 where id=449;
 update mdl_course_categories  set coursecount = 182
 where id=421;
 update mdl_course_categories  set coursecount = 67
 where id=420;
 update mdl_course_categories  set coursecount = 50
 where id=587;
 update mdl_course_categories  set coursecount = 29
 where id=588;
 update mdl_course_categories  set coursecount = 48
 where id=482;
 update mdl_course_categories  set coursecount = 49
 where id=483;
 update mdl_course_categories  set coursecount = 9
 where id=273;
 update mdl_course_categories  set coursecount = 0
 where id=274;
 update mdl_course_categories  set coursecount = 0
 where id=334;
 update mdl_course_categories  set coursecount = 0
 where id=426;
 update mdl_course_categories  set coursecount = 58
 where id=427;
 update mdl_course_categories  set coursecount = 118
 where id=469;
 update mdl_course_categories  set coursecount = 6
 where id=519;
 update mdl_course_categories  set coursecount = 0
 where id=586;
 update mdl_course_categories  set coursecount = 4
 where id=582;
 update mdl_course_categories  set coursecount = 3
 where id=583;
 update mdl_course_categories  set coursecount = 5
 where id=585;
 update mdl_course_categories  set coursecount = 19
 where id=584;
 update mdl_course_categories  set coursecount = 28
 where id=425;
 update mdl_course_categories  set coursecount = 53
 where id=589;
 update mdl_course_categories  set coursecount = 1
 where id=511;
 update mdl_course_categories  set coursecount = 17
 where id=578;
 update mdl_course_categories  set coursecount = 0
 where id=103;
 update mdl_course_categories  set coursecount = 0
 where id=306;
 update mdl_course_categories  set coursecount = 0
 where id=358;
 update mdl_course_categories  set coursecount = 0
 where id=105;
 update mdl_course_categories  set coursecount = 0
 where id=261;
 update mdl_course_categories  set coursecount = 0
 where id=106;
 update mdl_course_categories  set coursecount = 0
 where id=110;
 update mdl_course_categories  set coursecount = 0
 where id=108;
 update mdl_course_categories  set coursecount = 0
 where id=226;
 update mdl_course_categories  set coursecount = 0
 where id=104;
 update mdl_course_categories  set coursecount = 0
 where id=109;
 update mdl_course_categories  set coursecount = 0
 where id=107;
 update mdl_course_categories  set coursecount = 0
 where id=111;
 update mdl_course_categories  set coursecount = 0
 where id=442;
 update mdl_course_categories  set coursecount = 20
 where id=433;
 update mdl_course_categories  set coursecount = 16
 where id=446;
 update mdl_course_categories  set coursecount = 30
 where id=439;
 update mdl_course_categories  set coursecount = 13
 where id=467;
 update mdl_course_categories  set coursecount = 48
 where id=419;
 update mdl_course_categories  set coursecount = 15
 where id=485;
 update mdl_course_categories  set coursecount = 14
 where id=484;
 update mdl_course_categories  set coursecount = 18
 where id=581;
 update mdl_course_categories  set coursecount = 19
 where id=590;
 update mdl_course_categories  set coursecount = 0
 where id=122;
 update mdl_course_categories  set coursecount = 0
 where id=462;
 update mdl_course_categories  set coursecount = 0
 where id=431;
 update mdl_course_categories  set coursecount = 48
 where id=458;
 update mdl_course_categories  set coursecount = 25
 where id=464;
 update mdl_course_categories  set coursecount = 55
 where id=441;
 update mdl_course_categories  set coursecount = 45
 where id=470;
 update mdl_course_categories  set coursecount = 0
 where id=514;
 update mdl_course_categories  set coursecount = 48
 where id=416;
 update mdl_course_categories  set coursecount = 80
 where id=417;
 update mdl_course_categories  set coursecount = 55
 where id=418;
 update mdl_course_categories  set coursecount = 69
 where id=461;
 update mdl_course_categories  set coursecount = 3
 where id=459;
 update mdl_course_categories  set coursecount = 0
 where id=460;
 update mdl_course_categories  set coursecount = 13
 where id=456;
 update mdl_course_categories  set coursecount = 2
 where id=463;
 update mdl_course_categories  set coursecount = 53
 where id=438;
 update mdl_course_categories  set coursecount = 0
 where id=131;
 update mdl_course_categories  set coursecount = 0
 where id=481;
 update mdl_course_categories  set coursecount = 0
 where id=101;
 update mdl_course_categories  set coursecount = 0
 where id=457;
 update mdl_course_categories  set coursecount = 0
 where id=236;
 update mdl_course_categories  set coursecount = 0
 where id=450;
 update mdl_course_categories  set coursecount = 0
 where id=451;
 update mdl_course_categories  set coursecount = 0
 where id=455;
 update mdl_course_categories  set coursecount = 0
 where id=468;
 update mdl_course_categories  set coursecount = 0
 where id=321;
 update mdl_course_categories  set coursecount = 0
 where id=466;
 update mdl_course_categories  set coursecount = 0
 where id=454;
 update mdl_course_categories  set coursecount = 0
 where id=453;
 update mdl_course_categories  set coursecount = 0
 where id=465;
 update mdl_course_categories  set coursecount = 0
 where id=452;
 update mdl_course_categories  set coursecount = 0
 where id=102;
 update mdl_course_categories  set coursecount = 34
 where id=448;
*/
/* Affected rows: 52  Filas encontradas: 0  Advertencias: 0  Duración para 97 queries: 0,262 sec. */


/*

Usuarios creados: 0
Usuarios actualizados: 0
Usuarios con contraseña débil: 0
Errores: 0
*/

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

/* Affected rows: 0  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,031 sec. */

-- Docentes creados:
select c.pers_tnombre      as nombres, 
       c.pers_tape_paterno as apellido_paterno, 
       c.pers_tape_materno as apellido_materno, 
       rut 
from   cuentas_email_upa a, 
       sis_usuarios b, 
       personas c 
where  a.pers_ncorr = b.pers_ncorr 
       and fecha_creacion >= convert(datetime, '18/01/2016', 103)  
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo like '%docentes%' 
/* Affected rows: 0  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,015 sec. */

-- Alumnos creados
select c.pers_tnombre      as nombres, 
       c.pers_tape_paterno as apellido_paterno, 
       c.pers_tape_materno as apellido_materno, 
       rut 
from   cuentas_email_upa a, 
       sis_usuarios b, 
       personas c 
where  a.pers_ncorr = b.pers_ncorr 
       and fecha_creacion >= convert(datetime, '18/01/2016', 103) 
       and b.pers_ncorr = c.pers_ncorr 
       and email_nuevo not like '%docentes%' 

/* Affected rows: 0  Filas encontradas: 0  Advertencias: 0  Duración para 1 query: 0,016 sec. */





 

































							  