<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
on error resume next
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

formulario.carga_parametros  "detalle_postulacion_new.xml","f_detalle_otec_extension"
formulario.inicializar conectar
formulario.procesaForm
	

formulario.mantienetablas false
if conectar.obtenerEstadoTransaccion then 
	conectar.MensajeError "Observación guardada correctamente"
end if

%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	CerrarActualizar();
</script>