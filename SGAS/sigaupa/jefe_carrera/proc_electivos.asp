<!-- #include file="../biblioteca/_conexion.asp" -->

<%
asig_ccod=request.Form("asig_ccod")
mall_ccod = request.Form("mall_ccod")


set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"


formulario.carga_parametros "buscar_asignaturas_elec.xml", "form_busca_asig"
formulario.inicializar conectar



formulario.procesaForm
formulario.agregacampopost "asig_ccod", asig_ccod
formulario.agregacampopost "mall_ccod", mall_ccod

formulario.mantienetablas false
session("mensajeError") = "Electivo Guardado" 
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
//CerrarActualizar();
</script>