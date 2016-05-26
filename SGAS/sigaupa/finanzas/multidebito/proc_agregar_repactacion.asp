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
'response.End()
'if cint(q_mrep_ccod)=8 then
'	stde_ccod="1402"
'end if
'if cint(q_mrep_ccod)=9 then
'	stde_ccod="1550"
'end if
'if cint(q_mrep_ccod)=10 then
'	stde_ccod="1544"
'end if
'if cint(q_mrep_ccod) > 10 then
'	stde_ccod="0"
'end if

'if cint(q_mrep_ccod) < 8 then
'	stde_ccod="0"
'end if

'response.Write("<pre>stde"&stde_ccod&"</pre>")
'q_post_ncorr=115093
'response.Write("<br> select case count(post_ncorr) when 0 then 'N' else 'S' end from alumno_credito where post_ncorr="&q_post_ncorr&" and tdet_ccod='"&stde_ccod&"'")

'tipo_alumno_cae=""
'existe=conexion.ConsultaUno("select case count(post_ncorr) when 0 then 'N' else 'S' end from alumno_credito where cast(post_ncorr as varchar)='"&q_post_ncorr&"' and tdet_ccod='"&stde_ccod&"'")
''response.End()
'if existe="N" then

'	usu=negocio.obtenerUsuario

'	if  stde_ccod="1544" or stde_ccod="1550"   then 
	
'		acre_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'alumno_credito'")
'		'acre_ncorr=10000

'		p_insert="insert into alumno_credito(acre_ncorr,post_ncorr,tdet_ccod,audi_tusuario,tipo_alumno_cae,audi_fmodificacion) values("&acre_ncorr&","&q_post_ncorr&",'"&stde_ccod&"','"&usu&"','"&tipo_alumno_cae&"',getdate())"		  
'		'response.Write("<pre>"&p_insert&"</pre>")
'		conexion.ejecutaS (p_insert)
	
'	end if

'	if stde_ccod ="1402" then
'		pers_ncorr=conexion.ConsultaUno("select pers_ncorr from postulantes where post_ncorr="&q_post_ncorr&"")
		
'		tipo_alumno_cae=conexion.ConsultaUno("select protic.tipo_alumno_CAE ("&pers_ncorr&","&q_post_ncorr&")")
		
'		existe_postulante_cae=conexion.ConsultaUno("select case count(post_ncorr) when 0 then 'N' else 'S' end from alumno_credito where post_ncorr="&q_post_ncorr&" and tdet_ccod='1645'")
	
'		if existe_postulante_cae ="S" then
		
'			acre_ncorr=conexion.ConsultaUno("select acre_ncorr from alumno_credito where tdet_ccod=1645 and post_ncorr="&q_post_ncorr&"")
			

'			update_cr_alum ="update alumno_credito set tdet_ccod=1402, tipo_alumno_cae='"&tipo_alumno_cae&"',audi_tusuario='"&usu&"',audi_fmodificacion=getdate() where acre_ncorr="&acre_ncorr&""  
'			conexion.ejecutaS (update_cr_alum)
'			'response.Write("<pre>"&update_cr_alum&"</pre>")
'		else
'			acre_ncorr=conexion.ConsultaUno("exec ObtenerSecuencia 'alumno_credito'")

'			pp_insert="insert into alumno_credito(acre_ncorr,post_ncorr,tdet_ccod,audi_tusuario,tipo_alumno_cae,audi_fmodificacion) values("&acre_ncorr&","&q_post_ncorr&",'"&stde_ccod&"','"&usu&"','"&tipo_alumno_cae&"',getdate())"		  
'				'response.Write("<pre>"&pp_insert&"</pre>")
'			conexion.ejecutaS (pp_insert)
			
'		end if
	
'	end if
'end if
''response.End()
''existe_alumno_post_cae=
''response.write("repa_ncorr="&v_repa_ncorr&"<br>")
''response.End()
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
conexion.EstadoTransaccion conexion.EjecutaP(sentencia)

ubicado=conexion.consultaUno("select count(*) from repactaciones where cast(repa_ncorr as varchar)='"&v_repa_ncorr&"'")
'response.Write("<br>ubicado: "&ubicado)
'Response.Write("<pre> Estado_Transaccion: <b>"&conexion.ObtenerEstadoTransaccion&"</b></pre>")
'conexion.estadotransaccion false
'response.Write("<br>"&sentencia)
'response.End()
'On Error Resume Next
'bejecutaP = false
'conexion.EjecutaS(sentencia)

 'conexion.EjecutaS(sentencia)
'---------------------------------------------------------------------------------------------------------------------
'msj_error = negocio.ObtenerErrorOracle(Err.Description)



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