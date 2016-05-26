<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
' codigo del postulante
'v_post_ncorr = request.QueryString("post_ncorr")
'Session("post_ncorr") = v_post_ncorr
'if EsVacio(v_post_ncorr) then
'	Response.Redirect("inicio.asp")
'end if
'Session("post_ncorr") = v_post_ncorr

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

'------------------------------------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "postulacion_1.xml", "carrera_postulante2"
formulario.Inicializar conexion
formulario.ProcesaForm

'v_post_ncorr = formulario.ObtenerValorPost (0, "post_ncorr")
for fila = 0 to formulario.CuentaPost - 1
	post_ncorr_aux = formulario.ObtenerValorPost (fila, "post_ncorr")
	if 	not EsVacio(post_ncorr_aux) then
		v_post_ncorr = post_ncorr_aux
	end if
next
   'envio = formulario.ObtenerValorPost (fila, "envi_ncorr")

'response.Write("post_ncorr :" & v_post_ncorr)
'response.End()
'rut = formulario.ObtenerValorPost (0, "pers_nrut")
'digito = formulario.ObtenerValorPost (0, "pers_xdv")
'Session("post_ncorr") = v_post_ncorr

'if	EsVacio(v_post_ncorr) then
'	Session("mensajeError") = "Error, Falta parámetro."
'	str_url = "inicio.asp"
'else ' si se trae una postulacion
'	Session("post_ncorr") = v_post_ncorr
'	str_url = "postulacion_2.asp"	 
'end if

'------------------------------------------------------------------------------------------------
v_peri_ccod = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-------------------------------------------------------------------------------------------------
consulta = "select count(*) " & vbCrLf &_
	           "from postulantes " & vbCrLf &_
			   "where post_ncorr = '" & v_post_ncorr & "' " & vbCrLf &_
			   "  and peri_ccod = '" & v_peri_ccod & "' "& vbCrLf &_
			   "  and epos_ccod = 2 "& vbCrLf &_
			   "  and tpos_ccod in (1,2) " ' para indentificar la doble postulacion y normal


'postulaciones_cerradas = conexion.ConsultaUno(consulta)' se ve si la postulacion ha sido enviada
if	EsVacio(v_post_ncorr) then
	Session("mensajeError") = "Error, Falta parámetro."
	str_url = "inicio.asp"
else
	Session("post_ncorr") = v_post_ncorr	
	postulaciones_cerradas = conexion.ConsultaUno(consulta)' se ve si la postulacion ha sido enviada
	if	EsVacio(postulaciones_cerradas) then
		Session("mensajeError") = "Error, postulacion no existe."
		str_url = "inicio.asp"
		postulaciones_cerradas = 0
	elseif	postulaciones_cerradas > 0 then ' para cuando la postulacion
			str_url = "post_cerrada.asp"	' a sido enviada
	else ' para cuando la postulacion NO ha sido enviada
		str_url = "postulacion_2.asp"
	end if
	
	act_antecedentes = Session("ses_act_ancedentes") 
	if	not EsVacio(act_antecedentes) and act_antecedentes = "S" then
		str_url = "postulacion_2.asp"	
	end if

end if
'conexion.estadotransaccion false
'response.End()
'---------------------------------------------------------------------------------------------------------------
Response.Redirect(str_url)
%>