<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
Function PuedeEliminarTipo(p_igas_ccod)
	PuedeEliminarTipo = true
	
	v_cuenta = CInt(conexion.ConsultaUno("select count(*) from tipos_detalle where cast(igas_ccod as varchar) = '" & p_igas_ccod & "'"))	
	if v_cuenta > 0 then
		PuedeEliminarTipo = false
	end if	
		
End Function


'----------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false

set f_itemes_gasto = new CFormulario
f_itemes_gasto.Carga_Parametros "adm_itemes_gasto.xml", "itemes_gasto"
f_itemes_gasto.Inicializar conexion
f_itemes_gasto.ProcesaForm

msj_error = ""

for i_ = 0 to f_itemes_gasto.CuentaPost - 1
	if not PuedeEliminarTipo(f_itemes_gasto.ObtenerValorPost(i_, "igas_ccod")) then
		msj_error = msj_error & "No se puede eliminar " & conexion.ConsultaUno("select igas_tdesc from itemes_gasto where cast(igas_ccod as varchar) = '"&f_itemes_gasto.ObtenerValorPost(i_, "igas_ccod")&"'") & ".\n"
		f_itemes_gasto.EliminaFilaPost i_		
	end if
next

f_itemes_gasto.MantieneTablas false

conexion.MensajeError msj_error
'----------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
