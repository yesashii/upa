<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%



v_area_ccod			=	request.Form("busqueda[0][area_ccod]")
v_codcaja			=	request.Form("busqueda[0][codcaja]")
v_dpre_ncorr		=	request.Form("busqueda[0][detalle]")
v_nuevo_detalle		=	request.Form("busqueda[0][nuevo_detalle]")


set conexion2 = new CConexion2
conexion2.Inicializar "upacifico"

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

v_usuario=negocio.ObtenerUsuario()

'-------------------------------------------------------------------------------------------------------
set f_busqueda2 = new CFormulario
f_busqueda2.Carga_Parametros "tabla_vacia.xml", "tabla_vacia" 
f_busqueda2.inicializar conexion2	
con_1 = "select concepto_pre from  presupuesto_upa.protic.codigos_presupuesto where cod_pre = '"&cod_pre&"'"
'response.write(con_1)
'response.end()
f_busqueda2.consultar con_1	
f_busqueda2.siguiente
nombre_1     = f_busqueda2.ObtenerValor("concepto_pre")
v_concepto			=	nombre_1
'-------------------------------------------------------------------------------------------------------


if v_codcaja <>"" and v_area_ccod <>"" and v_nuevo_detalle <> "" then
	
	'Obtiene secuencia (para el nuevo detalle)
	v_dpre_ncorr = conexion2.ConsultaUno("exec presupuesto_upa.dbo.obtenersecuencia 'detalle'")
	v_concepto=conexion2.ConsultaUno("select top 1 concepto_pre from presupuesto_upa.protic.codigos_presupuesto where cod_pre='"&v_codcaja&"' and cod_area="&v_area_ccod&" ")
		sql_detalle= "" & vbCrLf & _
		"insert into presupuesto_upa.protic.codigos_presupuesto " & vbCrLf & _
		"            (cpre_ncorr,                               " & vbCrLf & _
		"             cod_area,                                 " & vbCrLf & _
		"             cod_pre,                                  " & vbCrLf & _
		"             concepto_pre,                             " & vbCrLf & _
		"             detalle_pre,                              " & vbCrLf & _
		"             audi_tusuario,                            " & vbCrLf & _
		"             audi_fmodificacion,                       " & vbCrLf & _
		"             cpre_bestado,                             " & vbCrLf & _
		"             cpre_orden)                               " & vbCrLf & _
		"values      ("&v_dpre_ncorr&",                         " & vbCrLf & _
		"             "&v_area_ccod&",                          " & vbCrLf & _
		"             '"&v_codcaja&"',                          " & vbCrLf & _
		"             '"&v_concepto&"',                         " & vbCrLf & _
		"             '"&v_nuevo_detalle&"',                    " & vbCrLf & _
		"             '"&v_usuario&"',                          " & vbCrLf & _
		"             Getdate(),                                " & vbCrLf & _
		"             1,                                        " & vbCrLf & _
		"             1)                                        " 	
	
 	v_estado_transaccion=conexion2.ejecutaS(sql_detalle)
end if

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