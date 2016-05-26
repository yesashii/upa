<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"


set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'----------------------------------------------------

set formulario = new CFormulario
formulario.Carga_Parametros "envios_notaria_pagare.xml", "f_enviar"
formulario.Inicializar conexion
formulario.ProcesaForm

'formulario.ListarPost


'ACTUALIZO LOS DETALLES DEL INGRESO A 'EN BANCO'
for fila = 0 to formulario.CuentaPost - 1
	for each k in request.form
		'response.Write(" -->" &k & " = "&request.Form(k)&"   <-<br>")
		if instr(k, "envi_ncorr") then
			envio = request.Form(k)
		end if
	next
   'envio = formulario.ObtenerValorPost (fila, "envi_ncorr")

	'response.write(envio &" aca")
	'response.end()
	if envio <> "" then
		SQL = "select count(envi_ncorr) as total from detalle_envios where envi_ncorr=" & envio
		response.write(sql)
		'response.end()
		f_consulta.consultar SQL
		f_consulta.siguiente
		documentos = f_consulta.ObtenerValor ("total")
		response.write(documentos)
		'response.end()
		if documentos > 0 then
			'formulario.AgregaCampoPost "eenv_ccod" , 2
			consulta = "UPDATE envios SET eenv_ccod = 2 WHERE envi_ncorr='" & envio & "'"
			'response.write(consulta)
			'response.end()
			conexion.EstadoTransaccion conexion.EjecutaS(consulta)
			'consulta = "UPDATE pagare_upa SET epup_ccod = 2 WHERE envi_ncorr='" & envio & "'"
			'conexion.EstadoTransaccion conexion.EjecutaS(consulta)	
			consulta = "UPDATE detalle_envios SET epag_ccod = 2 WHERE envi_ncorr='" & envio & "'"
			conexion.EstadoTransaccion conexion.EjecutaS(consulta)
		else
			cont =cont + 1
			cad = cad & envio & "  "	
		end if	 	
	end if 
next
 
 'response.write count
 'response.end()

if cont > 0 then
  mensage = " Los siguientes Envios Pagare a Notaria no se enviaron porque no contenían Pagares Asociados ..." & "\nFolios: " & cad 
  session("mensajeError")= mensage
end if
'conexion.estadotransaccion false  'roolback  
formulario.MantieneTablas false
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
