<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

set conexion = new CConexion
conexion.Inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conexion

'------------------------------------------------------------------------------------------------
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
v_fecha = conexion.consultaUno("select protic.trunc(getdate()) as fecha")

v_usuario = Request.Form("usuario")
v_clave = Request.Form("clave")


sql_usuario_valido =" select count(*) " & vbCrLf &_
	    	 	    " from usuarios " & vbCrLf &_
			        " where usua_tusuario = '" & v_usuario & "' " & vbCrLf &_
    			    " and upper(usua_tclave) = '" & UCase(v_clave) & "'"
					
usuario_valido = conexion.consultauno(sql_usuario_valido)

v_act_antecedentes = Request.Form("act_antecedentes")
Session("ses_act_ancedentes") = ""

if v_act_antecedentes = "S" then
	b_act_antecedentes = true
else
	b_act_antecedentes = false
end if
'response.Write(b_act_antecedentes&"<br>")
'response.Write("v_usuario : "&v_usuario&"<br>")
'response.Write("v_clave : "&v_clave&"<br>")
'response.End()

v_tpos_ccod = "2" ' DOBLE
v_epos_ccod = "1" ' En Proceso

if usuario_valido=0 and not b_act_antecedentes then
	session("mensajeError") = "Usuario no está registrado."
	'Response.Redirect("inicio.asp")
	Response.Redirect("actualizacion_antecedentes_diplo.asp")
end if



'------------------------------------------------------------------------------------------------
'if not b_act_antecedentes then

	consulta = "select pers_ncorr " & vbCrLf &_
			   "from usuarios " & vbCrLf &_
			   "where usua_tusuario = '" & v_usuario & "' " & vbCrLf &_
    			   "  and upper(usua_tclave) = '" & UCase(v_clave) & "'"

	v_pers_ncorr = conexion.ConsultaUno(consulta)
'--------------------------------buscar el pers_ncorr en el caso que sea actualizacion de datos----------------------
'--------------------------------------------------actualizado 15-11-2004---------------by Marcelo Sandoval----------
if b_act_antecedentes and EsVacio(v_pers_ncorr) then
v_pers_ncorr=request.Form("persona[0][pers_ncorr]")
end if
'----------------------------------------------Fin de la actualización------------------------------------------------
	
'else
' para la Autonoma
'	v_pers_ncorr = Request.Form("persona[0][pers_ncorr]")	
'	v_pers_nrut = conexion.ConsultaUno("select pers_nrut from personas where pers_ncorr = " & v_pers_ncorr & "")
'	if EsVacio(v_pers_nrut) then
'		v_pers_nrut = conexion.ConsultaUno("select pers_nrut from personas_postulante where pers_ncorr = " & v_pers_ncorr & "")
'	end if
'	
'	sentencia = "exec traspasa_persona_pp(" & v_pers_nrut & ")"
'	response.Write(sentencia)
'	response.End()
'	conexion.EstadoTransaccion conexion.EjecutaP(sentencia)

'end if

'---------IMPEDIR QUE ENTREN ALUMNOS ANTIGUOS -----------------

sql_nuevo_f  = "select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") "
v_post_bnuevo_institucion = conexion.ConsultaUno(sql_nuevo_f)

'if v_post_bnuevo_institucion = "N" then
if false then
	conexion.EstadoTransaccion false
	conexion.MensajeError "Se ha detectado que eres alumno antiguo.\n\nTu período de matrícula todavía no comienza."
	Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
end if

'--------------------------------------------------------------------------------------------------------------------
'************************* AHORA SE PUEDE MATRICULAR A MAS DE UNA CARRERA *******************************************
'consulta = "select count(*) as cuenta " & vbCrLf &_
 '          "from postulantes a, alumnos b, periodos_academicos c, " & vbCrLf &_
	'	   "     periodos_academicos d  " & vbCrLf &_
	'	   "where a.post_ncorr = b.post_ncorr " & vbCrLf &_
	'	   "  and a.peri_ccod = c.peri_ccod " & vbCrLf &_
	'	   "  and c.anos_ccod = d.anos_ccod " & vbCrLf &_
	'	   "  and b.emat_ccod <> 9 " & vbCrLf &_
	'	   "  and c.plec_ccod = 1 " & vbCrLf &_
	'	   "  and d.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
	'	   "  and a.pers_ncorr = '" & v_pers_ncorr & "'"

'v_cuenta = CInt(conexion.ConsultaUno(consulta))
'if v_cuenta > 0 then
'	conexion.EstadoTransaccion false
'	conexion.MensajeError "Se ha detectado que el alumno ya se matriculó en el primer semestre."
'	Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
'end if
'--------------------------------------------------------------------------------------------------------------------


if EsVacio(v_pers_ncorr) then	
	Session("mensajeError") = "El USUARIO y la CLAVE ingresada no coinciden."
	str_url = "inicio.asp"
else
	Session("pers_ncorr") = v_pers_ncorr
	
v_post_bnuevo = conexion.ConsultaUno("select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") ")
if	v_post_bnuevo = "S" then
	v_post_bnuevo = "S"
else
	v_post_bnuevo = "N"
end if
	
	set fc_postulacion = new CFormulario
	fc_postulacion.Carga_Parametros "consulta.xml", "consulta"
	fc_postulacion.Inicializar conexion
	
if	v_post_bnuevo = "S" then	
	'------ VALIDACION NECESARIA PARA VERIFICAR EXISTENCIA POSTULACION NORMAL para alumnos nuevos
	consulta = " select count(*) as contador " & vbCrLf &_
	           " from postulantes " & vbCrLf &_
			   " where pers_ncorr = '" & v_pers_ncorr & "' " & vbCrLf &_
			   "  and peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
			   "  and tpos_ccod = 1 " & vbCrLf &_
               "  and epos_ccod = 2 " 
	'---------VALIDACION para verificar que el contrato fue creado y esta activo(alumno matriculado)para alumnos nuevos
	consulta2 = "select count(*) as contador from postulantes a,contratos b,alumnos c " & vbCrLf &_
			   " where a.pers_ncorr = '" & v_pers_ncorr & "' " & vbCrLf &_
			   "  and a.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
			   "  and a.tpos_ccod = 1 " & vbCrLf &_
               "  and a.epos_ccod = 2   " & vbCrLf &_
               "  and c.post_ncorr = a.post_ncorr " & vbCrLf &_
               "  and a.post_ncorr = b.post_ncorr " & vbCrLf &_
               "  and b.econ_ccod = 1 "			   
	verif_otra_matri = conexion.ConsultaUno(consulta2)	   		   
	verif_otra_post = conexion.ConsultaUno(consulta)	   
	if 	EsVacio(verif_otra_post) then
		verif_otra_post = 0
	end if			   
	if 	EsVacio(verif_otra_matri) then
		verif_otra_matri = 0
	end if			   
	if	verif_otra_post = 0 then
		Session("mensajeError") = "Esta función es para postular a una segunda o más carreras.\n Favor postular por la función indicada para ello."
		'Response.Redirect("inicio_diplo.asp")
		Response.Redirect("actualizacion_antecedentes_diplo.asp")
	end if		   
	if	verif_otra_matri = 0 then
		Session("mensajeError") = "Esta función es para postular a una segunda o más carreras.\n Además debe estar matrículado."
		'Response.Redirect("inicio_diplo.asp")
		Response.Redirect("actualizacion_antecedentes_diplo.asp")
	end if
end if			   
	'-----------------------------------------------------------------------------
	consulta = " select post_ncorr, ofer_ncorr, epos_ccod, tpos_ccod " & vbCrLf &_
	           " from postulantes " & vbCrLf &_
			   " where pers_ncorr = '" & v_pers_ncorr & "' " & vbCrLf &_
			   "  and peri_ccod = '" & v_peri_ccod & "' "& vbCrLf &_
			   "  and tpos_ccod = 2 order by post_ncorr desc" ' para indentificar la doble postulacion
			   
	fc_postulacion.Consultar consulta

v_post_bnuevo = "S"		' aqui todos los postulantes seran considerados como NUEVOS
	if fc_postulacion.NroFilas = 0 then    'No tiene postulacion para este periodo
		set f_postulacion = new CFormulario
		f_postulacion.Carga_Parametros "matricula-inicio.xml", "postulacion"
		f_postulacion.Inicializar conexion		
		f_postulacion.CreaFilaPost		

		'----------------------------------------------------------------------------------
		v_post_ncorr = conexion.ConsultaUno("exec ObtenerSecuencia 'postulantes'")
		'v_post_bnuevo_institucion = conexion.ConsultaUno("select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") ")
		
		'if v_post_bnuevo_institucion = "S" then
			v_post_bnuevo = "S"
		'else
			'--------------------------------------------------------------
			'v_post_bnuevo = "N"
			'set fc_matricula_anterior = new CFormulario
			'fc_matricula_anterior.Carga_Parametros "consulta.xml", "consulta"
			'fc_matricula_anterior.Inicializar conexion
			
			'consulta = "select b.sede_ccod, b.espe_ccod, c.carr_ccod, b.jorn_ccod " & vbCrLf &_
			 '          "from alumnos a, ofertas_academicas b, especialidades c " & vbCrLf &_
				'	   "where a.ofer_ncorr = b.ofer_ncorr " & vbCrLf &_
				'	   "  and b.espe_ccod = c.espe_ccod " & vbCrLf &_
				'	   "  and a.emat_ccod = 1 " & vbCrLf &_
				'	   "  and b.peri_ccod < '" & v_peri_ccod & "' "	& vbCrLf &_
				'	   "  and a.pers_ncorr = '" & v_pers_ncorr & "' " & vbCrLf &_					   
				'	   "order by b.peri_ccod desc, a.alum_fmatricula desc"
					   
			'fc_matricula_anterior.Consultar consulta
			'fc_matricula_anterior.Siguiente
			
			'-------------------------------------------------------------------------------------------------------------						
			'Buscar la oferta anterior equivalente a este periodo, considerando carrera, especialidad, sede y jornada
			'consulta = "select a.ofer_ncorr " & vbCrLf &_
			 '          "from ofertas_academicas a, especialidades b, aranceles c " & vbCrLf &_
				'	   "where a.espe_ccod = b.espe_ccod " & vbCrLf &_
				'	   "  and a.aran_ncorr = c.aran_ncorr " & vbCrLf &_
				'	   "  and a.post_bnuevo = 'N' " & vbCrLf &_
				'	   "  and c.aran_nano_ingreso = protic.ano_ingreso_carrera('" & v_pers_ncorr & "', b.carr_ccod) " & vbCrLf &_
				'	   "  and a.sede_ccod = '" & fc_matricula_anterior.ObtenerValor("sede_ccod") & "' " & vbCrLf &_
				'	   "  and a.espe_ccod = '" & fc_matricula_anterior.ObtenerValor("espe_ccod") & "' " & vbCrLf &_
				'	   "  and b.carr_ccod = '" & fc_matricula_anterior.ObtenerValor("carr_ccod") & "' " & vbCrLf &_
				'	   "  and a.jorn_ccod = '" & fc_matricula_anterior.ObtenerValor("jorn_ccod") & "' " & vbCrLf &_
				'	   "  and a.peri_ccod = '" & v_peri_ccod & "'"					   
			
			'v_ofer_ncorr = conexion.ConsultaUno(consulta)
	
			'if EsVacio(v_ofer_ncorr) then			
				'Buscar la oferta anterior equivalente a este periodo, no considerando jornada
				'consulta = "select a.ofer_ncorr " & vbCrLf &_
				'		   "from ofertas_academicas a, especialidades b, aranceles c " & vbCrLf &_
				'		   "where a.espe_ccod = b.espe_ccod " & vbCrLf &_
				'		   "  and a.aran_ncorr = c.aran_ncorr " & vbCrLf &_
				'		   "  and a.post_bnuevo = 'N' " & vbCrLf &_
				'		   "  and c.aran_nano_ingreso = protic.ano_ingreso_carrera('" & v_pers_ncorr & "', b.carr_ccod) " & vbCrLf &_
				'		   "  and a.sede_ccod = '" & fc_matricula_anterior.ObtenerValor("sede_ccod") & "' " & vbCrLf &_
				'		   "  and b.carr_ccod = '" & fc_matricula_anterior.ObtenerValor("carr_ccod") & "' " & vbCrLf &_
				'		   "  and a.espe_ccod = '" & fc_matricula_anterior.ObtenerValor("espe_ccod") & "' " & vbCrLf &_
				'		   "  and a.peri_ccod = '" & v_peri_ccod & "'"
						   
				'v_ofer_ncorr = conexion.ConsultaUno(consulta)				
				'if EsVacio(v_ofer_ncorr) then
					'Buscar la oferta anterior equivalente a este periodo, considerando solo carrera y sede
					'consulta = "select a.ofer_ncorr " & vbCrLf &_
					'		   "from ofertas_academicas a, especialidades b, aranceles c " & vbCrLf &_
					'		   "where a.espe_ccod = b.espe_ccod " & vbCrLf &_
					'		   "  and a.aran_ncorr = c.aran_ncorr " & vbCrLf &_
					'		   "  and a.post_bnuevo = 'N' " & vbCrLf &_
					'		   "  and c.aran_nano_ingreso = protic.ano_ingreso_carrera('" & v_pers_ncorr & "', b.carr_ccod) " & vbCrLf &_
					'		   "  and a.sede_ccod = '" & fc_matricula_anterior.ObtenerValor("sede_ccod") & "' " & vbCrLf &_
					'		   "  and b.carr_ccod = '" & fc_matricula_anterior.ObtenerValor("carr_ccod") & "' " & vbCrLf &_
					'		   "  and a.peri_ccod = '" & v_peri_ccod & "'"
	   
					'v_ofer_ncorr = conexion.ConsultaUno(consulta)				
					'if EsVacio(v_ofer_ncorr) then
					'	v_ofer_ncorr = ""
					'	v_post_bnuevo = "S"					
					'end if
					
				'end if	
			'end if				   
		'end if
		
		'----------------------------------------------------------------------------------
		sql_post_ncorrelativo = "Select isnull(max(post_ncorrelativo),0) from postulantes " & vbCrLf &_
			   "  where pers_ncorr = '" & v_pers_ncorr & "' " & vbCrLf &_
			   "  and peri_ccod = '" & v_peri_ccod & "' "& vbCrLf &_
			   "  and tpos_ccod = 2"
		post_ncorrelativo = conexion.ConsultaUno(sql_post_ncorrelativo)	   
		if 	EsVacio(post_ncorrelativo) then
			post_ncorrelativo = 0
		end if
		v_post_ncorrelativo = cint(post_ncorrelativo) + 1 ' necesario para indicar el numero de postulaciones
														  ' para segundas carreras o licenciaturas diplomados 		
		f_postulacion.AgregaCampoPost "post_ncorr", v_post_ncorr
		f_postulacion.AgregaCampoPost "pers_ncorr", v_pers_ncorr
		f_postulacion.AgregaCampoPost "peri_ccod", v_peri_ccod
		f_postulacion.AgregaCampoPost "tpos_ccod", v_tpos_ccod
		f_postulacion.AgregaCampoPost "epos_ccod", v_epos_ccod
		f_postulacion.AgregaCampoPost "post_ncorrelativo", v_post_ncorrelativo
		f_postulacion.AgregaCampoPost "eepo_ccod", 5
		
		f_postulacion.AgregaCampoPost "ofer_ncorr", v_ofer_ncorr
		f_postulacion.AgregaCampoPost "post_bnuevo", v_post_bnuevo
		f_postulacion.AgregaCampoPost "post_fpostulacion", v_fecha
		
		
		f_postulacion.MantieneTablas false

		'str_url = "principal.asp"
		Session("post_ncorr") = v_post_ncorr
		Session("solo_postgrado") = 1
		str_url = "postulacion_diplo_1.asp"
		
	else ' Ya tiene postulaciones
		fc_postulacion.Siguiente
		'str_url = "crear_o_ver_postulaciones_doble.asp"
		'--------- C O M E N T A R ----------------
		if fc_postulacion.ObtenerValor("tpos_ccod") = "2" then' postulacion doble					
			'if fc_postulacion.ObtenerValor("epos_ccod") = "2" then
			if 	fc_postulacion.ObtenerValor("epos_ccod") = "2" then 'and not b_act_antecedentes then
				Session("post_ncorr") = fc_postulacion.ObtenerValor("post_ncorr")
				str_url = "pre2_postulacion_diplo_1.asp"
			else
				'str_url = "principal.asp"
				Session("post_ncorr") = fc_postulacion.ObtenerValor("post_ncorr")
				str_url = "postulacion_diplo_1.asp"
			end if
		else
			Session("mensajeError") = "Tu tipo de postulación no te permite entrar a este sistema."
			'str_url = "inicio_diplo.asp"			
			str_url ="actualizacion_antecedentes_diplo.asp"
		end if
	end if
end if
'response.Write(str_url&" postulante nuevo ?->"&v_post_bnuevo)
'conexion.estadotransaccion false
if v_post_bnuevo = "N" and str_url<>"post_cerrada.asp" then
	str_url = "postulacion_antiguo.asp"
end if 
'---------------------------------------------------------------------------------------------------------------------
Response.Redirect(str_url)
%>