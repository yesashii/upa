<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
'for each x in request.Form
'	response.Write("<br>"&x&"->"&request.form(x))
'next
'response.End()


set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_datos_antiguos = new CFormulario
f_datos_antiguos.Carga_Parametros "consulta.xml", "consulta"

set f_alumno = new CFormulario
f_alumno.Carga_Parametros "adm_cambio_especialidad.xml", "alumno"
f_alumno.Inicializar conexion
f_alumno.ProcesaForm

f_alumno.MantieneTablas false
'response.Write(conexion.obtenerEstadoTransaccion)
'response.end()
'------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
