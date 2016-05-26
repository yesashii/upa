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
formulario.Carga_Parametros "numeros_notas_credito.xml", "detalle_notas_credito"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
  
   v_rncr_ncorr		= formulario.ObtenerValorPost (fila, "rncr_ncorr")
   v_rncr_ninicio	= formulario.ObtenerValorPost (fila, "rncr_ninicio")
   v_rncr_nfin		= formulario.ObtenerValorPost (fila, "rncr_nfin")
   v_inst_ccod		= formulario.ObtenerValorPost (fila, "c_inst_ccod")
 'response.Write("v_rncr_ncorr: "&v_rncr_ncorr&" <br>v_rncr_ninicio :"&v_rncr_ninicio&" <br>v_rncr_nfin: "&v_rncr_nfin&"")  
   if v_rncr_ncorr <> "" and v_rncr_ninicio <> "" and  v_rncr_nfin <> "" then
		  
		  sql_menor =	" select count(*) from rangos_notas_credito_sedes  "& vbCrLf &_
						" where "&v_rncr_ninicio&" between rncr_ninicio and rncr_nfin "& vbCrLf &_
						" and ernc_ccod not in (3) "& vbCrLf &_
						" and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
						" and cast(rncr_ncorr as varchar) not in ('"&v_rncr_ncorr&"')"

		v_limite_menor=conexion.consultaUno(sql_menor)
		'response.Write("<pre>"&sql_menor&"</pre>")
				
		  sql_mayor =	" select count(*) from rangos_notas_credito_sedes  "& vbCrLf &_
						" where "&v_rncr_nfin&" between rncr_ninicio and rncr_nfin "& vbCrLf &_
						" and ernc_ccod not in (3) "& vbCrLf &_
						" and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
						" and cast(rncr_ncorr as varchar) not in ('"&v_rncr_ncorr&"')"
						
		v_limite_mayor=conexion.consultaUno(sql_mayor)

'response.Write("<pre>"&sql_mayor&"</pre>")
'response.End()
		if v_limite_menor >0 and v_limite_mayor >0 then
			v_error="Las numeracion de las notas de creditos ingresadas ya existe en otra sede."
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

'Response.Write("<br> Transaccion :"&conexion.ObtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'Response.End()
formulario.MantieneTablas false


if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Los rangos de notas de credito selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar actualizar uno o mas rangos de notas de credito.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>