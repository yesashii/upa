<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'conectar.estadotransaccion false

formulario.carga_parametros "configurar_plan.xml", "configurar_plan"
formulario.inicializar conectar

formulario.procesaForm
formulario.mantienetablas false
'response.End()
'response.Redirect("editar_asignatura.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))
if conectar.ObtenerEstadoTransaccion then
	conectar.MensajeError "Se ha guardado correctamente los cambios al plan de estudios."
else
	conectar.MensajeError "Ha ocurrido un error no se pudo realizar los cambios solicitados."	
end if

%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	CerrarActualizar();
</script>