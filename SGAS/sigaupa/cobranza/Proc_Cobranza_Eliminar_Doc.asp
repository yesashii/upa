<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'----------------------------------------------------


set formulario = new CFormulario
formulario.Carga_Parametros "edicion_envios_cobranza.xml", "f_listado"
formulario.Inicializar conexion
formulario.ProcesaForm

'formulario.ListarPost
'response.End()
for fila = 0 to formulario.CuentaPost - 1
   
   t_ingreso = formulario.ObtenerValorPost (fila, "ting_ccod")
   
   documento = formulario.ObtenerValorPost (fila, "ding_ndocto")
   ingreso = formulario.ObtenerValorPost (fila, "ingr_ncorr")
   envio = formulario.ObtenerValorPost (fila, "envi_ncorr")
    
  'response.Write("ingreso: " & ingreso & " tipo ingreso: " & t_ingreso &  " letra: " & documento & "envio:" & envio & "<BR>")
  
   
   if envio <> "" then
     
     consulta = "UPDATE detalle_ingresos SET envi_ncorr = null "&_ 
	     "WHERE cast(ting_ccod as varchar)='" & t_ingreso & "' "&_
		   "AND  cast(ding_ndocto as varchar)='" & documento & "' "&_
		   "AND  cast(ingr_ncorr as varchar)='" & ingreso & "'"
		   
  		   
	response.Write(consulta & "<BR>")	 
	' response.End()
     conexion.EstadoTransaccion conexion.EjecutaS(consulta)	
   end if 
next


formulario.MantieneTablas false
'conexion.estadotransaccion false  'roolback   
'response.End() 
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
