<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "desauas"

'conexion.EstadoTransaccion false

set negocio = new CNegocio
negocio.Inicializa conexion

Periodo = negocio.ObtenerPeriodoAcademico("CLASES18")
'response.Write(Periodo)
sede = negocio.ObtenerSede
'---------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'---------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Ingreso_Pagares_Protestados.xml", "f_letras"
formulario.Inicializar conexion
formulario.ProcesaForm
formulario.AgregaCampoPost "epag_ccod" , 5
'formulario.ListarPost

formulario.AgregaCampoPost "tcom_ccod", 5
formulario.AgregaCampoPost "ecom_ccod", 1
formulario.AgregaCampoPost "comp_fdocto", date
formulario.AgregaCampoPost "comp_ncuotas", 1
formulario.AgregaCampoPost "sede_ccod", Sede
formulario.AgregaCampoPost "dcom_fcompromiso", date
formulario.AgregaCampoPost "dcom_ncompromiso", 1
'formulario.AgregaCampoPost "peri_ccod", Periodo
formulario.AgregaCampoPost "deta_ncantidad", 1
formulario.AgregaCampoPost "inst_ccod", 1

set f_compromiso = new CFormulario
f_compromiso.Carga_Parametros "Ingreso_Pagares_Protestados.xml", "f_protestar"
f_compromiso.Inicializar conexion
f_compromiso.ProcesaForm

set f_ingresos = new CFormulario
f_ingresos.Carga_Parametros "Ingreso_Pagares_Protestados.xml", "f_pactar_ii"
f_ingresos.Inicializar conexion
f_ingresos.ProcesaForm

protestando = false

for fila = 0 to formulario.CuentaPost - 1
   paga_ncorr = formulario.ObtenerValorPost (fila, "paga_ncorr")
   enpa_ncorr = formulario.ObtenerValorPost (fila, "enpa_ncorr")
   
  
   if enpa_ncorr <> "" then
   		protestando = true
   
     
	  valor_pagar =  formulario.ObtenerValorPost (fila, "valor_pagar_c") 
	  bene_ncorr =  formulario.ObtenerValorPost (fila, "bene_ncorr") 
	  nro_inst =  formulario.ObtenerValorPost (fila, "INST_CCOD") 
	  
	  cc_ufom_ncorr= "select nvl(obtener_ufom_ncorr(sysdate),0) ufom_ncorr from dual"
	  ufom_ncorr = conexion.consultaUno(cc_ufom_ncorr)
	  
	  
	  cc_mvalor="select round('"&valor_pagar&"' * ufom_mvalor) valor from uf where ufom_fuf = to_char(sysdate,'DD/MM/YYYY')"
	  mvalor=conexion.consultaUno(cc_mvalor)
	  
	 	 '--------------SECUENCIA ABONO INGR_NCORR -------------------------------
		  f_consulta.Inicializar conexion
		  f_consulta.consultar "select ingr_ncorr_seq.nextval as nuevo_ingr_ncorr from dual"
		  f_consulta.siguiente
		  nuevo_ingr_ncorr = f_consulta.obtenerValor("nuevo_ingr_ncorr")
		  
		  '--------------SECUENCIA DING_NSECUENCIA_SEQ -------------------------------
		  
		  f_consulta.consultar "select ding_nsecuencia_seq.nextval as ding_nsecuencia from dual"
		  f_consulta.siguiente
		  ding_nsecuencia = f_consulta.obtenerValor("ding_nsecuencia")
		  
		  '--------------SECUENCIA INGR_NFOLIO_REFERENCIA -------------------------------
		  
		  f_consulta.consultar "select ingr_nfolio_referencia_seq.nextval as ingr_nfolio_referencia from dual"
		  f_consulta.siguiente
		  ingr_nfolio_referencia = f_consulta.obtenerValor("ingr_nfolio_referencia")
		  
		  '--------------SECUENCIA ABONO INGR_NCORR -------------------------------
		  
		  f_consulta.consultar "select ingr_ncorr_seq.nextval as nuevo_ingr_ncorr from dual"
		  f_consulta.siguiente
		  nuevo_ingr_ncorr = f_consulta.obtenerValor("nuevo_ingr_ncorr")
		  
		  		
          '----------------------------------ABONOS--------------------------------
		  f_compromiso.AgregaCampoFilaPost fila, "ingr_ncorr" , nuevo_ingr_ncorr
		  f_compromiso.AgregaCampoFilaPost fila, "abon_fabono" , date
		  f_compromiso.AgregaCampoFilaPost fila, "abon_mabono" , mvalor
		  
		  '------------------------------- DETALLES INGRESOS ----------------------
		  f_compromiso.AgregaCampoFilaPost fila, "ting_ccod" , 26
		  f_compromiso.AgregaCampoFilaPost fila, "ding_ndocto" , paga_ncorr
		  f_compromiso.AgregaCampoFilaPost fila, "ding_nsecuencia" , ding_nsecuencia
		  f_compromiso.AgregaCampoFilaPost fila, "ding_ncorrelativo" , 1
		  f_compromiso.AgregaCampoFilaPost fila, "ding_fdocto" , date
		  f_compromiso.AgregaCampoFilaPost fila, "ding_nsecuencia" , ding_nsecuencia
		  f_compromiso.AgregaCampoFilaPost fila, "ding_mdetalle" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "ding_mdocto" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "edin_ccod" , 15
		  f_compromiso.AgregaCampoFilaPost fila, "ding_bpacta_cuota" , "S"
		  
		  '-----------------------INGRESOS ------------------------------------------
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_ncorr" , nuevo_ingr_ncorr
		  f_ingresos.AgregaCampoFilaPost fila, "eing_ccod" , 4
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_fpago" , date
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_mefectivo" , 0
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_mdocto" , mvalor
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_mtotal" , mvalor
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_nfolio_referencia" ,ingr_nfolio_referencia
		  f_ingresos.AgregaCampoFilaPost fila, "ting_ccod" , 28
		  f_ingresos.AgregaCampoFilaPost fila, "inst_ccod" , nro_inst
	  
	  
	  '-----------------INSERTA DATOS EN LA TABLAS COMPROMISOS, DETALLES Y DETALLE_COMPROMISOS ----------------
	      f_compromiso.AgregaCampoFilaPost fila,"COMP_NDOCTO" , paga_ncorr
	      f_compromiso.AgregaCampoFilaPost fila, "inst_ccod" , nro_inst
		  f_compromiso.AgregaCampoFilaPost fila, "comp_mdocumento" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "comp_mneto" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "dcom_mdocumento" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "dcom_mcompromiso" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "dcom_mneto" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "ufom_ncorr" , ufom_ncorr
		  
		  
		  
		  
		  		  
		  '------------------------------------------------------------------------------------------------
		  '---  Para la multa
		  valor_multa = formulario.ObtenerValorPost (fila, "multa")   
		  pers_ncorr = formulario.ObtenerValorPost (fila, "pers_ncorr")   
		  
		  if valor_multa = "0" or  valor_multa = "" then
			  valor_multa = "0"
			  formulario.AgregaCampoFilaPost fila, "tcom_ccod", ""       'para que no haga el cargo por la multa x cero pesos
		   end if	  
		   
		   
		   sql = "select multas_intereses_seq.nextval as reca_ncorr from dual"		   
		   reca_ncorr = conexion.ConsultaUno(sql)
		  
		   formulario.AgregaCampofilaPost fila, "comp_ndocto", reca_ncorr		  
		   formulario.AgregaCampoFilaPost fila, "tdet_ccod", "18"
		   
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
		   
		   '-- Fin multa
		   '------------------------------------------------------------------------------------------------
   
   
   
   else
        formulario.EliminaFilaPost fila
   end if 
next

		f_compromiso.AgregaCampoPost "tcom_ccod" , 12
		f_compromiso.AgregaCampoPost "tdet_ccod" , 9
		f_compromiso.AgregaCampoPost "ecom_ccod" , 1
		f_compromiso.AgregaCampoPost "dcom_ncompromiso" , 1
		f_compromiso.AgregaCampoPost "dcom_fcompromiso" , date
		f_compromiso.AgregaCampoPost "comp_fdocto" , date
		f_compromiso.AgregaCampoPost "comp_ncuotas" , 1
		f_compromiso.AgregaCampoPost "peri_ccod" , Periodo
		
IF  (ufom_ncorr=0) and (protestando) then 
		  mensage = " No se ha relizado la operación de protesto debido a que el valor de la UF no se encuentra registrada." 
		  session("mensajeError")= mensage

ELSE 		
		formulario.MantieneTablas false
		f_compromiso.MantieneTablas false
		f_ingresos.MantieneTablas false

end if 
'conexion.estadotransaccion false  'roolback  
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
