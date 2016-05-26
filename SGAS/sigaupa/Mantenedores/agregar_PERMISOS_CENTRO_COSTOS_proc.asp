<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'for each k in request.form'
'	response.write(k&"="&request.Form(k)&"<br>")'
'next'
'Uresponse.End()'

pers_nrut=request.form("b[0][pers_nrut]")
ccod_tcodigo=request.form("b[0][ccos_tcodigo]")

existe=conexion.ConsultaUno("select case count(*) when 0 then 'N' else 'S'end  from ocag_permisos_centro_costo where pers_nrut="&pers_nrut&" and ccos_tcodigo='"&ccod_tcodigo&"'")
'response.write(existe&"<hr>")'
if existe= "N" then
query="insert into ocag_permisos_centro_costo (pers_nrut,ccos_tcodigo)values ("&pers_nrut&",'"&ccod_tcodigo&"')"

'response.write(query)'
conexion.EjecutaS(query)


'Response.End()'

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="El Centro de costo ha sido asignado exitosamente"
else
	session("mensajeError")="Ocurrio un error al guardar"
end if
else
session("mensajeError")="El centro de costo seleccinado ya fue ingresado"
end if
'response.End()'
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>