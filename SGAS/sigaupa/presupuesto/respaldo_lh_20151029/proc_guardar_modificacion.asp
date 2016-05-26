<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file = "../biblioteca/_conexion_softland.asp" -->

<%
'for each k in request.form
'	response.Write(k&" = "&request.Form(k)&"<br>")
'next

'response.End()



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
  formulario.Carga_Parametros "modifica_ejecucion_presupuestaria.xml", "f_modifica"
  formulario.Inicializar conexion2
  formulario.ProcesaForm

	for fila = 0 to formulario.CuentaPost - 1
	
		v_concepto	= 	formulario.ObtenerValorPost (fila, "concepto")
		v_cod_pre	= 	formulario.ObtenerValorPost (fila, "cod_pre")
		v_detalle	= 	formulario.ObtenerValorPost (fila, "detalle")

		' Meses y sus valores
		v_enero		= 	formulario.ObtenerValorPost (fila, "enero")
		v_febrero	= 	formulario.ObtenerValorPost (fila, "febrero")
		v_marzo		= 	formulario.ObtenerValorPost (fila, "marzo")
		v_abril		= 	formulario.ObtenerValorPost (fila, "abril")
		v_mayo		= 	formulario.ObtenerValorPost (fila, "mayo")
		v_junio		= 	formulario.ObtenerValorPost (fila, "junio")
		v_julio		= 	formulario.ObtenerValorPost (fila, "julio")
		v_agosto	= 	formulario.ObtenerValorPost (fila, "agosto")
		v_septiembre= 	formulario.ObtenerValorPost (fila, "septiembre")
		v_octubre	= 	formulario.ObtenerValorPost (fila, "octubre")
		v_noviembre	= 	formulario.ObtenerValorPost (fila, "noviembre")
		v_diciembre	= 	formulario.ObtenerValorPost (fila, "diciembre")
		v_enero_prox	= 	formulario.ObtenerValorPost (fila, "enero_prox")
		v_febrero_prox	= 	formulario.ObtenerValorPost (fila, "febrero_prox")
		
		suma_1= clng(v_enero) + clng(v_febrero) + clng(v_marzo) + clng(v_abril) 
		suma_2= clng(v_mayo) + clng(v_junio) + clng(v_julio) + clng(v_agosto)
		suma_3= clng(v_septiembre) + clng(v_octubre) + clng(v_noviembre) + clng(v_diciembre)
		
		suma= suma_1+ suma_2 + suma_3
		sql_presup= " update presupuesto_upa.protic.presupuesto_upa_2015 " &_
					 "	set enero='"&v_enero&"',febrero='"&v_febrero&"',marzo='"&v_marzo&"',abril='"&v_abril&"' " &_
					 "	,mayo='"&v_mayo&"',junio='"&v_junio&"',julio='"&v_julio&"', agosto='"&v_agosto&"' " &_
					 "	,septiembre='"&v_septiembre&"',octubre='"&v_octubre&"',noviembre='"&v_noviembre&"',diciembre='"&v_diciembre&"' " &_
					 "  ,enero_prox='"&v_enero_prox&"', febrero_prox='"&v_febrero_prox&"', total='"&suma&"' " &_
					 " where concepto='"&v_concepto&"' and cod_pre='"&v_cod_pre&"' and detalle='"&v_detalle&"' and cod_anio=2015  " 
		'response.Write("<br>"&sql_presup)	 
			
		v_estado_transaccion=conexion2.ejecutaS(sql_presup)

		'response.Write("<br/> Estado: <b>"&conexion2.ObtenerEstadoTransaccion&"</b>")
	next

'response.End()

if v_estado_transaccion=false  then
	'response.Write("<br>Todo MAL")
	session("mensaje_error")="ERROR: El o los codigos presupuestarios seleccionados NO pudieron ser modificados.\nVuelva a intentarlo."
else	
	'response.Write("<br>Todo bien")
	session("mensaje_error")="El o los codigos presupuestarios seleccionados fueron correctamente modificados."
end if

response.Redirect(request.ServerVariables("HTTP_REFERER"))

%>