<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
on error resume next
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
nroVars = request.Form("nro_solicitudes")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.obtenerUsuario

for i = 0 to nroVars - 1
	codigo 		= request.Form("certificados["&i&"][sctg_ncorr]")
    estado 		= request.Form("certificados["&i&"][esctg_ccod]")
    pers_ncorr 	= request.Form("certificados["&i&"][pers_ncorr]")
    tipo  		= request.Form("certificados["&i&"][tctg_ccod]")
    observacion = request.Form("certificados["&i&"][observacion]")
	
	estado_registrado = conexion.consultaUno("select esctg_ccod from solicitud_certificados_tyg where cast(sctg_ncorr as varchar)='"&codigo&"' and cast(tctg_ccod as varchar)='"&tipo&"'")
	observacion_registrado = conexion.consultaUno("select isnull(observacion,'') from solicitud_certificados_tyg where cast(sctg_ncorr as varchar)='"&codigo&"' and cast(tctg_ccod as varchar)='"&tipo&"'")
	
	if cstr(estado_registrado) <> cstr(estado) or cstr(observacion_registrado) <> cstr(observacion) then
		c_update = " update solicitud_certificados_tyg set esctg_ccod = "&estado&", observacion='"&observacion&"', sctg_fmodificacion=getDate(),audi_tusuario='"&usuario&"',audi_fmodificacion=getDate()  where cast(sctg_ncorr as varchar)='"&codigo&"' and cast(tctg_ccod as varchar)='"&tipo&"'"
	    c_insert = " insert into historico_solicitud_certificados_tyg  select * from solicitud_certificados_tyg where cast(sctg_ncorr as varchar)='"&codigo&"' and cast(tctg_ccod as varchar)='"&tipo&"' "
	
	    'response.Write("<br>"&c_update)
		'response.Write("<br>"&c_insert)
	    
		conexion.ejecutaS c_update	
		conexion.ejecutaS c_insert
	end if
next

if conexion.ObtenerEstadoTransaccion then
	conexion.MensajeError "La modificación solicitada fue realizada exitosamente."
end if

'response.End()
'------------------------------------------------------------------------------
Response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
