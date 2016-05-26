<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
Function PuedeEliminarTipo(p_ccos_ccod)
	PuedeEliminarTipo = true
	
	v_cuenta = CInt(conexion.ConsultaUno("select count(*) from tipos_detalle where cast(ccos_ccod as varchar) = '" & p_ccos_ccod & "'"))	
	if v_cuenta > 0 then
		PuedeEliminarTipo = false
	end if	
		
End Function


'----------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false

set f_centros_costo = new CFormulario
f_centros_costo.Carga_Parametros "adm_centros_costo.xml", "centros_costo"
f_centros_costo.Inicializar conexion
f_centros_costo.ProcesaForm

msj_error = ""

for i_ = 0 to f_centros_costo.CuentaPost - 1
	if not PuedeEliminarTipo(f_centros_costo.ObtenerValorPost(i_, "ccos_ccod")) then
		msj_error = msj_error & "No se puede eliminar " & conexion.ConsultaUno("select ccos_tdesc from centros_costo where cast(ccos_ccod as varchar) = '"&f_centros_costo.ObtenerValorPost(i_, "ccos_ccod")&"'") & ".\n"
		f_centros_costo.EliminaFilaPost i_		
	end if
next

f_centros_costo.MantieneTablas false

conexion.MensajeError msj_error
'----------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
