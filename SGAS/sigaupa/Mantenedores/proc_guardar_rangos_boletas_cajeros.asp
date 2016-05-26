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
formulario.Carga_Parametros "numeros_boletas_cajeros.xml", "detalle_boletas_cajero"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_rbca_ncorr		= formulario.ObtenerValorPost (fila, "rbca_ncorr")
   v_rbca_ninicio	= formulario.ObtenerValorPost (fila, "rbca_ninicio")
   v_rbca_nfin		= formulario.ObtenerValorPost (fila, "rbca_nfin")
   v_tbol_ccod		= formulario.ObtenerValorPost (fila, "tbol_ccod")
   v_sede_ccod		= formulario.ObtenerValorPost (fila, "c_sede_ccod")
	  
   if v_rbca_ncorr <> "" and v_rbca_ninicio <> "" and  v_rbca_nfin <> "" then
		  

		  sql_rango_sede= "select count(*) from rangos_boletas_sedes "& vbCrLf &_
							"  where  erbo_ccod in (1,4)"& vbCrLf &_
							"  and tbol_ccod= "&v_tbol_ccod&" "& vbCrLf &_
							"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
							"  and rbol_ninicio<="&v_rbca_ninicio&" "& vbCrLf &_
							"  and rbol_nfin >="&v_rbca_nfin
'response.Write("<pre>"&sql_rango_sede&"</pre>")			
'response.End()				
		  v_rango_sede=conexion.consultaUno(sql_rango_sede)						
		  if v_rango_sede <=0 then
				v_error="ERROR: Las numeracion de las boletas ingresadas no esta dentro del rango de esta SEDE."
				session("MensajeError")=v_error
				response.Redirect(request.ServerVariables("HTTP_REFERER"))
		  end if
		  
		  sql_menor =	" select count(*) from RANGOS_BOLETAS_CAJEROS  "& vbCrLf &_
						" where "&v_rbca_ninicio&" between rbca_ninicio and rbca_nfin "& vbCrLf &_
						" and tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_
						" and erbo_ccod not in (3) "& vbCrLf &_
						" and cast(rbca_ncorr as varchar) not in ('"&v_rbca_ncorr&"')"

		v_limite_menor=conexion.consultaUno(sql_menor)
		'response.Write("<pre>"&sql_menor&"</pre>")
				
		  sql_mayor =	" select count(*) from RANGOS_BOLETAS_CAJEROS  "& vbCrLf &_
						" where "&v_rbca_nfin&" between rbca_ninicio and rbca_nfin "& vbCrLf &_
						" and tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_
						" and erbo_ccod not in (3) "& vbCrLf &_
						" and cast(rbca_ncorr as varchar) not in ('"&v_rbca_ncorr&"')"
						
		v_limite_mayor=conexion.consultaUno(sql_mayor)

	'	response.Write("<pre>"&sql_mayor&"</pre>")
'response.End()
		if v_limite_menor >0 and v_limite_mayor >0 then
			v_error="ERROR: Las numeracion de las boletas ingresadas ya existe para otro cajero."
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
	session("mensajeError")="Los rangos de boletas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="ERROR: Ocurrio un error al intentar actualizar uno o mas rangos boletas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>