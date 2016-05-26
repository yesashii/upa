<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set formulario = new CFormulario
formulario.Carga_Parametros "castigos_documentos.xml", "f_detalle_envio"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost
for fila = 0 to formulario.CuentaPost - 1
   t_ingreso = formulario.ObtenerValorPost (fila, "ting_ccod")
   documento = formulario.ObtenerValorPost (fila, "ding_ndocto")
   ingreso = formulario.ObtenerValorPost (fila, "ingr_ncorr")
   envio = formulario.ObtenerValorPost (fila, "envi_ncorr")
   if envio <> "" then
     consulta = "UPDATE detalle_ingresos SET envi_ncorr = NULL "&_ 
	     "WHERE  ting_ccod='" & t_ingreso & "' "&_
		   "AND  ding_ndocto='" & documento & "' "&_
		   "AND  ingr_ncorr='" & ingreso & "'"
	 'response.Write(consulta & "<BR>")	 
     conexion.EstadoTransaccion conexion.EjecutaS(consulta)	
   else
      formulario.EliminaFilaPost fila 
   end if 
next
formulario.MantieneTablas false
'conexion.estadotransaccion false  'roolback 
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
