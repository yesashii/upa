<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
on error resume next
set conectar = new cconexion
conectar.inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

'for each k in request.form
	'response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()
set errores 	= new cErrores
dcur_ncorr = request.Form("dcur_ncorr")

	set formulario2 = new cformulario
	formulario2.carga_parametros "m_descuentos_diplomados_curso.xml", "mantiene_descuentos"
	formulario2.inicializar conectar
	formulario2.procesaForm
	for i=0 to formulario2.cuentaPost - 1
		tdet_ccod=formulario2.obtenerValorPost(i,"tdet_ccod")
		ddcu_mdescuento=formulario2.obtenerValorPost(i,"ddcu_mdescuento")
		if tdet_ccod <> "" and dcur_ncorr <> "" then
		   tiene_descuento = conectar.consultaUno("select case count(*) when 0 then 'N' else 'S' end from descuentos_diplomados_curso where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"' and cast(tdet_ccod as varchar)='"&tdet_ccod&"'")
			'response.Write(tiene_descuento)
			if tiene_descuento="N" then
			c_agregar_descuento = " insert into descuentos_diplomados_curso (DCUR_NCORR,TDET_CCOD,DDCU_MDESCUENTO,AUDI_TUSUARIO,AUDI_FMODIFICACION) "&_
							      " values ("&dcur_ncorr&","&tdet_ccod&","&ddcu_mdescuento&",'"&negocio.obtenerUsuario&"',getDate())"
			else
			c_agregar_descuento = " update descuentos_diplomados_curso set ddcu_mdescuento="&ddcu_mdescuento&",audi_tusuario='"&negocio.obtenerUsuario&"', audi_fmodificacion=getDate() "&_
			                     " where cast(dcur_ncorr as varchar)='"&dcur_ncorr&"' and cast(tdet_ccod as varchar)='"&tdet_ccod&"' "  
			end if					  
			'response.Write(c_agregar_descuento&"</br>")
			conectar.ejecutaS c_agregar_descuento
		end if
	next
	
	if conectar.obtenerEstadoTransaccion then 
		conectar.MensajeError "Descuentos ingresados exitosamente"
	end if

'response.write(request.ServerVariables("HTTP_REFERER"))
response.Redirect(request.ServerVariables("HTTP_REFERER"))
'response.End()
'response.Redirect("editar_asignatura.asp?asig_ccod="&request.Form("m[0][asig_ccod]"))

%>
