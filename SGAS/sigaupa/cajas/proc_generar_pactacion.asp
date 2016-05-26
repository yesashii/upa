<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%

'for each x in request.Form
'	response.Write(x&"->"&request.Form(x)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set variables = new CVariables
variables.ProcesaForm

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

Usuario = negocio.ObtenerUsuario()
v_mcaj_ncorr = cajero.ObtenerCajaAbierta
v_comp_ndocto = variables.ObtenerValor("detalles_pactacion", 0, "comp_ndocto")
'response.Write("comp_ndocto "&v_comp_ndocto)
'response.End()

'-----------------------------------------------------------------------------------------------------------
set f_detalles_pactacion = new CFormulario
f_detalles_pactacion.Carga_Parametros "agregar_cargo_pactacion.xml", "detalles_pactacion"
f_detalles_pactacion.Inicializar conexion
f_detalles_pactacion.ProcesaForm
f_detalles_pactacion.MantieneTablas false

'response.End()


'conexion.estadotransaccion false

'-----------------------------------------------------------------------------------------------------------
sentencia = "execute genera_pactacion '" & v_comp_ndocto & "','" & negocio.ObtenerSede & "','" & negocio.ObtenerPeriodoAcademico("POSTULACION") & "','" & v_mcaj_ncorr & "'"
'response.Write(sentencia)
'response.End()
conexion.EstadoTransaccion conexion.EjecutaP(sentencia)
'conexion.EstadoTransaccion true


'###################################################################################
'###########################			BOLETAS 		############################

		sql_ingreso=" select c.ingr_nfolio_referencia " & vbCrLf &_   
					" 	from sim_pactaciones a " & vbCrLf &_
					"	join abonos b " & vbCrLf &_
					"		on a.comp_ndocto = b.comp_ndocto " & vbCrLf &_      
					"		and a.inst_ccod = b.inst_ccod  " & vbCrLf &_     
					"		and a.tcom_ccod = b.tcom_ccod " & vbCrLf &_
					"  join ingresos c " & vbCrLf &_
					"		on b.ingr_ncorr = c.ingr_ncorr " & vbCrLf &_ 
					"  left outer join detalle_ingresos d  " & vbCrLf &_
					"		on c.ingr_ncorr= d.ingr_ncorr " & vbCrLf &_
					"		and d.ting_ccod not in (5) " & vbCrLf &_    
					"  where cast(a.comp_ndocto as varchar) = '" & v_comp_ndocto & "' " & vbCrLf &_    
					"		and b.tcom_ccod in (7) " & vbCrLf &_      
					"		and c.ting_ccod=33 " & vbCrLf &_ 
					" group by c.ingr_nfolio_referencia "

	 
	v_folio_referencia   =conexion.consultaUno(sql_ingreso)

	if v_folio_referencia <> "" then
		sql_crea_boletas="Exec genera_boletas_electronicas 1,"&v_folio_referencia&", 33, "&negocio.ObtenerSede&","&v_mcaj_ncorr&", '"&Usuario&"' "
		v_salida = conexion.ConsultaUno(sql_crea_boletas)
		
		'***********************************************************************************
		sql_boletas="select pers_ncorr,isnull(pers_ncorr_aval,pers_ncorr)as pers_ncorr_aval,bole_ncorr from boletas where ingr_nfolio_referencia="&v_folio_referencia
	else
		sql_boletas="select '' "
	end if

	 set f_boletas = new CFormulario	
	 f_boletas.Carga_Parametros "tabla_vacia.xml","tabla"
	 f_boletas.Inicializar conexion
	 f_boletas.Consultar sql_boletas
	'***********************************************************************************

'###################################################################################



'---------------------------------------------------------------------------------------------------------------------
if conexion.ObtenerEstadoTransaccion then
	str_url = "imprimir_pactacion.asp?comp_ndocto="&v_comp_ndocto
else
	str_url = Request.ServerVariables("HTTP_REFERER")
end if
'Response.Write(str_url)


%>

<script language="javascript" type="text/javascript">
	 <%

	'IF negocio.ObtenerUsuario ="8876413" or negocio.ObtenerUsuario ="11853739" or negocio.ObtenerUsuario ="8861959" or negocio.ObtenerUsuario ="12234131" or negocio.ObtenerUsuario ="8533344" or negocio.ObtenerUsuario ="13275090" then	
		cantidad=f_boletas.nroFilas
		 if cantidad >0 then
			fila=0
			while f_boletas.siguiente
				
				  v_pers_ncorr=f_boletas.ObtenerValor("pers_ncorr")
				  v_pers_ncorr_aval=f_boletas.ObtenerValor("pers_ncorr_aval")
				  v_bole_ncorr=f_boletas.ObtenerValor("bole_ncorr")
				  if v_bole_ncorr <> "" then
					url="ver_detalle_boletas.asp?bole_ncorr="&v_bole_ncorr&"&pers_ncorr="&v_pers_ncorr&"&pers_ncorr_aval="&v_pers_ncorr_aval
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
<script language="JavaScript">
   location.reload("<%=str_url%>") 
</script>



