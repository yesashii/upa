 <!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'*******************************************************************
'DESCRIPCION			        :
'FECHA CREACIÓN			      :
'CREADO POR				        :
'ENTRADA				          : NA
'SALIDA				            : NA
'MODULO QUE ES UTILIZADO	: PLANIFICACION ACADÉMICA
'
'--ACTUALIZACION--
'
'FECHA ACTUALIZACION		: 20/03/2013
'ACTUALIZADO POR			  : Luis Herrera G.
'MOTIVO				          : Corregir código, eliminar sentencia *=, =*
'LINEA				          : 466, 515, 516, 740, 825
'********************************************************************
 Response.Buffer = True
 Response.ExpiresAbsolute = Now() - 1
 Response.Expires = 0
 Response.CacheControl = "no-cache" 
 
 habilita_toma_carga = false
 
set pagina = new CPagina
pagina.Titulo = "Asignación de Carga Académica"
matr_ncorr		= 	request.querystring("ch[0][matr_ncorr]")
'---------------------------------------------------------------------------------------------------
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar



set f_botonera = new CFormulario
f_botonera.Carga_Parametros "toma_carga.xml", "BotoneraTomaCarga"

set f_botoneraEQ = new CFormulario
f_botoneraEQ.Carga_Parametros "toma_carga.xml", "BotoneraEQ"

set f_botonera_optativo = new CFormulario
f_botonera_optativo.Carga_Parametros "toma_carga.xml", "BotoneraOptativos"

'---------------------------------------------------------------------------------------------------
'response.Write("<hr>1")

set formulario 	= new cformulario
set errores 	= new cErrores
set alumno 		= new cAlumno
set tresumen	= new cformulario
set optativos_deportivos = new cformulario
set tresumen_otrasede = new cformulario
set datos		=	new cFormulario
set combo_carreras    = new cFormulario


datos.inicializar	conectar
datos.carga_parametros	"paulo.xml","tabla"

formulario.carga_parametros "parametros.xml", "toma_carga"
formulario.inicializar conectar
tresumen.inicializar conectar
tresumen_otrasede.inicializar conectar
optativos_deportivos.inicializar conectar


pers_nrut = request.QueryString("rut")
pers_xdv = request.QueryString("dv")

'acá debemos válidar que el periodo sea el correspondiente a la toma de carga.
actividad = session("_actividad")
'response.Write("a "&actividad)
if (actividad = "7")  then
	peri_ccod = negocio.obtenerPeriodoAcademico("TOMACARGA")
else
	peri_ccod = negocio.obtenerPeriodoAcademico("CLASES18")
end if
if peri_ccod= "202" then 
	peri_ccod = "200"
end if

sede_ccod = negocio.obtenerSede
peri_tdesc = conectar.consultaUno("Select protic.initcap(peri_tdesc) from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
'-------------------------------------Agregado MArcelo Sandoval para multiples matriculas 
'---------------------------------------------en el mismo periodo de estudios------------------
pers_ncorr_tmp= conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&pers_nrut&"'")
consulta_carreras=" select a.matr_ncorr as parametro, d.carr_tdesc as salida " & vbCrlf & _
				  " from alumnos a, ofertas_academicas b, especialidades c, carreras d" & vbCrlf & _
				  " where cast(a.pers_ncorr as varchar)='"&pers_ncorr_tmp&"'" & vbCrlf & _
				  " and a.emat_ccod=1 " & vbCrlf & _
				  " and a.ofer_ncorr=b.ofer_ncorr " & vbCrlf & _
				  " and b.espe_ccod=c.espe_ccod " & vbCrlf & _
				  " and c.carr_ccod=d.carr_ccod " & vbCrlf & _
				  " and cast(b.peri_ccod as varchar)='"&peri_ccod&"'" & vbCrlf & _
				  " and cast(b.sede_ccod as varchar)='"&sede_ccod&"'"
				  
if not esVacio(pers_nrut) then
combo_carreras.carga_parametros "toma_carga.xml", "combo_carreras"
combo_carreras.inicializar conectar
combo_carreras.consultar "select ''"
combo_carreras.agregaCampoParam "matr_ncorr","destino","(" & consulta_carreras & ")s"				  
combo_carreras.siguiente
combo_carreras.agregaCampoCons "matr_ncorr",matr_ncorr
cantidad_carreras=conectar.consultaUno("select count(*) from ("&consulta_carreras&")b")
'response.Write(matr_ncorr)
end if
if not EsVacio(pers_nrut) then
    url="../CERTIFICADOS/HISTORICO_NOTAS.ASP?busqueda[0][pers_nrut]="&pers_nrut&"&busqueda[0][pers_xdv]="&pers_xdv&"&ocultar=1"
	v_plec_ccod = conectar.ConsultaUno("select plec_ccod from periodos_academicos where cast(peri_ccod as varchar) = '" & peri_ccod & "'")
	if v_plec_ccod = "2" then
	     ''''''''''''debemos válidar que el alumno no tenga asignaturas sin evaluar el primer semestre ---------------
		 ''''''''''''para ellos debemos sacar la última matrícula que tenga
		 'if cantidad_carreras = 1 then
		'	 texto_1 = " SELECT matr_ncorr "& vbCrlf &_
		'			  " FROM personas a, alumnos b, ofertas_academicas c "& vbCrlf &_
		'			  " WHERE a.pers_ncorr = b.pers_ncorr "& vbCrlf &_
		'			  " AND b.ofer_ncorr = c.ofer_ncorr "& vbCrlf &_
		'			  " AND cast(pers_nrut as varchar) = '"& pers_nrut &"' "& vbCrlf &_
		'			  " AND cast(peri_ccod as varchar)= '"& peri_ccod &"' "& vbCrlf &_
		'			  " AND cast(sede_ccod as varchar) = '"& sede_ccod &"' "& vbCrlf &_
		'			  " and emat_ccod = 1 " 		
		' else
		'	 texto_1 = "select top 1 parametro from (" & consulta_carreras & ")b"		 
		' end if
		' if esVacio(matr_ncorr) then
		'	 matr_ncorr =  conectar.consultaUno(texto_1) 
		' end if
	     ''''''''debemos revisar si las asignaturas que el alumno curso el primer semestre estan en situación pendiente o no
		' consulta_pendientes = " select isnull(count(*),0) from cargas_academicas a, secciones b, asignaturas c "& vbCrlf &_
		'					   " where cast(matr_ncorr as varchar)='"&matr_ncorr&"'"& vbCrlf &_
		'					   " and a.secc_ccod=b.secc_ccod "& vbCrlf &_
		'					   " and b.asig_ccod=c.asig_ccod "& vbCrlf &_
		'					   " and c.duas_ccod <> 3 "
		'					   
		'
		'situacion_pendiente = conectar.consultaUno(consulta_pendientes & " and isnull(a.sitf_ccod,'SP') = 'SP'")
		'no_cerradas = conectar.consultaUno(consulta_pendientes & " and isnull(a.estado_cierre_ccod,1) = 1")
		'if cint(consulta_pendientes) = 0 and cint(no_cerradas) = 0 then
		'response.Write(conectar.obtenerEstadoTransaccion)
			sentencia = "exec crear_matricula_seg_semestre '" & sede_ccod & "', '" & pers_nrut & "', '" & peri_ccod& "'"
		'	response.Write(sentencia)
			conectar.EjecutaPsql(sentencia)
		'response.Write(conectar.obtenerEstadoTransaccion)
		'elseif cint(consulta_pendientes) > 0 and cint(no_cerradas)= 0 then
			''''''''''el alumno tienen evaluaciones pendientes en el primer semestre.
		'    msj_bloqueo = "No se puede asignar carga académica al alumno \n por que presenta asignaturas en el primer semestre en situación pendiente."
        'elseif cint(consulta_pendientes) = 0 and cint(no_cerradas) > 0 then
			''''''''''el alumno tienen evaluaciones no cerradas en el primer semestre.
		'    msj_bloqueo = "No se puede asignar carga académica al alumno \n por que presenta asignaturas en el primer semestre que no han sido cerradas."			
		'else
			''''''''''el alumno tienen evaluaciones pendientes en el primer semestre.
		'    msj_bloqueo = "No se puede asignar carga académica al alumno \n por que presenta asignaturas en el primer semestre en situación pendiente y sin cerrar."
		'end if
	end if
	
	if v_plec_ccod = "3" then
		sentencia = "exec crear_matricula_ter_trimestre '" & sede_ccod & "', '" & pers_nrut & "', '" & peri_ccod& "'"
		conectar.EjecutaPsql(sentencia)
	end if
	
	bloqueado = false
		msj_bloqueo = negocio.ObtenerMensajeBloqueo(pers_nrut, peri_ccod)
		if not EsVacio(msj_bloqueo) then 'and msj_bloqueo <> "El postulante se encuentra moroso.\n\n" then
			bloqueado = true
			conectar.MensajeError(msj_bloqueo)
		'elseif not EsVacio(msj_bloqueo) and msj_bloqueo = "El postulante se encuentra moroso.\n\n" then
			'conectar.MensajeError(msj_bloqueo)
		end if
		
		if pers_nrut="15184371"  then
			bloqueado = false
		end if
		
		usuario1=negocio.obtenerUsuario
        pers_usuario=conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario1&"'")
        es_administrador = conectar.consultaUno("Select case count(*) when 0 then 'N' else 'S' end from sis_roles_usuarios where cast(pers_ncorr as varchar)='"&pers_usuario&"' and srol_ncorr = 1")
        if es_administrador="S" and msj_bloqueo = "El postulante se encuentra moroso.\n\n" then
			bloqueado = false
			conectar.MensajeError(msj_bloqueo)
		end if

end if
	
'-----------------------------------------------------------------------------------------------------------

tresumen.carga_parametros	"tabla_resumen.xml","tabla_resumen"
optativos_deportivos.carga_parametros "toma_carga.xml" , "tabla_Op_deportivos"
tresumen_otrasede.carga_parametros	"tabla_resumen.xml","tabla_resumen_otra_sede"

 if cantidad_carreras = 1 then
 texto_1 = " SELECT matr_ncorr "& vbCrlf &_
          " FROM personas a, alumnos b, ofertas_academicas c "& vbCrlf &_
          " WHERE a.pers_ncorr = b.pers_ncorr "& vbCrlf &_
          " AND b.ofer_ncorr = c.ofer_ncorr "& vbCrlf &_
          " AND cast(pers_nrut as varchar) = '"& pers_nrut &"' "& vbCrlf &_
          " AND cast(peri_ccod as varchar)= '"& peri_ccod &"' "& vbCrlf &_
          " AND cast(sede_ccod as varchar) = '"& sede_ccod &"' "& vbCrlf &_
          " and emat_ccod = 1 " 		
 else
	texto_1 = "select top 1 parametro from (" & consulta_carreras & ")b"		 
 end if
 'response.Write("<pre>"&texto_1&"</pre>")
 if esVacio(matr_ncorr) then
	 matr_ncorr =  conectar.consultaUno(texto_1) 
 end if
 
 if matr_ncorr<>"" then 
       '----------------------------------------------En caso de alumnos nuevos se buscará el filtro para que solo muestre el primer nivel-------
	   '-------------------------------------------------------------msandoval 22-02-2005--------------------------------------------------------
	   v_pers_ncorr = conectar.consultauno("select pers_ncorr from personas where cast(pers_nrut as varchar)  = '"&pers_nrut&"'")		   
	   consulta_carr=" select top 1 carr_ccod " & vbCrlf & _
				" from alumnos a, ofertas_Academicas b, especialidades c " & vbCrlf & _
				" where a.ofer_ncorr = b.ofer_ncorr " & vbCrlf & _
				" and b.espe_ccod=c.espe_ccod " & vbCrlf & _
				" and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"'"
	   carr_temporal = conectar.consultaUno(consulta_carr)
	   consulta_peri= " select top 1 min(b.peri_ccod)as periodo " & vbCrlf & _
	                  " from postulantes a, periodos_academicos b,ofertas_Academicas c, especialidades d " & vbCrlf & _
					  "	where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' " & vbCrlf & _
					  "	and a.ofer_ncorr=c.ofer_ncorr and c.espe_ccod=d.espe_ccod" & vbCrlf & _
					  "	and cast(d.carr_ccod as varchar)='"&carr_temporal&"' " & vbCrlf & _
					  "	and a.peri_ccod=b.peri_ccod order by periodo asc"
					  
	   primer_periodo = conectar.consultaUno(consulta_peri)
       'primer_periodo = conectar.consultaUno(" select top 1 min(b.peri_ccod)as periodo from postulantes a, periodos_academicos b where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and a.peri_ccod=b.peri_ccod order by periodo asc")
       ano_ingreso= conectar.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&primer_periodo&"'")
	   ano_proceso= conectar.consultaUno("Select anos_ccod from periodos_academicos where cast(peri_ccod as varchar)='"&peri_ccod&"'")
	   'response.Write(" select top 1 min(b.peri_ccod)as periodo from postulantes a, periodos_academicos b where cast(a.pers_ncorr as varchar)='"&v_pers_ncorr&"' and a.peri_ccod=b.peri_ccod order by periodo asc")
	   if cint(ano_ingreso)=cint(ano_proceso) then
	   		alumno_nuevo=1
	   else
			alumno_nuevo=0	
	   end if
	   'response.Write("alumno_nuevo "&alumno_nuevo)
	   '------------------------------------------------------------------------------------------------------------------------------------------
		sql_espe_ccod = " select espe_ccod from alumnos a, ofertas_academicas b " & _
						" where a.ofer_ncorr = b.ofer_ncorr " & _
						" and cast(matr_ncorr as varchar)= '"&matr_ncorr&"'" 
		
		sql_jorn_ccod = " select jorn_ccod from alumnos a, ofertas_academicas b " & _
						" where a.ofer_ncorr = b.ofer_ncorr " & _
						" and cast(matr_ncorr as varchar)= '"&matr_ncorr&"'" 
		'response.Write(sql_jorn_ccod)				
		 v_espe_ccod  = conectar.consultauno(sql_espe_ccod)
		 v_jorn_ccod  = conectar.consultauno(sql_jorn_ccod)		 
		 
		 
		 sql_pers_ncorr = "select pers_ncorr from personas where cast(pers_nrut as varchar) = '"&negocio.obtenerusuario&"'"	
		 'response.Write(sql_pers_ncorr)
		 pers_ncorr_usuario = conectar.consultauno(sql_pers_ncorr)
		 sql_especialidades = " select count(*) " & _
	     					  " from sis_especialidades_usuario " & _
		 					  " where cast(pers_ncorr as varchar) = '"&pers_ncorr_usuario&"' " & _
							  " and cast(espe_ccod as varchar) = '"&v_espe_ccod&"'" & _
							  " and cast(jorn_ccod as varchar)= '"&v_jorn_ccod&"'"
		 'response.Write(sql_especialidades)
		 acceso_usuario = conectar.consultauno(sql_especialidades)
end if 

' if (acceso_usuario = 0 and pers_nrut <>"" ) then
'	pers_ncorr = "-1"
'	es_nuevo = "-1"
'	sede_ccod = "-1"
'	plan_ccod = "-1"
'	peri_ccod = "-1"
'	es_nuevo = "-1"
'	matr_ncorr = ""
	
'	session("mensajeError") = "Usuario No Tiene Acceso Para\nAsignar Carga A Este Alumno"
'	set errx = new cErrores
	
'end if 
 'matr_ncorr = conectar.consultaUno ("select matr_ncorr from personas a, alumnos b, ofertas_academicas c where a.pers_ncorr=b.pers_ncorr and b.ofer_ncorr=c.ofer_ncorr and pers_nrut='" & pers_nrut & "' and peri_ccod='" & peri_ccod & "'  ")
 pers_ncorr = conectar.consultaUno ("select pers_ncorr from alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "' ")
 nombre = conectar.consultaUno ("select cast(pers_tape_paterno as varchar) + ' ' + cast(pers_tape_materno as varchar) + ', ' + cast(pers_tnombre as varchar) from personas where cast(pers_ncorr as varchar)='" & pers_ncorr & "'")
 carrera = conectar.consultaUno ("select carr_tdesc from carreras a, especialidades b, planes_estudio c, alumnos d where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod and c.plan_ccod=d.plan_ccod and cast(matr_ncorr as varchar)='" & matr_ncorr & "' and d.emat_ccod=1")
 v_carr_ccod  = conectar.consultaUno ("select ltrim(rtrim(a.carr_ccod)) from carreras a, especialidades b, planes_estudio c, alumnos d where a.carr_ccod=b.carr_ccod and b.espe_ccod=c.espe_ccod and c.plan_ccod=d.plan_ccod and cast(matr_ncorr as varchar)='" & matr_ncorr & "' and d.emat_ccod=1")
 alumno.inicializa conectar, matr_ncorr
 alumno.construyeSituacionAsignaturas
'response.Write("==> "&v_carr_ccod)

usuario_paso=negocio.obtenerUsuario
autorizado = conectar.consultaUno("select isnull(count(*),0) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=79 and cast(a.pers_nrut as varchar)='"&usuario_paso&"'")

'------------------------------------------------------------------------------------------------------
'-------------------------para anularle el derecho de ingreso a los directores de carrera--------------
usuario_temporal = negocio.obtenerUsuario
pers_ncorr_usuario = conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario_temporal&"'")
autorizado_carga = conectar.consultaUno("Select isnull(count(*),0) from sis_roles_usuarios where srol_ncorr=2 and cast(pers_ncorr as varchar)='"&pers_ncorr_usuario&"'")
'response.Write("Select isnull(count(*),0) from sis_roles_usuarios where srol_ncorr=2 and cast(pers_ncorr as varchar)='"&pers_ncorr_usuario&"'")

'response.Write("sys_cierra_toma_carga "&sys_cierra_toma_carga&" autorizado "&autorizado_carga)
'-----------------------------------------------FIN---------------------------------------------------- 
'response.Write(v_carr_ccod)

if v_carr_ccod = "45" or v_carr_ccod="51" then
    'response.Write("1-")
	dentro_rango = conectar.consultaUno("select case when getDate() >= convert(datetime,'21-11-2005',103) and getDate() <= convert(datetime,'23-11-2005',103) then '1' else '0' end ")
	if dentro_rango= "1" then
	    'response.Write("2-")
		' habilitamos a las personas de comunicación multimedia y de periodismo pa que modifiquen la carga académica.
		autorizado = "1"
		autorizado_carga = "1"
	end if
end if

if autorizado_carga > "0" then
     'response.Write("3-")
	sys_cierra_toma_carga = false
end if	

 if isnull(pers_ncorr) then
	pers_ncorr = "-1"
	es_nuevo = "-1"
	sede_ccod = "-1"
	plan_ccod = "-1"
	peri_ccod = "-1"
	es_nuevo = "-1"
 else
	sede_ccod = conectar.consultaUno ("select sede_ccod from ofertas_academicas a, alumnos b where a.ofer_ncorr=b.ofer_ncorr and cast(matr_ncorr as varchar)='" & matr_ncorr & "' and b.emat_ccod=1")
	plan_ccod = conectar.consultaUno ("select plan_ccod from  alumnos where cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
	es_nuevo = conectar.consultaUno ("select protic.alumno_es_nuevo('" & matr_ncorr & "')")
	'response.Write("Es nuevo= "&es_nuevo)
	area_ccod = conectar.consultaUno ("select area_ccod from alumnos a, planes_estudio b, especialidades c, carreras d where a.plan_ccod=b.plan_ccod and b.espe_ccod=c.espe_ccod and c.carr_ccod=d.carr_ccod and cast(matr_ncorr as varchar)='" & matr_ncorr & "'")
 end if

 if ((isnull(matr_ncorr)) and (pers_ncorr="-1")) and (pers_nrut<>"") then
	session("mensajeError") = "Persona no matriculada en sede : " & pers_nrut & "-" & pers_xdv
	set errx = new cErrores
 end if
 
 jorn_ccod = conectar.consultaUno ("select jorn_ccod from alumnos a, ofertas_academicas b where a.ofer_ncorr=b.ofer_ncorr and cast(matr_ncorr as varchar)='"&matr_ncorr&"'") 
 '/************************************buscamos la cadena de planes de estudios para alumnos antiguos*************************************************
  'response.Write("alumno_nuevo "&alumno_nuevo&"carrera "&v_carr_ccod)
  if ((alumno_nuevo=0 or v_plec_ccod = "2") or v_plec_ccod = "3") and not esVacio(v_carr_ccod) then
     
     'response.Write("select protic.obtener_planes_carrera("&v_carr_ccod&","&jorn_ccod&")")
	 cadena_planes=conectar.consultaUno("select protic.obtener_planes_carrera("&v_carr_ccod&","&jorn_ccod&")")
	 'response.Write("<br>cadena_planes "&cadena_planes)
  else 
     'response.Write("select protic.obtener_planes_optativos_carrera('"&v_carr_ccod&"')")
     cadena_temporal = conectar.consultaUno("select protic.obtener_planes_optativos_carrera('"&v_carr_ccod&"')")
	 if ( not esVacio(cadena_temporal) and cadena_temporal <>"") then 
     	cadena_planes="('"&plan_ccod&"',"&cadena_temporal&")"
     else
	 	cadena_planes="('"&plan_ccod&"')"
	 end if			 
 end if
 '/***************************************************************************************************************************************************

'response.Write("<br>cadena_planes "&cadena_planes)
 asignaturas_disponibles_cons = "" & vbCrlf & _
"select distinct c.asig_ccod,c.asig_ccod asig_ccod_paso, c.asig_tdesc as asignatura,case moda_ccod when 2 then secc_nhoras_pagar else asig_nhoras end as asig_nhoras, b.secc_ccod, '" & matr_ncorr & "' as matr_ncorr " & vbCrlf & _
"	  , a.nive_ccod, isnull(d.reprobado,0) as reprobado  from (SELECT DISTINCT b.asig_ccod, b.nive_ccod,secc.moda_ccod,secc.secc_nhoras_pagar " & vbCrlf & _
"  FROM malla_curricular b,secciones secc,bloques_horarios bl" & vbCrlf & _
" WHERE cast(b.plan_ccod as varchar) in " & cadena_planes & " and cast(secc.peri_ccod as varchar)='"&peri_ccod&"'"
if alumno_nuevo=1 then
  asignaturas_disponibles_cons =  asignaturas_disponibles_cons & " --and b.nive_ccod=1 "'''''liberamos los niveles para alumnos de primer año Marco Perelli 24-05-2005
end if
'asignaturas_disponibles_cons =  asignaturas_disponibles_cons & " --AND protic.completo_requisitos_asignatura (b.mall_ccod, '" & pers_ncorr & "') = 0" & vbCrlf & _
'"   and b.asig_ccod=secc.asig_ccod and b.mall_ccod=secc.mall_ccod and secc.secc_ncupo > 0 and secc.secc_ccod=bl.secc_ccod and cast(secc.jorn_ccod as varchar)='"&jorn_ccod&"' AND cast(secc.sede_ccod as varchar) = '" & sede_ccod & "' " & vbCrlf & _
'"   AND NOT (  " & vbCrlf & _
'"			EXISTS (SELECT 1 " & vbCrlf & _
'"                    FROM secciones sa," & vbCrlf & _
'"                         cargas_academicas sb," & vbCrlf & _
'"                         alumnos sc," & vbCrlf & _
'"                         situaciones_finales sd" & vbCrlf & _
'"                   WHERE sa.secc_ccod = sb.secc_ccod" & vbCrlf & _
'"                     AND sa.asig_ccod = b.asig_ccod" & vbCrlf & _
'"                     AND sb.matr_ncorr = sc.matr_ncorr" & vbCrlf & _
'"                     AND sb.sitf_ccod = sd.sitf_ccod" & vbCrlf & _
'"                     AND cast(sd.sitf_baprueba as varchar) = 'S'" & vbCrlf & _
'"                     AND sc.emat_ccod = 1" & vbCrlf & _
'"                     AND cast(sc.pers_ncorr as varchar) = '" & pers_ncorr & "')" & vbCrlf & _
'"        OR  " & vbCrlf & _
'"           EXISTS (  select 1 " & vbCrlf & _
'		"			from  " & vbCrlf & _
'		"				 convalidaciones a " & vbCrlf & _
'		"				 , alumnos b1 " & vbCrlf & _
'		"				 ,personas c " & vbCrlf & _
'		"				 , actas_convalidacion d " & vbCrlf & _
'		"				 , ofertas_academicas e " & vbCrlf & _
'		"				 , planes_estudio f " & vbCrlf & _
'		"				 ,especialidades g " & vbCrlf & _
'		"				 ,situaciones_finales h " & vbCrlf & _
'		"			where " & vbCrlf & _
'		"				 a.matr_ncorr=b1.matr_ncorr " & vbCrlf & _
'		"				 and b1.pers_ncorr=c.pers_ncorr " & vbCrlf & _
'		"				 and a.acon_ncorr=d.acon_ncorr " & vbCrlf & _
'		"				 and b1.ofer_ncorr=e.ofer_ncorr " & vbCrlf & _
'		"				 and b1.plan_ccod=f.plan_ccod " & vbCrlf & _
'		"				 and f.espe_ccod=g.espe_ccod " & vbCrlf & _
'		"				 and a.asig_ccod=b.asig_ccod " & vbCrlf & _
'		"				 and a.sitf_ccod=h.sitf_ccod " & vbCrlf & _
'		"				 and cast(h.sitf_baprueba as varchar)='S' " & vbCrlf & _
'		"			     and cast(c.pers_ncorr as varchar)='"&pers_ncorr&"')" & vbCrlf & _	
'"        OR  " & vbCrlf & _
'"           /*EXISTS ( SELECT 1 " & vbCrlf & _
'"                		from homologacion_destino hd, homologacion_fuente hf,homologacion h,asignaturas asig, " & vbCrlf & _
'"                		secciones secc,cargas_academicas carg, alumnos al, personas pers, situaciones_finales s2c " & vbCrlf & _
'"                		where hd.homo_ccod=h.homo_ccod " & vbCrlf & _
'"                		and hf.homo_ccod=h.homo_ccod " & vbCrlf & _
'"                		and asig.asig_ccod=hd.asig_ccod " & vbCrlf & _
'"                		and asig.asig_ccod=secc.asig_ccod " & vbCrlf & _
'"                		and secc.secc_ccod=carg.secc_ccod " & vbCrlf & _
'"                     	AND hf.asig_ccod  = b.asig_ccod" & vbCrlf & _
'"                		and al.matr_ncorr=carg.matr_ncorr " & vbCrlf & _
'"                		and pers.pers_ncorr=al.pers_ncorr " & vbCrlf & _
'"        		 		and hd.asig_ccod <> hf.asig_ccod " & vbCrlf & _
'"                     	AND carg.sitf_ccod = s2c.sitf_ccod" & vbCrlf & _
'"                     	AND cast(s2c.sitf_baprueba as varchar) = 'S'" & vbCrlf & _
'"                		and cast(carg.sitf_ccod as varchar) <>'EQ' " & vbCrlf & _
'"          		 		and h.THOM_CCOD = 1 " & vbCrlf & _
'"                       AND al.emat_ccod = 1" & vbCrlf & _
'"                		and cast(pers.pers_ncorr as varchar)='" & pers_ncorr & "')" & vbCrlf & _
'"		OR */EXISTS (select  1 " & vbCrlf & _
'"		   		  		   from " & vbCrlf & _
'"								equivalencias a " & vbCrlf & _
'"								, cargas_academicas b1 " & vbCrlf & _
'"								, secciones c " & vbCrlf & _
'"								, ofertas_academicas d " & vbCrlf & _
'"								, planes_estudio e " & vbCrlf & _
'"								, especialidades f " & vbCrlf & _
'"								, alumnos g " & vbCrlf & _
'"								, personas h " & vbCrlf & _
'"								, situaciones_finales sf " & vbCrlf & _
'"							where " & vbCrlf & _
'"								 a.matr_ncorr=b1.matr_ncorr " & vbCrlf & _
'"								 and a.secc_ccod=b1.secc_ccod " & vbCrlf & _
'"								 and b1.secc_ccod=c.secc_ccod " & vbCrlf & _
'"								 and b1.matr_ncorr=g.matr_ncorr " & vbCrlf & _
'"								 and d.ofer_ncorr=g.ofer_ncorr " & vbCrlf & _
'"								 and e.plan_ccod=g.plan_ccod " & vbCrlf & _
'"								 and e.espe_ccod=f.espe_ccod " & vbCrlf & _
'"								 and g.pers_ncorr=h.pers_ncorr " & vbCrlf & _
'"								 and a.asig_ccod=b.asig_ccod " & vbCrlf & _
'"								 and isnull(b1.sitf_ccod,sf.sitf_ccod)=sf.sitf_ccod " & vbCrlf & _
'"								 and cast(sf.sitf_baprueba as varchar)='S' " & vbCrlf & _
'"								 and cast(h.pers_ncorr as varchar)='" & pers_ncorr & "') " & vbCrlf & _
'"        ) " & vbCrlf & _
'"   AND cast(b.plan_ccod as varchar) in  " & cadena_planes & "" & vbCrlf & _
'"   AND NOT EXISTS (SELECT 1 " & vbCrlf & _
'"                      FROM  " & vbCrlf & _
'"                      MALLA_CURRICULAR MC, " & vbCrlf & _
'"                      (SELECT HOMO_CCOD,ASIG_CCOD_DESTINO, COUNT(*) NREQUISITOS, count(asig_ccod)NAPROBADOS " & vbCrlf & _
'"                      FROM  " & vbCrlf & _
'"                      (SELECT HD.HOMO_CCOD,HD.ASIG_CCOD ASIG_CCOD_DESTINO,HF.ASIG_CCOD ASIG_CCOD_FUENTE  " & vbCrlf & _
'"                       FROM HOMOLOGACION_FUENTE HF,  " & vbCrlf & _
'"                       HOMOLOGACION_DESTINO HD " & vbCrlf & _
'"                       WHERE HF.HOMO_CCOD=HD.HOMO_CCOD ) HOM, " & vbCrlf & _
'"                      (SELECT S.ASIG_CCOD  " & vbCrlf & _
'"                       FROM " & vbCrlf & _
'"                       SECCIONES S, " & vbCrlf & _
'"                       CARGAS_ACADEMICAS CA, " & vbCrlf & _
'"                       ALUMNOS A, " & vbCrlf & _
'"                       SITUACIONES_FINALES SF " & vbCrlf & _
'"                       WHERE S.SECC_CCOD = CA.SECC_CCOD " & vbCrlf & _
'"                       	   AND CA.MATR_NCORR = A.MATR_NCORR  " & vbCrlf & _
'"                      	   AND SF.SITF_CCOD=CA.SITF_CCOD " & vbCrlf & _
'"                      	   AND SF.SITF_BAPRUEBA='S'   " & vbCrlf & _
'"                      	   AND cast(A.PERS_NCORR as varchar) = '" & pers_ncorr & "') APRO ---PONER PERS_NCORR  " & vbCrlf & _
'"                      WHERE HOM.ASIG_CCOD_FUENTE *=APRO.ASIG_CCOD  " & vbCrlf & _
'"                      group by HOMO_CCOD,asig_ccod_destino)	PRUEBA " & vbCrlf & _
'"                      WHERE MC.ASIG_CCOD=ASIG_CCOD_DESTINO " & vbCrlf & _
'"                      AND MC.ASIG_CCOD=B.ASIG_CCOD " & vbCrlf & _
'"					  AND NREQUISITOS=NAPROBADOS " & vbCrlf & _
'"                      AND cast(PLAN_CCOD as varchar) in " & cadena_planes & ") " & vbCrlf & _
'") a, " & vbCrlf & _
'"	(SELECT a.asig_ccod, a.secc_ccod, c.matr_ncorr  " & vbCrlf & _
'"	   FROM secciones a, cargas_academicas b, alumnos c " & vbCrlf & _
'"	  WHERE a.secc_ccod = b.secc_ccod " & vbCrlf & _
'"	   AND b.matr_ncorr = c.matr_ncorr and b.sitf_ccod is null" & vbCrlf & _
'"      AND c.emat_ccod = 1" & vbCrlf & _
'"      AND cast(a.sede_ccod as varchar) = '" & sede_ccod & "' " & vbCrlf & _
'"      AND cast(a.peri_ccod as varchar) = '" & peri_ccod & "' " & vbCrlf & _
'"	   AND cast(c.pers_ncorr as varchar) = '" & pers_ncorr & "'"& vbCrlf & _
'" 	   AND cast(c.emat_ccod as varchar)='1'"& vbCrlf & _
'"      union"& vbCrlf & _
'"	   select null,null,null) b, " & vbCrlf & _
'"	  asignaturas c, " & vbCrlf & _ 
'"   ( select a.asig_ccod, 1 as reprobado  " & vbCrlf & _
'"       from secciones a, cargas_academicas b, situaciones_finales c, alumnos d " & vbCrlf & _
'"      where a.secc_ccod=b.secc_ccod  " & vbCrlf & _
'"        and b.sitf_ccod=c.sitf_ccod  " & vbCrlf & _
'"        and b.matr_ncorr=d.matr_ncorr " & vbCrlf & _
'"        AND d.emat_ccod = 1" & vbCrlf & _
'"        and cast(d.pers_ncorr as varchar)='" & pers_ncorr & "' " & vbCrlf & _
'"        and cast(sitf_baprueba as varchar)='N' " & vbCrlf & _
'"        and cast(b.sitf_ccod as varchar) not in ('EE') " & vbCrlf & _
'"	  union all" & vbCrlf & _
'"	  	select  " & vbCrlf & _
'"			a.asig_ccod,1 as reprobado  " & vbCrlf & _
'"		from  " & vbCrlf & _
'"			 equivalencias a,  " & vbCrlf & _
'"			 cargas_academicas b,  " & vbCrlf & _
'"			 secciones c,  " & vbCrlf & _
'"			 situaciones_finales d,  " & vbCrlf & _
'"			 alumnos e,  " & vbCrlf & _
'"			 personas f " & vbCrlf & _
'"	  where a.matr_ncorr=b.matr_ncorr " & vbCrlf & _
'"		  and a.secc_ccod=b.secc_ccod  " & vbCrlf & _
'"		  and b.secc_ccod=c.secc_ccod " & vbCrlf & _
'"		  and b.sitf_ccod=d.sitf_ccod " & vbCrlf & _
'"		  and b.matr_ncorr=e.matr_ncorr " & vbCrlf & _
'"		  and e.pers_ncorr=f.pers_ncorr " & vbCrlf & _
'"		  and b.sitf_ccod not in ('EE') " & vbCrlf & _
'"		  and d.sitf_baprueba='N'" & vbCrlf & _
'"		  and cast(f.pers_ncorr as varchar)='"& pers_ncorr &"'"& vbCrlf & _
'"          union "& vbCrlf & _
'"		  select null,null) d" & vbCrlf & _
'"  where a.asig_ccod *=b.asig_ccod  " & vbCrlf & _
'"    and a.asig_ccod *=d.asig_ccod  " & vbCrlf & _
'"    and a.asig_ccod=c.asig_ccod " & vbCrLf & _
'"  " & vbCrLf
'--------------------------------------------------------------------------------------------INICIO CONSULTA SQLServer 2008
asignaturas_disponibles_cons =  asignaturas_disponibles_cons & "	--AND protic.completo_requisitos_asignatura (b.mall_ccod, '" & pers_ncorr & "') = 0 " & vbCrlf & _  
"        and b.asig_ccod = secc.asig_ccod                                                                                                               " & vbCrlf & _
"        and b.mall_ccod = secc.mall_ccod                                                                                                               " & vbCrlf & _
"        and secc.secc_ncupo > 0                                                                                                                        " & vbCrlf & _
"        and secc.secc_ccod = bl.secc_ccod                                                                                                              " & vbCrlf & _
"        and cast(secc.jorn_ccod as varchar) = '"&jorn_ccod&"'                                                                                          " & vbCrlf & _
"        and cast(secc.sede_ccod as varchar) = '" & sede_ccod & "'                                                                                      " & vbCrlf & _
"        and not ( exists (select 1                                                                                                                     " & vbCrlf & _
"                          from   secciones as sa                                                                                                       " & vbCrlf & _
"                                 inner join cargas_academicas as sb                                                                                    " & vbCrlf & _
"                                         on sa.secc_ccod = sb.secc_ccod                                                                                " & vbCrlf & _
"                                 inner join alumnos as sc                                                                                              " & vbCrlf & _
"                                         on sb.matr_ncorr = sc.matr_ncorr                                                                              " & vbCrlf & _
"                                            and sc.emat_ccod = 1                                                                                       " & vbCrlf & _
"                                            and cast(sc.pers_ncorr as varchar) = '" & pers_ncorr & "'                                                  " & vbCrlf & _
"                                 inner join situaciones_finales as sd                                                                                  " & vbCrlf & _
"                                         on sb.sitf_ccod = sd.sitf_ccod                                                                                " & vbCrlf & _
"                                            and cast(sd.sitf_baprueba as varchar) = 'S'                                                                " & vbCrlf & _
"                          where  sa.asig_ccod = b.asig_ccod)                                                                                           " & vbCrlf & _
"                   or exists (select 1                                                                                                                 " & vbCrlf & _
"                              from   convalidaciones as a                                                                                              " & vbCrlf & _
"                                     inner join alumnos as b1                                                                                          " & vbCrlf & _
"                                             on a.matr_ncorr = b1.matr_ncorr                                                                           " & vbCrlf & _
"                                     inner join personas as c                                                                                          " & vbCrlf & _
"                                             on b1.pers_ncorr = c.pers_ncorr                                                                           " & vbCrlf & _
"                                                and cast(c.pers_ncorr as varchar) = '"&pers_ncorr&"'                                                   " & vbCrlf & _
"                                     inner join actas_convalidacion as d                                                                               " & vbCrlf & _
"                                             on a.acon_ncorr = d.acon_ncorr                                                                            " & vbCrlf & _
"                                     inner join ofertas_academicas as e                                                                                " & vbCrlf & _
"                                             on b1.ofer_ncorr = e.ofer_ncorr                                                                           " & vbCrlf & _
"                                     inner join planes_estudio as f                                                                                    " & vbCrlf & _
"                                             on b1.plan_ccod = f.plan_ccod                                                                             " & vbCrlf & _
"                                     inner join especialidades as g                                                                                    " & vbCrlf & _
"                                             on f.espe_ccod = g.espe_ccod                                                                              " & vbCrlf & _
"                                     inner join situaciones_finales as h                                                                               " & vbCrlf & _
"                                             on a.sitf_ccod = h.sitf_ccod                                                                              " & vbCrlf & _
"                                                and cast(h.sitf_baprueba as varchar) = 'S'                                                             " & vbCrlf & _
"                              where  a.asig_ccod = b.asig_ccod)                                                                                        " & vbCrlf & _
"                   or                                                                                                                                  " & vbCrlf & _
"                  /*EXISTS ( SELECT 1                                                                                                                  " & vbCrlf & _
"                           from homologacion_destino hd, homologacion_fuente hf,homologacion h,asignaturas asig,                                       " & vbCrlf & _
"                           secciones secc,cargas_academicas carg, alumnos al, personas pers, situaciones_finales s2c                                   " & vbCrlf & _
"                           where hd.homo_ccod=h.homo_ccod                                                                                              " & vbCrlf & _
"                           and hf.homo_ccod=h.homo_ccod                                                                                                " & vbCrlf & _
"                           and asig.asig_ccod=hd.asig_ccod                                                                                             " & vbCrlf & _
"                           and asig.asig_ccod=secc.asig_ccod                                                                                           " & vbCrlf & _
"                           and secc.secc_ccod=carg.secc_ccod                                                                                           " & vbCrlf & _
"                              AND hf.asig_ccod  = b.asig_ccod                                                                                          " & vbCrlf & _
"                           and al.matr_ncorr=carg.matr_ncorr                                                                                           " & vbCrlf & _
"                           and pers.pers_ncorr=al.pers_ncorr                                                                                           " & vbCrlf & _
"                      and hd.asig_ccod <> hf.asig_ccod                                                                                                 " & vbCrlf & _
"                              AND carg.sitf_ccod = s2c.sitf_ccod                                                                                       " & vbCrlf & _
"                              AND cast(s2c.sitf_baprueba as varchar) = 'S'                                                                             " & vbCrlf & _
"                           and cast(carg.sitf_ccod as varchar) <>'EQ'                                                                                  " & vbCrlf & _
"                         and h.THOM_CCOD = 1                                                                                                           " & vbCrlf & _
"                              AND al.emat_ccod = 1                                                                                                     " & vbCrlf & _
"                           and cast(pers.pers_ncorr as varchar)='" & pers_ncorr & "')                                                                  " & vbCrlf & _
"                  OR */exists (select 1                                                                                                                " & vbCrlf & _
"                                                        from   equivalencias as a                                                                      " & vbCrlf & _
"                                                               inner join cargas_academicas as b1                                                      " & vbCrlf & _
"                                                                       on a.matr_ncorr = b1.matr_ncorr                                                 " & vbCrlf & _
"                                                                          and a.secc_ccod = b1.secc_ccod                                               " & vbCrlf & _                     
"                                                               inner join secciones as c                                                               " & vbCrlf & _
"                                                                       on b1.secc_ccod = c.secc_ccod                                                   " & vbCrlf & _
"                                                               inner join alumnos as g                                                                 " & vbCrlf & _
"                                                                       on b1.matr_ncorr = g.matr_ncorr                                                 " & vbCrlf & _
"                                                               inner join ofertas_academicas as d                                                      " & vbCrlf & _
"                                                                       on g.ofer_ncorr = d.ofer_ncorr                                                  " & vbCrlf & _
"                                                               inner join planes_estudio as e                                                          " & vbCrlf & _
"                                                                       on g.plan_ccod = e.plan_ccod                                                    " & vbCrlf & _
"                                                               inner join especialidades as f                                                          " & vbCrlf & _
"                                                                       on e.espe_ccod = f.espe_ccod                                                    " & vbCrlf & _
"                                                               inner join personas as h                                                                " & vbCrlf & _
"                                                                       on g.pers_ncorr = h.pers_ncorr                                                  " & vbCrlf & _
"                                                                          and cast(h.pers_ncorr as varchar) = '" & pers_ncorr & "'                     " & vbCrlf & _
"                                                               inner join situaciones_finales as sf                                                    " & vbCrlf & _
"                                                                       on cast(sf.sitf_baprueba as varchar) = 'S'                                      " & vbCrlf & _
"																	   and isnull(b1.sitf_ccod, sf.sitf_ccod) = sf.sitf_ccod                                                              " & vbCrlf & _
"                                                        where  a.asig_ccod = b.asig_ccod) )                                                            " & vbCrlf & _
"        and cast(b.plan_ccod as varchar) in " & cadena_planes & "                                                                                      " & vbCrlf & _
"        and not exists (select 1                                                                                                                       " & vbCrlf & _
"                        from   malla_curricular as mc                                                                                                  " & vbCrlf & _
"                               inner join (select homo_ccod,                                                                                           " & vbCrlf & _
"                                                  asig_ccod_destino,                                                                                   " & vbCrlf & _
"                                                  count(*)        nrequisitos,                                                                         " & vbCrlf & _
"                                                  count(asig_ccod)naprobados                                                                           " & vbCrlf & _
"                                           from   (select hd.homo_ccod,                                                                                " & vbCrlf & _
"                                                          hd.asig_ccod asig_ccod_destino,                                                              " & vbCrlf & _
"                                                          hf.asig_ccod asig_ccod_fuente                                                                " & vbCrlf & _
"                                                   from   homologacion_fuente as hf                                                                    " & vbCrlf & _
"                                                          inner join homologacion_destino as hd                                                        " & vbCrlf & _
"                                                                  on hf.homo_ccod = hd.homo_ccod) as hom                                               " & vbCrlf & _
"                                                  left outer join (select s.asig_ccod                                                                  " & vbCrlf & _
"                                                                   from   secciones as s                                                               " & vbCrlf & _
"                                                                          inner join cargas_academicas as ca                                           " & vbCrlf & _
"                                                                                  on s.secc_ccod = ca.secc_ccod                                        " & vbCrlf & _
"                                                                          inner join alumnos as a                                                      " & vbCrlf & _
"                                                                                  on ca.matr_ncorr = a.matr_ncorr                                      " & vbCrlf & _
"                                                                                     and cast(a.pers_ncorr as varchar) = '" & pers_ncorr & "'          " & vbCrlf & _
"                                                                          inner join situaciones_finales as sf                                         " & vbCrlf & _
"                                                                                  on ca.sitf_ccod = sf.sitf_ccod                                       " & vbCrlf & _
"                                                                                     and sf.sitf_baprueba = 'S') as apro ---PONER PERS_NCORR           " & vbCrlf & _
"                                                               on hom.asig_ccod_fuente = apro.asig_ccod                                                " & vbCrlf & _
"                                           group  by homo_ccod,                                                                                        " & vbCrlf & _
"                                                     asig_ccod_destino) as prueba                                                                      " & vbCrlf & _
"                                       on mc.asig_ccod = prueba.asig_ccod_destino --se agrega prueba. 18_03_2013                                       " & vbCrlf & _
"                        where  mc.asig_ccod = b.asig_ccod                                                                                              " & vbCrlf & _
"                               and nrequisitos = naprobados                                                                                            " & vbCrlf & _
"                               and cast(plan_ccod as varchar) in " & cadena_planes & "                                                                 " & vbCrlf & _
"                       )) as a                                                                                                                         " & vbCrlf & _
"left outer join (select a.asig_ccod,                                                                                                                   " & vbCrlf & _
"                        a.secc_ccod,                                                                                                                   " & vbCrlf & _
"                        c.matr_ncorr                                                                                                                   " & vbCrlf & _
"                 from   secciones as a                                                                                                                 " & vbCrlf & _
"                        inner join cargas_academicas as b                                                                                              " & vbCrlf & _
"                                on a.secc_ccod = b.secc_ccod                                                                                           " & vbCrlf & _
"                                   and b.sitf_ccod is null                                                                                             " & vbCrlf & _
"                        inner join alumnos as c                                                                                                        " & vbCrlf & _
"                                on b.matr_ncorr = c.matr_ncorr                                                                                         " & vbCrlf & _
"                                   and c.emat_ccod = 1                                                                                                 " & vbCrlf & _
"                                   and cast(c.pers_ncorr as varchar) = '" & pers_ncorr & "'                                                            " & vbCrlf & _
"                                   and cast(c.emat_ccod as varchar) = '1'                                                                              " & vbCrlf & _
"                 where  cast(a.sede_ccod as varchar) = '" & sede_ccod & "'                                                                             " & vbCrlf & _
"                        and cast(a.peri_ccod as varchar) = '" & peri_ccod & "'                                                                         " & vbCrlf & _
"                 union                                                                                                                                 " & vbCrlf & _
"                 select null,                                                                                                                          " & vbCrlf & _
"                        null,                                                                                                                          " & vbCrlf & _
"                        null) as b                                                                                                                     " & vbCrlf & _
"             on a.asig_ccod = b.asig_ccod                                                                                                              " & vbCrlf & _
"inner join asignaturas as c                                                                                                                            " & vbCrlf & _
"        on a.asig_ccod = c.asig_ccod                                                                                                                   " & vbCrlf & _
"left outer join (select a.asig_ccod,                                                                                                                   " & vbCrlf & _
"                        1 as reprobado                                                                                                                 " & vbCrlf & _
"                 from   secciones as a                                                                                                                 " & vbCrlf & _
"                        inner join cargas_academicas as b                                                                                              " & vbCrlf & _
"                                on a.secc_ccod = b.secc_ccod                                                                                           " & vbCrlf & _
"                                   and cast(b.sitf_ccod as varchar) not in ( 'EE' )                                                                    " & vbCrlf & _
"                        inner join situaciones_finales as c                                                                                            " & vbCrlf & _
"                                on b.sitf_ccod = c.sitf_ccod                                                                                           " & vbCrlf & _
"                        inner join alumnos as d                                                                                                        " & vbCrlf & _
"                                on b.matr_ncorr = d.matr_ncorr                                                                                         " & vbCrlf & _
"                                   and d.emat_ccod = 1                                                                                                 " & vbCrlf & _
"                                   and cast(d.pers_ncorr as varchar) = '" & pers_ncorr & "'                                                            " & vbCrlf & _
"                 where  cast(sitf_baprueba as varchar) = 'N' -- ¿de que tabla?                                                                         " & vbCrlf & _
"                 union all                                                                                                                             " & vbCrlf & _
"                 select a.asig_ccod,                                                                                                                   " & vbCrlf & _
"                        1 as reprobado                                                                                                                 " & vbCrlf & _
"                 from   equivalencias as a                                                                                                             " & vbCrlf & _
"                        inner join cargas_academicas as b                                                                                              " & vbCrlf & _
"                                on a.matr_ncorr = b.matr_ncorr                                                                                         " & vbCrlf & _
"                                   and a.secc_ccod = b.secc_ccod                                                                                       " & vbCrlf & _
"                                   and b.sitf_ccod not in ( 'EE' )                                                                                     " & vbCrlf & _
"                        inner join secciones as c                                                                                                      " & vbCrlf & _
"                                on b.secc_ccod = c.secc_ccod                                                                                           " & vbCrlf & _
"                        inner join situaciones_finales as d                                                                                            " & vbCrlf & _
"                                on b.sitf_ccod = d.sitf_ccod                                                                                           " & vbCrlf & _
"                                   and d.sitf_baprueba = 'N'                                                                                           " & vbCrlf & _
"                        inner join alumnos as e                                                                                                        " & vbCrlf & _
"                                on b.matr_ncorr = e.matr_ncorr                                                                                         " & vbCrlf & _
"                        inner join personas as f                                                                                                       " & vbCrlf & _
"                                on e.pers_ncorr = f.pers_ncorr                                                                                         " & vbCrlf & _
"                                   and cast(f.pers_ncorr as varchar) = '"& pers_ncorr &"'                                                              " & vbCrlf & _
"                 union                                                                                                                                 " & vbCrlf & _
"                 select null,                                                                                                                          " & vbCrlf & _
"                        null) as d                                                                                                                     " & vbCrlf & _
"             on a.asig_ccod = d.asig_ccod                                                                                                              " & vbCrLf & _
"  " & vbCrLf
'--------------------------------------------------------------------------------------------FIN CONSULTA SQLServer 2008
	
'response.Write("<pre>"&asignaturas_disponibles_cons&"</pre>")
formulario.consultar asignaturas_disponibles_cons

'response.Write("<pre>"&asignaturas_disponibles_cons&"</pre>")
'response.End()
filas_asig = formulario.nrofilas

set datos_elec		=	new cFormulario
datos_elec.inicializar	conectar
datos_elec.carga_parametros	"paulo.xml","tabla"

for i_=0 to filas_asig-1
	formulario.siguiente
	v_asig_ccod =formulario.obtenervalor("asig_ccod")
	sql_electivos = " select b.asig_ccod " & _
					" from electivos a,secciones b "& _
					" where a.secc_ccod = b.secc_ccod  " & _
					" and cast(a.asig_ccod as varchar) ='"&v_asig_ccod&"' "  & _
					" and cast(peri_ccod as varchar) ='"&peri_ccod&"'"
	datos_elec.consultar sql_electivos
	for j_=0 to datos_elec.nrofilas	-1
		datos_elec.siguiente
		asig_ccod_elec=datos_elec.obtenervalor("asig_ccod")
		if asig_ccod_elec<>"" then
			if arr_asignatura_elec <>"" then
				arr_asignatura_elec =arr_asignatura_elec &",'"&asig_ccod_elec&"'" 
			else
				arr_asignatura_elec= "'"&asig_ccod_elec&"'"
			end if	
		end if
	next			
	if arr_asignatura <>"" then
		arr_asignatura =  arr_asignatura &",'"&v_asig_ccod&"'" 
	else
		arr_asignatura ="'"&v_asig_ccod&"'" 
	end if	
next
if arr_asignatura_elec<>"" then
arr_asignatura=arr_asignatura&","&arr_asignatura_elec
end if
'RESPONSE.Write(arr_asignatura&"<br>")
'RESPONSE.Write(arr_asignatura_elec&"<br>")
'RESPONSE.End()
formulario.primero

'destino =" (SELECT a.carr_ccod,a.asig_ccod, a.secc_tdesc, a.secc_ccod,  " & vbCrLf &  _
'"	  case a.carr_ccod when '"&v_carr_ccod&"'  " & vbCrLf & _
'"	  then '(*)' + cast(a.asig_ccod as varchar)+ '-' + cast(a.secc_tdesc as varchar)+  ' -> ' + cast(protic.horario(a.secc_ccod) as varchar)  " & vbCrLf & _
'"	  else cast(a.asig_ccod as varchar)+ '-' + cast(a.secc_tdesc as varchar) + ' -> ' + cast(protic.horario(a.secc_ccod) as varchar) " & vbCrLf & _
'"	  end horario--, a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0)  " & vbCrLf & _
'"	  FROM secciones a, cargas_academicas c  " & vbCrLf & _
'"	  WHERE a.secc_ccod *= c.secc_ccod   " & vbCrLf & _
'"	  AND cast(a.sede_ccod as varchar)='"&sede_ccod&"'  " & vbCrLf & _
'"	  and cast(a.peri_ccod as varchar)= '"&peri_ccod&"'  " & vbCrLf & _
'"	  and cast(a.asig_ccod as varchar) in ("&arr_asignatura&")  " & vbCrLf & _
'"	  and cast(a.carr_ccod as varchar) ='"&v_carr_ccod&"'  " & vbCrLf & _
'"	  GROUP BY a.asig_ccod, a.secc_ccod, a.secc_tdesc, a.secc_ncupo,carr_ccod " & vbCrLf & _
'"	  HAVING a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0) > 0) a  " & vbCrLf  

'--------------------------------------------------------------------------------------------INICIO CONSULTA SQLServer 2008
destino =" (                                                                         " & vbCrlf & _
"select a.carr_ccod,                                                                 " & vbCrlf & _
"       a.asig_ccod,                                                                 " & vbCrlf & _
"       a.secc_tdesc,                                                                " & vbCrlf & _
"       a.secc_ccod,                                                                 " & vbCrlf & _
"       case a.carr_ccod                                                             " & vbCrlf & _
"         when '"&v_carr_ccod&"' then '(*)' + cast(a.asig_ccod as varchar) + '-'     " & vbCrlf & _
"                                     + cast(a.secc_tdesc as varchar) + ' -> '       " & vbCrlf & _
"                                     + cast(protic.horario(a.secc_ccod) as varchar) " & vbCrlf & _
"         else cast(a.asig_ccod as varchar) + '-'                                    " & vbCrlf & _
"              + cast(a.secc_tdesc as varchar) + ' -> '                              " & vbCrlf & _
"              + cast(protic.horario(a.secc_ccod) as varchar)                        " & vbCrlf & _
"       end horario--, a.secc_ncupo - isnull(COUNT (distinct c.secc_ccod), 0)        " & vbCrlf & _
"from   secciones as a                                                               " & vbCrlf & _
"       left outer join cargas_academicas as c                                       " & vbCrlf & _
"                    on a.secc_ccod = c.secc_ccod                                    " & vbCrlf & _
"where  cast(a.sede_ccod as varchar) = '"&sede_ccod&"'                               " & vbCrlf & _
"       and cast(a.peri_ccod as varchar) = '"&peri_ccod&"'                           " & vbCrlf & _
"       and cast(a.asig_ccod as varchar) in ( "&arr_asignatura&" )                   " & vbCrlf & _
"       and cast(a.carr_ccod as varchar) = '"&v_carr_ccod&"'                         " & vbCrlf & _
"group  by a.asig_ccod,                                                              " & vbCrlf & _
"          a.secc_ccod,                                                              " & vbCrlf & _
"          a.secc_tdesc,                                                             " & vbCrlf & _
"          a.secc_ncupo,                                                             " & vbCrlf & _
"          carr_ccod                                                                 " & vbCrlf & _
"having a.secc_ncupo - isnull(count (distinct c.secc_ccod), 0) > 0                   " & vbCrlf & _
" ) as a                                                                             " & vbCrLf 
'--------------------------------------------------------------------------------------------FIN CONSULTA SQLServer 2008

'response.Write("<pre>"&destino&"</pre>")
'response.End()


filtro = "    asig_ccod in (select '%asig_ccod%' as asig_ccod ) " & vbCrLf  & _
"	 or	asig_ccod in ( select b.asig_ccod from electivos a,secciones b  " & vbCrLf  & _
" 	   			 	 where a.secc_ccod = b.secc_ccod  " & vbCrLf  & _
" 	   			 	 and  cast(b.carr_ccod as varchar) ='"&v_carr_ccod&"'  " & vbCrLf  & _
"				     and a.asig_ccod ='%asig_ccod%'  )" 
'response.Write("<pre>"&filtro&"</pre>")

formulario.agregaCampoParam "secc_ccod", "filtro", filtro
formulario.agregaCampoParam "secc_ccod", "destino", destino

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
			"	 and cast(matr_ncorr as varchar)='"&matr_ncorr&"'"& vbCrLf & _
			"	 and cast(sede_ccod as varchar)='"&sede_ccod&"'"& vbCrLf & _
			"	 and cast(b.peri_ccod as varchar)='"&peri_ccod&"'"& vbCrLf & _
			" "
consulta="select count(*) from ("&cons_resumen&")a"		
'response.Write("<pre>"&consulta&"</pre>")		
'response.End()
registros=conectar.consultauno(consulta)
	
tresumen.consultar cons_resumen


'Secciones =	" SELECT isnull(C.ASIG_CCOD,A.ASIG_CCOD) asig_ccod, b.secc_ccod,case a.carr_ccod when '"&v_carr_ccod&"' then " & _
'	 	   	"	 	  '(*)'+cast(a.asig_ccod as varchar) + '-' + cast(a.secc_tdesc as varchar) + ' -> ' + cast(protic.horario(a.secc_ccod) as varchar)" & _
'		   	" else  " & _
'		   	" 	   cast(a.asig_ccod as varchar)+ '-' + cast(a.secc_tdesc as varchar)+ ' -> ' +cast(protic.horario(a.secc_ccod) as varchar)  " & _
'		 	" end    horario " & _
'			" FROM secciones  a, cargas_academicas b, ELECTIVOS C " & _
'			" WHERE cast(b.MATR_NCORR as varchar) = '"&matr_ncorr&"' " & _
'			"  AND B.SECC_CCOD *= C.SECC_CCOD" & _
'			" and a.secc_ccod = b.secc_ccod " 

'--------------------------------------------------------------------------------------------INICIO CONSULTA SQLServer 2008
Secciones =	" select isnull(c.asig_ccod, a.asig_ccod) asig_ccod,                     "& _
"       b.secc_ccod,                                                                 "& _
"       case a.carr_ccod                                                             "& _
"         when '"&v_carr_ccod&"' then '(*)' + cast(a.asig_ccod as varchar) + '-'     "& _
"                                     + cast(a.secc_tdesc as varchar) + ' -> '       "& _
"                                     + cast(protic.horario(a.secc_ccod) as varchar) "& _
"         else cast(a.asig_ccod as varchar) + '-'                                    "& _
"              + cast(a.secc_tdesc as varchar) + ' -> '                              "& _
"              + cast(protic.horario(a.secc_ccod) as varchar)                        "& _
"       end                              horario                                     "& _
"from   secciones as a                                                               "& _
"       inner join cargas_academicas as b                                            "& _
"               on a.secc_ccod = b.secc_ccod                                         "& _
"                  and cast(b.matr_ncorr as varchar) = '"&matr_ncorr&"'              "& _
"       left outer join electivos as c                                               "& _
"                    on b.secc_ccod = c.secc_ccod                                    "
'--------------------------------------------------------------------------------------------FIN CONSULTA SQLServer 2008

conectar.Ejecuta Secciones
set rec_secciones = conectar.ObtenerRS
'response.Write("<pre>"&Secciones&"</pre>")
'------------------------consulta para mostrar los optativos deportivos que tiene en la carga el alumno-----------------------------------
'--------------------------------------agregada el 14 de julio de 2005 por Marcelo Sandoval-----------------------------------------------
cons_optativo=" select '"&matr_ncorr&"' as matr_ncorr,a.secc_ccod, c.asig_ccod + ' --> ' + c.asig_tdesc as asignatura, "& vbCrLf & _
			 " 'Secc. ' + cast(b.secc_tdesc as varchar)+' -> '+ cast(protic.horario(b.secc_ccod) as varchar) as horario,'N' as afecta "& vbCrLf & _
			 " from cargas_academicas a, secciones b, asignaturas c "& vbCrLf & _
		     " where a.secc_ccod = b.secc_ccod "& vbCrLf & _
		     " and b.asig_ccod = c.asig_ccod "& vbCrLf & _
			 " and cast(a.matr_ncorr as varchar)= '"&matr_ncorr&"' "& vbCrLf & _
			 " and cast(b.peri_ccod as varchar)= '"&peri_ccod&"' "& vbCrLf & _
			 " and b.carr_ccod='820' "
			

optativos_deportivos.consultar cons_optativo

'------------debemos ver que usuario inicio sessión y si es el profesor de los optativos deshabilitar las otras opciones.....
'conectar.estadoTransaccion false
'response.Write("sys_cierra_toma_carga "&sys_cierra_toma_carga&" autorizado "&autorizado)
'response.Write(conectar.obtenerEstadoTransaccion)

usuario_paso=negocio.obtenerUsuario
autorizado = conectar.consultaUno("select isnull(count(*),0) from personas a, sis_roles_usuarios b where a.pers_ncorr=b.pers_ncorr and b.srol_ncorr=79 and cast(a.pers_nrut as varchar)='"&usuario_paso&"'")

'------------------------------------------------------------------------------------------------------
'-------------------------para anularle el derecho de ingreso a los directores de carrera--------------
usuario_temporal = negocio.obtenerUsuario
pers_ncorr_usuario = conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario_temporal&"'")
autorizado_carga = conectar.consultaUno("Select isnull(count(*),0) from sis_roles_usuarios where srol_ncorr=2 and cast(pers_ncorr as varchar)='"&pers_ncorr_usuario&"'")
'response.Write("Select isnull(count(*),0) from sis_roles_usuarios where srol_ncorr=2 and cast(pers_ncorr as varchar)='"&pers_ncorr_usuario&"'")

'response.Write("sys_cierra_toma_carga "&sys_cierra_toma_carga&" autorizado "&autorizado_carga)
'-----------------------------------------------FIN---------------------------------------------------- 

'response.Write("carrera "&v_carr_ccod)
consulta_habilitar = " Select isnull(count(*),0) from alumnos a, ofertas_Academicas b, especialidades d"&_
                     " where a.ofer_ncorr=b.ofer_ncorr and b.espe_ccod=d.espe_ccod"&_
					 " and cast(a.matr_ncorr as varchar)='"&matr_ncorr&"' and d.carr_ccod in ('45')"&_
					 " and case when convert(varchar,getDate(),103) >= convert(datetime,'13-12-2005',103) and convert(varchar,getDate(),103) <= convert(datetime,'16-12-2005',103) then '1' else '0' end = 1 "

'response.Write(consulta_habilitar)
'response.Write("habilitar "& conectar.consultaUno(consulta_habilitar))
if conectar.consultaUno(consulta_habilitar) > "0" then
	'response.Write("Es carrera")
		' habilitamos a las personas de comunicación multimedia y de periodismo pa que modifiquen la carga académica.
		'response.Write("estoy en la fecha")
		autorizado = "0"
		autorizado_carga = "1"
		sys_cierra_toma_carga = false
	    habilita_toma_carga = true
end if


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
rec_secciones = new Array();
<%

if (rec_secciones.BOF <> rec_secciones.EOF) then
rec_secciones.MoveFirst
j = 0
while not rec_secciones.Eof
%>
rec_secciones[<%=j%>] = new Array();
rec_secciones[<%=j%>]["asig_ccod"] = '<%=rec_secciones("asig_ccod")%>';
rec_secciones[<%=j%>]["secc_ccod"] = '<%=rec_secciones("secc_ccod")%>';
rec_secciones[<%=j%>]["horario"] = '<%=rec_secciones("horario")%>';
<%	
	rec_secciones.MoveNext
	j = j + 1
wend
end if
%>

function dibujar(formulario){
	formulario.submit();
}

function ver_notas()
{
//alert("muestra historico de notas");
self.open('<%=url%>','notas','width=700px, height=550px, scrollbars=yes, resizable=yes')
}

function horario(){
	self.open('horario.asp?matr_ncorr=<%=matr_ncorr%>','horario','width=700px, height=550px, scrollbars=yes, resizable=yes')
}


function iniciopagina(formulario){
j_ = 0
nro_filas=<%=filas_asig%>

	if (nro_filas>0) {
			for (i = 0; i < rec_secciones.length; i++) {
				for (j=0; j< nro_filas;j++){
					if(rec_secciones[i]["asig_ccod"] == formulario.elements["toma_carga["+j+"][asig_ccod]"].value){
					   	alert(formulario.elements["toma_carga["+j+"][asig_ccod]"].value)
						formulario.elements["toma_carga["+j+"][secc_ccod]"].value =rec_secciones[i]["secc_ccod"]
					}
				}
			}
	}
}


function enviar(formulario){ 

    formulario.dv.value =formulario.dv.value.toUpperCase();
  	if(preValidaFormulario(formulario)){
	   if(!(valida_rut(formulario.rut.value + '-' + formulario.dv.value))){
	      alert('El RUT que Ud. ha ingresado no es válido.Por favor, ingréselo nuevamente.');
	      formulario.rut.focus();
	      formulario.rut.select();
	   }
       else{
	  	
	      formulario.submit();
	   }
	}   
 }
 
function guardar(formulario){
formulario.method="post"
formulario.action="toma_carga_proc.asp"
formulario.submit();
}
function abrir2(){
		var matricula 	= '<%=matr_ncorr%>';
		var pers 		= '<%=pers_ncorr%>';
		var sede		= '<%=sede_ccod%>';
		var plan		= '<%=plan_ccod%>';
		var periodo     = '<%=peri_ccod%>';
		
		direccion = "busca_secciones.asp?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo;
		resultado=window.open(direccion, "ventana1","scrollbars=yes,resizable,width=750,height=400");
}
function abrir(){
		var matricula 	= '<%=matr_ncorr%>';
		var pers 		= '<%=pers_ncorr%>';
		var sede		= '<%=sede_ccod%>';
		var plan		= '<%=plan_ccod%>';
		var periodo     = '<%=peri_ccod%>';
		
		direccion = "busca_secciones_forzadas.asp?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo;
		resultado=window.open(direccion, "ventana1","scrollbars=yes,resizable,width=750,height=400");
}
function abrir_optativo(){
		var matricula 	= '<%=matr_ncorr%>';
		var pers 		= '<%=pers_ncorr%>';
		var sede		= '<%=sede_ccod%>';
		var plan		= '<%=plan_ccod%>';
		var periodo     = '<%=peri_ccod%>';
		
		direccion = "busca_optativo_deportivo.asp?matr_ncorr="+matricula+"&pers_ncorr="+pers+"&sede_ccod="+sede+"&plan_ccod="+plan+"&peri_ccod="+periodo;
		resultado=window.open(direccion, "ventana1","scrollbars=yes,resizable,width=710,height=280");
}
function eliminar (formulario){
	if (verifica_check(formulario)){
		formulario.method="post"
		formulario.action="eliminar_equivalencias.asp";
		formulario.submit();
	}
	else{
		alert('No ha seleccionado ninguna equivalencia.');
	}
}
function eliminar_optativo (formulario){
   		if (verifica_check(formulario))
			{
				if (confirm("¿Está seguro que desea eliminar el optativo deportivo de la carga del alumno?"))
				{
					formulario.method="post"
					formulario.action="eliminar_optativo.asp";
					formulario.submit();
				}
			}
			else{
				alert('No ha seleccionado ninguna asignatura optativa a eliminar.');
			}
}
function verifica_check(formulario) {
	num=formulario.elements.length;
	c=0;
	for (i=0;i<num;i++){
		nombre = formulario.elements[i].name;
		var elem = new RegExp ("secc_ccod","gi");
		if (elem.test(nombre)){
			if((formulario.elements[i].checked==true)){
				c=c+1;
			}
		}
	}
	if (c>0) {
		return (true);
	}
	else {
		return (false);
	}
}

</script>
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
<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="iniciopagina(document.edicion);MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif')" onBlur="revisaVentana();">
<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td height="62" valign="top"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
  </tr>
  <%pagina.DibujarEncabezado()%>  
  <tr>
    <td valign="top" bgcolor="#EAEAEA">
	<br>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif"></td>
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><form name="buscador">
              <br>
              <table width="98%"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                      <tr> 
                        <td nowrap> <div align="center"></div></td>
                        <td> <div align="center">I<font size="1" face="Verdana, Arial, Helvetica, sans-serif">ngrese 
                            el RUT del alumno : 
                            <input name="rut" type="text" ID="NU-N" value="<%=pers_nrut%>" size="10" maxlength="8">
                            - 
                            <input name="dv" type="text" ID="LN-N" value="<%=pers_xdv%>" size="2" maxlength="1" >
                            <%pagina.DibujarBuscaPersonas "rut", "dv"%><br>
                            </font></div></td></tr>
      </table></div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton "buscar"%></div></td>
                </tr>
              </table>
            </form></td>
          </tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif"></td>
      </tr>
      <tr>
        <td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
        <td height="13" background="../imagenes/base2.gif"></td>
        <td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
      </tr>
    </table>
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
            <td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
          </tr>
          <tr>
            <td height="2" background="../imagenes/top_r3_c2.gif"></td>
          </tr>
          <tr>
            <td><div align="center"><br>
                    <% pagina.Titulo = pagina.Titulo & "<br>" & peri_tdesc
					  pagina.DibujarTituloPagina%>
                    <br>
                </div><%
if nombre <> "" then
%>
            <form name="temporal" action="toma_carga.asp">
			<input name="rut" type="hidden" ID="NU-N" value="<%=pers_nrut%>" size="10" maxlength="8">
            <input name="dv" type="hidden" ID="LN-N" value="<%=pers_xdv%>" size="2" maxlength="1" >
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="80">RUT</td>
                <td width="443">: <%= pers_nrut %>-<%= pers_xdv %></td>
				<td width="136" align="center"><% if autorizado= "0" then f_botonera.DibujaBoton "NOTAS" end if%></td>
              </tr>
              <tr>
                <td>Nombre</td>
                <td colspan="2">: <%= nombre %></td>
              </tr>
              <tr>
                <td>Carrera</td>
                <td colspan="2">: <%if cantidad_carreras=1 then
					                        response.Write(carrera)
										   else
										    combo_carreras.dibujaCampo("matr_ncorr")
										  end if %>
			    </td>
              </tr>
			  <tr>
                <td> <font size="1"><strong>Periodo</strong></font></td>
                <td colspan="2"> <font size="1"><strong>: <%=peri_tdesc %></strong></font></td>
              </tr>
            </table>
			</form>
<%
end if
%>		
              
			  <%if nombre <> "" and not bloqueado then%>
			  <form name="edicion">
			  <input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
			  <%if autorizado = "0" then%>
					<table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
					  <tr>
						<td><%pagina.DibujarSubtitulo "Asignaturas Asignables"%>
						  <br>
						  (*) Secciones Planificadas Para la Carrera :  <%= carrera %> </td>
					  </tr>
					  <%if (autorizado_carga = 0 or sys_cierra_toma_carga = true) and v_plec_ccod <> "3" then %>
					  <tr>
						<td>&nbsp;</td>
					  </tr>
					  <tr>
						<td><font color="#0000FF" size="2">  - Proceso cerrado, cualquier cambio o modificación se debe solicitar a Departamento de Docencia</font></td>
					  </tr>
					  <tr>
						<td>&nbsp;</td>
					  </tr>
					  <%end if%>
					</table>
				<table width="100%" border="0">
					  <tr> 
						<td align="right"><strong><font color="000000" size="1"> 
						  <% formulario.pagina%>
						  &nbsp;&nbsp;&nbsp;&nbsp; 
						  <% formulario.accesoPagina%>
						  </font></strong></td>
					  </tr>
					  <tr> 
						 <td><strong><font color="000000" size="1"> 
						 <% formulario.dibujaTabla%>
						 </font></strong></td>
					  </tr>
					  <tr> 
						<td align="right">&nbsp;</td>
					  </tr>
					  <tr>
						<td align="right">
						<% if habilita_toma_carga = false then 
							   if filas_asig = 0 or (autorizado_carga =0 or sys_cierra_toma_carga = true) and v_plec_ccod <> "3" then
									  f_botonera.agregabotonparam "GUARDAR", "deshabilitado" ,"TRUE"
								end if
                           end if							
								  f_botonera.DibujaBoton "GUARDAR"%>
							</td>
					  </tr>
       			</table>
				<%end if%>
                <br>
				<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
                      <tr> 
                        <td colspan="3" align="center"><%pagina.DibujarSubtitulo "Equivalencias"%></td>
                      </tr>
                      <tr>
                        <td colspan="3" align="center">&nbsp;</td>
                      </tr>
                      <tr>
                        <td colspan="3" align="right"><strong>Páginas:</strong> <%tresumen.accesopagina%></td>
                      </tr>
                      <tr> 
                        <td colspan="3" align="center"> <%if matr_ncorr <> "" then 
						  tresumen.dibujatabla()
						  end if%>
						  <input type="hidden" name="registros" value="<%=registros%>"> </td>
                      </tr>
                      <tr>
                        <td colspan="3" align="center">&nbsp;</td>
                      </tr>
					  <%if autorizado= "0" then%>
                      <tr>
					    <td width="76%" align="center"><div align="right">
                          <%'f_botoneraEQ.DibujaBoton "FORZAR"%>
                        </div></td>
                        <td width="12%" align="center"><div align="center">
                          <% if habilita_toma_carga = false then 
									if v_plec_ccod <> "3" then
										 if autorizado_carga =0 or sys_cierra_toma_carga = true then
											f_botoneraEQ.AgregaBotonParam "AGREGAR","deshabilitado","TRUE"	
											f_botoneraEQ.AgregaBotonParam "ELIMINAR","deshabilitado","TRUE"	
										 end if
									 end if
							 end if		 
						     f_botoneraEQ.DibujaBoton "AGREGAR"%>
                        </div></td>
                        <td width="12%" align="center"><div align="left">
                            		 <% f_botoneraEQ.DibujaBoton "ELIMINAR"%>
                        </div></td>
                      </tr>
					  <%end if%>
                      <tr> 
                        <td colspan="3" align="center">&nbsp; </td>
                      </tr>
				</table>
				</form>
				<form name="edicion_optativo">
				<input type="hidden" name="matr_ncorr" value="<%=matr_ncorr%>">
				<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">	  
					  <tr> 
                        <td colspan="3" align="center"><%pagina.DibujarSubtitulo "Optativos deportivos complementarios"%></td>
                      </tr>
                      <tr>
                        <td colspan="3" align="center">&nbsp;</td>
                      </tr>
					  <tr>
                        <td colspan="3" align="right"><strong>Páginas:</strong> <%optativos_deportivos.accesopagina%></td>
                      </tr>
                      <tr> 
                        <td colspan="3" align="center"> 
						  <%if matr_ncorr <> "" then 
						  optativos_deportivos.dibujatabla()
						  end if%>
						 </td>
                      </tr>
                      <tr>
                        <td colspan="3" align="center">&nbsp;</td>
                      </tr>
                      <tr>
					    <td width="76%" align="center"><div align="right">&nbsp;</div></td>
                        <td width="12%" align="center"><div align="center">
                          <% if autorizado_carga=0 or sys_cierra_toma_carga = true then
						  		f_botonera_optativo.AgregaBotonParam "AGREGAR","deshabilitado","TRUE"	
						  	 end if
						    f_botonera_optativo.DibujaBoton "AGREGAR"%>
                        </div></td>
                        <td width="12%" align="center"><div align="left">
                            <%if autorizado_carga =0 or sys_cierra_toma_carga = true then
						  		f_botonera_optativo.AgregaBotonParam "ELIMINAR","deshabilitado","TRUE"	
						  	  end if
							  f_botonera_optativo.DibujaBoton "ELIMINAR"%>
                        </div></td>
                      </tr>
                      <tr> 
                        <td colspan="3" align="center">&nbsp; </td>
                      </tr>
                    </table></form>
				<%end if%>
            </td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="38%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center"><%f_botonera.DibujaBoton "HORARIO"%>
                  </div></td>
                  <td><div align="center">
                    <%f_botonera.DibujaBoton "SALIR"%>
                  </div></td>
                  <td><div align="center"></div></td>
                </tr>
              </table>
            </div></td>
            <td width="62%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
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
