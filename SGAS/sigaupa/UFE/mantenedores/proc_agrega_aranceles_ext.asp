<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_mantiene_ciudades = new CFormulario
f_mantiene_ciudades.Carga_Parametros "adm_aranceles_ext.xml", "mantiene_aranceles_ext"
f_mantiene_ciudades.Inicializar conexion
f_mantiene_ciudades.ProcesaForm


for filai = 0 to f_mantiene_ciudades.CuentaPost - 1
	
	aran_ccor=f_mantiene_ciudades.ObtenerValorPost (filai, "aran_ccor")
	if aran_ccor="" then
		aran_ccor= conexion.ConsultaUno("execute obtenersecuencia 'ufe_aranceles_ext'")
		f_mantiene_ciudades.agregacampopost "aran_ccor",aran_ccor
	end if
	'v_estado_transaccion=conexion.ejecutaS(sql_carrera)
	'response.Write("<b>estado:</b>"&conexion.obtenerEstadoTransaccion)
next


v_estado_transaccion=f_mantiene_ciudades.MantieneTablas (false)


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
