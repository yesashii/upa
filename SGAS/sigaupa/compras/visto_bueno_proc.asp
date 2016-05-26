<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

v_vibo_ccod	= request.Form("datos[0][vibo_ccod]")
v_tipo 		= request.Form("tsol_ccod")
v_solicitud = request.Form("cod_solicitud")


if  v_vibo_ccod <> "" and v_tipo<>"" and v_solicitud <>""  then

	Select Case v_tipo
	   Case 1:
		'solicitud a proveedores
			v_tipo_solicitud="PAGO A PROVEEDORES"
			sql_update="Update ocag_solicitud_giro set vibo_ccod="&v_vibo_ccod&" where sogi_ncorr="&v_solicitud
	
	   Case 2:
		'reembolso gastos
			v_tipo_solicitud="REEMBOLSO DE GASTOS"	
			sql_update="Update ocag_reembolso_gastos set vibo_ccod="&v_vibo_ccod&" where rgas_ncorr="&v_solicitud
	
	   Case 3:
		'fondos a rendir
			v_tipo_solicitud="FONDO A RENDIR"	
			sql_update="Update ocag_fondos_a_rendir set vibo_ccod="&v_vibo_ccod&" where fren_ncorr="&v_solicitud
	
	   Case 4:
		'viaticos
			v_tipo_solicitud="SOLICITUD DE VIATICO"
			sql_update="Update ocag_solicitud_viatico set vibo_ccod="&v_vibo_ccod&" where sovi_ncorr="&v_solicitud
	
	   Case 5:
		'devolucion alumnos
			v_tipo_solicitud="DEVOLUCION ALUMNO"
			sql_update="Update ocag_devolucion_alumno set vibo_ccod="&v_vibo_ccod&" where dalu_ncorr="&v_solicitud
			
	   Case 6:
		'fondo fijo
			v_tipo_solicitud="NUEVO FONDO FIJO"										
			sql_update="Update ocag_fondo_fijo set vibo_ccod="&v_vibo_ccod&" where ffij_ncorr="&v_solicitud
	end select
end if
'response.Write(v_tipo_solicitud&" -->"&sql_update)
conexion.estadotransaccion	conexion.ejecutas(sql_update)


'response.Write("<br/><b> 2: "&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false
'response.End()

	
if conexion.obtenerEstadoTransaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="No se pudo actualizar el estado a la solicitud.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="El estado de la Solicitud fue actualizado correctamente."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>