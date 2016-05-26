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
formulario.carga_parametros "encuesta_empleadores.xml", "guardar_encuesta"
formulario.inicializar conectar
formulario.procesaForm
eemp_ncorr = conectar.ConsultaUno("execute obtenerSecuencia 'encuestas_empleadores' ") 
formulario.AgregaCampoPost "eemp_ncorr", eemp_ncorr
formulario.AgregaCampoPost "fecha_grabado", Date'conectar.consultaUno("select convert(datetime,getDate(),103)")
formulario.MantieneTablas false
'----------------------------------------------------

'¿response.End()
%>

<script language="JavaScript" type="text/JavaScript">
  location.href = "encuesta_empleadores.asp?devuelto=1"
</script>

