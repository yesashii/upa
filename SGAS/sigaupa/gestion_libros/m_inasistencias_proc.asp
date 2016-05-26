<!-- #include file="../biblioteca/_conexion.asp" -->
<!-- #include file="../biblioteca/_negocio.asp" -->

<%
'nueva_secc_ccod=request.Form("d[0][secc_ccod]")
'cantidad_transferible=request.Form("cantidad_transferible")
'for each k in request.Form()
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next
'response.End()

set conectar = new cconexion
set formulario = new cformulario

conectar.inicializar "upacifico"
msj_errores=""

set negocio = new CNegocio
negocio.Inicializa conectar

usuario = negocio.obtenerUsuario


formulario.carga_parametros "m_recuperativas.xml", "listado_asignaturas"
formulario.inicializar conectar


formulario.procesaForm
for i=0 to formulario.cuentaPost - 1
	libr_ncorr=formulario.obtenerValorPost(i,"libr_ncorr")
	bloq_ccod=formulario.obtenerValorPost(i,"bloq_ccod")
	fecha_cambio=formulario.obtenerValorPost(i,"cale_fcalendario")
	observacion=formulario.obtenerValorPost(i,"observacion")
	opli_ccod = formulario.obtenerValorPost(i,"opli_ccod")
	opli_tdesc = conectar.consultaUno("select opli_tdesc from observaciones_prestamos_libros where cast(opli_ccod as varchar)='"&opli_ccod&"'")
	if opli_ccod="" then
		opli_ccod=0
		opli_tdesc=""
	end if	
	if esVacio(observacion) then
		observacion="No Asiste a esta clase"
	end if
	
	if not EsVacio(libr_ncorr) and not EsVacio(bloq_ccod) and not EsVacio(fecha_cambio) then
		pres_ncorr=conectar.consultauno("execute obtenersecuencia 'prestamos_libros'")
		'ahora debemos hacer una inserción en la tabla prestamos_libros para esta inasistencia a clases
		consulta_insercion = " Insert into prestamos_libros (pres_ncorr,libr_ncorr,bloq_ccod,pres_fprestamo,pres_estado_prestamo,"&_
         		             " pres_tobservacion_prestamo,pres_fdevolucion,pres_estado_devolucion,audi_tusuario,audi_fmodificacion,opli_ccod_prestamo) values "&_
							 " ("&pres_ncorr&","&libr_ncorr&","&bloq_ccod&",'"&fecha_cambio&"',6,'"&opli_tdesc&"','"&fecha_cambio&"',3,'inasistencia por "&usuario&"',getDate(),"&opli_ccod&") "
        conectar.ejecutaS consulta_insercion						  
		'response.Write("<br>"&consulta_update)
	end if 
next 
conectar.MensajeError "La inasistencia ha sigo ingresada exitosamente"
'formulario.mantienetablas true
'conectar.estadotransaccion false
'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
