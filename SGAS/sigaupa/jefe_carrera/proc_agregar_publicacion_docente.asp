<!-- #include file="../biblioteca/_conexion.asp" -->

<%
'for each x in request.Form 
'	response.Write(x&"->"&request.Form(x)&"<br>")
'next
'response.End()


publ_ccod = request.Form("publ_ccod")


set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"


formulario.carga_parametros "publicacion_docente.xml", "agregar_publicacion_docente"
formulario.inicializar conectar

formulario.procesaForm
if	publ_ccod="" then
	publ_ccod = conectar.consultauno("execute obtenersecuencia 'publicacion_docente'")
end if	
formulario.agregacampopost "publ_ccod", publ_ccod

formulario.mantienetablas false
'conectar.EstadoTransaccion false
'response.End()
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>