<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next

set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_mantiene_ciudades = new CFormulario
f_mantiene_ciudades.Carga_Parametros "adm_homologaciones_ciud.xml", "mantiene_homologaciones"
f_mantiene_ciudades.Inicializar conexion
f_mantiene_ciudades.ProcesaForm


for filai = 0 to f_mantiene_ciudades.CuentaPost - 1
	
	ciudh_ccod=f_mantiene_ciudades.ObtenerValorPost (filai, "ciudh_ccod")
	if ciudh_ccod="" then
		ciudh_ccod= conexion.ConsultaUno("execute obtenersecuencia 'ufe_ciudades_homologadas'")
		f_mantiene_ciudades.agregacampopost "ciudh_ccod",ciudh_ccod
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
