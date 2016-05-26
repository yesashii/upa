<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

set formulario = new CFormulario
formulario.Carga_Parametros "numeros_boletas_venta.xml", "detalle_boletas"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_rbol_ncorr		= formulario.ObtenerValorPost (fila, "rbol_ncorr")
   v_rbol_ninicio	= formulario.ObtenerValorPost (fila, "rbol_ninicio")
   v_rbol_nfin		= formulario.ObtenerValorPost (fila, "rbol_nfin")
   v_tbol_ccod		= formulario.ObtenerValorPost (fila, "tbol_ccod")
   
   if v_rbol_ncorr <> "" and v_rbol_ninicio <> "" and  v_rbol_nfin <> "" then
		  
		  sql_menor =	" select count(*) from RANGOS_BOLETAS_SEDES  "& vbCrLf &_
						" where "&v_rbol_ninicio&" between rbol_ninicio and rbol_nfin "& vbCrLf &_
						" and tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_
						" and erbo_ccod not in (3) "& vbCrLf &_
						" and cast(rbol_ncorr as varchar) not in ('"&v_rbol_ncorr&"')"

		v_limite_menor=conexion.consultaUno(sql_menor)
		'response.Write("<pre>"&sql_menor&"</pre>")
				
		  sql_mayor =	" select count(*) from RANGOS_BOLETAS_SEDES  "& vbCrLf &_
						" where "&v_rbol_nfin&" between rbol_ninicio and rbol_nfin "& vbCrLf &_
						" and tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_
						" and erbo_ccod not in (3) "& vbCrLf &_
						" and cast(rbol_ncorr as varchar) not in ('"&v_rbol_ncorr&"')"
						
		v_limite_mayor=conexion.consultaUno(sql_mayor)

	'	response.Write("<pre>"&sql_mayor&"</pre>")
'response.End()
		if v_limite_menor >0 and v_limite_mayor >0 then
			v_error="Las numeracion de las boletas ingresadas ya existe en otra sede."
		elseif v_limite_menor >0 then
			v_error="el rango de INICIO que ha ingresado ya esta siendo usado en otra sede"
		elseif v_limite_mayor >0 then
			v_error="el rango de FIN que ha ingresado ya esta siendo usado en otra sede"
		end if			
		

   end if
next

if v_error <> "" then
	session("MensajeError")=v_error
	response.Redirect(request.ServerVariables("HTTP_REFERER"))
end if


formulario.MantieneTablas false
'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Los rangos de boletas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar uno o mas rangos boletas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>