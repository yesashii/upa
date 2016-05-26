<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->


<%
Function ComprobarEliminacion(p_formulario, p_parametros)
	Dim p, i
	Dim v_tabla, v_campo
	Dim sql
	Dim v_cuenta
	Dim mensaje, linea, tipo
	
	
	'response.Write(p_formulario.CuentaPost): response.Flush()
	
	mensaje = ""

	
	for each p in p_parametros
		v_tabla = p(0)
		v_campo = p(1)
		

		for i = 0 to p_formulario.CuentaPost - 1
			sql = "select count(*) from " & v_tabla & " where cast(" & v_campo & " as varchar) = '" & p_formulario.ObtenerValorPost(i, v_campo) & "'"
			'response.Write(sql)			
			v_cuenta = CInt(conexion.ConsultaUno(sql))
	
			if v_cuenta > 0 then				
				tipo = conexion.ConsultaUno("select b.treq_tdesc from requisitos_plan a, tipos_requisitos_titulo b where a.treq_ccod = b.treq_ccod and cast(a.repl_ncorr as varchar) = '" & p_formulario.ObtenerValorPost(i, v_campo) & "'")
				linea = "No se puede eliminar el tipo " & tipo & ", porque hay alumnos que tienen ingresado el requisito."				
				mensaje = mensaje & linea
				
				p_formulario.EliminaFilaPost i
			end if
		next		
	next
	
	ComprobarEliminacion = mensaje
	
End Function


'------------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_requisitos = new CFormulario
f_requisitos.Carga_Parametros "adm_requisitos_adicionales.xml", "requisitos"
f_requisitos.Inicializar conexion
f_requisitos.ProcesaForm


'response.Write(f_requisitos.CuentaPost): response.Flush()

msj_error = ComprobarEliminacion (f_requisitos, Array(Array("requisitos_titulacion", "repl_ncorr")))
conexion.MensajeError msj_error

f_requisitos.MantieneTablas false


'------------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>

