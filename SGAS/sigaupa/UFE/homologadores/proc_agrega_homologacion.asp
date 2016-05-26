<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_mantiene_carreras = new CFormulario
f_mantiene_carreras.Carga_Parametros "adm_homologaciones.xml", "mantiene_homologaciones"
f_mantiene_carreras.Inicializar conexion
f_mantiene_carreras.ProcesaForm

'for filai = 0 to f_mantiene_carreras.CuentaPost - 1
'	carr_ccod=f_mantiene_carreras.ObtenerValorPost (filai, "carr_ccod")
'	car_min_ncorr=f_mantiene_carreras.ObtenerValorPost (filai, "car_min_ncorr")
'	car_ing_ncorr=f_mantiene_carreras.ObtenerValorPost (filai, "car_ing_ncorr")
'	'v_estado_transaccion=conexion.ejecutaS(sql_carrera)
'	
'	'response.Write("<b>estado:</b>"&conexion.obtenerEstadoTransaccion)
'next
v_estado_transaccion=f_mantiene_carreras.MantieneTablas (false)
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
