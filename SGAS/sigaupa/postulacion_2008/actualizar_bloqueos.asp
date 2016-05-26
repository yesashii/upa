 <!-- #include file="../biblioteca/_conexion.asp" -->
<%
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

registros	=	request.Form("registros")
rut			=	request.Form("rut")

set conectar 	= new cconexion
set formulario 	= new cformulario

conectar.inicializar "upacifico"

formulario.carga_parametros 	"paulo.xml", "bloqueos"
formulario.inicializar 			conectar

'fecha	=	conectar.consultauno("select to_char(sysdate,'dd/mm/yyyy') from dual")
fecha	=	conectar.consultauno("select convert(varchar,getdate(),103)")

formulario.procesaForm
formulario.agregacampopost	"eblo_ccod"		,	2
formulario.agregacampopost	"bloq_fdesbloqueo",	fecha
formulario.mantienetablas false
'conectar.estadotransaccion	false

response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>