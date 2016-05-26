<!-- #include file="../biblioteca/_conexion.asp" -->

<%
publ_ccod = request.Form("publ_ccod")

set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"


formulario.carga_parametros "otras_actividades.xml", "agregar_otras_actividades"
formulario.inicializar conectar

formulario.procesaForm
if	publ_ccod = "" then
	publ_ccod = conectar.consultauno("execute obtenersecuencia 'publicacion_docente'")
end if	
formulario.agregacampopost "publ_ccod", publ_ccod
formulario.agregacampopost "tpub_ccod", 3 ' tipo de documentos OTRAS ACTIVIDADES

formulario.mantienetablas FALSE
'response.End()
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>