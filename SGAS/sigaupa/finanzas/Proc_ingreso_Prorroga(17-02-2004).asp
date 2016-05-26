<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion
'-----------------------------------------------------------------------
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

formulario.AgregaCampoPost "edin_ccod", 8 
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
   
   'response.Write(inst_ccod_ref & " " & tcom_ccod_ref  & " " & comp_ndocto_ref & "<BR><BR>")
   if num_doc = "" or  valor_multa = "" then
     formulario.EliminaFilaPost fila 
	 f_log.EliminaFilaPost fila 
	 f_cambia_fecha.EliminaFilaPost fila   
   else
       f_cambia_fecha.AgregaCampoFilaPost fila, "dcom_fcompromiso", nueva_fecha
	   
	   f_consulta.Inicializar conexion
       sql = "select multas_intereses_seq.nextval as reca_ncorr from dual"
       f_consulta.Consultar sql
	   f_consulta.siguiente
	   reca_ncorr = f_consulta.ObtenerValor("reca_ncorr")

   	   formulario.AgregaCampoFilaPost fila, "comp_ndocto", reca_ncorr
	   
	   'f_consulta.Inicializar conexion
       'sql = "select dilg_ncorr_seq.nextval as dilg_ncorr  from dual"
       'f_consulta.Consultar sql
	   'f_consulta.siguiente	   
	   'dilg_ncorr = f_consulta.ObtenerValor("dilg_ncorr")
   	   dilg_ncorr = reca_ncorr
	  
       f_log.AgregaCampoFilaPost fila, "dilg_ncorr", dilg_ncorr
	   f_log.AgregaCampoFilaPost fila, "ding_ncorrelativo", ding_ncorrelativo
	   f_log.AgregaCampoFilaPost fila, "plaz_ccod", plaz_ccod
	   f_log.AgregaCampoFilaPost fila, "banc_ccod", banc_ccod
	   f_log.AgregaCampoFilaPost fila, "ding_fdocto", ding_fdocto
	   f_log.AgregaCampoFilaPost fila, "ding_mdetalle", ding_mdetalle
	   f_log.AgregaCampoFilaPost fila, "ding_mdocto", c_ding_mdocto
	   f_log.AgregaCampoFilaPost fila, "ding_tcuenta_corriente", ding_tcuenta_corriente
	   f_log.AgregaCampoFilaPost fila,"envi_ncorr", envi_ncorr
	   f_log.AgregaCampoFilaPost fila, "repa_ncorr", repa_ncorr
	   f_log.AgregaCampoFilaPost fila, "edin_ccod", estado_original  
	  
	   if ting_ccod = 3 then
         formulario.AgregaCampoFilaPost fila, "tdet_ccod", 12
	   else
	     formulario.AgregaCampoFilaPost fila, "tdet_ccod", 13
	   end if
	     
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
	   
   end if 
next

f_cambia_fecha.MantieneTablas false
f_log.MantieneTablas false
formulario.MantieneTablas true

conexion.estadotransaccion false  'roolback  

'response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
