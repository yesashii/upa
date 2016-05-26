<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
for each k in request.form
	response.Write(k&" = "&request.Form(k)&"<br>")
next
'response.End()

v_dalu_ncorr= request.Form("datos[0][dalu_ncorr]")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set f_solicitud = new cFormulario
f_solicitud.carga_parametros "devolucion_alumno.xml", "datos_funcionario"
f_solicitud.inicializar conexion
f_solicitud.procesaForm

v_usuario=negocio.ObtenerUsuario()

'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA OC *************
for fila = 0 to f_solicitud.CuentaPost - 1
	pers_nrut 		= f_solicitud.ObtenerValorPost (fila, "pers_nrut")
	pers_xdv 		= f_solicitud.ObtenerValorPost (fila, "pers_xdv")
	pers_tnombre 	= f_solicitud.ObtenerValorPost (fila, "pers_tnombre")
	
	if 	pers_nrut<>"" then
		
		v_pers_ncorr=conexion.consultaUno("Select pers_ncorr from personas where pers_nrut="&pers_nrut)
		'inserta datos del proveedor y su direccion o los actualiza
		if v_pers_ncorr <>"" then
			sql_persona	=	" Update personas set pers_tnombre='"&pers_tnombre&"' "&_
							" where pers_nrut="&pers_nrut	
			sql_persona="select ''"							
		else
			v_pers_ncorr=conexion.consultauno("exec generasecuencia 'personas'")
			sql_persona	=	" insert into personas(pers_ncorr,pers_tnombre,pers_nrut,pers_xdv) values("&v_pers_ncorr&",'"&pers_tnombre&"',"&pers_nrut&",'"&pers_xdv&"' ) "
		end if
	
		conexion.estadotransaccion	conexion.ejecutas(sql_persona)
	end if

next



if EsVAcio(v_dalu_ncorr) or v_dalu_ncorr="" then
	
	v_dalu_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_devolucion_alumno'")
	f_solicitud.AgregaCampoPost "dalu_ncorr", v_dalu_ncorr
	
else
	url_final=request.ServerVariables("HTTP_REFERER")
end if

f_solicitud.AgregaCampoPost "pers_ncorr", v_pers_ncorr
f_solicitud.MantieneTablas false

'response.Write("<br/><b> 2: "&conexion.obtenerEstadoTransaccion&"</b>")
'response.Write("<br/><b> 2: "&url_final&"</b>")
'conexion.estadotransaccion false
'response.End()


if v_estado_transaccion=false  then
	session("mensaje_error")="No se pudo ingresar la solicitud de devolucion.\nVuelva a intentarlo."
else	
	session("mensaje_error")="La solicitud de devolucion fue ingresada correctamente."
end if
if url_final ="" then
	url_final=request.ServerVariables("HTTP_REFERER")&"?busqueda[0][dalu_ncorr]="&v_dalu_ncorr
end if
response.Redirect(url_final)
%>