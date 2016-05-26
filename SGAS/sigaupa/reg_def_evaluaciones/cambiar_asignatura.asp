<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.form(k)&"<br>")
'next

set conectar		=	new cconexion
set negocio			=	new cnegocio

conectar.inicializar	"desauas"
negocio.inicializa	conectar


secc_ccod=request.Form("secc_ccod")
tipo_asig=request.Form("tipo_asignatura")
response.Write(tipo_asig&"<br>")
response.Write(secc_ccod)
t_asig=conectar.consultauno("select tasg_ccod from tipos_asignatura where tasg_ccod<>'"&tipo_asig&"'")

sentencia=" update secciones set tasg_ccod='"&t_asig&"' ," & _
		  " audi_tusuario='"&negocio.obtenerusuario&"', " & _
		  " audi_fmodificacion=sysdate"	& _
		  " where secc_ccod='"&secc_ccod&"'"
response.Write(sentencia)
conectar.EstadoTransaccion conectar.EjecutaS(sentencia)		  
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>