<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_tipos_requisitos = new CFormulario
f_tipos_requisitos.Carga_Parametros "adm_tipos_requisitos.xml", "tipos_requisitos"
f_tipos_requisitos.Inicializar conexion
f_tipos_requisitos.ProcesaForm

msj = ""


for i_ = 0 to f_tipos_requisitos.CuentaPost - 1
	v_treq_ccod = f_tipos_requisitos.ObtenerValorPost(i_, "treq_ccod")
	
	sql = "select count(*) from requisitos_plan where cast(treq_ccod as varchar)= '" & v_treq_ccod & "'"
	v_cuenta = CInt(conexion.ConsultaUno(sql))
		
	if v_cuenta > 0 then		
		msj = msj & "- No se puede eliminar el tipo " & conexion.ConsultaUno("select treq_tdesc from tipos_requisitos_titulo where treq_ccod = '" & v_treq_ccod & "'") & ", porque hay planes que lo tienen configurado como requisito.\n"
		f_tipos_requisitos.EliminaFilaPost i_
	end if
next

conexion.MensajeError msj
f_tipos_requisitos.MantieneTablas false


'-------------------------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
