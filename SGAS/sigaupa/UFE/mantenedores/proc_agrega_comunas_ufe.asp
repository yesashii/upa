<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_mantiene_ciudades = new CFormulario
f_mantiene_ciudades.Carga_Parametros "adm_comunas_ufe.xml", "mantiene_comunas"
f_mantiene_ciudades.Inicializar conexion
f_mantiene_ciudades.ProcesaForm

for filai = 0 to f_mantiene_ciudades.CuentaPost - 1
	
	uhciu_ccod=f_mantiene_ciudades.ObtenerValorPost (filai, "uhciu_ccod")
	if uhciu_ccod="" then
		uhciu_ccod= conexion.ConsultaUno("execute obtenersecuencia 'ufe_ciudades'")
		f_mantiene_ciudades.agregacampopost "uhciu_ccod",uhciu_ccod
	end if
	'v_estado_transaccion=conexion.ejecutaS(sql_carrera)
	'response.Write("<b>estado:</b>"&conexion.obtenerEstadoTransaccion)
next

v_estado_transaccion=f_mantiene_ciudades.MantieneTablas (false)
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
