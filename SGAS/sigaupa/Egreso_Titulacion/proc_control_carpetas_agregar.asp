<!-- #include file = "../biblioteca/_conexion.asp" -->
<%
set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()
'conectar.estadotransaccion false
formulario.carga_parametros "control_carpetas.xml", "mantiene_carpeta"
formulario.inicializar conectar

formulario.procesaForm
formulario.mantienetablas false
'response.write(request.ServerVariables("HTTP_REFERER"))
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.End()
'response.Redirect("editar_asignatura.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>