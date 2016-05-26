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



set formulario = new CFormulario
formulario.Carga_Parametros "numeros_notas_credito_cajeros.xml", "nuevo_rango"
formulario.Inicializar conexion
formulario.ProcesaForm		



for fila = 0 to formulario.CuentaPost - 1
   v_sede_ccod		= formulario.ObtenerValorPost (fila, "sede_ccod")
   v_pers_ncorr		= formulario.ObtenerValorPost (fila, "pers_ncorr")
   v_rncc_ninicio	= formulario.ObtenerValorPost (fila, "rncc_ninicio")
   v_rncc_nfin		= formulario.ObtenerValorPost (fila, "rncc_nfin")
   v_inst_ccod		= formulario.ObtenerValorPost (fila, "inst_ccod")
    
   if v_rncc_ninicio <> "" and v_rncc_nfin <> "" and v_sede_ccod <> "" and v_pers_ncorr <> "" then
		
		sql_exite_rango="Select count(*) from rangos_notas_credito_cajeros where sede_ccod ="&v_sede_ccod&" and pers_ncorr="&v_pers_ncorr&" and ernc_ccod in (1) and inst_ccod="&v_inst_ccod&" "

		v_exite_rango=conexion.consultaUno(sql_exite_rango)

		if v_exite_rango > 0 then	
	
			v_nombre=conexion.consultaUno("select protic.obtener_nombre(pers_ncorr,'n') as nombre from personas where pers_ncorr="&v_pers_ncorr)

			sql_exite_rango_extra="Select count(*) from rangos_notas_credito_cajeros where sede_ccod ="&v_sede_ccod&" and pers_ncorr="&v_pers_ncorr&" and ernc_ccod in (4) and inst_ccod="&v_inst_ccod&"  "
		
			v_exite_rango_extra=conexion.consultaUno(sql_exite_rango_extra)

				

			if v_exite_rango_extra > 0 then
				session("MensajeError")="ERROR: El cajero "&v_nombre&", ya registra un rango de notas de credito sin terminar.\nAdemas ya registra un rango de notas de credito en espera "
				response.Redirect(request.ServerVariables("HTTP_REFERER"))
			else
				v_crea_pendiente=true
			end if	
		end if


				  sql_rango_activo_sede= "select count(*) from rangos_notas_credito_sedes "& vbCrLf &_
							"  where  ernc_ccod=1	"& vbCrLf &_
							"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
							"  and rncr_ninicio<="&v_rncc_ninicio&" "& vbCrLf &_
							"  and rncr_nfin >="&v_rncc_nfin&" "& vbCrLf &_
							"  and inst_ccod="&v_inst_ccod&" "

					
		  v_rango_activo_sede=conexion.consultaUno(sql_rango_activo_sede)						
		  
		  if v_rango_activo_sede <=0 then
		  		
				sql_rango_espera_sede= "select count(*) from rangos_notas_credito_sedes "& vbCrLf &_
									"  where  ernc_ccod=4	"& vbCrLf &_
									"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
									"  and rncr_ninicio<="&v_rncc_ninicio&" "& vbCrLf &_
									"  and rncr_nfin >="&v_rncc_nfin&""& vbCrLf &_
									"  and inst_ccod="&v_inst_ccod&" "
			
 			    v_rango_espera_sede=conexion.consultaUno(sql_rango_espera_sede)						
				
				if v_rango_espera_sede <=0 then
					
					v_error="ERROR: \nLa numeracion ingresada no esta dentro del rango ACTIVO, \nni dentro de los rangos EN ESPERA de esta SEDE. \nAdemas no puede combinar notas de credito entre 2 rangos diferentes."
					session("MensajeError")=v_error
					response.Redirect(request.ServerVariables("HTTP_REFERER"))
				end if
		  end if

'response.End()
	'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -	
	  sql_rango_activo_institucion= "select count(*) from rangos_notas_credito_sedes "& vbCrLf &_
							"  where  ernc_ccod=1	"& vbCrLf &_
							"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
							"  and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
							"  and rncr_ninicio<="&v_rncc_ninicio&" "& vbCrLf &_
							"  and rncr_nfin >="&v_rncc_nfin

			response.Write("<pre>"&sql_rango_activo_institucion&"</pre>")		
		  v_rango_activo_institucion=conexion.consultaUno(sql_rango_activo_institucion)						
		  
		  if v_rango_activo_sede <=0 then
		  		
				sql_rango_espera_institucion= "select count(*) from rangos_notas_credito_sedes "& vbCrLf &_
									"  where  ernc_ccod=4	"& vbCrLf &_
									"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
									"  and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
									"  and rncr_ninicio<="&v_rncc_ninicio&" "& vbCrLf &_
									"  and rncr_nfin >="&v_rncc_nfin
			response.Write("<pre>"&sql_rango_espera_institucion&"</pre>")
 			    v_rango_espera_institucion=conexion.consultaUno(sql_rango_espera_institucion)						
				
				if v_rango_espera_institucion <=0 then
					
					vs_error="ERROR: \nLa numeracion ingresada no esta dentro del rango ACTIVO, \nni dentro de los rangos EN ESPERA de esta INSTITUCIÓN y de esta SEDE. \nAdemas no puede combinar notas de credito entre 2 rangos diferentes."
					session("MensajeError")=vs_error
					response.Redirect(request.ServerVariables("HTTP_REFERER"))
				end if
		  end if
		  
'response.End()		  
	'- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -		
		
		sql_menor =	" select count(*) from rangos_notas_credito_cajeros  "& vbCrLf &_
						" where "&v_rncc_ninicio&" between rncc_ninicio and rncc_nfin "& vbCrLf &_
						" and ernc_ccod not in (3)  and inst_ccod="&v_inst_ccod&" "

		v_limite_menor=conexion.consultaUno(sql_menor)
		'response.Write("<pre>"&sql_menor&"</pre>")
				
		sql_mayor =	" select count(*) from rangos_notas_credito_cajeros  "& vbCrLf &_
						" where "&v_rncc_nfin&" between rncc_ninicio and rncc_nfin "& vbCrLf &_
						" and ernc_ccod not in (3) and inst_ccod="&v_inst_ccod&" "
						
		v_limite_mayor=conexion.consultaUno(sql_mayor)

	'	response.Write("<pre>"&sql_mayor&"</pre>")

		if v_limite_menor >0 and v_limite_mayor >0 then
			v_error="ERROR: Las numeracion de las notas de credito ingresadas ya existen para otro cajero."
		elseif v_limite_menor >0 then
			v_error="ERROR: El rango de INICIO que ha ingresado ya esta siendo usado por otro cajero"
		elseif v_limite_mayor >0 then
			v_error="ERROR: El rango de FIN que ha ingresado ya esta siendo usado por otro cajero"
		else
			v_rncc_ncorr=conexion.consultaUno("exec obtenersecuencia 'rangos_notas_credito_cajero' ")
'response.Write("Redirect to :"&v_rncc_ncorr)
'response.End()				
			formulario.AgregaCampoFilaPost fila , "rncc_ncorr", v_rncc_ncorr
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
	session("mensajeError")="ERROR: Ocurrio un error al intentar ingresar uno nuevo rango de notas de credito.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
