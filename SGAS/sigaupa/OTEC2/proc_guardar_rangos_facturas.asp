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
formulario.Carga_Parametros "numeros_facturas_venta.xml", "detalle_facturas"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_rfac_ncorr		= formulario.ObtenerValorPost (fila, "rfac_ncorr")
   v_rfac_ninicio	= formulario.ObtenerValorPost (fila, "rfac_ninicio")
   v_rfac_nfin		= formulario.ObtenerValorPost (fila, "rfac_nfin")
   v_tfac_ccod		= formulario.ObtenerValorPost (fila, "tfac_ccod")
   v_inst_ccod		= formulario.ObtenerValorPost (fila, "c_inst_ccod")
   
   if v_rfac_ncorr <> "" and v_rfac_ninicio <> "" and  v_rfac_nfin <> "" then
		  
		  sql_menor =	" select count(*) from RANGOS_FACTURAS_SEDES  "& vbCrLf &_
						" where "&v_rfac_ninicio&" between rfac_ninicio and rfac_nfin "& vbCrLf &_
						" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_
						" and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
						" and erfa_ccod not in (3) "& vbCrLf &_
						" and cast(rfac_ncorr as varchar) not in ('"&v_rfac_ncorr&"')"

		v_limite_menor=conexion.consultaUno(sql_menor)
		'response.Write("<pre>"&sql_menor&"</pre>")
				
		  sql_mayor =	" select count(*) from RANGOS_FACTURAS_SEDES  "& vbCrLf &_
						" where "&v_rfac_nfin&" between rfac_ninicio and rfac_nfin "& vbCrLf &_
						" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_
						" and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
						" and erfa_ccod not in (3) "& vbCrLf &_
						" and cast(rfac_ncorr as varchar) not in ('"&v_rfac_ncorr&"')"
						
		v_limite_mayor=conexion.consultaUno(sql_mayor)

'response.Write("<pre>"&sql_mayor&"</pre>")
'response.End()
		if v_limite_menor >0 and v_limite_mayor >0 then
			v_error="Las numeracion de las facturas ingresadas ya existe en otra sede."
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
	session("mensajeError")="Los rangos de facturas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar uno o mas rangos de facturas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>