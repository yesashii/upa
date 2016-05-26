<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'-----------------------------------------------------
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()

set conectar = new cconexion
conectar.inicializar "upacifico"

'conectar.estadoTransaccion false

set formulario = new cformulario
formulario.carga_parametros "contestar_encuesta_otec.xml", "guardar_encuesta"
formulario.inicializar conectar
formulario.procesaForm
eote_ncorr = conectar.ConsultaUno("execute obtenerSecuencia 'encuestas_otec' ") 
formulario.AgregaCampoPost "eote_ncorr", eote_ncorr
formulario.AgregaCampoPost "fecha_grabado", Date'conectar.consultaUno("select convert(datetime,getDate(),103)")
formulario.MantieneTablas false

'response.End()
'----------------------------------------------------

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>


