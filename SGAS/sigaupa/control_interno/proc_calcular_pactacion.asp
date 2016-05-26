<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
'conexion.EstadoTransaccion false
pers_ncorr_codeudor = request.Form("forma_pactacion[0][pers_ncorr_codeudor]")
'response.Write(pers_ncorr_codeudor)
'response.End()

'------------------------------------------------------------------------------------------------------------------
set f_pactacion = new CFormulario
f_pactacion.Carga_Parametros "agregar_cargo_pactacion.xml", "cargo_mostrar"
f_pactacion.Inicializar conexion
f_pactacion.ProcesaForm

v_comp_ndocto = f_pactacion.ObtenerValorPost(0, "comp_ndocto")
v_tcom_ccod = f_pactacion.ObtenerValorPost(0, "tcom_ccod")
v_inst_ccod = f_pactacion.ObtenerValorPost(0, "inst_ccod")

if EsVacio(v_comp_ndocto) then
	v_comp_ndocto = conexion.ConsultaUno("execute obtenersecuencia 'compromisos'")
end if

'response.Write("simula_pactacion('" & v_comp_ndocto & "', '" & negocio.ObtenerUsuario & "')")
'response.End()
'------------------------------------------------------------------------------------------------------------------
set f_forma_pactacion = new CFormulario
f_forma_pactacion.Carga_Parametros "agregar_cargo_pactacion.xml", "forma_pactacion"
f_forma_pactacion.Inicializar conexion
f_forma_pactacion.ProcesaForm

set f_elimina_forma_pactacion = new CFormulario
f_elimina_forma_pactacion.Carga_Parametros "agregar_cargo_pactacion.xml", "elimina_forma_pactacion"
f_elimina_forma_pactacion.Inicializar conexion
f_elimina_forma_pactacion.ProcesaForm

'------------------------------------------------------------------------------------------------------------------
f_pactacion.AgregaCampoPost "comp_ndocto", v_comp_ndocto
f_forma_pactacion.AgregaCampoPost "comp_ndocto", v_comp_ndocto
f_elimina_forma_pactacion.AgregaCampoPost "comp_ndocto", v_comp_ndocto

'------------------------------------------------------------------------------------------------------------------
for i_ = 0 to f_forma_pactacion.CuentaPost - 1
	if f_forma_pactacion.ObtenerValorPost(i_, "butiliza") = f_forma_pactacion.ObtenerDescriptor("butiliza", "valorFalso") then
		f_forma_pactacion.EliminaFilaPost i_
	else
		f_elimina_forma_pactacion.EliminaFilaPost i_
	end if
next

'------------------------------------------------------------------------------------------------------------------
f_pactacion.MantieneTablas false
f_forma_pactacion.MantieneTablas false 
f_elimina_forma_pactacion.MantieneTablas false


'------------------------------------------------------------------------------------------------------------------
sentencia = "exec simula_pactacion '" & v_comp_ndocto & "'"
'response.Write(sentencia)
'response.End()
conexion.EstadoTransaccion conexion.EjecutaS(sentencia)

'------------------------------------------------------------------------------------------------------------------
url = "pactacion_cargo.asp?tcom_ccod=" & v_tcom_ccod & "&inst_ccod=" & v_inst_ccod & "&comp_ndocto=" & v_comp_ndocto & "&pers_ncorr_codeudor=" & pers_ncorr_codeudor
'response.Write("<br>"&url)
Response.Redirect(url)
%>
