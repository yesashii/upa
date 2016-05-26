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

formulario.carga_parametros "agregar_recuperativas.xml", "listado_asignaturas"
formulario.inicializar conectar

formulario.procesaForm
for i=0 to formulario.cuentaPost - 1
	libr_ncorr=formulario.obtenerValorPost(i,"libr_ncorr")
	pres_ncorr=formulario.obtenerValorPost(i,"pres_ncorr")
	bloq_ccod=formulario.obtenerValorPost(i,"bloq_ccod")
	fecha_recuperacion=formulario.obtenerValorPost(i,"fecha_recuperacion")
	fecha_inasistencia = conectar.consultaUno("select pres_fprestamo from prestamos_libros where cast(pres_ncorr as varchar)='"&pres_ncorr&"'")
	
	diferencia = conectar.consultaUno("select case  when convert(varchar,getDate(),103) < convert(datetime,'"&fecha_recuperacion&"',103) then 1 else 0 end")
	'response.Write(diferencia)
	if diferencia <> "1" then 
		if not EsVacio(libr_ncorr) and not EsVacio(bloq_ccod) and not EsVacio(pres_ncorr)  then
			'pres_ncorr=conectar.consultauno("execute obtenersecuencia 'prestamos_libros'")
			'ahora debemos hacer una inserción en la tabla prestamos_libros para esta recuperación de clases
			consulta_insercion = " Insert into registro_recuperativas (pres_ncorr,libr_ncorr,bloq_ccod,pres_fprestamo,pres_estado_prestamo,"&_
								 " fecha_recuperacion,audi_tusuario,audi_fmodificacion) values "&_
								 " ("&pres_ncorr&","&libr_ncorr&","&bloq_ccod&",'"&fecha_inasistencia&"',5,'"&fecha_recuperacion&"','registrada por "&negocio.obtenerUsuario&"',getDate()) "
			conectar.ejecutaS consulta_insercion						  
			'response.Write("<br>"&consulta_insercion)
		end if 
    else
	    fechas_malas = true
	end if	
next 


if fechas_malas then
conectar.MensajeError "Imposible guardar la clase recuperativa ya que hay fechas que exceden el día actual."
conectar.estadotransaccion false
else
conectar.MensajeError "La Recuperativa a sido ingresada exitosamente"
end if
'formulario.mantienetablas true

'response.End()
response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>
