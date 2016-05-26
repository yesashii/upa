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
pare_ccod=request.form("b[0][pare_ccod]")

existe=conexion.ConsultaUno("select case count(*) when 0 then 'N' else 'S'end  from ocag_perfiles_areas_usuarios where pers_nrut="&pers_nrut&" and pare_ccod='"&pare_ccod&"'")
'response.write(existe&"<hr>")'
if existe= "N" then
query="insert into ocag_perfiles_areas_usuarios (pers_nrut,pare_ccod)values ("&pers_nrut&",'"&pare_ccod&"')"

'response.write(query)'
conexion.EjecutaS(query)


'Response.End()'

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="El Perfil ha sido asignado exitosamente"
else
	session("mensajeError")="Ocurrio un error al guardar"
end if
else
session("mensajeError")="El Perfil seleccinado ya estaba agregado"
end if
'response.End()'
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
CerrarActualizar();
</script>