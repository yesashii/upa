<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
Function PuedeEliminarTipo(p_tdet_ccod)
	PuedeEliminarTipo = true
	
	v_cuenta = CInt(conexion.ConsultaUno("select count(*) from detalles a, compromisos b where a.tcom_ccod = b.tcom_ccod and a.inst_ccod = b.inst_ccod and a.comp_ndocto = b.comp_ndocto and b.ecom_ccod <> 3 and cast(a.tdet_ccod as varchar) = '"&p_tdet_ccod&"'"))	
	if v_cuenta > 0 then
		PuedeEliminarTipo = false
	end if
	
	v_cuenta = CInt(conexion.ConsultaUno("select count(*) from sim_pactaciones where cast(tdet_ccod as varchar) = '" & p_tdet_ccod & "'"))	
	if v_cuenta > 0 then
		PuedeEliminarTipo = false
	end if
	
End Function


'----------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false

set f_tipos_detalle = new CFormulario
f_tipos_detalle.Carga_Parametros "edicion_tipos_compromisos.xml", "tipos_detalle"
f_tipos_detalle.Inicializar conexion
f_tipos_detalle.ProcesaForm

msj_error = ""

for i_ = 0 to f_tipos_detalle.CuentaPost - 1
	if not PuedeEliminarTipo(f_tipos_detalle.ObtenerValorPost(i_, "tdet_ccod")) then
		texto_tipo = conexion.ConsultaUno("select tdet_tdesc from tipos_detalle where cast(tdet_ccod as varchar) = '"&f_tipos_detalle.ObtenerValorPost(i_, "tdet_ccod")&"'") 
		msj_error = msj_error & "No se puede eliminar el tipo: " &texto_tipo & ". ya que ha sido asociado a mas de un alumno.\n"
		f_tipos_detalle.EliminaFilaPost i_		
	end if
next

f_tipos_detalle.MantieneTablas false

conexion.MensajeError msj_error
'----------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
