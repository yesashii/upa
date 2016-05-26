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
formulario.Carga_Parametros "numeros_boletas_cajeros.xml", "nuevo_rango"
formulario.Inicializar conexion
formulario.ProcesaForm		


for fila = 0 to formulario.CuentaPost - 1
   v_sede_ccod		= formulario.ObtenerValorPost (fila, "sede_ccod")
    v_inst_ccod		= formulario.ObtenerValorPost (fila, "inst_ccod")
   v_pers_ncorr		= formulario.ObtenerValorPost (fila, "pers_ncorr")
   v_tbol_ccod		= formulario.ObtenerValorPost (fila, "tbol_ccod")
   v_rbca_ninicio	= formulario.ObtenerValorPost (fila, "rbca_ninicio")
   v_rbca_nfin		= formulario.ObtenerValorPost (fila, "rbca_nfin")

   if v_rbca_ninicio <> "" and v_rbca_nfin <> "" and v_tbol_ccod <> "" and v_sede_ccod <> "" and v_pers_ncorr <> "" and v_inst_ccod <> "" then
		
		sql_exite_rango="Select count(*) from RANGOS_BOLETAS_CAJEROS where tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_ 
						" and sede_ccod ="&v_sede_ccod&" and pers_ncorr="&v_pers_ncorr&" and erbo_ccod in (1) and inst_ccod = "&v_inst_ccod& ""

		v_exite_rango=conexion.consultaUno(sql_exite_rango)

		if v_exite_rango > 0 then	
			v_nombre=conexion.consultaUno("select protic.obtener_nombre(pers_ncorr,'n') as nombre from personas where pers_ncorr="&v_pers_ncorr)
			v_tbol_tdesc=conexion.consultaUno("select tbol_tdesc from tipos_boletas where tbol_ccod="&v_tbol_ccod)
			v_inst_trazon_social=conexion.consultaUno("select inst_trazon_social from instituciones where inst_ccod="&v_inst_ccod)
			
			sql_exite_rango_extra="Select count(*) from RANGOS_BOLETAS_CAJEROS where tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_ 
								" and sede_ccod ="&v_sede_ccod&" and pers_ncorr="&v_pers_ncorr&" and erbo_ccod in (4)  and inst_ccod = "&v_inst_ccod& ""
		
			v_exite_rango_extra=conexion.consultaUno(sql_exite_rango_extra)

			if v_exite_rango_extra > 0 then
				session("MensajeError")="ERROR: El cajero "&v_nombre&", ya registra un rango de boletas "&v_tbol_tdesc&" sin terminar.\nAdemas ya registra un rango de boletas en espera "
				response.Redirect(request.ServerVariables("HTTP_REFERER"))
			else
				v_crea_pendiente=true
			end if	
		end if
		
		
				  sql_rango_activo_sede= "select count(*) from rangos_boletas_sedes "& vbCrLf &_
							"  where  erbo_ccod=1	"& vbCrLf &_
							"  and tbol_ccod= "&v_tbol_ccod&" "& vbCrLf &_
							"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
							"  and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
							"  and rbol_ninicio<="&v_rbca_ninicio&" "& vbCrLf &_
							"  and rbol_nfin >="&v_rbca_nfin

											
		  v_rango_activo_sede=conexion.consultaUno(sql_rango_activo_sede)						
		  
		  if v_rango_activo_sede <=0 then
		  		
				sql_rango_espera_sede= "select count(*) from rangos_boletas_sedes "& vbCrLf &_
									"  where  erbo_ccod=4	"& vbCrLf &_
									"  and tbol_ccod= "&v_tbol_ccod&" "& vbCrLf &_
									"  and sede_ccod="&v_sede_ccod&" "& vbCrLf &_
									"  and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
									"  and rbol_ninicio<="&v_rbca_ninicio&" "& vbCrLf &_
									"  and rbol_nfin >="&v_rbca_nfin
			
 			    v_rango_espera_sede=conexion.consultaUno(sql_rango_espera_sede)						
				
				
				if v_rango_espera_sede <=0 then
					
					v_error="ERROR: \nLa numeracion ingresada no esta dentro del rango ACTIVO, \nni dentro de los rangos EN ESPERA de esta SEDE. \nAdemas no puede combinar boletas entre 2 rangos diferentes."
					session("MensajeError")=v_error
					response.Redirect(request.ServerVariables("HTTP_REFERER"))
				end if
		  end if

		
		
		
		sql_menor =	" select count(*) from RANGOS_BOLETAS_CAJEROS  "& vbCrLf &_
						" where "&v_rbca_ninicio&" between rbca_ninicio and rbca_nfin "& vbCrLf &_
						" and tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_
						" and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
						" and erbo_ccod not in (3) "

		v_limite_menor=conexion.consultaUno(sql_menor)
'		response.Write("<pre>"&sql_menor&"</pre>")
				
		sql_mayor =	" select count(*) from RANGOS_BOLETAS_CAJEROS  "& vbCrLf &_
						" where "&v_rbca_nfin&" between rbca_ninicio and rbca_nfin "& vbCrLf &_
						" and tbol_ccod="&v_tbol_ccod&" "& vbCrLf &_
						" and inst_ccod="&v_inst_ccod&" "& vbCrLf &_
						" and erbo_ccod not in (3) "
						
		v_limite_mayor=conexion.consultaUno(sql_mayor)

'		response.Write("<pre>"&sql_mayor&"</pre>")

'response.End()
		if v_limite_menor >0 and v_limite_mayor >0 then
			v_error="ERROR: Las numeracion de las boletas ingresadas ya existen para otro cajero."
		elseif v_limite_menor >0 then
			v_error="ERROR: El rango de INICIO que ha ingresado ya esta siendo usado por otro cajero"
		elseif v_limite_mayor >0 then
			v_error="ERROR: El rango de FIN que ha ingresado ya esta siendo usado por otro cajero"
		else
			v_rbca_ncorr=conexion.consultaUno("exec obtenersecuencia 'rangos_boletas_cajeros' ")
			formulario.AgregaCampoFilaPost fila , "rbca_ncorr", v_rbca_ncorr
			if v_crea_pendiente=true then
				formulario.AgregaCampoFilaPost fila , "erbo_ccod", "4"
			else
				formulario.AgregaCampoFilaPost fila , "erbo_ccod", "1"
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
	session("mensajeError")="Los rangos de boletas ingresados fueron guardadas correctamente "
else
	session("mensajeError")="ERROR: Ocurrio un error al intentar ingresar uno nuevo rango de boletas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
%>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript">
CerrarActualizar();
</script>
