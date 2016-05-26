 <!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.Form
	'response.write(k&" = "&request.Form(k)&"<br>")
'next

malla_ccod=request.form("mall_ccod")
set conectar = new CConexion
conectar.Inicializar "upacifico"
set formulario = new cformulario


formulario.carga_parametros "editar_malla.xml", "edicion_malla"
formulario.inicializar conectar

formulario.procesaForm
formulario.agregacampopost "mall_ccod",malla_ccod
'formulario.listarpost
formulario.mantienetablas false

response.redirect(request.ServerVariables("HTTP_REFERER"))
'response.Redirect("editar_malla.asp")

%>