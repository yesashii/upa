<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'conexion.EstadoTransaccion false

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

'response.End()
'response.Write("<br>")
'comp_ndocto = request.QueryString("detalle_compromisos[0][comp_ndocto]")
comp_ndocto = request.Form("detalle_compromisos[0][comp_ndocto]")
tcom_ccod = request.Form("detalle_compromisos[0][tcom_ccod]")
'response.Write(comp_ndocto)
'response.Write(tcom_ccod)
'response.End()
'------------------------------------------------------------------------------------------------------------------
set f_repactacion = new CFormulario
f_repactacion.Carga_Parametros "agregar_repactacion.xml", "repactacion"
f_repactacion.Inicializar conexion
f_repactacion.ProcesaForm

'------------------------------------------------------------------------------------------------------------------
v_repa_ncorr = f_repactacion.ObtenerValorPost(0, "repa_ncorr")
if EsVacio(v_repa_ncorr) then
	'v_repa_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'repactaciones'")
	v_repa_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
end if


'------------------------------------------------------------------------------------------------------------------
set f_forma_repactacion = new CFormulario
f_forma_repactacion.Carga_Parametros "agregar_repactacion.xml", "forma_repactacion"
f_forma_repactacion.Inicializar conexion
f_forma_repactacion.ProcesaForm

set f_elimina_forma_repactacion = new CFormulario
f_elimina_forma_repactacion.Carga_Parametros "agregar_repactacion.xml", "elimina_forma_repactacion"
f_elimina_forma_repactacion.Inicializar conexion
f_elimina_forma_repactacion.ProcesaForm

'------------------------------------------------------------------------------------------------------------------
f_repactacion.AgregaCampoPost "repa_ncorr", v_repa_ncorr
f_repactacion.AgregaCampoPost "comp_ndocto",comp_ndocto
f_repactacion.AgregaCampoPost "tcom_ccod",tcom_ccod

f_forma_repactacion.AgregaCampoPost "repa_ncorr", v_repa_ncorr
f_elimina_forma_repactacion.AgregaCampoPost "repa_ncorr", v_repa_ncorr

'------------------------------------------------------------------------------------------------------------------
for i_ = 0 to f_forma_repactacion.CuentaPost - 1
	if f_forma_repactacion.ObtenerValorPost(i_, "butiliza") = f_forma_repactacion.ObtenerDescriptor("butiliza", "valorFalso") then
		f_forma_repactacion.EliminaFilaPost i_
	else
		f_elimina_forma_repactacion.EliminaFilaPost i_
	end if
next

'------------------------------------------------------------------------------------------------------------------
f_repactacion.MantieneTablas false
f_forma_repactacion.MantieneTablas false  
f_elimina_forma_repactacion.MantieneTablas false


'------------------------------------------------------------------------------------------------------------------
set f_detalle_compromisos = new CFormulario
f_detalle_compromisos.Carga_Parametros "agregar_repactacion.xml", "documentos_repactacion"
f_detalle_compromisos.Inicializar conexion
f_detalle_compromisos.ProcesaForm

v_str_ingresos = ""
for i_ = 0 to f_detalle_compromisos.CuentaPost - 1
	v_str_ingresos = v_str_ingresos & "'" & f_detalle_compromisos.ObtenerValorPost(i_, "ingr_ncorr") & "'"
	
	if CInt(i_) <>  CInt(f_detalle_compromisos.CuentaPost - 1) then
		v_str_ingresos = v_str_ingresos & ","
	end if
next

'------------------------------------------------------------------------------------------------------------------
'On Error Resume Next
'bejecutaS = false
sentencia = "exec simula_repactacion '" & v_repa_ncorr & "'"
conexion.EstadoTransaccion conexion.EjecutaS(sentencia)
'bejecutaS = conexion.EjecutaS(sentencia)
'conexion.EstadoTransaccion bejecutaS


'------------------------------------------------------------------------------------------------------------------
str_url = "agregar_repactacion.asp?repa_ncorr=" & v_repa_ncorr & "&ingresos=" & v_str_ingresos
'response.Write(str_url)
'response.Write("<br><b>Estado:</b>"&conexion.obtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'response.End()

Response.Redirect(str_url)
%>
