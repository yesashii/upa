<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
'for each k in request.QueryString
'	response.Write(k&" = "&request.QueryString(k)&"<br>")
'next
'response.End()

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

if v_estado_solicitud <>"" and v_codigo_solicitud <>"" and area_ccod <> "" then

estado_final=2
	
	select case (area_ccod)
		case 60:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_audiovisual set esol_ccod="&estado_final&" where ccau_ncorr="&v_codigo_solicitud&" " 
		case 99:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_biblioteca set esol_ccod="&estado_final&" where ccbi_ncorr="&v_codigo_solicitud&" "
		case 15:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_computacion set esol_ccod="&estado_final&" where ccco_ncorr="&v_codigo_solicitud&" "
		case 77,78,79,80: 
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_servicios_generales set esol_ccod="&estado_final&" where ccsg_ncorr="&v_codigo_solicitud&" "
		
		case 125:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_personal set esol_ccod="&estado_final&" where ccpe_ncorr="&v_codigo_solicitud&" "
		case 27:
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_dir_docencia set esol_ccod="&estado_final&" where ccau_ncorr="&v_codigo_solicitud&" "
		case 69: 'aseguramiento de la calidad
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_aceguraCalidad set esol_ccod="&estado_final&" where ccau_ncorr="&v_codigo_solicitud&" "			
		case 87: 'DAE
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_dae set esol_ccod="&estado_final&" where ccau_ncorr="&v_codigo_solicitud&" "	
		case 83: 'DAE
			sql_update="update  presupuesto_upa.protic.centralizar_solicitud_vicerectoriaAcademica set esol_ccod="&estado_final&" where ccau_ncorr="&v_codigo_solicitud&" "		
	end select	
	
 	v_estado_transaccion=conexion2.ejecutaS(sql_update)
	
end if

'response.Write("<pre>"&sql_update&"</pre>")
'response.End()

if v_estado_transaccion=false  then
	'response.Write("<br>Todo MAL")
	session("mensaje_error")="Ocurrio un error, la solicitud no pudo ser dada de alta correctamente.\nVuelva a intentarlo."
else	
	'response.Write("<br>Todo bien")
	session("mensaje_error")="La solicitud seleccionada fue dada de alta correctamente."
end if

'response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
<script language="javascript1.1">
location.href="ingreso_presupuesto_directo_2015.asp?area_ccod=<%=area_ccod%>&codcaja=&nro_t=3";
</script>