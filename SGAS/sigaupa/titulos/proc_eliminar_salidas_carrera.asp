<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_salidas = new CFormulario
f_salidas.Carga_Parametros "adm_salidas_carrera.xml", "salidas"
f_salidas.Inicializar conexion
f_salidas.ProcesaForm


msj_error = ""
for i_ = 0 to f_salidas.CuentaPost - 1
	v_saca_ncorr = f_salidas.ObtenerValorPost(i_, "saca_ncorr")
	v_cuenta1 = CInt(conexion.ConsultaUno("select count(*) from salidas_alumnos where cast(sapl_ncorr as varchar)= '" & v_saca_ncorr & "'"))
	v_cuenta2 = CInt(conexion.ConsultaUno("select count(*) from requisitos_carrera where cast(saca_ncorr as varchar)= '" & v_saca_ncorr & "'"))
	v_cuenta3 = CInt(conexion.ConsultaUno("select count(*) from asignaturas_salidas_carrera where cast(saca_ncorr as varchar)= '" & v_saca_ncorr & "'"))
	
	v_cuenta = v_cuenta1 + v_cuenta2 + v_cuenta3
	
	if v_cuenta > 0 then
		v_descripcion = conexion.ConsultaUno("select b.tsca_tdesc + ' ' + a.saca_tdesc from salidas_carrera a, tipos_salidas_carrera b where a.tsca_ccod = b.tsca_ccod and cast(a.saca_ncorr as varchar)= '" & v_saca_ncorr & "'")
		msj_error = msj_error & "- No se puede eliminar la salida " & v_descripcion & ".\n"
		f_salidas.EliminaFilaPost i_		
	end if
next

conexion.MensajeError msj_error
f_salidas.MantieneTablas false


'----------------------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
