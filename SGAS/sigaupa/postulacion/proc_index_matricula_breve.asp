<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

set conexion = new CConexion
conexion.Inicializar "upacifico"
 

set negocio = new CNegocio
negocio.InicializaPortal conexion

'------------------------------------------------------------------------------------------------
v_peri_ccod = session("periodo_postulacion") 'negocio.ObtenerPeriodoAcademico("POSTULACION")
v_fecha = conexion.consultaUno("select protic.trunc(getdate()) as fecha")
'response.Write(v_peri_ccod)
'response.End()
v_usuario = Request.Form("usuario")
v_clave = Request.Form("clave")



sql_usuario_valido =" select count(*) " & vbCrLf &_
	    	 	    " from usuarios " & vbCrLf &_
			        " where usua_tusuario = '" & v_usuario & "' " 


					
usuario_valido = conexion.consultauno(sql_usuario_valido)



v_act_antecedentes = Request.Form("act_antecedentes")
Session("ses_act_ancedentes") = v_act_antecedentes

if v_act_antecedentes = "S" then
	b_act_antecedentes = true
else
	b_act_antecedentes = false
end if


v_tpos_ccod = "1" ' Normal 
v_epos_ccod = "1" ' En Proceso

if usuario_valido=0 and not b_act_antecedentes then
	session("mensajeError") = "Usuario no está registrado."
	Response.Redirect("inicio.asp")
end if



'------------------------------------------------------------------------------------------------
'if not b_act_antecedentes then

	consulta = " select pers_ncorr " & vbCrLf &_
			   " from usuarios " & vbCrLf &_
			   " where usua_tusuario = '" & v_usuario & "' " & vbCrLf &_
    		   "  and upper(usua_tclave) = '" & UCase(v_clave) & "'"

	v_pers_ncorr = conexion.ConsultaUno(consulta)
	


'---------IMPEDIR QUE ENTREN ALUMNOS ANTIGUOS -----------------
if EsVacio(v_pers_ncorr) then	
	Session("mensajeError") = "El USUARIO y la CLAVE ingresada no coinciden."
	str_url = "inicio.asp"
else
	Session("pers_ncorr") = v_pers_ncorr


'--------------------------------------------------------------------------------------------------------------------	
	sql_nuevo_f  = "select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") "
	v_post_bnuevo_institucion = conexion.ConsultaUno(sql_nuevo_f)
	
	if v_post_bnuevo_institucion = "N" then
	
		consulta = "select count(*) as cuenta " & vbCrLf &_
				   "from postulantes a, alumnos b, periodos_academicos c, " & vbCrLf &_
				   "     periodos_academicos d  " & vbCrLf &_
				   "where a.post_ncorr = b.post_ncorr " & vbCrLf &_
				   "  and a.peri_ccod = c.peri_ccod " & vbCrLf &_
				   "  and c.anos_ccod = d.anos_ccod " & vbCrLf &_
				   "  and b.emat_ccod not in (14,9,7,5) " & vbCrLf &_
				   "  and c.plec_ccod = 1 " & vbCrLf &_
				   "  and d.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
				   "  and a.pers_ncorr = '" & v_pers_ncorr & "'"
	
		v_cuenta = CInt(conexion.ConsultaUno(consulta))
		if v_cuenta > 0 then
			conexion.EstadoTransaccion false
			conexion.MensajeError "Se ha detectado que ya tienes una matricula para el Primer Semestre."
			Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
		end if
		
		' cambiar por una variable global que controle el periodo de nuevos y antiguos.  ej: if sys_admision_nuevos=true then
		if false then	
			conexion.EstadoTransaccion false
			conexion.MensajeError "Se ha detectado que eres alumno antiguo.\n\nTu período de matrícula todavía no comienza."
			Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
		end if

	end if
'--------------------------------------------------------------------------------------------------------------------
	
		
	v_post_bnuevo = conexion.ConsultaUno("select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") ")
		
		
		set fc_postulacion = new CFormulario
		fc_postulacion.Carga_Parametros "consulta.xml", "consulta"
		fc_postulacion.Inicializar conexion
		
		consulta = "select post_ncorr, ofer_ncorr, epos_ccod, tpos_ccod " & vbCrLf &_
				   "from postulantes " & vbCrLf &_
				   "where pers_ncorr = '" & v_pers_ncorr & "' " & vbCrLf &_
				   "  and peri_ccod = '" & v_peri_ccod & "'" & vbCrLf &_
				   "  and tpos_ccod = 1 " ' para indentificar la postulacion simple
		fc_postulacion.Consultar consulta
	
			
		if fc_postulacion.NroFilas = 0 then    'No tiene postulacion para este periodo
			set f_postulacion = new CFormulario
			f_postulacion.Carga_Parametros "matricula-inicio.xml", "postulacion"
			f_postulacion.Inicializar conexion		
			f_postulacion.CreaFilaPost		
	
			'----------------------------------------------------------------------------------
			v_post_ncorr = conexion.ConsultaUno("exec ObtenerSecuencia 'postulantes'")
			v_post_bnuevo_institucion = conexion.ConsultaUno("select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") ")
			
			if v_post_bnuevo_institucion = "S" then
				v_post_bnuevo = "S"
				
			else
				'--------------------------------------------------------------
				v_post_bnuevo = "N"
				
				set fc_matricula_anterior = new CFormulario
				fc_matricula_anterior.Carga_Parametros "consulta.xml", "consulta"
				fc_matricula_anterior.Inicializar conexion
				
				consulta = "select b.sede_ccod, b.espe_ccod, c.carr_ccod, b.jorn_ccod " & vbCrLf &_
						   "from alumnos a, ofertas_academicas b, especialidades c " & vbCrLf &_
						   "where a.ofer_ncorr = b.ofer_ncorr " & vbCrLf &_
						   "  and b.espe_ccod = c.espe_ccod " & vbCrLf &_
						   "  and a.emat_ccod = 1 " & vbCrLf &_
						   "  and b.peri_ccod < '" & v_peri_ccod & "' "	& vbCrLf &_
						   "  and a.pers_ncorr = '" & v_pers_ncorr & "' " & vbCrLf &_					   
						   "order by b.peri_ccod desc, a.alum_fmatricula desc"
						   
				fc_matricula_anterior.Consultar consulta
				fc_matricula_anterior.Siguiente
				
				'-------------------------------------------------------------------------------------------------------------						
				'Buscar la oferta anterior equivalente a este periodo, considerando carrera, especialidad, sede y jornada
				consulta = "select a.ofer_ncorr " & vbCrLf &_
						   "from ofertas_academicas a, especialidades b, aranceles c " & vbCrLf &_
						   "where a.espe_ccod = b.espe_ccod " & vbCrLf &_
						   "  and a.aran_ncorr = c.aran_ncorr " & vbCrLf &_
						   "  and a.post_bnuevo = 'N' " & vbCrLf &_
						   "  and c.aran_nano_ingreso = protic.ano_ingreso_carrera('" & v_pers_ncorr & "', b.carr_ccod) " & vbCrLf &_
						   "  and a.sede_ccod = '" & fc_matricula_anterior.ObtenerValor("sede_ccod") & "' " & vbCrLf &_
						   "  and a.espe_ccod = '" & fc_matricula_anterior.ObtenerValor("espe_ccod") & "' " & vbCrLf &_
						   "  and b.carr_ccod = '" & fc_matricula_anterior.ObtenerValor("carr_ccod") & "' " & vbCrLf &_
						   "  and a.jorn_ccod = '" & fc_matricula_anterior.ObtenerValor("jorn_ccod") & "' " & vbCrLf &_
						   "  and a.peri_ccod = '" & v_peri_ccod & "'"					   
	
				v_ofer_ncorr = conexion.ConsultaUno(consulta)
		
				if EsVacio(v_ofer_ncorr) then			
					'Buscar la oferta anterior equivalente a este periodo, no considerando jornada
					consulta = "select a.ofer_ncorr " & vbCrLf &_
							   "from ofertas_academicas a, especialidades b, aranceles c " & vbCrLf &_
							   "where a.espe_ccod = b.espe_ccod " & vbCrLf &_
							   "  and a.aran_ncorr = c.aran_ncorr " & vbCrLf &_
							   "  and a.post_bnuevo = 'N' " & vbCrLf &_
							   "  and c.aran_nano_ingreso = protic.ano_ingreso_carrera('" & v_pers_ncorr & "', b.carr_ccod) " & vbCrLf &_
							   "  and a.sede_ccod = '" & fc_matricula_anterior.ObtenerValor("sede_ccod") & "' " & vbCrLf &_
							   "  and b.carr_ccod = '" & fc_matricula_anterior.ObtenerValor("carr_ccod") & "' " & vbCrLf &_
							   "  and a.espe_ccod = '" & fc_matricula_anterior.ObtenerValor("espe_ccod") & "' " & vbCrLf &_
							   "  and a.peri_ccod = '" & v_peri_ccod & "'"
					   
					v_ofer_ncorr = conexion.ConsultaUno(consulta)				
					if EsVacio(v_ofer_ncorr) then
						'Buscar la oferta anterior equivalente a este periodo, considerando solo carrera y sede
						consulta = "select a.ofer_ncorr " & vbCrLf &_
								   "from ofertas_academicas a, especialidades b, aranceles c " & vbCrLf &_
								   "where a.espe_ccod = b.espe_ccod " & vbCrLf &_
								   "  and a.aran_ncorr = c.aran_ncorr " & vbCrLf &_
								   "  and a.post_bnuevo = 'N' " & vbCrLf &_
								   "  and c.aran_nano_ingreso = protic.ano_ingreso_carrera('" & v_pers_ncorr & "', b.carr_ccod) " & vbCrLf &_
								   "  and a.sede_ccod = '" & fc_matricula_anterior.ObtenerValor("sede_ccod") & "' " & vbCrLf &_
								   "  and b.carr_ccod = '" & fc_matricula_anterior.ObtenerValor("carr_ccod") & "' " & vbCrLf &_
								   "  and a.peri_ccod = '" & v_peri_ccod & "'"
		   
						v_ofer_ncorr = conexion.ConsultaUno(consulta)				
						if EsVacio(v_ofer_ncorr) then
							v_ofer_ncorr = ""
							v_post_bnuevo = "S"					
						end if
						
					end if	
				end if				   
			end if
			
			'----------------------------------------------------------------------------------		
			f_postulacion.AgregaCampoPost "post_ncorr", v_post_ncorr
			f_postulacion.AgregaCampoPost "pers_ncorr", v_pers_ncorr
			f_postulacion.AgregaCampoPost "peri_ccod", v_peri_ccod
			f_postulacion.AgregaCampoPost "tpos_ccod", v_tpos_ccod
			f_postulacion.AgregaCampoPost "epos_ccod", v_epos_ccod
			f_postulacion.AgregaCampoPost "eepo_ccod", 5
			
			f_postulacion.AgregaCampoPost "ofer_ncorr", v_ofer_ncorr
			f_postulacion.AgregaCampoPost "post_bnuevo", v_post_bnuevo
			
			'agregada para las nuevas postulacions que no pagan examen
			f_postulacion.AgregaCampoPost "post_bpaga", "N"
			f_postulacion.AgregaCampoPost "post_fpostulacion", v_fecha
	
			
			f_postulacion.MantieneTablas false
	
			'str_url = "principal.asp"
			str_url = "postulacion_1_breve.asp"
			
		else ' Ya tiene postulacion
			fc_postulacion.Siguiente
			
			if fc_postulacion.ObtenerValor("tpos_ccod") = "1" then					
				'if fc_postulacion.ObtenerValor("epos_ccod") = "2" then
				if fc_postulacion.ObtenerValor("epos_ccod") = "2" and not b_act_antecedentes then		
					str_url = "post_cerrada.asp"
				else
					str_url = "postulacion_1_breve.asp"
				end if
			else
				Session("mensajeError") = "Tu tipo de postulación no te permite entrar a este sistema."
				str_url = "inicio.asp"			
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
