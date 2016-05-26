<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_mantiene_carreras = new CFormulario
f_mantiene_carreras.Carga_Parametros "adm_carreras_min.xml", "mantiene_carreras"
f_mantiene_carreras.Inicializar conexion
f_mantiene_carreras.ProcesaForm

for filai = 0 to f_mantiene_carreras.CuentaPost - 1
	
	car_min_ncorr=f_mantiene_carreras.ObtenerValorPost (filai, "car_min_ncorr")
	if car_min_ncorr="" then
		car_min_ncorr= conexion.ConsultaUno("execute obtenersecuencia 'carreras_mineduc'")
		f_mantiene_carreras.agregacampopost "car_min_ncorr",car_min_ncorr
	end if
	'v_estado_transaccion=conexion.ejecutaS(sql_carrera)
	v_estado_transaccion=f_mantiene_carreras.MantieneTablas (false)
	'response.Write("<b>estado:</b>"&conexion.obtenerEstadoTransaccion)
next

'response.End()

if v_estado_transaccion=false  then
	session("mensaje_error")="La carrera no pudo ser ingresada correctamente.\nVuelva a intentarlo."
else	
	session("mensaje_error")="La carrera fue ingresada correctamente."
end if

'conexion.estadoTransaccion false
'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))



%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	//self.opener.location.reload();
	//window.close();
</script>
