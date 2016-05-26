<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
  
set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()  
'----------------------------------------------------------------------
'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x))
'next
'response.End()
'----------------------------------------------------------------------
  set formulario = new CFormulario
  formulario.Carga_Parametros "detalle_acuse.xml", "detalle_pagos"
  formulario.Inicializar conexion
  formulario.ProcesaForm
v_indice=0
  	for fila = 0 to formulario.CuentaPost - 1

		v_tipo_comprobante			= formulario.ObtenerValorPost (fila, "tipo_comprobante")
	   	v_ingr_nfolio_referencia	= formulario.ObtenerValorPost (fila, "ingr_nfolio_referencia")
		v_comp_ndocto		= formulario.ObtenerValorPost (fila, "comp_ndocto")
	   	v_tcom_ccod			= formulario.ObtenerValorPost (fila, "tcom_ccod")
	   	v_inst_ccod			= formulario.ObtenerValorPost (fila, "inst_ccod")
		v_dcom_ncompromiso	= formulario.ObtenerValorPost (fila, "dcom_ncompromiso")
		v_ding_ndocto		= formulario.ObtenerValorPost (fila, "ding_ndocto")
		v_ting_ccod			= formulario.ObtenerValorPost (fila, "ting_ccod")
   	

		if v_comp_ndocto <> "" then
v_indice=v_indice+1
			sql_inserta= " Insert into documentos_acuse_recibo "& vbCrLf &_ 
						 " (tipo_comprobante, ingr_nfolio_referencia,comp_ndocto,tcom_ccod,inst_ccod,dcom_ncompromiso,ding_ndocto,ting_ccod, audi_tusuario,audi_fmodificacion) "& vbCrLf &_ 
						 " Values ('"&v_tipo_comprobante&"','"&v_ingr_nfolio_referencia&"','"&v_comp_ndocto&"','"&v_tcom_ccod&"','"&v_inst_ccod&"','"&v_dcom_ncompromiso&"','"&v_ding_ndocto&"','"&v_ting_ccod&"','"&usuario&"', getdate() ) "
			'response.Write("<br><hr><pre>"&sql_inserta&"</pre><hr>")
			conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta)
		end if	
	next
  

  if conexion.obtenerEstadoTransaccion = false then
  	session("mensajeError") = "No se pudo guardar el detalle de los compromisos seleccionados"
  else
	if v_indice>0 then
		session("mensajeError") = "El o los compromisos seleccionados fueron guardados correctamente"
	else
		session("mensajeError") = "Debe seleccionar al menos un documento para imprimir un acuse de recibo"
		response.Redirect(request.ServerVariables("HTTP_REFERER"))
	end if
  end if
  
'response.Redirect(request.ServerVariables("HTTP_REFERER"))
response.Redirect("imprimir_acuse_recibo.asp?nfolio="&v_ingr_nfolio_referencia&"&ting_ccod="&v_tipo_comprobante&"")
%>

