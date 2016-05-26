<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
Function PuedeEliminarTipo(p_tcom_ccod)
	PuedeEliminarTipo = true
	
	v_cuenta = CInt(conexion.ConsultaUno("select count(*) from tipos_detalle where cast(tcom_ccod as varchar) = '"&p_tcom_ccod & "'"))	
	if v_cuenta > 0 then
		PuedeEliminarTipo = false
	end if
	
	v_cuenta = CInt(conexion.ConsultaUno("select count(*) from compromisos where cast(tcom_ccod as varchar) = '"&p_tcom_ccod & "'"))	
	if v_cuenta > 0 then
		PuedeEliminarTipo = false
	end if
	
End Function


'----------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false

set f_tipos_compromisos = new CFormulario
f_tipos_compromisos.Carga_Parametros "adm_tipos_compromisos.xml", "tipos_compromisos"
f_tipos_compromisos.Inicializar conexion
f_tipos_compromisos.ProcesaForm

msj_error = ""

for i_ = 0 to f_tipos_compromisos.CuentaPost - 1
	if not PuedeEliminarTipo(f_tipos_compromisos.ObtenerValorPost(i_, "tcom_ccod")) then
		msj_error = msj_error & "No se puede eliminar el tipo " & conexion.ConsultaUno("select tcom_tdesc from tipos_compromisos where cast(tcom_ccod as varchar) = '"&f_tipos_compromisos.ObtenerValorPost(i_, "tcom_ccod")&"'") & ".\n"
		f_tipos_compromisos.EliminaFilaPost i_
	end if
next

f_tipos_compromisos.MantieneTablas false


conexion.MensajeError msj_error
'----------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>