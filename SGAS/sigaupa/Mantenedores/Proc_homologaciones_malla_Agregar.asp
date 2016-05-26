<!-- #include file = "../biblioteca/_conexion.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set f_planes = new CFormulario
f_planes.Carga_Parametros "m_homologaciones_malla.xml", "f_nuevo"
f_planes.Inicializar conexion
f_planes.ProcesaForm
'f_planes.ListarPost

'response.End()

'area_ccod = request.querystring("area_ccod")
homo_ccod = request.querystring("homo_ccod")
homo_nresolucion = request.Form("homo[0][homo_nresolucion]")

verif_nresolucion = conexion.consultaUno("Select count(homo_ccod) as contador from homologacion where homo_nresolucion='" & homo_nresolucion&"'")
if	cint(verif_nresolucion) > 0 then
	f_planes.EliminaFilaPost 0 
	session("mensajeError") = "Error, Homologación no fue creada. Número resolución ya existe.\nFavor intentarlo nuevamente."
	response.Redirect(request.ServerVariables("HTTP_REFERER"))
else
	if	homo_ccod = "" then
		homo_ccod = conexion.consultauno("exec ObtenerSecuencia 'homologacion'")
   		f_planes.AgregaCampoPost "homo_ccod", homo_ccod
	else
   		f_planes.AgregaCampoPost "homo_ccod", homo_ccod
	end if
end if	


'f_planes.MantieneTablas false
conexion.EstadoTransaccion f_planes.MantieneTablas(false)
transaccion = conexion.obtenerEstadoTransaccion
if 	transaccion=TRUE then
	session("mensajeError") = "Homologación creada con éxito."
else
	session("mensajeError") = "Error, Homologación no fue creada.\nFavor intentarlo nuevamente."
end if
'conexion.estadotransaccion false  'roolback 
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>