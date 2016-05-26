<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

sala_ccod	=	request.Form("sala")

set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

set salas = new cformulario
sede_ccod	=	negocio.obtenersede

salas.carga_parametros "adm_salas.xml", "agregar_salas"
salas.inicializar conectar

if sala_ccod = "" or isnull(sala_ccod) then
	sala_ccod=clng(conectar.consultauno("execute obtenersecuencia 'salas'"))
else
	sala_ccod=sala_ccod
end if
	
	salas.procesaform
	salas.agregacampopost	"sala_ccod",	sala_ccod
	salas.agregacampopost	"sede_ccod",	sede_ccod
	salas.agregacampopost	"esal_ccod",	1
'salas.listarpost

salas.mantienetablas false
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	self.opener.location.reload();
	window.close();
</script>