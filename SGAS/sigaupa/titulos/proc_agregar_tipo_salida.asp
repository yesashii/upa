<!-- #include file = "../biblioteca/_conexion.asp" -->

<%

set conexion = new CConexion
conexion.Inicializar "upacifico"

tsca_ccod = request.Form("em[0][tsca_ccod]")

set f_mantiene_carreras = new CFormulario
f_mantiene_carreras.Carga_Parametros "adm_tipos_salidas.xml", "mantiene_salidas"
f_mantiene_carreras.Inicializar conexion
f_mantiene_carreras.ProcesaForm

if tsca_ccod = "" then
	tsca_ccod = conexion.ConsultaUno("select isnull(max(tsca_ccod),0) + 1 from tipos_salidas_carrera")
end if
f_mantiene_carreras.AgregaCampoPost "tsca_ccod", tsca_ccod

v_estado_transaccion=f_mantiene_carreras.MantieneTablas (false)



if v_estado_transaccion=false  then
	session("mensaje_error")="El tipo de salida no pudo ser ingresado correctamente.\nVuelva a intentarlo."
else	
	session("mensaje_error")="El tipo de salida fue ingresado correctamente."
end if

'conexion.estadoTransaccion false
'response.End()

'response.Redirect(request.ServerVariables("HTTP_REFERER"))



%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>
