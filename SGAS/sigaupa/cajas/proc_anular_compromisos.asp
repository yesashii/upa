<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
  
set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()  
'----------------------------------------------------------------------
'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x))
'next
'response.End()
'----------------------------------------------------------------------
  set formulario = new CFormulario
  formulario.Carga_Parametros "anular_compromisos.xml", "f_compromisos"
  formulario.Inicializar conexion
  formulario.ProcesaForm
  	for fila = 0 to formulario.CuentaPost - 1
		v_comp_ndocto	= formulario.ObtenerValorPost (fila, "comp_ndocto")
	   	v_tcom_ccod		= formulario.ObtenerValorPost (fila, "tcom_ccod")
	   	v_inst_ccod		= formulario.ObtenerValorPost (fila, "inst_ccod")
		v_motivo		= formulario.ObtenerValorPost (fila, "motivo")
		if v_comp_ndocto <> "" then
			
			sql_inserta= " Insert into compromisos_log "& vbCrLf &_ 
						 " Select *,'"&v_motivo&"' as motivo, '"&usuario&"' as usuario, getdate() as fecha_modificacion from compromisos "& vbCrLf &_ 
						 " Where comp_ndocto="&v_comp_ndocto&" and tcom_ccod="&v_tcom_ccod&" and inst_ccod="&v_inst_ccod&" "
			'response.Write("<br><hr><pre>"&sql_inserta&"</pre><hr>")
			conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta)
		end if	
	next
  
  
  formulario.AgregaCampoPost "ecom_ccod", 3
 
  formulario.MantieneTablas false
 
 	'conexion.estadotransaccion false  'roolback   
	'response.End()
  if conexion.obtenerEstadoTransaccion = false then
  	session("mensajeError") = "No se pudo anular el o los compromisos seleccionados"
  else
  	session("mensajeError") = "El o los compromisos seleccionados fueron anulados correctamente"
  end if
  
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

