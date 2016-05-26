<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->
<%

'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

secc_ccod=session("secc_ccod_trabajo")
registros=request.Form("regAlumnos")

set nf_alumnos			=	new cformulario
set conectar		=	new cconexion
conectar.inicializar	"upacifico"

set negocio			=	new cnegocio
negocio.inicializa	conectar

sql_secciones="UPDATE SECCIONES SET ESTADO_CIERRE_CCOD=2,audi_tusuario='"&negocio.obtenerUsuario&"',audi_fmodificacion=getDate() WHERE cast(SECC_CCOD as varchar)='"&secc_ccod&"'"
SQL_CARGAS_ACADEMICAS=" UPDATE CARGAS_ACADEMICAS SET ESTADO_CIERRE_CCOD=2,audi_tusuario='"&negocio.obtenerUsuario&"',audi_fmodificacion=getDate() WHERE cast(SECC_CCOD as varchar)='"&secc_ccod&"'"
'response.Write("<br>"&sql_secciones)
'response.Write("<br>"&SQL_CARGAS_ACADEMICAS)
conectar.EstadoTransaccion conectar.EjecutaS(sql_secciones)
conectar.EstadoTransaccion conectar.EjecutaS(SQL_CARGAS_ACADEMICAS)
	
response.Redirect(request.ServerVariables("HTTP_REFERER"))
%>