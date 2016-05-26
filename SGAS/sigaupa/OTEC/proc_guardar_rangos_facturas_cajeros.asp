<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'for each k in request.form
	'response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

set formulario = new CFormulario
formulario.Carga_Parametros "numeros_facturas_cajeros.xml", "detalle_facturas_cajero"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_rfca_ncorr		= formulario.ObtenerValorPost (fila, "rfca_ncorr")
   v_rfca_ninicio	= formulario.ObtenerValorPost (fila, "rfca_ninicio")
   v_rfca_nfin		= formulario.ObtenerValorPost (fila, "rfca_nfin")
   v_tfac_ccod		= formulario.ObtenerValorPost (fila, "tfac_ccod")
   v_sede_ccod		= formulario.ObtenerValorPost (fila, "c_sede_ccod")
	  
   if v_rfca_ncorr <> "" and v_rfca_ninicio <> "" and  v_rfca_nfin <> "" then
		  

		  sql_rango_sede= "select count(*) from rangos_facturas_sedes "& vbCrLf &_
							"  where  erfa_ccod in (1,4)"& vbCrLf &_
							"  and tfac_ccod= "&v_tfac_ccod&" "& vbCrLf &_
							"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
							"  and rfac_ninicio<="&v_rfca_ninicio&" "& vbCrLf &_
							"  and rfac_nfin >="&v_rfca_nfin
'response.Write("<pre>"&sql_rango_sede&"</pre>")			
'response.End()				
		  v_rango_sede=conexion.consultaUno(sql_rango_sede)						
		  if v_rango_sede <=0 then
				v_error="ERROR: Las numeracion de las facturas ingresadas no esta dentro del rango de esta SEDE."
				session("MensajeError")=v_error
				response.Redirect(request.ServerVariables("HTTP_REFERER"))
		  end if
		  
		  sql_menor =	" select count(*) from RANGOS_FACTURAS_CAJEROS  "& vbCrLf &_
						" where "&v_rfca_ninicio&" between rfca_ninicio and rfca_nfin "& vbCrLf &_
						" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_
						" and erfa_ccod not in (3) "& vbCrLf &_
						" and cast(rfca_ncorr as varchar) not in ('"&v_rfca_ncorr&"')"
'response.Write("<pre>"&sql_menor&"</pre>") response.End()
		v_limite_menor=conexion.consultaUno(sql_menor)
		
				
		  sql_mayor =	" select count(*) from RANGOS_FACTURAS_CAJEROS  "& vbCrLf &_
						" where "&v_rfca_nfin&" between rfca_ninicio and rfca_nfin "& vbCrLf &_
						" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_
						" and erfa_ccod not in (3) "& vbCrLf &_
						" and cast(rfca_ncorr as varchar) not in ('"&v_rfca_ncorr&"')"
'response.Write("<pre>"&sql_mayor&"</pre>")
'response.End()						
		v_limite_mayor=conexion.consultaUno(sql_mayor)


		if v_limite_menor >0 and v_limite_mayor >0 then
			v_error="ERROR: Las numeracion de las facturas ingresadas ya existe para otro cajero."
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