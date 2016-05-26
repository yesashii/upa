<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_recursos = new CFormulario
f_recursos.Carga_Parametros "entrega_recursos.xml", "recursos"
f_recursos.Inicializar conexion
f_recursos.ProcesaForm

set f_elimina_recursos = new CFormulario
f_elimina_recursos.Carga_Parametros "entrega_recursos.xml", "elimina_recursos"
f_elimina_recursos.Inicializar conexion
f_elimina_recursos.ProcesaForm


for i_ = 0 to f_recursos.CuentaPost - 1
	if f_recursos.ObtenerValorPost(i_, "bentregado") = f_recursos.ObtenerDescriptor("bentregado", "valorFalso") then
		f_recursos.EliminaFilaPost i_
	else
		f_elimina_recursos.EliminaFilaPost i_
	end if
next


f_recursos.MantieneTablas true
f_elimina_recursos.MantieneTablas true

'---------------------------------------------------------------------------------------------------------
'Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
