<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next

'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion


set f_mantiene_cuentas_ingresos = new CFormulario
f_mantiene_cuentas_ingresos.Carga_Parametros "adm_cuentas_cargos.xml", "mantiene_cuentas"
f_mantiene_cuentas_ingresos.Inicializar conexion
f_mantiene_cuentas_ingresos.ProcesaForm

'v_estado_transaccion=conexion.ejecutaS(sql_carrera)

v_estado_transaccion=f_mantiene_cuentas_ingresos.MantieneTablas (false)
'response.Write("<br><b>estado:</b>"&conexion.obtenerEstadoTransaccion)


if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="La cuenta no pudo ser ingresada correctamente.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="La cuenta fue ingresada correctamente."
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
