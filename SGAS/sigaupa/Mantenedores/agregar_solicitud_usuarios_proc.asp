<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

pers_nrut=request.form("b[0][pers_nrut]")
tsol_ccod=request.form("b[0][tsol_ccod]")

existe=conexion.ConsultaUno("select case count(*) when 0 then 'N' else 'S'end  from ocag_permisos_solicitudes_usuarios where pers_nrut="&pers_nrut&" and tsol_ccod='"&tsol_ccod&"'")
'response.write(existe&"<hr>")
if existe= "N" then
	query="insert into ocag_permisos_solicitudes_usuarios (pers_nrut,tsol_ccod, audi_tusuario, audi_fmodificacion) values ("&pers_nrut&","&tsol_ccod&",'"&usuario&"', getdate())"
	'response.write(query)
	conexion.EjecutaS(query)

	if conexion.ObtenerEstadoTransaccion  then
		session("mensajeError")="El Tipo de solicitud ha sido asignado exitosamente"
	else
		session("mensajeError")="Ocurrio un error al guardar"
	end if
else
	session("mensajeError")="El Tipo de solicitud seleccionado ya estaba agregado"
end if

%>
<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	CerrarActualizar();
</script>