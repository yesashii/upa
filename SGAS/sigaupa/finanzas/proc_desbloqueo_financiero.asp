<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_rut_usuario = negocio.ObtenerUsuario


set f_alumno = new CFormulario
f_alumno.Carga_Parametros "desbloqueo_financiero.xml", "alumno"
f_alumno.Inicializar conexion
f_alumno.ProcesaForm


for i_ = 0 to f_alumno.CuentaPost - 1
	v_desbloqueado = f_alumno.ObtenerValorPost(i_, "desbloqueado")
	
	if v_desbloqueado = "S" then
		sentencia = "exec inserta_desbloqueo '" & f_alumno.ObtenerValorPost(i_, "pers_nrut") & "', '" & f_alumno.ObtenerValorPost(i_, "tdes_ccod") & "', '" & f_alumno.ObtenerValorPost(i_, "peri_ccod") & "'"
		'conexion.EjecutaS sentencia
		conexion.EstadoTransaccion conexion.EjecutaS(sentencia)
	else
		sentencia = "update desbloqueos_especiales set dees_bvigente = 'N', audi_tusuario = '" & v_rut_usuario & "', audi_fmodificacion = getdate() where cast(dees_ncorr as varchar) = '" & f_alumno.ObtenerValorPost(i_, "dees_ncorr") & "'"
		'conexion.EjecutaS sentencia
		conexion.EstadoTransaccion conexion.EjecutaS(sentencia)
	end if	
next



'--------------------------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
