<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"
'response.Write("llegue")
'response.End()
set negocio = new CNegocio
negocio.Inicializa conexion

v_msg_auditoria= " - prorroga." 

'-----------------------------------------------------------------------
'conexion.estadotransaccion false  'roolback  
Usuario = negocio.ObtenerUsuario
Sede = negocio.ObtenerSede
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'---------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
'---------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Ingreso_prorroga.xml", "f_documentos"
formulario.Inicializar conexion
formulario.ProcesaForm
'---------------------------------------------------------------------
set f_log = new CFormulario
f_log.Carga_Parametros "Ingreso_prorroga.xml", "f_detalle_ingresos_log"
f_log.Inicializar conexion
f_log.ProcesaForm
'--------------------------------------------------------------------
set f_cambia_fecha = new CFormulario
f_cambia_fecha.Carga_Parametros "Ingreso_prorroga.xml", "f_cambia_fecha"
f_cambia_fecha.Inicializar conexion
f_cambia_fecha.ProcesaForm
'--------------------------------------------------------------------

'formulario.AgregaCampoPost "edin_ccod", 8 
formulario.AgregaCampoPost "tcom_ccod", 5
formulario.AgregaCampoPost "ecom_ccod", 1
formulario.AgregaCampoPost "comp_fdocto", date
formulario.AgregaCampoPost "comp_ncuotas", 1
formulario.AgregaCampoPost "sede_ccod", Sede
formulario.AgregaCampoPost "dcom_fcompromiso", date
formulario.AgregaCampoPost "dcom_ncompromiso", 1
formulario.AgregaCampoPost "deta_ncantidad", 1
formulario.AgregaCampoPost "inst_ccod", 1

'f_cambia_fecha.ListarPost

for fila = 0 to formulario.CuentaPost - 1
   num_doc = formulario.ObtenerValorPost (fila, "ding_ndocto")
   ting_ccod  = formulario.ObtenerValorPost (fila, "ting_ccod")
   num_secuencia = formulario.ObtenerValorPost (fila, "ding_nsecuencia")
   pers_ncorr = formulario.ObtenerValorPost (fila, "pers_ncorr")
   valor_multa = formulario.ObtenerValorPost (fila, "multa")
   nueva_fecha = formulario.ObtenerValorPost (fila, "nueva_fecha")
   estado_original = formulario.ObtenerValorPost (fila, "c_edin_ccod") 
   ding_ncorrelativo = formulario.ObtenerValorPost (fila, "ding_ncorrelativo") 
   plaz_ccod = formulario.ObtenerValorPost (fila, "plaz_ccod")  
   banc_ccod = formulario.ObtenerValorPost (fila, "banc_ccod")  
   ding_fdocto = formulario.ObtenerValorPost (fila, "c_ding_fdocto")
   ding_mdetalle = formulario.ObtenerValorPost (fila, "ding_mdetalle")
   c_ding_mdocto = formulario.ObtenerValorPost (fila, "c_ding_mdocto")
   ding_tcuenta_corriente = formulario.ObtenerValorPost (fila, "ding_tcuenta_corriente") 
   envi_ncorr = formulario.ObtenerValorPost (fila, "envi_ncorr") 
   repa_ncorr = formulario.ObtenerValorPost (fila, "repa_ncorr")        
   
   if num_doc = "" or nueva_fecha = "" then
     formulario.EliminaFilaPost fila 
	 f_log.EliminaFilaPost fila 
	 f_cambia_fecha.EliminaFilaPost fila   
   else
       if valor_multa = "" or valor_multa = "0" then
	      valor_multa = "0"
		  formulario.AgregaCampoFilaPost fila, "tcom_ccod", ""       'para que no haga el cargo por la multa x cero pesos
	   end if
	   f_cambia_fecha.AgregaCampoFilaPost fila, "dcom_fcompromiso", nueva_fecha
	   
	   f_consulta.Inicializar conexion

	   reca_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'referencias_cargos'")

   	   formulario.AgregaCampoFilaPost fila, "comp_ndocto", reca_ncorr
	   
   	   dilg_ncorr = reca_ncorr
	  
       f_log.AgregaCampoFilaPost fila, "dilg_ncorr", dilg_ncorr
	   f_log.AgregaCampoFilaPost fila, "ding_ncorrelativo", ding_ncorrelativo
	   f_log.AgregaCampoFilaPost fila, "plaz_ccod", plaz_ccod
	   f_log.AgregaCampoFilaPost fila, "banc_ccod", banc_ccod
	   f_log.AgregaCampoFilaPost fila, "ding_fdocto", ding_fdocto
	   f_log.AgregaCampoFilaPost fila, "ding_mdetalle", ding_mdetalle
	   f_log.AgregaCampoFilaPost fila, "ding_mdocto", c_ding_mdocto
	   f_log.AgregaCampoFilaPost fila, "ding_tcuenta_corriente", ding_tcuenta_corriente
	   f_log.AgregaCampoFilaPost fila, "envi_ncorr", envi_ncorr
	   f_log.AgregaCampoFilaPost fila, "repa_ncorr", repa_ncorr
	   f_log.AgregaCampoFilaPost fila, "edin_ccod", estado_original  
	  
	   formulario.AgregaCampoFilaPost fila, "tdet_ccod", 15
	     
       formulario.AgregaCampoFilaPost fila, "pers_ncorr", pers_ncorr
       formulario.AgregaCampoFilaPost fila, "comp_mneto", valor_multa
       formulario.AgregaCampoFilaPost fila, "comp_mdocumento", valor_multa 
	   formulario.AgregaCampoFilaPost fila, "dcom_mneto", valor_multa 
	   formulario.AgregaCampoFilaPost fila, "dcom_mcompromiso", valor_multa 
	   formulario.AgregaCampoFilaPost fila, "deta_mvalor_unitario", valor_multa 
	   formulario.AgregaCampoFilaPost fila, "deta_mvalor_detalle", valor_multa 
	   formulario.AgregaCampoFilaPost fila, "deta_msubtotal", valor_multa 
	   
   	   formulario.AgregaCampoFilaPost fila, "reca_ncorr", reca_ncorr
	   formulario.AgregaCampoFilaPost fila, "reca_mmonto", valor_multa
	   formulario.AgregaCampoFilaPost fila, "ding_fdocto", nueva_fecha
	   
	' para prorrogar protestos asociados a una letra
	if ting_ccod="4" then
		' buscar protesto asociado
		sql_compromiso="select b.comp_ndocto from detalle_ingresos a, abonos b "&_
						" where a.ingr_ncorr=b.ingr_ncorr "&_
						" and ding_ndocto='"&num_doc&"' "&_
						" and ting_ccod=87 "
		'response.Write("<br>"&sql_compromiso)
		'response.Flush()
		v_comp_ndocto =conexion.ConsultaUno(sql_compromiso)

		if v_comp_ndocto <> "" then
				actualiza_detalle="update detalle_ingresos set ding_fdocto='"&nueva_fecha&"', audi_tusuario='"&Usuario&v_msg_auditoria&"' where ding_ndocto="&num_doc&" and ting_ccod=87 "
				actualiza_compromiso="update detalle_compromisos set dcom_fcompromiso='"&nueva_fecha&"' where tcom_ccod=5 and inst_ccod=1 and comp_ndocto="&v_comp_ndocto&" and dcom_ncompromiso=1 "
			'response.Write("<br>"&actualiza_detalle)
			'response.Write("<br>"&actualiza_compromiso)
			'response.Flush()
			conexion.ejecutaS(actualiza_detalle)	
			conexion.ejecutaS(actualiza_compromiso)	
		end if

	end if

   end if 
next

f_cambia_fecha.MantieneTablas false
f_log.MantieneTablas false
formulario.MantieneTablas false

'conexion.EstadoTransaccion false
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
