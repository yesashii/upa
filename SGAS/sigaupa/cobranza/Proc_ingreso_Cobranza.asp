<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new Cnegocio
negocio.Inicializa conexion

fecha_actual=conexion.consultaUno("select getDate()")

set cajero = new CCajero
cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede
'-----------------------------------------------------------------------
caja_abierta = cajero.obtenerCajaAbierta
Sede = negocio.ObtenerSede

'---------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'---------------------------------------------------------------------
audi_tusuario = negocio.ObtenerUsuario
'---------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
'---------------------------------------------------------------------

set f_abono = new CFormulario
f_abono.Carga_Parametros "Devueltas_cobranza.xml", "f_abono"   ''EFECTUA EL ABONO Y EL INGRESO
f_abono.Inicializar conexion
f_abono.ProcesaForm

'---------------------------------------------------------------------

set f_detalle_ingresos = new CFormulario
f_detalle_ingresos.Carga_Parametros "Devueltas_cobranza.xml", "f_detalle_ingresos"    'EFECTUA EL DETALLE_INGRESO
f_detalle_ingresos.Inicializar conexion
f_detalle_ingresos.ProcesaForm
'---------------------------------------------------------------------

set f_cambia_estado = new CFormulario
f_cambia_estado.Carga_Parametros "Devueltas_cobranza.xml", "f_cambia_estado"    'EFECTUA EL DETALLE_INGRESO
f_cambia_estado.Inicializar conexion
f_cambia_estado.ProcesaForm
'---------------------------------------------------------------------

set f_compromiso = new CFormulario
f_compromiso.Carga_Parametros "Devueltas_cobranza.xml", "f_compromiso"    'EFECTUA EL COMPROMISO POR LOS INTERESES
f_compromiso.Inicializar conexion
f_compromiso.ProcesaForm
'---------------------------------------------------------------------
set f_abono_intereses = new CFormulario
f_abono_intereses.Carga_Parametros "Devueltas_cobranza.xml", "f_abono_multa"   ''EFECTUA EL ABONO Y EL INGRESO
f_abono_intereses.Inicializar conexion
f_abono_intereses.ProcesaForm

'-----------------------------------------------------------------------

set f_referencia_cargo = new CFormulario
f_referencia_cargo.Carga_Parametros "Devueltas_cobranza.xml", "f_referencia_cargo"   ''EFECTUA la refrencia del cargo en la tabla respectiva
f_referencia_cargo.Inicializar conexion
f_referencia_cargo.ProcesaForm

'f_abono.ListarPost



for fila = 0 to f_abono.CuentaPost - 1
   num_doc = f_abono.ObtenerValorPost (fila, "oculto")
   estado = f_abono.ObtenerValorPost (fila, "edin_ccod")
   Monto_Pagado = f_abono.ObtenerValorPost (fila, "C_SALDO_CUOTA") 
   ding_nsecuencia = f_abono.ObtenerValorPost (fila, "ding_nsecuencia") 
   multa = f_abono.ObtenerValorPost (fila, "multa") 
   
   ingr_ncorr = f_abono.ObtenerValorPost (fila, "ingr_ncorr")  
   if num_doc <> "" then
      f_cambia_estado.AgregaCampoFilaPost fila, "edin_ccod" , estado	 
	  
	  if estado = "13" then            '------------DEVUELTO POR COBRANZA
	     f_abono.AgregaCampoFilaPost fila, "ingr_ncorr" , ""  'para que no actualize  en abonos
		 f_detalle_ingresos.AgregaCampoFilaPost fila, "ingr_ncorr" , ""  'para que no actualize  en detalle_ingresos
		 f_compromiso.AgregaCampoFilaPost fila, "tcom_ccod" , ""   'para que no actualize  en compromiso
		 f_abono_intereses.AgregaCampoFilaPost fila, "ingr_ncorr" , ""   'para que no actualize en abono_multa		 
	  end if	  
	  
	  if estado = "6" or estado = "18" then      '----- PAGADO  -------   'se paga el documento	     			 
		 nuevo_ingr_ncorr = obtener_nuevo_ingr_ncorr()
		 nuevo_ingr_nfolio_referencia = obtener_nuevo_ingr_nfolio_referencia()
		 nuevo_ding_nsecuencia = obtener_nuevo_ding_nsecuencia()
	   	 
		 f_abono.AgregaCampoFilaPost fila, "abon_fabono" , fecha_Actual
		 f_abono.AgregaCampoFilaPost fila, "mcaj_ncorr" , caja_abierta
		 f_abono.AgregaCampoFilaPost fila, "eing_ccod" , 1
		 f_abono.AgregaCampoFilaPost fila, "ingr_fpago" , fecha_actual
		 f_abono.AgregaCampoFilaPost fila, "ting_ccod" , 11
		 		     
		 f_abono.AgregaCampoFilaPost fila, "ingr_ncorr" , nuevo_ingr_ncorr
		 f_abono.AgregaCampoFilaPost fila, "abon_mabono" , Monto_Pagado
		 f_abono.AgregaCampoFilaPost fila, "ingr_mdocto" , Monto_Pagado
		 f_abono.AgregaCampoFilaPost fila, "ingr_mtotal" , Monto_Pagado		 
		 f_abono.AgregaCampoFilaPost fila, "ingr_nfolio_referencia" , nuevo_ingr_nfolio_referencia
		 		 
         f_detalle_ingresos.AgregaCampoFilaPost fila, "ding_ncorrelativo" , 1
         f_detalle_ingresos.AgregaCampoFilaPost fila, "ding_fdocto" , fecha_actual
         f_detalle_ingresos.AgregaCampoFilaPost fila, "TING_CCOD" , 11
		   
		 f_detalle_ingresos.AgregaCampoFilaPost fila, "ingr_ncorr" , nuevo_ingr_ncorr
		 f_detalle_ingresos.AgregaCampoFilaPost fila, "ding_ndocto" , ding_nsecuencia
		 f_detalle_ingresos.AgregaCampoFilaPost fila, "ding_nsecuencia" , nuevo_ding_nsecuencia
		 f_detalle_ingresos.AgregaCampoFilaPost fila, "ding_mdetalle" , Monto_Pagado
		 f_detalle_ingresos.AgregaCampoFilaPost fila, "ding_mdocto" , Monto_Pagado
		 
		 if estado = 6 then
             f_compromiso.AgregaCampoFilaPost fila, "tcom_ccod" , ""   'para que no actualize  en compromiso
		     f_abono_intereses.AgregaCampoFilaPost fila, "ingr_ncorr" , ""   'para que no actualize en abono_multa
		 end if			  		 
	  end if	
	  
	  if estado = "18" then   'PAGADO CON INTERESES   ' se hace el cargo por los intereses
         nuevo_reca_ncorr = obtener_nuevo_reca_ncorr()
		 
		 f_compromiso.AgregaCampoFilaPost fila, "tcom_ccod" , 6
		 f_compromiso.AgregaCampoFilaPost fila, "comp_ndocto" , nuevo_reca_ncorr
		 f_compromiso.AgregaCampoFilaPost fila, "ecom_ccod" , 1
		 f_compromiso.AgregaCampoFilaPost fila, "comp_fdocto" , fecha_actual
		 f_compromiso.AgregaCampoFilaPost fila, "comp_ncuotas" , 1
		 f_compromiso.AgregaCampoFilaPost fila, "comp_mneto" , multa
		 f_compromiso.AgregaCampoFilaPost fila, "comp_mdocumento" , multa
		 f_compromiso.AgregaCampoFilaPost fila, "sede_ccod" , Sede		
		 f_compromiso.AgregaCampoFilaPost fila, "dcom_fcompromiso" , fecha_actual
		 f_compromiso.AgregaCampoFilaPost fila, "dcom_mneto" , multa
		 f_compromiso.AgregaCampoFilaPost fila, "dcom_mcompromiso" , multa
		 f_compromiso.AgregaCampoFilaPost fila, "tdet_ccod" , 14
		 f_compromiso.AgregaCampoFilaPost fila, "deta_ncantidad" , 1
 		 f_compromiso.AgregaCampoFilaPost fila, "deta_mvalor_unitario" , multa
		 f_compromiso.AgregaCampoFilaPost fila, "deta_mvalor_detalle" , multa
		 f_compromiso.AgregaCampoFilaPost fila, "deta_msubtotal" , multa
		 
		 '------------AHORA  pagamos la multa ----------------------------
		 nuevo_ingr_ncorr = obtener_nuevo_ingr_ncorr()
		 nuevo_ingr_nfolio_referencia = obtener_nuevo_ingr_nfolio_referencia()
		 nuevo_ding_nsecuencia = obtener_nuevo_ding_nsecuencia()
		 
		 f_abono_intereses.AgregaCampoFilaPost fila, "tcom_ccod" , 6
		 f_abono_intereses.AgregaCampoFilaPost fila, "comp_ndocto" , nuevo_reca_ncorr
		 f_abono_intereses.AgregaCampoFilaPost fila, "ingr_ncorr" , nuevo_ingr_ncorr
		 f_abono_intereses.AgregaCampoFilaPost fila, "abon_fabono" , fecha_actual
		 f_abono_intereses.AgregaCampoFilaPost fila, "abon_mabono" , multa
 		 f_abono_intereses.AgregaCampoFilaPost fila, "mcaj_ncorr" , caja_abierta
		 f_abono_intereses.AgregaCampoFilaPost fila, "eing_ccod" , 1
	     f_abono_intereses.AgregaCampoFilaPost fila, "ingr_fpago" , fecha_actual
		 f_abono_intereses.AgregaCampoFilaPost fila, "ingr_mdocto" , multa
	     f_abono_intereses.AgregaCampoFilaPost fila, "ingr_mtotal" , multa
	     f_abono_intereses.AgregaCampoFilaPost fila, "ingr_nfolio_referencia" , nuevo_ingr_nfolio_referencia
         f_abono_intereses.AgregaCampoFilaPost fila, "ting_ccod" , 11
		 f_abono_intereses.AgregaCampoFilaPost fila, "ding_ndocto" , nuevo_reca_ncorr
         f_abono_intereses.AgregaCampoFilaPost fila, "ding_ncorrelativo" , 1
		 f_abono_intereses.AgregaCampoFilaPost fila, "ding_nsecuencia" , nuevo_ding_nsecuencia
		 f_abono_intereses.AgregaCampoFilaPost fila, "ding_fdocto" , fecha_actual
		 f_abono_intereses.AgregaCampoFilaPost fila, "ding_mdetalle" , multa
		 f_abono_intereses.AgregaCampoFilaPost fila, "ding_mdocto" , multa
		 
		 '-------------- ahora guardamos la referencia del cargo -----------------------------
		 
		  f_referencia_cargo.AgregaCampoFilaPost fila, "reca_ncorr" , nuevo_reca_ncorr
		  f_referencia_cargo.AgregaCampoFilaPost fila, "reca_mmonto" , multa		 
	  end if
   else
	 f_abono.EliminaFilaPost fila 
	 f_detalle_ingresos.EliminaFilaPost fila
	 f_cambia_estado.EliminaFilaPost fila
	 f_compromiso.EliminaFilaPost fila
	 f_abono_intereses.EliminaFilaPost fila
	 f_referencia_cargo.EliminaFilaPost fila
	 	 
   end if
next

f_cambia_estado.MantieneTablas true
f_abono.MantieneTablas true
f_detalle_ingresos.MantieneTablas true
f_compromiso.MantieneTablas true
f_abono_intereses.MantieneTablas true
f_referencia_cargo.MantieneTablas true

conexion.estadotransaccion false  'roolback  
'response.Redirect(Request.ServerVariables("HTTP_REFERER"))



 function obtener_nuevo_ingr_ncorr()
    f_consulta.Inicializar conexion
	f_consulta.consultar "execute obtenerSecuencia 'ingresos'"
	f_consulta.siguiente
	valor = f_consulta.obtenerValor("nuevo_ingr_ncorr")
    obtener_nuevo_ingr_ncorr = valor
 end function

 function obtener_nuevo_ingr_nfolio_referencia()
   f_consulta.Inicializar conexion
   f_consulta.consultar "execute obtenerSecuencia 'ingresos_referencia'"
   f_consulta.siguiente
   obtener_nuevo_ingr_nfolio_referencia = f_consulta.obtenerValor("nuevo_folio_ref")
 end function
 
 function obtener_nuevo_ding_nsecuencia()
    f_consulta.Inicializar conexion
	'f_consulta.consultar "select ding_nsecuencia_seq.nextval as nuevo_ding_nsecuencia from dual"
	f_consulta.consultar "execute obtenerSecuencia 'ingresos'"
	f_consulta.siguiente
	valor = f_consulta.obtenerValor("nuevo_ding_nsecuencia")
    obtener_nuevo_ding_nsecuencia = valor
 end function
 
  function obtener_nuevo_reca_ncorr()
    f_consulta.Inicializar conexion
	f_consulta.consultar "select multas_intereses_seq.nextval as nuevo_reca_ncorr from dual"
	f_consulta.consultar "execute obtenerSecuencia 'compromisos'"
	f_consulta.siguiente
	valor = f_consulta.obtenerValor("nuevo_reca_ncorr")
    obtener_nuevo_reca_ncorr = valor
 end function

%>
