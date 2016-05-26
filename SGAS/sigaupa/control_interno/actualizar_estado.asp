<!-- #include file="../biblioteca/_conexion.asp" -->

<%

set conectar = new cconexion
set formulario = new cformulario
set busca	= new cVariables

conectar.inicializar "desauas"
busca.procesaForm

if busca.nrofilas("CE") > 0 then
	formulario.carga_parametros "paulo.xml", "cambia_estado"
	formulario.inicializar conectar

	formulario.procesaForm
	formulario.agregacampopost "ecom_ccod", "5"
	formulario.mantienetablas false
	
	response.Redirect(request.ServerVariables("HTTP_REFERER"))

else
	formulario.carga_parametros "paulo.xml", "cambia_estado2"
	formulario.inicializar conectar

	formulario.procesaForm
	formulario.agregacampopost "ecom_ccod", "1"
	formulario.mantienetablas false
	
	response.Redirect(request.ServerVariables("HTTP_REFERER"))

end if

'formulario.listarpost
%>
