<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
set conexion = new CConexion
conexion.Inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conexion

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede



'--------------------------------------------------------------------------------------------------
set f_cheques = new CFormulario
f_cheques.Carga_Parametros "pago_cheques.xml", "cheques"
f_cheques.Inicializar conexion
f_cheques.ProcesaForm


'--------------------------------------------------------------------------------------------------
v_usuario = negocio.ObtenerUsuario
v_peri_ccod = negocio.ObtenerPeriodoAcademico("CLASES18")

'--------------------------------------------------------------------------------------------------
for i_ = 0 to f_cheques.CuentaPost - 1
	v_ding_ndocto = f_cheques.ObtenerValorPost(i_, "ding_ndocto")
	v_ting_ccod = f_cheques.ObtenerValorPost(i_, "ting_ccod")
	v_banc_ccod = f_cheques.ObtenerValorPost(i_, "banc_ccod")
	v_ding_tcuenta_corriente = f_cheques.ObtenerValorPost(i_, "ding_tcuenta_corriente")
	
	if not EsVacio(v_ding_ndocto) then
		sentencia = "exec PREPARA_PAGO_CHEQUE '" & v_ting_ccod & "', '" & v_ding_ndocto & "', '" & v_banc_ccod & "', '" & v_ding_tcuenta_corriente & "', '" & cajero.ObtenerCajaAbierta & "', '" & v_peri_ccod & "', '"&v_usuario&"'"
		'Response.Write("<br>" & sentencia)
		conexion.EstadoTransaccion conexion.EjecutaS(sentencia)
	end if
next

'response.Write("<br>Estado Transaccion: "&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'response.End()
'--------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
