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
formulario.carga_parametros "encuesta_docentes.xml", "guardar_encuesta"
formulario.inicializar conectar
formulario.procesaForm
edoc_ncorr = conectar.ConsultaUno("execute obtenerSecuencia 'encuestas_docentes' ") 
formulario.AgregaCampoPost "edoc_ncorr", edoc_ncorr
formulario.AgregaCampoPost "fecha_grabado", Date'conectar.consultaUno("select convert(datetime,getDate(),103)")
formulario.MantieneTablas false

'response.End()
'----------------------------------------------------
%>

<script language="JavaScript" type="text/JavaScript">
  location.href = "encuesta_docentes.asp?devuelto=1"
</script>

