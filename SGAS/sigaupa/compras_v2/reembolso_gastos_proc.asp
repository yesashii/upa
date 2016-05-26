<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

v_sogi_ncorr= request.Form("datos[0][sogi_ncorr]")

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

set f_proveedor = new cFormulario
f_proveedor.carga_parametros "reembolso_gasto.xml", "datos_proveedor"
f_proveedor.inicializar conexion
f_proveedor.procesaForm

v_usuario=negocio.ObtenerUsuario()

'**************************** SE RECORRE LOS REGISTROS DE LA PERSONA PARA INSERTAR DATOS DE LA OC *************
for fila = 0 to f_proveedor.CuentaPost - 1
	pers_nrut 		= f_proveedor.ObtenerValorPost (fila, "pers_nrut")
	pers_xdv 		= f_proveedor.ObtenerValorPost (fila, "pers_xdv")
	pers_tnombre 	= f_proveedor.ObtenerValorPost (fila, "pers_tnombre")
	
	if 	pers_nrut<>"" then
		
		v_pers_ncorr=conexion.consultaUno("Select pers_ncorr from personas where pers_nrut="&pers_nrut)
		'inserta datos del proveedor y su direccion o los actualiza
		if v_pers_ncorr <>"" then
			sql_persona	=	" Update personas set pers_tnombre='"&pers_tnombre&"' "&_
							" where pers_nrut="&pers_nrut
			sql_persona="select ''"								
		else
			v_pers_ncorr=conexion.consultauno("exec generasecuencia 'personas'")
			sql_persona	=	" insert into personas(pers_tnombre,pers_nrut,pers_xdv) values('"&pers_tnombre&"', '"&pers_nrut&"', '"&pers_xdv&"') "
		end if
	
		conexion.estadotransaccion	conexion.ejecutas(sql_persona)
	end if

'response.Write("<br/><b> 1: "&conexion.obtenerEstadoTransaccion&"</b>")
'response.Write("<hr>"&sql_persona&"<br/>"&sql_direccion)
next


if EsVAcio(v_sogi_ncorr) or v_sogi_ncorr="" then
	url_final=request.ServerVariables("HTTP_REFERER")
	v_sogi_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_solicitud_giro'")

	f_proveedor.AgregaCampoPost "pers_ncorr_proveedor", v_pers_ncorr
	f_proveedor.AgregaCampoPost "sogi_ncorr", v_sogi_ncorr
	f_proveedor.MantieneTablas false
	
end if

'response.Write("<br/><b> 2: "&conexion.obtenerEstadoTransaccion&"</b>")

set f_detalle = new cFormulario
f_detalle.carga_parametros "reembolso_gasto.xml", "detalle_giro"
f_detalle.inicializar conexion
f_detalle.procesaForm



for fila = 0 to f_detalle.CuentaPost - 1
	
	v_drga_ndocto 		= f_detalle.ObtenerValorPost (fila, "drga_ndocto")
	'response.Write("<br>Dato 1"&v_drga_ndocto)
	if v_drga_ndocto<>"" then
		v_drga_ncorr=conexion.consultauno("exec obtenersecuencia 'ocag_detalle_reembolso_gasto'")
		f_detalle.AgregaCampoFilaPost fila, "drga_ncorr", v_drga_ncorr
		f_detalle.AgregaCampoFilaPost fila, "sogi_ncorr", v_sogi_ncorr
	else
		f_detalle.EliminaFilaPost fila 
	end if
next

f_detalle.MantieneTablas false

'response.Write("<br><b>"&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false
'response.End()


if v_estado_transaccion=false  then
'response.Write("<br>Todo MAL")
	session("mensaje_error")="No se pudo ingresar la solicitud reembolso de gastos.\nVuelva a intentarlo."
else	
'response.Write("<br>Todo bien")
	session("mensaje_error")="La solicitud de reembolso de gastos fue ingresada correctamente."
end if
if url_final ="" then
	url_final=request.ServerVariables("HTTP_REFERER")&"?busqueda[0][sogi_ncorr]="&v_sogi_ncorr
end if
response.Redirect(url_final)

%>