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
formulario.Carga_Parametros "numeros_facturas_venta.xml", "nuevo_rango"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_sede_ccod		= formulario.ObtenerValorPost (fila, "sede_ccod")
   v_tfac_ccod		= formulario.ObtenerValorPost (fila, "tfac_ccod")
   v_rfac_ninicio	= formulario.ObtenerValorPost (fila, "rfac_ninicio")
   v_rfac_nfin		= formulario.ObtenerValorPost (fila, "rfac_nfin")

   if v_rfac_ninicio <> "" and v_rfac_nfin <> "" and v_tfac_ccod <> "" and v_sede_ccod <> "" then
		
		sql_exite_rango="Select count(*) from RANGOS_FACTURAS_SEDES where tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_ 
						" and sede_ccod ="&v_sede_ccod&" and erfa_ccod in (1)  "
		
		v_exite_rango=conexion.consultaUno(sql_exite_rango)

		if v_exite_rango > 0 then	
		
			v_sede_tdesc=conexion.consultaUno("select sede_tdesc from sedes where sede_ccod="&v_sede_ccod)
			v_tfac_tdesc=conexion.consultaUno("select tfac_tdesc from tipos_facturas where tfac_ccod="&v_tfac_ccod)
			
				sql_exite_rango_extra="Select count(*) from RANGOS_FACTURAS_SEDES where tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_ 
									" and sede_ccod ="&v_sede_ccod&" and erfa_ccod in (4)  "
		
				v_exite_rango_extra=conexion.consultaUno(sql_exite_rango_extra)
			
			if v_exite_rango_extra > 3 then
				session("MensajeError")="La sede "&v_sede_tdesc&", ya registra un rango ACTIVO de Facturas "&v_tfac_tdesc&" sin terminar.\nAdemas ya registra mas de un rango de facturas en espera "
				response.Redirect(request.ServerVariables("HTTP_REFERER"))
			else
				v_crea_pendiente=true
			end if	
		end if

		sql_menor =	" select count(*) from RANGOS_FACTURAS_SEDES  "& vbCrLf &_
						" where "&v_rfac_ninicio&" between rfac_ninicio and rfac_nfin "& vbCrLf &_
						" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_
						" and erfa_ccod not in (3) "

		v_limite_menor=conexion.consultaUno(sql_menor)
	'	response.Write("<pre>"&sql_menor&"</pre>")
				
		sql_mayor =	" select count(*) from RANGOS_FACTURAS_SEDES  "& vbCrLf &_
						" where "&v_rfac_nfin&" between rfac_ninicio and rfac_nfin "& vbCrLf &_
						" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_
						" and erfa_ccod not in (3) "
						
		v_limite_mayor=conexion.consultaUno(sql_mayor)

	'	response.Write("<pre>"&sql_mayor&"</pre>")

		if v_limite_menor >0 and v_limite_mayor >0 then
			v_error="Las numeracion de las facturas ingresadas ya existe en otra sede."
		elseif v_limite_menor >0 then
			v_error="el rango de INICIO que ha ingresado ya esta siendo usado en otra sede"
		elseif v_limite_mayor >0 then
			v_error="el rango de FIN que ha ingresado ya esta siendo usado en otra sede"
		else
			v_rfac_ncorr=conexion.consultaUno("exec obtenersecuencia 'rangos_facturas' ")
			formulario.AgregaCampoFilaPost fila , "rfac_ncorr", v_rfac_ncorr
			if v_crea_pendiente=true then
				formulario.AgregaCampoFilaPost fila , "erfa_ccod", "4"
			else
				formulario.AgregaCampoFilaPost fila , "erfa_ccod", "1"
			end if
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
	session("mensajeError")="Los rangos de facturas ingresados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar ingresar uno nuevo rango de facturas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
