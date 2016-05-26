<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next


v_cod	=	request.Form("cod")
nro_t	=	request.Form("nro")
v_motivo= 	request.Form("rechazo")


set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

if v_cod <> "" then

	estado_final=4

	select case (nro_t)
		case 1:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_audiovisual set esol_ccod="&estado_final&", ccau_tmotivo='"&v_motivo&"' where ccau_ncorr="&v_cod&" " 
		case 2:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_biblioteca set esol_ccod="&estado_final&", ccbi_tmotivo='"&v_motivo&"' where ccbi_ncorr="&v_cod&" "
		case 3:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_computacion set esol_ccod="&estado_final&", ccco_tmotivo='"&v_motivo&"' where ccco_ncorr="&v_cod&" "
		case 4:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_servicios_generales set esol_ccod="&estado_final&", ccsg_tmotivo='"&v_motivo&"' where ccsg_ncorr="&v_cod&" "
		case 5:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_personal set esol_ccod="&estado_final&", ccpe_tmotivo='"&v_motivo&"' where ccpe_ncorr="&v_cod&" "
	end select	
'response.Write(sql_update)
'response.End()	
 	v_estado_transaccion=conexion2.ejecutaS(sql_update)
end if


if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="La solicitud seleccionada No pudo ser rechazada.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="La solicitud seleccionada fue rechazada correctamente."
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>

<script language="javascript" src="../biblioteca/funciones.js"></script>
<script language="javascript">
	self.opener.location.reload();
	window.close();
</script>
