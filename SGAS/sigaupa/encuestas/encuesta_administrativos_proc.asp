<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'-----------------------------------------------------
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next



set conectar = new cconexion
conectar.inicializar "upacifico"

'conectar.estadoTransaccion false

set formulario = new cformulario
formulario.carga_parametros "encuesta_administrativos.xml", "guardar_encuesta"
formulario.inicializar conectar
formulario.procesaForm
edis_ncorr = conectar.ConsultaUno("execute obtenerSecuencia 'encuestas_administrativos' ") 
formulario.AgregaCampoPost "eadm_ncorr", edis_ncorr
formulario.AgregaCampoPost "fecha_grabado", Date'conectar.consultaUno("select convert(datetime,getDate(),103)")
formulario.MantieneTablas false

'response.End()
'----------------------------------------------------

response.Redirect("encuesta_administrativos.asp?codigo="&edis_ncorr)

%>


