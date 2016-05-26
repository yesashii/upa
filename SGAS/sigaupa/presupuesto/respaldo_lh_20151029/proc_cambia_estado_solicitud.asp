<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
'for each k in request.QueryString
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
'response.end()

v_estado_solicitud	=	request.QueryString("etd")
v_codigo_solicitud	=	request.QueryString("cod")
nro_t				=	request.QueryString("nro")
area_ccod			=	request.QueryString("area")


set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

if v_estado_solicitud <>"" and v_codigo_solicitud <>"" and nro_t <> "" then

if v_estado_solicitud=1 and v_estado_solicitud<>2 then
	estado_final=3
else
	estado_final=1
end if
	
	select case (nro_t)
		case 1:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_audiovisual set esol_ccod="&estado_final&" where ccau_ncorr="&v_codigo_solicitud&" " 
		case 2:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_biblioteca set esol_ccod="&estado_final&" where ccbi_ncorr="&v_codigo_solicitud&" "
		case 3:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_computacion set esol_ccod="&estado_final&" where ccco_ncorr="&v_codigo_solicitud&" "
		case 4:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_servicios_generales set esol_ccod="&estado_final&" where ccsg_ncorr="&v_codigo_solicitud&" "
		case 5:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_personal set esol_ccod="&estado_final&" where ccpe_ncorr="&v_codigo_solicitud&" "
		case 6:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_dir_docencia set esol_ccod="&estado_final&" where ccau_ncorr="&v_codigo_solicitud&" "			
	end select	
'response.Write(sql_update)
'response.end()
 	v_estado_transaccion=conexion2.ejecutaS(sql_update)
end if

'response.Write("<pre>"&sql_update&"</pre>")
'response.End()

if estado_final=3 then
	txt_estado="Anulada"
else
	txt_estado="dejada Pendiente"
end if	

if v_estado_transaccion=false  then
	'response.Write("<br>Todo MAL")
	session("mensaje_error")="Ocurrio un error, la solicitud no pudo ser "&txt_estado&" correctamente.\nVuelva a intentarlo."
else	
	'response.Write("<br>Todo bien")
	session("mensaje_error")="La solicitud seleccionada fue "&txt_estado&" correctamente."
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
<script language="javascript1.1">
location.href="INGRESO_PRESUPUESTO_CENTRALIZADO.ASP?area_ccod=<%=area_ccod%>&nro_t=<%=nro_t%>";
</script>