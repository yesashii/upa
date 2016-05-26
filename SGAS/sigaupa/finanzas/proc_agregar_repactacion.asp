<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

'conexion.EstadoTransaccion false


'for each k in request.form
'response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

set negocio = new CNegocio
negocio.Inicializa conexion

set variables = new CVariables
variables.ProcesaForm

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

v_mcaj_ncorr = cajero.ObtenerCajaAbierta

Usuario = negocio.ObtenerUsuario()

v_repa_ncorr = variables.ObtenerValor("repactaciones", 0, "repa_ncorr")
'response.Write("datos "&v_repa_ncorr)
'response.End()
'response.End()
'conexion.consultaUno()
q_mrep_ccod=conexion.consultaUno("select mrep_ccod from SIM_REPACTACIONES where cast(repa_ncorr as varchar)='"&v_repa_ncorr&"' ")
q_post_ncorr=conexion.consultaUno("select post_ncorr from SIM_REPACTACIONES a,contratos b where a.comp_ndocto= b.cont_ncorr and cast(repa_ncorr as varchar)='"&v_repa_ncorr& "'")
'response.Write(q_post_ncorr&" <br>")
'response.Write(q_mrep_ccod&" <br>")

'-----------------------------------------------------------------------------------------------------------
set f_detalles_repactacion = new CFormulario
f_detalles_repactacion.Carga_Parametros "agregar_repactacion.xml", "detalles_repactacion"
f_detalles_repactacion.Inicializar conexion
f_detalles_repactacion.ProcesaForm
f_detalles_repactacion.MantieneTablas false

'conexion.EstadoTransaccion
'response.End()

set f_detalle_ingresos = new CFormulario
f_detalle_ingresos.Carga_Parametros "agregar_repactacion.xml", "detalle_ingresos"
f_detalle_ingresos.Inicializar conexion
f_detalle_ingresos.ProcesaForm
f_detalle_ingresos.MantieneTablas false


'-----------------------------------------------------------------------------------------------------------
sentencia = "exec genera_repactacion '" & v_repa_ncorr & "', '" & negocio.ObtenerSede & "', '" & negocio.ObtenerPeriodoAcademico("POSTULACION") & "', '" & v_mcaj_ncorr & "'"
'response.write sentencia
'response.end
conexion.EstadoTransaccion conexion.EjecutaP(sentencia)

ubicado=conexion.consultaUno("select count(*) from repactaciones where cast(repa_ncorr as varchar)='"&v_repa_ncorr&"'")
'---------------------------------------------------------------------------------------------------------------------

if (cInt(ubicado)>0)then
	str_url = "imprimir_repactacion.asp?repa_ncorr=" & v_repa_ncorr
	
		'###################################################################################
		'###########################			BOLETAS 		############################
		
		'IF Usuario ="8861959" or Usuario ="11853739" or Usuario ="12234131" or Usuario ="8533344" or Usuario ="13373873" or Usuario ="13275090" then	
		
			sql_ingreso= " Select b.ingr_nfolio_referencia " & vbCrLf &_
							"	From abonos a, ingresos b, detalle_ingresos c, tipos_ingresos d   " & vbCrLf &_ 
							"	Where a.ingr_ncorr = b.ingr_ncorr    " & vbCrLf &_
							"	  and b.ingr_ncorr = c.ingr_ncorr   " & vbCrLf &_ 
							"	  and b.ting_ccod = d.ting_ccod    " & vbCrLf &_
							"	  and a.tcom_ccod = 3    " & vbCrLf &_
							"	  and b.eing_ccod = 7    " & vbCrLf &_
							"	  and c.ting_ccod = 44    " & vbCrLf &_
							"	  and cast(a.comp_ndocto as varchar)= '"& v_repa_ncorr&"'   " & vbCrLf &_ 
							"	group by b.ting_ccod, b.ingr_nfolio_referencia "
			 
			v_folio_referencia   =conexion.consultaUno(sql_ingreso)
			
			'***********************************************************************************
				if v_folio_referencia <> "" then
					sql_crea_boletas="Exec genera_boletas_electronicas 2,"&v_folio_referencia&", 16, "&negocio.ObtenerSede&","&v_mcaj_ncorr&", '"&Usuario&"' "

					v_salida = conexion.ConsultaUno(sql_crea_boletas)
					sql_boletas="select pers_ncorr,isnull(pers_ncorr_aval,pers_ncorr)as pers_ncorr_aval,bole_ncorr from boletas where ingr_nfolio_referencia="&v_folio_referencia
				else
				' si no encontro un compromiso por intereses busca la titulacion
					sql_titulacion="select b.ingr_nfolio_referencia " & vbCrLf &_
									" from detalle_ingresos a, ingresos b, abonos c, detalles d" & vbCrLf &_
									" where a.ting_ccod=53 " & vbCrLf &_
									" and a.repa_ncorr='"& v_repa_ncorr&"' " & vbCrLf &_
									" and a.ingr_ncorr=b.ingr_ncorr" & vbCrLf &_
									" and b.ingr_ncorr=c.ingr_ncorr" & vbCrLf &_
									" and c.tcom_ccod=d.tcom_ccod" & vbCrLf &_
									" and c.comp_ndocto=d.comp_ndocto" & vbCrLf &_
									" and d.tdet_ccod=1230" 
					v_folio_referencia   =conexion.consultaUno(sql_titulacion)

					if v_folio_referencia <> "" then
						sql_crea_boletas="Exec genera_boletas_electronicas 2,"&v_folio_referencia&", 16, "&negocio.ObtenerSede&","&v_mcaj_ncorr&", '"&Usuario&"' "
						v_salida = conexion.ConsultaUno(sql_crea_boletas)
						sql_boletas="select pers_ncorr,isnull(pers_ncorr_aval,pers_ncorr)as pers_ncorr_aval,bole_ncorr from boletas where cast(ingr_nfolio_referencia as varchar)='"&v_folio_referencia&"' "
					else
						sql_boletas="Select * from boletas where 1=2 "
					end if
				end if
			

				 set f_boletas = new CFormulario	
				 f_boletas.Carga_Parametros "tabla_vacia.xml","tabla"
				 f_boletas.Inicializar conexion
				 f_boletas.Consultar sql_boletas
			'***********************************************************************************
			
			
		'END IF
		'###################################################################################
	
else
	str_url = Request.ServerVariables("HTTP_REFERER")
end if
'response.End()
%>
<script language="javascript" type="text/javascript">
	 <%
	'IF Usuario ="8861959" or Usuario ="11853739" or Usuario ="12234131" or Usuario ="8533344" or Usuario ="13373873" or Usuario ="13275090" then	 

	 cantidad=f_boletas.nroFilas
		 if cantidad >0 then
			fila=0
			
			while f_boletas.siguiente
				
				  v_pers_ncorr=f_boletas.ObtenerValor("pers_ncorr")
				  v_pers_ncorr_aval=f_boletas.ObtenerValor("pers_ncorr_aval")
				  v_bole_ncorr=f_boletas.ObtenerValor("bole_ncorr")
				  if v_bole_ncorr <> "" then
					url="../cajas/ver_detalle_boletas.asp?bole_ncorr="&v_bole_ncorr&"&pers_ncorr="&v_pers_ncorr&"&pers_ncorr_aval="&v_pers_ncorr_aval
					%>
						window.open("<%=url%>","<%=v_bole_ncorr%>");
					<%
				  end if
				  fila=fila+1
		
			wend	
		 end if
	'END IF
	%>
</script>
<%
'Response.Write(conexion.ObtenerEstadoTransaccion)
'conexion.estadotransaccion false
'response.End()
%>
<script language="JavaScript">
   location.reload("<%=str_url%>") 
</script>