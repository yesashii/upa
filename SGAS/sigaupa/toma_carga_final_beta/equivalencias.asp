 <!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: TOMA CARGA ACADÉMICA
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 15/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=
'LINEA				          : 216, 262, 263, 418
'********************************************************************
 Server.ScriptTimeOut = 150000
 Response.Buffer = True
 Response.ExpiresAbsolute = Now() - 1
 Response.Expires = 0
 Response.CacheControl = "no-cache" 
 
set pagina = new CPagina
pagina.Titulo = "Asignación de Equivalencias"
carr_ccod   =   request.QueryString("a[0][carr_ccod]")
asig_ccod	=	request.querystring("a[0][asig_ccod]")
plan_ccod	=	request.QueryString("plan_ccod")
pers_ncorr	=	request.QueryString("pers_ncorr")
matr_ncorr		= 	session("matr_ncorr")
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'response.Write(matr_ncorr)

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "toma_carga_alfa.xml", "BotoneraTomaCarga"


set errores 	= new cErrores
set datos		=	new cFormulario
set datos_elec  = new cFormulario
set tresumen	= new cformulario
set seccion 		=	new cformulario
set asig_origen		=	new cformulario

set botonera2 = new CFormulario
botonera2.carga_parametros "toma_carga_alfa.xml", "BotoneraSeccionesEQ"

set f_botoneraEQ = new CFormulario
f_botoneraEQ.Carga_Parametros "inicio_toma_carga_alfa.xml", "botonera"


if matr_ncorr <> "" then
	tipo_plan = conectar.consultaUno("select isnull(plan_tcreditos,0) from alumnos a, planes_estudio b where a.plan_ccod=b.plan_ccod and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'")
	if tipo_plan = "0" then
		filtro_plan = " and isnull(plan_tcreditos,0)=0"
	else
		filtro_plan = " and isnull(plan_tcreditos,0)<>0"
	end if	
peri_ccod = conectar.consultaUno("Select peri_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
sede_ccod = conectar.consultaUno("Select sede_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
plan_ccod = conectar.consultaUno("Select plan_ccod from alumnos  where cast(matr_ncorr as varchar)='"&matr_ncorr&"'")
end if
pers_ncorr= session("pers_ncorr_alumno")
'-------------------------------------------Seleccionar asignatura para equivalencia de una lista sin escribir su código-----
'-----------------------------------------------------------msandoval 24-12-2005---------------------------------------------
set fbusqueda = new cFormulario
fbusqueda.carga_parametros "toma_carga_alfa.xml", "buscador"
fbusqueda.inicializar conectar
peri = peri_ccod'negocio.obtenerPeriodoAcademico ( "planificacion" ) 
sede = sede_ccod'negocio.obtenerSede

if sede="1" or sede="2" then
	filtro_sede = " and cast(b.sede_ccod as varchar) in ('1','2')"
	filtro_sede2 = " and cast(a.sede_ccod as varchar) in ('1','2')"
else
	filtro_sede = " and cast(b.sede_ccod as varchar)='"&sede&"'"
	filtro_sede2 = " and cast(a.sede_ccod as varchar)='"&sede&"'"
end if

consulta="Select '"&carr_ccod&"' as carr_ccod, '"&asig_ccod&"' as asig_ccod"
fbusqueda.consultar consulta

consulta = "select distinct a.carr_ccod, a.carr_tdesc,d.asig_ccod,d.asig_tdesc+' - '+cast(d.asig_ccod as varchar) as asig_tdesc " & vbCrLf & _
		   " from carreras a,secciones b, bloques_horarios c, asignaturas d, malla_curricular mc, planes_estudio pe " & vbCrLf & _
		   " where a.carr_ccod=b.carr_ccod " & vbCrLf & _
		   " and  b.secc_ccod=c.secc_ccod " & vbCrLf & _
		   " and b.asig_ccod=d.asig_ccod " & vbCrLf & _
    	   " and b.asig_ccod = mc.asig_ccod and b.mall_ccod = mc.mall_ccod " & vbCrLf & _
		   " and mc.plan_ccod = pe.plan_ccod "&filtro_plan & vbCrLf & _
		   " " & filtro_sede & vbCrLf & _
		   " and cast(b.peri_ccod as varchar)='"&peri&"' " 
'response.Write("<pre>"&consulta&"</pre>")	

fbusqueda.inicializaListaDependiente "lBusqueda", consulta

fbusqueda.siguiente


'---------------------------------------------------------Fin del ingreso de la consulta-------------------------------------

 v_carr_ccod  = conectar.consultaUno ("select ltrim(rtrim(c.carr_ccod)) from alumnos a, ofertas_academicas b, especialidades c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod = c.espe_ccod")

seccion.carga_parametros 		"toma_carga_alfa.xml", "toma_carga"
seccion.inicializar				conectar

'-------------------debemos quitar los requisitos de la toma de carga para las personas que pertenescan a registro curricular para 
'--------------------que puedan tomar carga a alumnos de intercambio o que presenten situación extraordinaria.
usuario_sesion = negocio.obtenerUsuario
sin_restriccion = conectar.consultaUno("select count(*) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=2 and cast(a.pers_nrut as varchar)='"&usuario_sesion&"'")
	

asig_origen.carga_parametros	"toma_carga_alfa.xml", "toma_carga"		
asig_origen.inicializar			conectar
if asig_ccod <>"" then
asig_disponibles = "select distinct c.asig_ccod, mall_ccod, cast(c.asig_ccod as  varchar)+ ' - ' + c.asig_tdesc as asignatura, asig_nhoras, b.secc_ccod, " & vbCrLf & _
				  " '" & matr_ncorr & "' as matr_ncorr , a.nive_ccod, isnull(d.reprobado,0) as reprobado  " & vbCrLf & _
                  " from (SELECT DISTINCT b.mall_ccod, b.asig_ccod, b.nive_ccod " & vbCrLf & _
                  "  FROM malla_curricular b" & vbCrLf & _
                  "  WHERE cast(b.plan_ccod as varchar) ='" & plan_ccod & "' " & vbCrLf & _
				  "   And not exists (select 1 from cargas_Academicas ac, secciones se " & vbCrLf & _
				  "                  where se.mall_ccod=b.mall_ccod and se.asig_ccod=b.asig_ccod " & vbCrLf & _
				  "                  and cast(ac.matr_ncorr as varchar)='" & matr_ncorr & "' and ac.secc_ccod = se.secc_ccod " & vbCrLf & _
				  "                  and isnull(ac.sitf_ccod,'1')= '1' and cast(se.peri_ccod as varchar)= '" & peri_ccod & "')" 
if sin_restriccion = "0" then
	asig_disponibles = asig_disponibles & "  and  protic.completo_requisitos_asignatura (b.mall_ccod, '" & pers_ncorr & "') = 0 " 
end if 

'asig_disponibles= asig_disponibles  & "   AND NOT (  " & vbCrLf & _
'				  "			EXISTS (SELECT 1 " & vbCrLf & _
'				  "                 FROM secciones sa, " & vbCrLf & _
'				  "                         cargas_academicas sb, " & vbCrLf & _
'				  "                         alumnos sc, " & vbCrLf & _
'				  "                         situaciones_finales sd " & vbCrLf & _
'                  "                   WHERE sa.secc_ccod = sb.secc_ccod " & vbCrLf & _
'                  "                     AND sa.asig_ccod = b.asig_ccod " & vbCrLf & _
'                  "                     AND sb.matr_ncorr = sc.matr_ncorr " & vbCrLf & _
'                  "                     AND sb.sitf_ccod = sd.sitf_ccod " & vbCrLf & _
'                  "                     AND sd.sitf_baprueba = 'S' " & vbCrLf & _
'                  "                     AND sc.emat_ccod in (1,6,11) " & vbCrLf & _
'                  "                     AND cast(sc.pers_ncorr as varchar)= '" & pers_ncorr & "') " & vbCrLf & _
'                  "        OR  " & vbCrLf & _
'				  "           EXISTS (  select 1 " & vbCrLf & _
'				  "			from  " & vbCrLf & _
'				  "				   convalidaciones a " & vbCrLf & _
'			 	  "				 , alumnos b1 " & vbCrLf & _
'				  "				 , actas_convalidacion d " & vbCrLf & _
'				  "				 , situaciones_finales h " & vbCrLf & _
'				  "			where " & vbCrLf & _
'				  "				 a.matr_ncorr=b1.matr_ncorr " & vbCrLf & _
'				  "				 and a.acon_ncorr=d.acon_ncorr " & vbCrLf & _
'				  "				 and a.asig_ccod=b.asig_ccod " & vbCrLf & _
'				  "				 and a.sitf_ccod=h.sitf_ccod " & vbCrLf & _
'				  "				 and h.sitf_baprueba='S' " & vbCrLf & _
'				  "			     and cast(b1.pers_ncorr as varchar)='" & pers_ncorr & "')" & vbCrLf & _
'				  "       -- OR  " & vbCrLf & _
'				  "       --    EXISTS ( SELECT 1 " & vbCrLf & _
'				  "       --         		from homologacion_destino hd, homologacion_fuente hf,homologacion h,asignaturas asig, " & vbCrLf & _
'				  "       --         		secciones secc,cargas_academicas carg, alumnos al, personas pers, situaciones_finales s2c " & vbCrLf & _
'				  "       --         		where hd.homo_ccod=h.homo_ccod " & vbCrLf & _
'				  "       --         		and hf.homo_ccod=h.homo_ccod " & vbCrLf & _
'				  "       --         		and asig.asig_ccod=hd.asig_ccod " & vbCrLf & _
'				  "       --         		and asig.asig_ccod=secc.asig_ccod " & vbCrLf & _
'				  "       --         		and secc.secc_ccod=carg.secc_ccod " & vbCrLf & _
'				  "       --              	AND hf.asig_ccod  = b.asig_ccod " & vbCrLf & _
'				  "       --         		and al.matr_ncorr=carg.matr_ncorr " & vbCrLf & _
'				  "       --         		and pers.pers_ncorr=al.pers_ncorr " & vbCrLf & _
'				  "       -- 		 		and hd.asig_ccod <> hf.asig_ccod " & vbCrLf & _
'				  "       --              	AND carg.sitf_ccod = s2c.sitf_ccod " & vbCrLf & _
'				  "       --              	AND s2c.sitf_baprueba = 'S'" & vbCrLf & _
'				  "       --         		and carg.sitf_ccod <>'EQ' " & vbCrLf & _
'				  "       --   		 		and h.THOM_CCOD = 1 " & vbCrLf & _
'				  "       --                AND al.emat_ccod in (1,6,11) " & vbCrLf & _
'				  "       --         		and cast(pers.pers_ncorr as varchar)='" & pers_ncorr & "')" & vbCrLf & _
'				  "		OR EXISTS (select  1 " & vbCrLf & _
'				  "		   		  		   from " & vbCrLf & _
'				  "								equivalencias a " & vbCrLf & _
'				  "								, cargas_academicas b1,situaciones_finales sf" & vbCrLf & _
'				  "								, secciones c " & vbCrLf & _
'			      "								, alumnos g " & vbCrLf & _
'				  "							where " & vbCrLf & _
'				  "								 a.matr_ncorr=b1.matr_ncorr " & vbCrLf & _
'				  "								 and a.secc_ccod=b1.secc_ccod " & vbCrLf & _
'				  "								 and b1.secc_ccod=c.secc_ccod and b1.sitf_ccod=sf.sitf_ccod and sf.sitf_baprueba='S' " & vbCrLf & _
'				  "								 and b1.matr_ncorr=g.matr_ncorr " & vbCrLf & _
'				  "								 and a.asig_ccod=b.asig_ccod " & vbCrLf & _
'				  "								 and cast(g.pers_ncorr as varchar)='" & pers_ncorr & "') " & vbCrLf & _
'				  "        ) " & vbCrLf & _
'				  "   AND NOT EXISTS (SELECT 1 " & vbCrLf & _
'				  "                      FROM  " & vbCrLf & _
'				  "                      MALLA_CURRICULAR MC, " & vbCrLf & _
'				  "                      (SELECT HOMO_CCOD,ASIG_CCOD_DESTINO, COUNT(*) NREQUISITOS, count(asig_ccod)NAPROBADOS " & vbCrLf & _
'				  "                      FROM  " & vbCrLf & _
'				  "                      (SELECT HD.HOMO_CCOD,HD.ASIG_CCOD ASIG_CCOD_DESTINO,HF.ASIG_CCOD ASIG_CCOD_FUENTE  " & vbCrLf & _
'				  "                       FROM HOMOLOGACION_FUENTE HF,  " & vbCrLf & _
'				  "                       HOMOLOGACION_DESTINO HD " & vbCrLf & _
'				  "                       WHERE HF.HOMO_CCOD=HD.HOMO_CCOD ) HOM, " & vbCrLf & _
'				  "                      (SELECT S.ASIG_CCOD  " & vbCrLf & _
'			 	  "                       FROM " & vbCrLf & _
' 				  "                      SECCIONES S, " & vbCrLf & _
'				  "                       CARGAS_ACADEMICAS CA, " & vbCrLf & _
'				  "                       ALUMNOS A, " & vbCrLf & _
'				  "                       SITUACIONES_FINALES SF " & vbCrLf & _
'				  "                       WHERE S.SECC_CCOD = CA.SECC_CCOD " & vbCrLf & _
'				  "                       	   AND CA.MATR_NCORR = A.MATR_NCORR  and carr_ccod ='"&v_carr_ccod&"'" & vbCrLf & _
'				  "                      	   AND SF.SITF_CCOD=CA.SITF_CCOD " & vbCrLf & _
'				  "                      	   AND SF.SITF_BAPRUEBA='S'   " & vbCrLf & _
'				  "                      	   AND cast(A.PERS_NCORR as varchar)= '" & pers_ncorr & "') APRO " & vbCrLf & _
'				  "                      WHERE HOM.ASIG_CCOD_FUENTE *= APRO.ASIG_CCOD  " & vbCrLf & _
'				  "                      group by HOMO_CCOD,asig_ccod_destino)	PRUEBA " & vbCrLf & _
'				  "                      WHERE MC.ASIG_CCOD=ASIG_CCOD_DESTINO " & vbCrLf & _
'				  "                      AND MC.ASIG_CCOD=B.ASIG_CCOD " & vbCrLf & _
'				  " 					 AND NREQUISITOS=NAPROBADOS " & vbCrLf & _
'				  "                      AND cast(PLAN_CCOD as varchar) ='" & plan_ccod & "') " & vbCrLf & _
'    			  " ) a, " & vbCrLf & _
'				  "	(SELECT a.asig_ccod, a.secc_ccod, c.matr_ncorr  " & vbCrLf & _
'				  "	   FROM secciones a, cargas_academicas b, alumnos c " & vbCrLf & _
'				  "	  WHERE a.secc_ccod = b.secc_ccod " & vbCrLf & _
'				  "	   AND b.matr_ncorr = c.matr_ncorr and isnull(b.sitf_ccod,'0') = '0' " & vbCrLf & _
'				  "       AND c.emat_ccod in (1,6,11) " & vbCrLf & _
'                  "       AND cast(a.sede_ccod as varchar)= '" & sede_ccod & "' " & vbCrLf & _
'				  "       AND cast(a.peri_ccod as varchar)= '" & peri_ccod & "' " & vbCrLf & _
'				  "	      AND cast(c.pers_ncorr as varchar)= '" & pers_ncorr & "' " & vbCrLf & _
'				  "  union " & vbCrLf & _
'				  "       select null,null,null) b, " & vbCrLf & _
'				  "	asignaturas c, " & vbCrLf & _
'				  "   ( select a.asig_ccod, 1 as reprobado  " & vbCrLf & _
'				  "       from secciones a, cargas_academicas b, situaciones_finales c, alumnos d " & vbCrLf & _
'				  "      where a.secc_ccod=b.secc_ccod  " & vbCrLf  & _
'				  "        and b.sitf_ccod=c.sitf_ccod  " & vbCrLf & _
'				  "        and b.matr_ncorr=d.matr_ncorr " & vbCrLf & _
'				  "        AND d.emat_ccod in (1,6,11) " & vbCrLf & _
'				  "        and cast(d.pers_ncorr as varchar)='" & pers_ncorr & "' " & vbCrLf & _
'				  "        and sitf_baprueba='N' " & vbCrLf & _
'				  "	  union all" & vbCrLf & _
'				  "	  	select  " & vbCrLf & _
'				  "			a.asig_ccod,1 as reprobado  " & vbCrLf & _
'				  "		from  " & vbCrLf & _
'				  "			 equivalencias a,  " & vbCrLf & _
'				  "			 cargas_academicas b,  " & vbCrLf & _
'				  "			 secciones c,  " & vbCrLf & _
'				  "			 situaciones_finales d,  " & vbCrLf & _
'				  "			 alumnos e,  " & vbCrLf & _
'				  "			 personas f " & vbCrLf & _
'				  "	  where a.matr_ncorr=b.matr_ncorr  " & vbCrLf & _
'				  "		  and a.secc_ccod=b.secc_ccod  " & vbCrLf & _
'				  "		  and b.secc_ccod=c.secc_ccod " & vbCrLf & _
'				  "		  and b.sitf_ccod=d.sitf_ccod " & vbCrLf & _
'				  "		  and b.matr_ncorr=e.matr_ncorr " & vbCrLf & _
'				  "		  and e.pers_ncorr=f.pers_ncorr " & vbCrLf & _
'				  "		  and d.sitf_baprueba='N' " & vbCrLf & _
'				  "		  and cast(f.pers_ncorr as varchar)='" & pers_ncorr & "'" & vbCrLf & _
'				  "          union " & vbCrLf & _
'				  "          select null,null) d " & vbCrLf & _
'				  "  where a.asig_ccod *=b.asig_ccod  " & vbCrLf & _
'				  "    and a.asig_ccod *=d.asig_ccod  " & vbCrLf & _
'				  "    and a.asig_ccod=c.asig_ccod "

'--------------------------------------------------------------------------------------------------------------------------ACTUALIZACIÓN SQLServer 2008	
asig_disponibles= asig_disponibles  & " and not ( exists (select 1                                                                  " & vbCrLf &_
"                                 from   secciones as sa                                                                            " & vbCrLf &_
"                                        inner join cargas_academicas as sb                                                         " & vbCrLf &_
"                                                on sa.secc_ccod = sb.secc_ccod                                                     " & vbCrLf &_
"                                        inner join alumnos as sc                                                                   " & vbCrLf &_
"                                                on sb.matr_ncorr = sc.matr_ncorr                                                   " & vbCrLf &_
"                                                   and sc.emat_ccod in ( 1, 6, 11 )                                                " & vbCrLf &_
"                                                   and cast(sc.pers_ncorr as varchar) = '" & pers_ncorr & "'                       " & vbCrLf &_
"                                        inner join situaciones_finales as sd                                                       " & vbCrLf &_
"                                                on sb.sitf_ccod = sd.sitf_ccod                                                     " & vbCrLf &_
"                                                   and sd.sitf_baprueba = 'S'                                                      " & vbCrLf &_
"                                 where  sa.asig_ccod = b.asig_ccod)                                                                " & vbCrLf &_
"                          or exists (select 1                                                                                      " & vbCrLf &_
"                                     from   convalidaciones as a                                                                   " & vbCrLf &_
"                                            inner join alumnos as b1                                                               " & vbCrLf &_
"                                                    on a.matr_ncorr = b1.matr_ncorr                                                " & vbCrLf &_
"                                                       and cast(b1.pers_ncorr as varchar) = '" & pers_ncorr & "'                   " & vbCrLf &_
"                                            inner join actas_convalidacion as d                                                    " & vbCrLf &_
"                                                    on a.acon_ncorr = d.acon_ncorr                                                 " & vbCrLf &_
"                                            inner join situaciones_finales as h                                                    " & vbCrLf &_
"                                                    on a.sitf_ccod = h.sitf_ccod                                                   " & vbCrLf &_
"                                                       and h.sitf_baprueba = 'S'                                                   " & vbCrLf &_
"                                                       and a.asig_ccod = b.asig_ccod)                                              " & vbCrLf &_
"                          -- OR                                                                                                    " & vbCrLf &_
"                          --    EXISTS ( SELECT 1                                                                                  " & vbCrLf &_
"                          --             from homologacion_destino hd, homologacion_fuente hf,homologacion h,asignaturas asig,     " & vbCrLf &_
"                          --             secciones secc,cargas_academicas carg, alumnos al, personas pers, situaciones_finales s2c " & vbCrLf &_
"                          --             where hd.homo_ccod=h.homo_ccod                                                            " & vbCrLf &_
"                          --             and hf.homo_ccod=h.homo_ccod                                                              " & vbCrLf &_
"                          --             and asig.asig_ccod=hd.asig_ccod                                                           " & vbCrLf &_
"                          --             and asig.asig_ccod=secc.asig_ccod                                                         " & vbCrLf &_
"                          --             and secc.secc_ccod=carg.secc_ccod                                                         " & vbCrLf &_
"                          --                AND hf.asig_ccod  = b.asig_ccod                                                        " & vbCrLf &_
"                          --             and al.matr_ncorr=carg.matr_ncorr                                                         " & vbCrLf &_
"                          --             and pers.pers_ncorr=al.pers_ncorr                                                         " & vbCrLf &_
"                          --          and hd.asig_ccod <> hf.asig_ccod                                                             " & vbCrLf &_
"                          --                AND carg.sitf_ccod = s2c.sitf_ccod                                                     " & vbCrLf &_
"                          --                AND s2c.sitf_baprueba = 'S'                                                            " & vbCrLf &_
"                          --             and carg.sitf_ccod <>'EQ'                                                                 " & vbCrLf &_
"                          --            and h.THOM_CCOD = 1                                                                        " & vbCrLf &_
"                          --                AND al.emat_ccod in (1,6,11)                                                           " & vbCrLf &_
"                          --             and cast(pers.pers_ncorr as varchar)='" & pers_ncorr & "')                                " & vbCrLf &_
"                          or exists (select 1                                                                                      " & vbCrLf &_
"                                     from   equivalencias as a                                                                     " & vbCrLf &_
"                                            inner join cargas_academicas as b1                                                     " & vbCrLf &_
"                                                    on a.matr_ncorr = b1.matr_ncorr                                                " & vbCrLf &_
"                                                       and a.secc_ccod = b1.secc_ccod                                              " & vbCrLf &_
"                                            inner join situaciones_finales as sf                                                   " & vbCrLf &_
"                                                    on b1.sitf_ccod = sf.sitf_ccod                                                 " & vbCrLf &_
"                                                       and sf.sitf_baprueba = 'S'                                                  " & vbCrLf &_
"                                            inner join secciones as c                                                              " & vbCrLf &_
"                                                    on b1.secc_ccod = c.secc_ccod                                                  " & vbCrLf &_
"                                            inner join alumnos as g                                                                " & vbCrLf &_
"                                                    on b1.matr_ncorr = g.matr_ncorr                                                " & vbCrLf &_
"                                                       and cast(g.pers_ncorr as varchar) = '" & pers_ncorr & "'                    " & vbCrLf &_
"                                     where  a.asig_ccod = b.asig_ccod) )                                                           " & vbCrLf &_
"               and not exists (select 1                                                                                            " & vbCrLf &_
"                               from   malla_curricular as mc                                                                       " & vbCrLf &_
"                                      inner join (select homo_ccod,                                                                " & vbCrLf &_
"                                                         asig_ccod_destino,                                                        " & vbCrLf &_
"                                                         count(*)        nrequisitos,                                              " & vbCrLf &_
"                                                         count(asig_ccod)naprobados                                                " & vbCrLf &_
"                                                  from   (select hd.homo_ccod,                                                     " & vbCrLf &_
"                                                                 hd.asig_ccod asig_ccod_destino,                                   " & vbCrLf &_
"                                                                 hf.asig_ccod asig_ccod_fuente                                     " & vbCrLf &_
"                                                          from   homologacion_fuente as hf                                         " & vbCrLf &_
"                                                                 inner join homologacion_destino as hd                             " & vbCrLf &_
"                                                                         on hf.homo_ccod = hd.homo_ccod) as hom                    " & vbCrLf &_
"                                                         left outer join (select s.asig_ccod                                       " & vbCrLf &_
"                                                                          from   secciones as s                                    " & vbCrLf &_
"                                                                                 inner join cargas_academicas as ca                " & vbCrLf &_
"                                                                                         on s.secc_ccod = ca.secc_ccod             " & vbCrLf &_
"                                                                                 inner join alumnos as a                           " & vbCrLf &_
"                                                                                         on ca.matr_ncorr = a.matr_ncorr           " & vbCrLf &_
"                                                                                 inner join situaciones_finales as sf              " & vbCrLf &_
"                                                                                         on sf.sitf_ccod = ca.sitf_ccod            " & vbCrLf &_
"                                                                                            and sf.sitf_ccod = ca.sitf_ccod        " & vbCrLf &_
"                                                                                            and sf.sitf_baprueba = 'S'             " & vbCrLf &_
"                                                                          where  cast(a.pers_ncorr as varchar) = '"& pers_ncorr &"'" & vbCrLf &_
"                                                                                 and carr_ccod = '"&v_carr_ccod&"') as apro        " & vbCrLf &_
"                                                                      on hom.asig_ccod_fuente = apro.asig_ccod                     " & vbCrLf &_
"                                                  group  by homo_ccod,                                                             " & vbCrLf &_
"                                                            asig_ccod_destino) as prueba                                           " & vbCrLf &_
"                                              on mc.asig_ccod = prueba.asig_ccod_destino--se agregra prueba. (14_03_2013)          " & vbCrLf &_
"                                                 and mc.asig_ccod = b.asig_ccod                                                    " & vbCrLf &_
"                                                 and nrequisitos = naprobados                                                      " & vbCrLf &_
"                                                 and cast(plan_ccod as varchar) = '" & plan_ccod & "')) as a                       " & vbCrLf &_
"       left outer join (select a.asig_ccod,                                                                                        " & vbCrLf &_
"                               a.secc_ccod,                                                                                        " & vbCrLf &_
"                               c.matr_ncorr                                                                                        " & vbCrLf &_
"                        from   secciones as a                                                                                      " & vbCrLf &_
"                               inner join cargas_academicas as b                                                                   " & vbCrLf &_
"                                       on a.secc_ccod = b.secc_ccod                                                                " & vbCrLf &_
"                                          and isnull(b.sitf_ccod, '0') = '0'                                                       " & vbCrLf &_
"                               inner join alumnos as c                                                                             " & vbCrLf &_
"                                       on b.matr_ncorr = c.matr_ncorr                                                              " & vbCrLf &_
"                                          and c.emat_ccod in ( 1, 6, 11 )                                                          " & vbCrLf &_
"                                          and cast(c.pers_ncorr as varchar) = '" & pers_ncorr & "'                                 " & vbCrLf &_
"                        where  cast(a.sede_ccod as varchar) = '" & sede_ccod & "'                                                  " & vbCrLf &_
"                               and cast(a.peri_ccod as varchar) = '" & peri_ccod & "'                                              " & vbCrLf &_
"                        union                                                                                                      " & vbCrLf &_
"                        select null,                                                                                               " & vbCrLf &_
"                               null,                                                                                               " & vbCrLf &_
"                               null) as b                                                                                          " & vbCrLf &_
"                    on a.asig_ccod = b.asig_ccod                                                                                   " & vbCrLf &_
"       inner join asignaturas as c                                                                                                 " & vbCrLf &_
"               on a.asig_ccod = c.asig_ccod                                                                                        " & vbCrLf &_
"       left outer join (select a.asig_ccod,                                                                                        " & vbCrLf &_
"                               1 as reprobado                                                                                      " & vbCrLf &_
"                        from   secciones as a                                                                                      " & vbCrLf &_
"                               inner join cargas_academicas as b                                                                   " & vbCrLf &_
"                                       on a.secc_ccod = b.secc_ccod                                                                " & vbCrLf &_
"                               inner join situaciones_finales as c                                                                 " & vbCrLf &_
"                                       on b.sitf_ccod = c.sitf_ccod                                                                " & vbCrLf &_
"                               inner join alumnos as d                                                                             " & vbCrLf &_
"                                       on b.matr_ncorr = d.matr_ncorr                                                              " & vbCrLf &_
"                                          and d.emat_ccod in ( 1, 6, 11 )                                                          " & vbCrLf &_
"                                          and cast(d.pers_ncorr as varchar) = '" & pers_ncorr & "'                                 " & vbCrLf &_
"                        where  sitf_baprueba = 'N'                                                                                 " & vbCrLf &_
"                        union all                                                                                                  " & vbCrLf &_
"                        select a.asig_ccod,                                                                                        " & vbCrLf &_
"                               1 as reprobado                                                                                      " & vbCrLf &_
"                        from   equivalencias as a                                                                                  " & vbCrLf &_
"                               inner join cargas_academicas as b                                                                   " & vbCrLf &_
"                                       on a.matr_ncorr = b.matr_ncorr                                                              " & vbCrLf &_
"                                          and a.secc_ccod = b.secc_ccod                                                            " & vbCrLf &_
"                               inner join secciones as c                                                                           " & vbCrLf &_
"                                       on b.secc_ccod = c.secc_ccod                                                                " & vbCrLf &_
"                               inner join situaciones_finales as d                                                                 " & vbCrLf &_
"                                       on b.sitf_ccod = d.sitf_ccod                                                                " & vbCrLf &_
"                                          and d.sitf_baprueba = 'N'                                                                " & vbCrLf &_
"                               inner join alumnos as e                                                                             " & vbCrLf &_
"                                       on b.matr_ncorr = e.matr_ncorr                                                              " & vbCrLf &_
"                               inner join personas as f                                                                            " & vbCrLf &_
"                                       on e.pers_ncorr = f.pers_ncorr                                                              " & vbCrLf &_
"                                          and cast(f.pers_ncorr as varchar) = '" & pers_ncorr & "'                                 " & vbCrLf &_
"                        union                                                                                                      " & vbCrLf &_
"                        select null,                                                                                               " & vbCrLf &_
"                               null) as d                                                                                          " & vbCrLf &_
"                    on a.asig_ccod = d.asig_ccod                                                                                   " 
'--------------------------------------------------------------------------------------------------------------------------ACTUALIZACIÓN SQLServer 2008	

'response.Write("<pre>"&asig_disponibles&"</pre>")
asig_tdesc=conectar.consultaUno("select ltrim(rtrim(asig_tdesc)) from asignaturas where cast(asig_ccod as varchar)='"&asig_ccod&"'")

'destino=" select asig_ccod,secc_ccod,horario " & vbCrLf &_
'		" 		  from " & vbCrLf &_
'		"              (SELECT a.asig_ccod, a.secc_tdesc, a.secc_ccod, " & vbCrLf &_
'		"                   cast(a.asig_ccod as varchar)+ '-' + a.secc_tdesc + ' -> ' + protic.horario(a.secc_ccod) + ' -(' + cast((a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod) ) as varchar) + ' Cupos)- ' " & vbCrLf &_
'		"                         AS horario " & vbCrLf &_
'		"              FROM secciones a, cargas_academicas c,asignaturas d " & vbCrLf &_
'		"             WHERE a.secc_ccod *= c.secc_ccod  " & vbCrLf &_
'		"               "& filtro_sede2 & vbCrLf &_
'		"               AND cast(a.peri_ccod as varchar)= '"&peri_ccod&"' " & vbCrLf &_
'		"               And a.asig_ccod=d.asig_ccod "& vbCrLf &_
'		"               and ltrim(rtrim(d.asig_tdesc)) = '"& asig_tdesc &"'" & vbCrLf &_
'		"               and cast(a.carr_ccod as varchar)='"&carr_ccod&"'"&vbCrLf &_
'		"             GROUP BY a.asig_ccod,  a.secc_ccod,  a.secc_tdesc,  a.secc_ncupo " & vbCrLf &_
'		"            HAVING a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0) > 0) a" 

'--------------------------------------------------------------------------------------------------------------------------ACTUALIZACIÓN SQLServer 2008	
destino = "select		asig_ccod,secc_ccod,horario                                                                       " & vbCrLf &_
"from (                                                                                                                   " & vbCrLf &_
"select a.asig_ccod,                                                                                                      " & vbCrLf &_
"       a.secc_tdesc,                                                                                                     " & vbCrLf &_
"       a.secc_ccod,                                                                                                      " & vbCrLf &_
"       cast(a.asig_ccod as varchar) + '-'                                                                                " & vbCrLf &_
"       + a.secc_tdesc + ' -> '                                                                                           " & vbCrLf &_
"       + protic.horario(a.secc_ccod) + ' -('                                                                             " & vbCrLf &_
"       + cast((a.secc_ncupo - (select count(*) from cargas_academicas ca where ca.secc_ccod = a.secc_ccod) ) as varchar) " & vbCrLf &_
"       + ' Cupos)- ' as horario                                                                                          " & vbCrLf &_
"from   secciones as a                                                                                                    " & vbCrLf &_
"       left outer join cargas_academicas as c                                                                            " & vbCrLf &_
"                    on a.secc_ccod = c.secc_ccod                                                                         " & vbCrLf &_
"       inner join asignaturas as d                                                                                       " & vbCrLf &_
"               on a.asig_ccod = d.asig_ccod                                                                              " & vbCrLf &_
"                  and ltrim(rtrim(d.asig_tdesc)) = '"& asig_tdesc &"'                                                    " & vbCrLf &_
"where  cast(a.peri_ccod as varchar) = '"&peri_ccod&"'                                                                    " & vbCrLf &_
"       and cast(a.carr_ccod as varchar) = '"&carr_ccod&"'                                                                " & vbCrLf &_
"	   "& filtro_sede2 & "							                                                                      " & vbCrLf &_
"group  by a.asig_ccod,                                                                                                   " & vbCrLf &_
"          a.secc_ccod,                                                                                                   " & vbCrLf &_
"          a.secc_tdesc,                                                                                                  " & vbCrLf &_
"          a.secc_ncupo                                                                                                   " & vbCrLf &_
"having a.secc_ncupo - isnull(count (distinct c.secc_ccod), 0) > 0                                                        " & vbCrLf &_
"	) as a                                                                                                                "
'--------------------------------------------------------------------------------------------------------------------------ACTUALIZACIÓN SQLServer 2008	

'response.Write("<pre>"&destino&"</pre>")
seccion.consultar 		destino 
seccion.agregacampoparam "secc_ccod","destino","("&destino&")a"
seccion.siguientef


asig_origen.consultar asig_disponibles
asig_origen.agregacampoparam "asignatura","destino","("&asig_disponibles&")j"
'response.Write("<pre>"&asig_disponibles&"</pre>")
asig_origen.siguientef
asignatura=conectar.consultauno("select asig_tdesc from asignaturas where cast(asig_ccod as varchar)='"&asig_ccod&"'")
total_asignaturas=asig_origen.nroFilas
total_secciones=seccion.nroFilas
'response.Write("total_asignaturas "&total_asignaturas&" total_secciones "&total_secciones)
'response.End()
end if

'---------------------------------------------------F I N consulta SEcciones plan--------------------------------------------
datos.inicializar	conectar
datos.carga_parametros	"paulo.xml","tabla"

tresumen.inicializar conectar
tresumen.carga_parametros	"tabla_resumen.xml","tabla_resumen"
peri_ccod = conectar.consultaUno("Select peri_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
sede_ccod = conectar.consultaUno("Select sede_ccod from alumnos a, ofertas_academicas b where cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and a.ofer_ncorr = b.ofer_ncorr")
peri_tdesc = conectar.consultaUno("Select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
pers_ncorr= session("pers_ncorr_alumno")

cons_resumen="select "& vbCrLf & _
			"    c.secc_ccod,cast(e.asig_ccod as varchar) + ' ' +  cast(e.asig_tdesc as varchar) as a_plan ,    "& vbCrLf & _
			"    cast(a.asig_ccod as varchar)+' '+ cast(a.asig_tdesc as varchar) as a_destino, "& vbCrLf & _
			"    'Secc. ' + cast(b.secc_tdesc as varchar)+' -> '+ cast(protic.horario(c.secc_ccod) as varchar)seccion, "& vbCrLf & _
			"    c.audi_fmodificacion "& vbCrLf & _
			" from asignaturas a, "& vbCrLf & _
			"    secciones b, "& vbCrLf & _
			"    equivalencias c, "& vbCrLf & _
			"   malla_curricular d, "& vbCrLf & _
			"    asignaturas e "& vbCrLf & _
			" where a.asig_ccod=b.asig_ccod "& vbCrLf & _
			"    and b.secc_ccod=c.secc_ccod "& vbCrLf & _
			"    and c.mall_ccod=d.mall_ccod "& vbCrLf & _
			"	 and e.asig_ccod=d.asig_ccod "& vbCrLf & _
			"	 and exists ( select 1 from cargas_academicas aa where aa.matr_ncorr=c.matr_ncorr and aa.secc_ccod=c.secc_ccod and isnull(acse_ncorr,0) <> 1) "& vbCrLf & _
			"	 and cast(matr_ncorr as varchar)='"&matr_ncorr&"'"& vbCrLf & _
			"	 " & filtro_sede & vbCrLf & _
			"	 and cast(b.peri_ccod as varchar)='"&peri_ccod&"'"& vbCrLf & _
			" "
consulta="select count(*) from ("&cons_resumen&")a"		
'response.Write("<pre>"&consulta&"</pre>")		
'response.End()
registros=conectar.consultauno(consulta)
	
tresumen.consultar cons_resumen

'response.Write(registros)
  nombre = conectar.consultaUno ("select cast(pers_tnombre as varchar) + ' ' + cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
  v_carr_ccod  = conectar.consultaUno ("select ltrim(rtrim(c.carr_ccod)) from alumnos a, ofertas_academicas b, especialidades c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod = c.espe_ccod")
  carrera = conectar.consultaUno ("select carr_tdesc from carreras  where carr_ccod='"&v_carr_ccod&"'")
  rut = conectar.consultaUno ("select cast(pers_nrut as varchar)+ '-'+ pers_xdv from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
  v_sede  = conectar.consultaUno ("select sede_tdesc from alumnos a, ofertas_academicas b, sedes c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.sede_ccod = c.sede_ccod")
  v_jornada  = conectar.consultaUno ("select jorn_tdesc from alumnos a, ofertas_academicas b, jornadas c where cast(matr_ncorr as varchar)='" & matr_ncorr & "' and a.ofer_ncorr=b.ofer_ncorr and b.jorn_ccod = c.jorn_ccod")
  plan_ccod = conectar.consultaUno ("select plan_ccod from  alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
  pers_nrut = conectar.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
  pers_xdv = conectar.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")

if tipo_plan = "0" then
	lenguetas_carga = Array(Array("Toma de Carga", "toma_carga_nuevo.asp"), Array("Equivalencias", "equivalencias.asp"), Array("Form. Gral. Optativa", "ingreso_optativos.asp"), Array("Artísticos-Culturales", "ingreso_cursos_dae.asp"),Array("Carga Extraordinaria Créditos", "toma_carga_extraordinaria.asp?tipo=1"))
else
	lenguetas_carga = Array(Array("Toma de Carga", "toma_carga_nuevo.asp"), Array("Equivalencias", "equivalencias.asp"), Array("Form. Gral. Optativa", "ingreso_optativos.asp"), Array("Artísticos-Culturales", "ingreso_cursos_dae.asp"),Array("Carga Extraordinaria Sesiones", "toma_carga_extraordinaria.asp?tipo=2"))
end if	

if tipo_plan <> "0" and matr_ncorr <> "" then
	suma_creditos = conectar.consultaUno("select protic.obtener_creditos_asignados("&matr_ncorr&")")
end if
'response.Write(suma_creditos)

v_espe_ccod = conectar.consultaUno("select espe_ccod from planes_estudio where cast(plan_ccod as varchar)='"&plan_ccod&"'")
url_malla="../MANTENEDORES/malla_curricular_imprimible.ASP?a[0][CARR_CCOD]="&v_carr_ccod&"&a[0][ESPE_CCOD]="&v_espe_ccod&"&a[0][PLAN_CCOD]="&plan_ccod

pers_nrut = conectar.consultaUno("Select pers_nrut from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
pers_xdv = conectar.consultaUno("Select pers_xdv from personas where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
url="../CERTIFICADOS/HISTORICO_NOTAS_LIBRE.ASP?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv&"&ocultar=1"


%>


<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>



<script language="JavaScript">

function abrir(){
		var matricula 	= '<%=matr_ncorr%>';
		var pers 		= '<%=pers_ncorr%>';
		var sede		= '<%=sede_ccod%>';
		var plan		= '<%=plan_ccod%>';
		var periodo     = '<%=peri_ccod%>';
		
		direccion = "busca_secciones_forzadas.asp?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo;
		resultado=window.open(direccion, "ventana1","scrollbars=yes,resizable,width=750,height=400");
}

function eliminar (formulario){
	if (verifica_check(formulario)){
		formulario.method="post"
		formulario.action="eliminar_equivalencias.asp";
		formulario.submit();
	}
}

function enviar(formulario){
            document.getElementById("texto_alerta").style.visibility="visible";
			formulario.action ="equivalencias.asp";
			formulario.submit();
}

function guardar(formulario){
	if (preValidaFormulario(formulario)){
			formulario.method="post";
			formulario.action="guardar_secciones.asp";
			formulario.submit();
	}
}
function ver_notas()
{
self.open('<%=url%>','notas','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function ver_malla()
{
self.open('<%=url_malla%>','malla','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function horario(){
	self.open('horario.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}
</script>
<% fbusqueda.generaJS %>
<STYLE type="text/css">
 <!-- 
 A {color: #000000;  text-decoration: none; font-weight: bold;}
 A:hover {COLOR: #63ABCC; }

 // -->
 </STYLE>
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<style type="text/css">
<!--
.anchofijo {
	font-family: "Courier New", Courier, mono;
	font-size: 10px;
	width: 350px;
}
-->
</style>
</head>
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas lenguetas_carga, 2 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
                    <% pagina.Titulo = pagina.Titulo & "<br>" & peri_tdesc
					  pagina.DibujarTituloPagina%>
                    <br>
                </div>
           
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
              <form name="buscador" action="toma_carga.asp"> 
			  <tr>
                <td width="11%">&nbsp; </td>
                <td colspan="2">&nbsp; </td>
              </tr>
			 <tr>
                <td width="10%"><strong>RUT</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%= rut %></strong></font></td>
              </tr>
              <tr>
				<td width="10%"><strong>Nombre</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%=nombre %></strong></font></td>
              </tr>
              <tr>
				<td width="10%"><strong>Sede</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%=v_sede %></strong></font></td>
			  </tr>  
			  <tr>
				<td width="10%"><strong>Carrera</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%=carrera %></strong></font></td>
			  </tr>
			  <tr>
				<td width="10%"><strong>Jornada</strong></td>
                <td width="2%"><strong>:</strong> </td>
				<td align="left"><font color="#CC0000"><strong><%=v_jornada %></strong></font></td>
			  </tr>
			  <tr>
                <td colspan="3">&nbsp;</td>
              </tr>
			  <tr>
                <td colspan="3">&nbsp;</td>
              </tr>
			  <tr>
			  	<td colspan="3">
					<table width="100%"  border="1">
                      <tr>
                        <td width="81%"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                              <tr>
							  	<td colspan="2"><%pagina.DibujarSubtitulo"Seleccione una asignatura para la equivalencia"%></td>
							  </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Carrera &nbsp; </div></td>
								<td width="87%">: <% fbusqueda.dibujaCampoLista "lBusqueda", "carr_ccod"%>
                                </td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left">Asignatura &nbsp; </div></td>
								<td>: <% fbusqueda.dibujaCampoLista "lBusqueda", "asig_ccod"%></td>
                              </tr>
							  <tr> 
                                <td width="13%"> <div align="left"></div></td>
								<td><div id="texto_alerta" style="position:absolute; visibility: hidden;"><font color="#0000FF" size="-1">Espere 
                                  un momento mientras se realiza la busqueda...</font></div></td>
                              </tr>
                            </table></td>
                        <td width="19%"><div align="center"><%botonera2.dibujaboton "buscar"%></div></td>
                      </tr>
                    </table>
				</td>
			  </tr>
			  </form>
			  <tr><td colspan="3">&nbsp;</td></tr>
			  <tr><td colspan="3">&nbsp;</td></tr>
			  <tr>
			  	<td colspan="3">
				<form name="edicion">
				<%if asig_ccod <> "" then %>
				<table width="100%" border="1">
				<tr><td width="100%">
				 <table width="100%" align="center" cellpadding="0" cellspacing="0">
                        <tr>
				            <td colspan="3"><%pagina.DibujarSubtitulo "Seleccione la asignatura del plan de estudios del Alumno"%></td>
                        </tr>
                        <tr>
                            <td width="15%">Asignatura</td>
							<td colspan="2">: <strong><%=asignatura%></strong></td>
						</tr>
						<tr>
							<td width="15%">Secci&oacute;n</td>
							<td colspan="2">: <%seccion.dibujacampo("secc_ccod")%></td>
                        </tr>
                        <tr> 
                            <td width="15%"><strong>Equivalente a</strong></td>
							<td  colspan="1">: <%asig_origen.dibujacampo("asignatura")%></td>
							<td width="5%"><div align="center"><%if total_asignaturas > 0 and total_secciones >0 then
							                        
													if tipo_plan <> "0" and cint(suma_creditos) >= 27 then
													   botonera2.agregaBotonParam "guardar","deshabilitado","TRUE"
													end if
													
					                                botonera2.dibujaboton "guardar"
												    end if%></div></td>
                        </tr>
						<%if tipo_plan <> "0" and cint(suma_creditos) >= 27 then%>
						<tr>
						   <td colspan="3" align="center"><font  size="2" color="#0000FF"><strong>Atención el total de Cr&eacute;ditos Asignados (<%=suma_creditos%>) esta fuera del rango permitido (9-27).<br> Elimine parte de la carga para tomar la equivalencia.</strong></font>
						   </td>
						</tr>
						<%end if%>
                              <div align="left"><input type="hidden" name="d[0][matr_ncorr]" value="<%=matr_ncorr%>"> <br></div>
                      </table></td></tr></table>
					  <%end if %>
				    </form>
				</td>
			  </tr>
            </table>
			
            <form name="edicion2">
			  <input type="hidden" name="registros" value="<%=registros%>"> 
			  <input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
					<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
					  <tr>
						<td><%pagina.DibujarSubtitulo "Listado de equivalencias realizadas para el alumno"%>
						  <br>
						  (*) Equivalencias Para la Carrera :  <%= carrera %> </td>
					  </tr>
					  </table>
				     <table width="100%" border="0">
					  <tr> 
						<td align="right"><strong><font color="000000" size="1"> 
						  <% tresumen.pagina%>
						  &nbsp;&nbsp;&nbsp;&nbsp; 
						  <% tresumen.accesoPagina%>
						  </font></strong></td>
					  </tr>
					  <tr> 
						 <td><strong><font color="000000" size="1"> 
						 <% tresumen.dibujaTabla%>
						 </font></strong> </td>
					  </tr>
					  <tr> 
						<td align="right">&nbsp;</td>
					  </tr>
					  <tr>
						<td align="right">
						<% if tresumen.NroFilas = 0 then
									  f_botonera.agregabotonparam "ELIMINAR", "deshabilitado" ,"TRUE"
                           end if							
								  f_botoneraEQ.DibujaBoton "ELIMINAR"%>
						</td>
					  </tr>
       			</table>
                <br>
				
    			</form>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="15%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
                    <% f_botonera.agregaBotonParam "anterior", "url", "toma_carga_nuevo.asp"
					  f_botonera.DibujaBoton "anterior"%>
                      </div>
				   </td>
				    <td><div align="center">
                    <%f_botonera.DibujaBoton "HORARIO"%>
                  </div></td>
                  <td><div align="center"><% f_botonera.DibujaBoton "NOTAS"%></div></td>
				  <td><div align="center"><% f_botonera.DibujaBoton "MALLA"%></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="85%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<br>
	<br>
	</td>
  </tr>  
</table>
</body>
</html>
