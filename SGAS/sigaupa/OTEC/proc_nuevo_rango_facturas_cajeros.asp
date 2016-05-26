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
formulario.Carga_Parametros "numeros_facturas_cajeros.xml", "nuevo_rango"
formulario.Inicializar conexion
formulario.ProcesaForm		



for fila = 0 to formulario.CuentaPost - 1
   v_sede_ccod		= formulario.ObtenerValorPost (fila, "sede_ccod")
   v_pers_ncorr		= formulario.ObtenerValorPost (fila, "pers_ncorr")
   v_tfac_ccod		= formulario.ObtenerValorPost (fila, "tfac_ccod")
   v_rfca_ninicio	= formulario.ObtenerValorPost (fila, "rfca_ninicio")
   v_rfca_nfin		= formulario.ObtenerValorPost (fila, "rfca_nfin")
 	v_inst_ccod		= formulario.ObtenerValorPost (fila, "inst_ccod")
   if v_rfca_ninicio <> "" and v_rfca_nfin <> "" and v_tfac_ccod <> "" and v_sede_ccod <> "" and v_pers_ncorr <> "" then
		
		sql_exite_rango="Select count(*) from rangos_facturas_cajeros where tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_ 
						" and sede_ccod ="&v_sede_ccod&" and pers_ncorr="&v_pers_ncorr&" and erfa_ccod in (1)  "

		v_exite_rango=conexion.consultaUno(sql_exite_rango)

		if v_exite_rango > 0 then	
	
			v_nombre=conexion.consultaUno("select protic.obtener_nombre(pers_ncorr,'n') as nombre from personas where pers_ncorr="&v_pers_ncorr)
			v_tfac_tdesc=conexion.consultaUno("select tfac_tdesc from tipos_facturas where tfac_ccod="&v_tfac_ccod)

			sql_exite_rango_extra="Select count(*) from rangos_facturas_cajeros where tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_ 
								" and sede_ccod ="&v_sede_ccod&" and pers_ncorr="&v_pers_ncorr&" and erfa_ccod in (4)  "
		
			v_exite_rango_extra=conexion.consultaUno(sql_exite_rango_extra)

				

			if v_exite_rango_extra > 0 then
				session("MensajeError")="ERROR: El cajero "&v_nombre&", ya registra un rango de facturas "&v_tfac_tdesc&" sin terminar.\nAdemas ya registra un rango de facturas en espera "
				response.Redirect(request.ServerVariables("HTTP_REFERER"))
			else
				v_crea_pendiente=true
			end if	
		end if


				  sql_rango_activo_sede= "select count(*) from rangos_facturas_sedes "& vbCrLf &_
							"  where  erfa_ccod=1	"& vbCrLf &_
							"  and tfac_ccod= "&v_tfac_ccod&" "& vbCrLf &_
							"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
							"  and rfac_ninicio<="&v_rfca_ninicio&" "& vbCrLf &_
							"  and rfac_nfin >="&v_rfca_nfin

'response.Write("Redirect to :"&sql_rango_activo_sede)
'response.End()						
		  v_rango_activo_sede=conexion.consultaUno(sql_rango_activo_sede)						
		  
		  if v_rango_activo_sede <=0 then
		  		
				sql_rango_espera_sede= "select count(*) from rangos_facturas_sedes "& vbCrLf &_
									"  where  erfa_ccod=4	"& vbCrLf &_
									"  and tfac_ccod= "&v_tfac_ccod&" "& vbCrLf &_
									"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
									"  and rfac_ninicio<="&v_rfca_ninicio&" "& vbCrLf &_
									"  and rfac_nfin >="&v_rfca_nfin
			
 			    v_rango_espera_sede=conexion.consultaUno(sql_rango_espera_sede)						
				
				if v_rango_espera_sede <=0 then
					
					v_error="ERROR: \nLa numeracion ingresada no esta dentro del rango ACTIVO, \nni dentro de los rangos EN ESPERA de esta SEDE. \nAdemas no puede combinar facturas entre 2 rangos diferentes."
					session("MensajeError")=v_error
					response.Redirect(request.ServerVariables("HTTP_REFERER"))
				end if
		  end if

	
'response.Write("Redirect to :"&sql_rango_activo_sede)
'response.End()		
'- - - - - - - - - - - - - - - - - - - -
sql_rango_activo_institucion= "select count(*) from rangos_facturas_sedes "& vbCrLf &_
							"  where  erfa_ccod=1	"& vbCrLf &_
							"  and tfac_ccod= "&v_tfac_ccod&" "& vbCrLf &_
							"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
							"  and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
							"  and rfac_ninicio<="&v_rfca_ninicio&" "& vbCrLf &_
							"  and rfac_nfin >="&v_rfca_nfin
		'response.Write("<pre>"&sql_rango_activo_institucion&"</pre>")					
'Response.End()											
		  v_rango_activo_institucion=conexion.consultaUno(sql_rango_activo_institucion)	
		  'response.Write("<pre>"&sql_rango_activo_institucion&"</pre>")
 if v_rango_activo_institucion <=0 then
		  		
				sql_rango_espera_institucion= "select count(*) from rangos_facturas_sedes "& vbCrLf &_
									"  where  erfa_ccod=4	"& vbCrLf &_
									"  and tfac_ccod= "&v_tfac_ccod&" "& vbCrLf &_
									"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
									"  and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
									"  and rfac_ninicio<="&v_rfca_ninicio&" "& vbCrLf &_
									"  and rfac_nfin >="&v_rfca_nfin
			                        
 			    v_rango_espera_institucion=conexion.consultaUno(sql_rango_espera_institucion)
			'response.Write("<pre>"&sql_rango_espera_institucion&"</pre>")	
					sede_t=conexion.consultaUno("select sede_tdesc from sedes where sede_ccod="&v_sede_ccod&"")
					institucion_t=conexion.consultaUno("select inst_trazon_social tdesc from instituciones where inst_ccod="&v_inst_ccod&"")					
				
				if v_rango_espera_institucion <=0 then
					
					vs_error="ERROR: \nLa numeracion ingresada no esta dentro del rango ACTIVO, \nni dentro de los rangos EN ESPERA de "&institucion_t&" para la sede "&sede_t&" "
					session("MensajeError")=vs_error
					response.Redirect(request.ServerVariables("HTTP_REFERER"))
				end if
		  end if
'Response.End()
' - - - - - - - - - - - - - - - - - - - -		
		sql_menor =	" select count(*) from rangos_facturas_cajeros  "& vbCrLf &_
						" where "&v_rfca_ninicio&" between rfca_ninicio and rfca_nfin "& vbCrLf &_
						" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_
						" and erfa_ccod not in (3) "

		v_limite_menor=conexion.consultaUno(sql_menor)
	'	response.Write("<pre>"&sql_menor&"</pre>")
				
		sql_mayor =	" select count(*) from rangos_facturas_cajeros  "& vbCrLf &_
						" where "&v_rfca_nfin&" between rfca_ninicio and rfca_nfin "& vbCrLf &_
						" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_
						" and erfa_ccod not in (3) "
						
		v_limite_mayor=conexion.consultaUno(sql_mayor)

	'	response.Write("<pre>"&sql_mayor&"</pre>")

		if v_limite_menor >0 and v_limite_mayor >0 then
			v_error="ERROR: Las numeracion de las facturas ingresadas ya existen para otro cajero."
		elseif v_limite_menor >0 then
			v_error="ERROR: El rango de INICIO que ha ingresado ya esta siendo usado por otro cajero"
		elseif v_limite_mayor >0 then
			v_error="ERROR: El rango de FIN que ha ingresado ya esta siendo usado por otro cajero"
		else
			v_rfca_ncorr=conexion.consultaUno("exec obtenersecuencia 'rangos_facturas_cajeros' ")
			formulario.AgregaCampoFilaPost fila , "rfca_ncorr", v_rfca_ncorr
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
	session("mensajeError")="ERROR: Ocurrio un error al intentar ingresar uno nuevo rango de facturas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
