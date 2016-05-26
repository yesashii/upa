<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
estado_transaccion=true
set conectar = new CConexion
conectar.Inicializar "upacifico"



set formulario = new cformulario
formulario.carga_parametros "programa_asignatura.xml", "elimina_unidades"
formulario.inicializar conectar
formulario.procesaForm

'formulario.ListarPost
formulario.agregaCampoPost "PRAS_CCOD", REQUEST.Form("PRAS_CCOD")
formulario.mantieneTablas  false


response.redirect(request.ServerVariables("HTTP_REFERER"))
%>