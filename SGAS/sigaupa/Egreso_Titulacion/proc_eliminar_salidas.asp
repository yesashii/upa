<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_salidas = new CFormulario
f_salidas.Carga_Parametros "adm_salidas.xml", "salidas"
f_salidas.Inicializar conexion
f_salidas.ProcesaForm


msj_error = ""
for i_ = 0 to f_salidas.CuentaPost - 1
	v_sapl_ncorr = f_salidas.ObtenerValorPost(i_, "sapl_ncorr")
	v_cuenta1 = CInt(conexion.ConsultaUno("select count(*) from salidas_alumnos where cast(sapl_ncorr as varchar)= '" & v_sapl_ncorr & "'"))
	v_cuenta2 = CInt(conexion.ConsultaUno("select count(*) from requisitos_plan where cast(sapl_ncorr as varchar)= '" & v_sapl_ncorr & "'"))
	v_cuenta3 = CInt(conexion.ConsultaUno("select count(*) from asignaturas_salidas where cast(sapl_ncorr as varchar)= '" & v_sapl_ncorr & "'"))
	
	v_cuenta = v_cuenta1 + v_cuenta2 + v_cuenta3
	
	if v_cuenta > 0 then
		v_descripcion = conexion.ConsultaUno("select b.tspl_tdesc + ' ' + a.sapl_tdesc from salidas_plan a, tipos_salidas_plan b where a.tspl_ccod = b.tspl_ccod and cast(a.sapl_ncorr as varchar)= '" & v_sapl_ncorr & "'")
		msj_error = msj_error & "- No se puede eliminar la salida " & v_descripcion & ".\n"
		f_salidas.EliminaFilaPost i_		
	end if
next

conexion.MensajeError msj_error
f_salidas.MantieneTablas false


'----------------------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
