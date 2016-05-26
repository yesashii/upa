<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'----------------------------------------------------


set formulario = new CFormulario
formulario.Carga_Parametros "edicion_envios_pagare.xml", "f_listado"
formulario.Inicializar conexion
formulario.ProcesaForm

'formulario.ListarPost
'response.End()
for fila = 0 to formulario.CuentaPost - 1
   
   
   
   pagare = formulario.ObtenerValorPost (fila, "DING_NDOCTO")
   envio = formulario.ObtenerValorPost (fila, "envi_ncorr")
   'response.write(pagare & " aca")
  'response.Write("ingreso: " & ingreso & " tipo ingreso: " & t_ingreso &  " letra: " & documento & "envio:" & envio & "<BR>")
  
   
	if envio <> "" then
		consulta = "DELETE FROM DETALLE_ENVIOS WHERE DING_NDOCTO =" & pagare & " AND envi_ncorr = " & envio
  		conexion.EstadoTransaccion conexion.EjecutaS(consulta)	
	end if 
next
	

formulario.MantieneTablas false
'conexion.estadotransaccion false  'roolback  
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
