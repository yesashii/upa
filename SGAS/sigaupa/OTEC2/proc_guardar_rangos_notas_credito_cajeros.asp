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
formulario.Carga_Parametros "numeros_notas_credito_cajeros.xml", "detalle_facturas_cajero"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_rncc_ncorr		= formulario.ObtenerValorPost (fila, "rncc_ncorr")
   v_inst_ccod		= formulario.ObtenerValorPost (fila, "inst_ccod")
   v_rncc_ninicio	= formulario.ObtenerValorPost (fila, "rncc_ninicio")
   v_rncc_nfin		= formulario.ObtenerValorPost (fila, "rncc_nfin")
   v_sede_ccod		= formulario.ObtenerValorPost (fila, "c_sede_ccod")
	  
   if v_rncc_ncorr <> "" and v_rncc_ninicio <> "" and  v_rncc_nfin <> "" then
		  

		  sql_rango_sede= "select count(*) from rangos_notas_credito_sedes "& vbCrLf &_
							"  where  ernc_ccod in (1,4)"& vbCrLf &_
							"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
							"  and rncr_ninicio<="&v_rncc_ninicio&" "& vbCrLf &_
							"  and rncr_nfin >="&v_rncc_nfin&" "& vbCrLf &_
							"  and inst_ccod="&v_inst_ccod&" "
'response.Write("<pre>"&sql_rango_sede&"</pre>")			
'response.End()				
		  v_rango_sede=conexion.consultaUno(sql_rango_sede)						
		  if v_rango_sede <=0 then
				v_error="ERROR: Las numeracion de las notas de credito ingresadas no esta dentro del rango de esta SEDE."
				session("MensajeError")=v_error
				response.Redirect(request.ServerVariables("HTTP_REFERER"))
		  end if
		  
		  sql_menor =	" select count(*) from RANGOS_notas_credito_CAJEROS  "& vbCrLf &_
						" where "&v_rncc_ninicio&" between rncc_ninicio and rncc_nfin "& vbCrLf &_
						" and ernc_ccod not in (3) "& vbCrLf &_
						" and cast(rncc_ncorr as varchar) not in ('"&v_rncc_ncorr&"')and inst_ccod="&v_inst_ccod&" "
'response.Write("<pre>"&sql_menor&"</pre>") 
'response.End()
		v_limite_menor=conexion.consultaUno(sql_menor)
		
				
		  sql_mayor =	" select count(*) from RANGOS_notas_credito_CAJEROS  "& vbCrLf &_
						" where "&v_rncc_nfin&" between rncc_ninicio and rncc_nfin "& vbCrLf &_
						" and ernc_ccod not in (3) "& vbCrLf &_
						" and cast(rncc_ncorr as varchar) not in ('"&v_rncc_ncorr&"') and inst_ccod="&v_inst_ccod&" "
'response.Write("<pre>"&sql_mayor&"</pre>")
'response.End()						
		v_limite_mayor=conexion.consultaUno(sql_mayor)


		if v_limite_menor >0 and v_limite_mayor >0 then
			v_error="ERROR: Las numeracion de las notas de credito ingresadas ya existe para otro cajero."
		elseif v_limite_menor >0 then
			v_error="ERROR: El rango de INICIO que ha ingresado ya esta siendo usado por otro cajero"
		elseif v_limite_mayor >0 then
			v_error="ERROR: El rango de FIN que ha ingresado ya esta siendo usado por otro cajero"
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
	session("mensajeError")="ERROR: Ocurrio un error al intentar actualizar uno o mas rangos facturas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>