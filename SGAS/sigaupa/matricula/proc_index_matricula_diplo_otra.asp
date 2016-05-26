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

v_tpos_ccod = "2" ' DOBLE
v_epos_ccod = "1" ' En Proceso



'------------------------------------------------------------------------------------------------
v_pers_ncorr = Session("pers_ncorr")
'----------------------------------------------Fin de la actualización------------------------------------------------
	
sql_nuevo_f  = "select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") "
v_post_bnuevo_institucion = conexion.ConsultaUno(sql_nuevo_f)

'if v_post_bnuevo_institucion = "N" then
if false then
	conexion.EstadoTransaccion false
	conexion.MensajeError "Se ha detectado que eres alumno antiguo.\n\nTu período de matrícula todavía no comienza."
	Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
end if

if EsVacio(v_pers_ncorr) then	
	Session("mensajeError") = "El USUARIO y la CLAVE ingresada no coinciden."
	str_url = "inicio.asp"
else
	Session("pers_ncorr") = v_pers_ncorr
	
v_post_bnuevo = conexion.ConsultaUno("select protic.es_nuevo_institucion(" & v_pers_ncorr & ", " & v_peri_ccod & ") ")
	
	
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
			v_post_bnuevo = "S"' todos los postulantes se toman como nuevos
		end if
		
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
		'Session("solo_postgrado") = 1
		str_url = "postulacion_diplo_1.asp"

end if
'response.Write(str_url&" postulante nuevo ?->"&v_post_bnuevo)
'conexion.estadotransaccion false
if v_post_bnuevo = "N" and str_url<>"post_cerrada.asp" then
	str_url = "postulacion_antiguo.asp"
end if 
'---------------------------------------------------------------------------------------------------------------------
Response.Redirect(str_url)
%>