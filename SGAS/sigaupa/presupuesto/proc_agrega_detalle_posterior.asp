<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

v_area_ccod			=	request.Form("busqueda[0][area_ccod]")
v_codcaja			=	request.Form("busqueda[0][codcaja]")
v_concepto			=	request.Form("busqueda[0][concepto]")
v_dpre_ncorr		=	request.Form("busqueda[0][detalle]")
v_nuevo_detalle		=	request.Form("busqueda[0][nuevo_detalle]")


set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario		=	negocio.ObtenerUsuario()
v_anio_actual	= 	conexion2.ConsultaUno("select year(getdate())")
'v_anio_actual	=	v_anio_actual-1 ' se agrego por que el 2010 el presupuesto paso de año

if v_codcaja <>"" and v_area_ccod <>"" and v_nuevo_detalle <> "" then

	v_concepto=conexion2.ConsultaUno("select top 1 concepto_pre from presupuesto_upa.protic.codigos_presupuesto where cod_pre='"&v_codcaja&"' and cod_area="&v_area_ccod&" ")
	v_area_tdesc=conexion2.ConsultaUno("select top 1 area_tdesc from presupuesto_upa.protic.area_presupuestal where area_ccod="&v_area_ccod&" ")

	sql_detalle="select count(*) from presupuesto_upa.protic.presupuesto_upa where "&_
			" cod_anio="&v_anio_actual&" and cod_pre='"&v_codcaja&"' and cod_area="&v_area_ccod&" "&_
			" and concepto='"&v_concepto&"' and detalle='"&v_nuevo_detalle&"' "
			
	v_existe_detalle=conexion2.ConsultaUno(sql_detalle)
		
	if v_existe <=0 then
		'Obtiene secuencia (para el nuevo detalle)
		v_dpre_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'detalle'")
		
		sql_detalle= " insert into presupuesto_upa.protic.codigos_presupuesto (cpre_ncorr,cod_area,cod_pre,concepto_pre,detalle_pre,audi_tusuario, audi_fmodificacion) " &_
					" values ("&v_dpre_ncorr&","&v_area_ccod&",'"&v_codcaja&"','"&v_concepto&"','"&v_nuevo_detalle&"','"&v_usuario&"', getdate())"
		v_estado_transaccion=conexion2.ejecutaS(sql_detalle)
		
		sql_insert_pre= "insert into presupuesto_upa.protic.presupuesto_upa" &_
					" (cod_anio,cod_pre,cod_area,descripcion_area,concepto,detalle,enero,febrero,marzo,abril,mayo,junio,julio,agosto,septiembre,octubre,noviembre,diciembre,total) " &_
					" values " &_
					" ("&v_anio_actual&",'"&v_codcaja&"',"&v_area_ccod&",'"&v_area_tdesc&"','"&v_concepto&"','"&v_nuevo_detalle&"',0,0,0,0,0,0,0,0,0,0,0,0,0) "	
		'response.Write("<pre>"&sql_insert_pre&"</pre>")
		'response.End()
		v_estado_transaccion=conexion2.ejecutaS(sql_insert_pre)
	end if
	
end if

'conexion2.estadotransaccion false
'response.Write("<pre>"&sql_detalle&"</pre>")
'response.End()

if v_estado_transaccion=false  then
	'response.Write("<br>Todo MAL")
	session("mensaje_error")="El nuevo detalle no pudo ser ingresado correctamente.\nVuelva a intentarlo."
else	
	'response.Write("<br>Todo bien")
	session("mensaje_error")="El nuevo detalle fue ingresado correctamente."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>