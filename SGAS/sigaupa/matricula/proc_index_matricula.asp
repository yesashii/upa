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
'response.Write(v_peri_ccod)
'response.End()
v_usuario = Request.Form("usuario")
v_clave = Request.Form("clave")



sql_usuario_valido =" select count(*) " & vbCrLf &_
	    	 	    " from usuarios " & vbCrLf &_
			        " where usua_tusuario = '" & v_usuario & "' " & vbCrLf &_
    			    " and upper(usua_tclave) is not null "

'---------------------------------------debug
'response.write(sql_usuario_valido)
'response.end()

usuario_valido = conexion.consultauno(sql_usuario_valido)

v_act_antecedentes = Request.Form("act_antecedentes")
Session("ses_act_ancedentes") = v_act_antecedentes

if v_act_antecedentes = "S" then
	b_act_antecedentes = true
else
	b_act_antecedentes = false
end if

'response.Write(b_act_antecedentes&"<br>")
'response.Write("v_usuario : "&v_usuario&"<br>")
'response.Write("v_clave : "&v_clave&"<br>")
'response.End()

v_tpos_ccod = "1" ' Normal
v_epos_ccod = "1" ' En Proceso

if usuario_valido=0 and not b_act_antecedentes then
	session("mensajeError") = "Usuario no está registrado."
	Response.Redirect("inicio.asp")
end if

'------------------------------------------------------------------------------------------------
'if not b_act_antecedentes then
if v_usuario<>"" then
	consulta = "select pers_ncorr " & vbCrLf &_
			   "from usuarios " & vbCrLf &_
			   "where usua_tusuario = '" & v_usuario & "' " & vbCrLf &_
    			   "  and upper(usua_tclave) = '" & UCase(v_clave) & "'"

	consulta = "select pers_ncorr " & vbCrLf &_
			   "from usuarios " & vbCrLf &_
			   "where usua_tusuario = '" & v_usuario & "' " & vbCrLf &_
    			   "  and upper(usua_tclave) is not null "

	v_pers_ncorr = conexion.ConsultaUno(consulta)
else
Session("mensajeError") = "El Postulante aún no ha sido aprobado en la entrevista o test de admision."
Response.Redirect("ACTUALIZACION_ANTECEDENTES.ASP")
end if
'--------------------------------buscar el pers_ncorr en el caso que sea actualizacion de datos----------------------
'--------------------------------------------------actualizado 15-11-2004---------------by Marcelo Sandoval----------
if b_act_antecedentes and EsVacio(v_pers_ncorr) then
v_pers_ncorr=request.Form("persona[0][pers_ncorr]")
end if
'----------------------------------------------Fin de la actualización------------------------------------------------

'---------IMPEDIR QUE ENTREN ALUMNOS ANTIGUOS -----------------

sql_nuevo_f  = "select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") "
v_post_bnuevo_institucion = conexion.ConsultaUno(sql_nuevo_f)

if v_post_bnuevo_institucion = "N" then' se creo pues es necesario solo para alumnos nuevos la siguiente validacion. ETORRES


'--------------------------------------------------------------------------------------------------------------------
consulta = "select count(*) as cuenta " & vbCrLf &_
           "from postulantes a, alumnos b, periodos_academicos c, " & vbCrLf &_
		   "     periodos_academicos d  " & vbCrLf &_
		   "where a.post_ncorr = b.post_ncorr " & vbCrLf &_
		   "  and a.peri_ccod = c.peri_ccod " & vbCrLf &_
		   "  and c.anos_ccod = d.anos_ccod " & vbCrLf &_
		   "  and a.peri_ccod = d.peri_ccod " & vbCrLf &_
		   "  and b.emat_ccod not in (14,9,7,5) " & vbCrLf &_
		   "  and c.plec_ccod = 1 " & vbCrLf &_
		   "  and d.peri_ccod = '" & v_peri_ccod & "' " & vbCrLf &_
		   "  and a.pers_ncorr = '" & v_pers_ncorr & "'"
'response.Write("<pre>"&consulta&"</pre>")
'response.End()
	v_cuenta = CInt(conexion.ConsultaUno(consulta))
	if v_cuenta > 0 then
		conexion.EstadoTransaccion false
		conexion.MensajeError "Se ha detectado que el alumno ya se matriculó en el primer semestre."
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


if EsVacio(v_pers_ncorr) then
	Session("mensajeError") = "El USUARIO y la CLAVE ingresada no coinciden."
	str_url = "inicio.asp"
else
	Session("pers_ncorr") = v_pers_ncorr

v_post_bnuevo = conexion.ConsultaUno("select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") ")


	set fc_postulacion = new CFormulario
	fc_postulacion.Carga_Parametros "consulta.xml", "consulta"
	fc_postulacion.Inicializar conexion

	consulta = "select a.post_ncorr, a.ofer_ncorr, a.epos_ccod, a.tpos_ccod " & vbCrLf &_
	           "from postulantes a, detalle_postulantes b, ofertas_academicas c " & vbCrLf &_
			   "where a.pers_ncorr = '" & v_pers_ncorr & "' " & vbCrLf &_
			   "  and a.peri_ccod = '" & v_peri_ccod & "'" & vbCrLf &_
			   "  and a.ofer_ncorr is not null  "& vbCrLf &_
			   "  and a.ofer_ncorr=c.ofer_ncorr "& vbCrLf &_
			   "  and a.post_ncorr=b.post_ncorr  "& vbCrLf &_
			   "  and c.audi_tusuario not like '%aju%' "& vbCrLf &_
			   "  and a.tpos_ccod = 1 " ' para indentificar la postulacion simple
	'response.write consulta
	'response.end
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
		else
			'--------------------------------------------------------------
			v_post_bnuevo = "N"
			carrera_sin_ofer = ""
			' nuevo ... llamada a procedimiento para crear postulacion automatica
			v_cadena = conexion.ConsultaUno("exec CREAR_POSTULACION_ANTIGUO " & v_pers_ncorr & "," & v_peri_ccod )
			v_lista = Split(v_cadena,"/")
			carrera_sin_ofer = v_lista(0)
			v_post_bnuevo = v_lista(1)
			mensaje_error_aux = "Carreras que no tienen Ofertas Academicas creadas: \n" & carrera_sin_ofer
			if 	carrera_sin_ofer <> " " then
				Session("mensajeError") = mensaje_error_aux
			end if

		end if

		'----------------------------------------------------------------------------------
		if v_post_bnuevo="S" then
			str_url = "postulacion_1_breve.asp"
		else
			str_url = "postulacion_1.asp"
		end if

	else ' Ya tiene postulacion
		fc_postulacion.Siguiente

		if fc_postulacion.ObtenerValor("tpos_ccod") = "1" then

			if 	fc_postulacion.ObtenerValor("epos_ccod") = "2" and v_post_bnuevo="S" then ' se agrego para ver las doble matriculas de antiguos
				Session("post_ncorr") = fc_postulacion.ObtenerValor("post_ncorr")
				str_url = "post_cerrada.asp"
			else
				'str_url = "principal.asp"
				if v_post_bnuevo="S" then
					str_url = "postulacion_1_breve.asp"
				else
					str_url = "postulacion_1.asp"
				end if
			end if
		else
			Session("mensajeError") = "Tu tipo de postulación no te permite entrar a este sistema."
			str_url = "inicio.asp"
		end if
	end if

end if

if v_post_bnuevo = "N" and str_url<>"post_cerrada.asp" then
	str_url = "postulacion_antiguo.asp"
end if

'conexion.estadotransaccion false
'response.End()
'---------------------------------------------------------------------------------------------------------------------
Response.Redirect(str_url)
%>
