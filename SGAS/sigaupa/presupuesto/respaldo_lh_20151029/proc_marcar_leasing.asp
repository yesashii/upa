<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next



set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

'response.Write(" Udsuario: "&v_usuario)
'response.End()

  set formulario = new CFormulario
  formulario.Carga_Parametros "formulacion_presupuesto.xml", "formulacion_detalle"
  formulario.Inicializar conexion2
  formulario.ProcesaForm

	for fila = 0 to formulario.CuentaPost - 1
	
		v_spru_ncorr= 	formulario.ObtenerValorPost (fila, "spru_ncorr")
		v_agregar	= 	formulario.ObtenerValorPost (fila, "agregar")
		if v_agregar="1" then
	
			v_txt_usuario="agrega-leasing-"&v_usuario

			sql_detalle= " update presupuesto_upa.protic.solicitud_presupuesto_upa set leasing=1,audi_tusuario='"&v_txt_usuario&"', audi_fmodificacion=getdate() " &_
						 " where spru_ncorr="&v_spru_ncorr
			'response.Write("<br>"&sql_detalle)	 
			
		else

			v_txt_usuario="quita-leasing-"&v_usuario

			sql_detalle= " update presupuesto_upa.protic.solicitud_presupuesto_upa set leasing=0, audi_tusuario='"&v_txt_usuario&"', audi_fmodificacion=getdate() " &_
						 " where spru_ncorr="&v_spru_ncorr
			'response.Write("<br>"&sql_detalle)	 
		end if
		v_estado_transaccion=conexion2.ejecutaS(sql_detalle)
	next

'response.End()

if v_estado_transaccion=false  then
	'response.Write("<br>Todo MAL")
	session("mensaje_error")="El o los detalles seleccionados NO pudieron ser asociados o eliminados al presupuesto de LEASING.\nVuelva a intentarlo."
else	
	'response.Write("<br>Todo bien")
	session("mensaje_error")="El o los detalles seleccionados fueron correctamente asociados o eliminados del LEASING segun su seleccion."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>