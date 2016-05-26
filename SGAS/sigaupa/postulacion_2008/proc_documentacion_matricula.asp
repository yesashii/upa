<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
 
'response.End()
 
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_documentos = new CFormulario
f_documentos.Carga_Parametros "documentacion_matricula.xml", "documentos2"
f_documentos.Inicializar conexion
f_documentos.ProcesaForm

set f_elimina_documentos = new CFormulario
f_elimina_documentos.Carga_Parametros "documentacion_matricula.xml", "elimina_documentos_postulantes"
f_elimina_documentos.Inicializar conexion
f_elimina_documentos.ProcesaForm


for i_ = 0 to f_documentos.CuentaPost - 1
	if f_documentos.ObtenerValorPost(i_, "entregado") = f_documentos.ObtenerDescriptor("entregado", "valorFalso") then
		f_documentos.EliminaFilaPost i_
	else
		f_elimina_documentos.EliminaFilaPost i_
	end if
next


f_documentos.MantieneTablas false
f_elimina_documentos.MantieneTablas false
'response.End()

'---------------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
