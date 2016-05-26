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
formulario.Carga_Parametros "numeros_notas_credito.xml", "nuevo_rango"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_sede_ccod		= formulario.ObtenerValorPost (fila, "sede_ccod")
   v_inst_ccod		= formulario.ObtenerValorPost (fila, "inst_ccod")
   v_rncr_ninicio	= formulario.ObtenerValorPost (fila, "rncr_ninicio")
   v_rncr_nfin		= formulario.ObtenerValorPost (fila, "rncr_nfin")

'response.Write("<pre>"&v_inst_ccod&"</pre>")
'response.End()
   if v_rncr_ninicio <> "" and v_rncr_nfin <> "" and v_sede_ccod <> "" and  v_inst_ccod <> "" then
		
		sql_exite_rango="Select count(*) from RANGOS_notas_credito_SEDES where sede_ccod ="&v_sede_ccod&" and ernc_ccod in (1) and inst_ccod="&v_inst_ccod&"  "
		
		v_exite_rango=conexion.consultaUno(sql_exite_rango)

		if v_exite_rango > 0 then	
		
			v_sede_tdesc=conexion.consultaUno("select sede_tdesc from sedes where sede_ccod="&v_sede_ccod)
			
				sql_exite_rango_extra="Select count(*) from RANGOS_notas_credito_SEDES where sede_ccod ="&v_sede_ccod&" and ernc_ccod in (4) and inst_ccod="&v_inst_ccod&"  "
		
				v_exite_rango_extra=conexion.consultaUno(sql_exite_rango_extra)
			
			if v_exite_rango_extra > 3 then
				session("MensajeError")="La sede "&v_sede_tdesc&", ya registra un rango ACTIVO de notas de credito sin terminar.\nAdemas ya registra mas de un rango de notas de credito en espera "
				response.Redirect(request.ServerVariables("HTTP_REFERER"))
			else
				v_crea_pendiente=true
			end if	
		end if

		sql_menor =	" select count(*) from RANGOS_notas_credito_SEDES  "& vbCrLf &_
						" where "&v_rncr_ninicio&" between rncr_ninicio and rncr_nfin "& vbCrLf &_
						" and ernc_ccod not in (3) and inst_ccod="&v_inst_ccod&" "

		v_limite_menor=conexion.consultaUno(sql_menor)
	'	response.Write("<pre>"&sql_menor&"</pre>")
				
		sql_mayor =	" select count(*) from RANGOS_notas_credito_SEDES  "& vbCrLf &_
						" where "&v_rncr_nfin&" between rncr_ninicio and rncr_nfin "& vbCrLf &_
						" and ernc_ccod not in (3) and inst_ccod="&v_inst_ccod&" "
						
		v_limite_mayor=conexion.consultaUno(sql_mayor)

	'	response.Write("<pre>"&sql_mayor&"</pre>")

		if v_limite_menor >0 and v_limite_mayor >0 then
			v_error="Las numeracion de las notas de credito ingresadas ya existe en otra sede."
		elseif v_limite_menor >0 then
			v_error="el rango de INICIO que ha ingresado ya esta siendo usado en otra sede"
		elseif v_limite_mayor >0 then
			v_error="el rango de FIN que ha ingresado ya esta siendo usado en otra sede"
		else
			v_rncr_ncorr=conexion.consultaUno("exec obtenersecuencia 'rangos_notas_credito' ")
			formulario.AgregaCampoFilaPost fila , "rncr_ncorr", v_rncr_ncorr
			if v_crea_pendiente=true then
				formulario.AgregaCampoFilaPost fila , "ernc_ccod", "4"
			else
				formulario.AgregaCampoFilaPost fila , "ernc_ccod", "1"
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
	session("mensajeError")="Los rangos de notas de credito ingresados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar ingresar uno nuevo rango de notas de credito.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
