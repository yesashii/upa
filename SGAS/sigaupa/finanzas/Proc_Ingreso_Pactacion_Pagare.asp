<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "desauas"

set negocio = new CNegocio
negocio.Inicializa conexion

'conexion.EstadoTransaccion false

'-----------------------------------------------------------------------


Periodo = negocio.ObtenerPeriodoAcademico("CLASES18")
'-----------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
'-----------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Ingreso_Pactacion_Pagare.xml", "f_letras"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost

'response.End()
set f_compromiso = new CFormulario
f_compromiso.Carga_Parametros "Ingreso_Pactacion_Pagare.xml", "f_pactar"
f_compromiso.Inicializar conexion
f_compromiso.ProcesaForm

set f_ingresos = new CFormulario
f_ingresos.Carga_Parametros "Ingreso_Pactacion_Pagare.xml", "f_pactar_ii"
f_ingresos.Inicializar conexion
f_ingresos.ProcesaForm

set f_prorroga = new CFormulario
f_prorroga.Carga_Parametros "Ingreso_Pactacion_Pagare.xml", "f_prorrogar"
f_prorroga.Inicializar conexion
f_prorroga.ProcesaForm






for fila = 0 to formulario.CuentaPost - 1
   num_pagare = formulario.ObtenerValorPost (fila, "oculto")
   num_pagare_c = formulario.ObtenerValorPost (fila, "oculto")
  
  
   if num_pagare <> "" then
      
      estado = formulario.ObtenerValorPost (fila, "epag_ccod")
	  ingreso = formulario.ObtenerValorPost (fila, "enpa_ncorr")
      nro_persona = formulario.ObtenerValorPost (fila, "pers_ncorr")
      nueva_fecha =  formulario.ObtenerValorPost (fila, "nueva_fecha") 
	  valor_pagar =  formulario.ObtenerValorPost (fila, "valor_pagar_c")
	  fecha_operacion = formulario.ObtenerValorPost (fila, "fecha_operacion")
	  
	   
	  bene_ncorr =  formulario.ObtenerValorPost (fila, "bene_ncorr") 
	  nro_inst =  formulario.ObtenerValorPost (fila, "INST_CCOD") 
	  monto_pactar_uf = formulario.ObtenerValorPost (fila, "monto_pactar") : monto_pactar_uf = Replace(monto_pactar_uf, ".", ",")
	  
	  'session("mensajeError") = monto_pactar_uf
	  'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
	  
	  
	  
	  'cc_ufom_ncorr= "select nvl(obtener_ufom_ncorr(sysdate),0) ufom_ncorr from dual"
	  cc_ufom_ncorr= "select nvl(obtener_ufom_ncorr(to_date('" & fecha_operacion & "', 'dd/mm/yyyy')), 0) ufom_ncorr from dual"
	  ufom_ncorr = conexion.consultaUno(cc_ufom_ncorr)
	  
	  'cc_ano_actual= "select to_char(sysdate,'YYYY') ano_actual from dual"
	  cc_ano_actual= "select to_char(to_date('" & fecha_operacion & "', 'dd/mm/yyyy'), 'YYYY') ano_actual from dual"
	  ano_actual = conexion.consultaUno(cc_ano_actual)
	  
	  'cc_mvalor="select round('"&valor_pagar&"' * ufom_mvalor) valor from uf where ufom_fuf = to_char(sysdate,'DD/MM/YYYY')"
	  cc_mvalor="select round('"&valor_pagar&"' * ufom_mvalor) valor from uf where ufom_fuf = to_date('" & fecha_operacion & "', 'dd/mm/yyyy')"
	  mvalor=conexion.consultaUno(cc_mvalor)
	  
	  'cc_mpactar="select round('"&monto_pactar_uf&"' * ufom_mvalor) valor from uf where ufom_fuf = to_char(sysdate,'DD/MM/YYYY')"
	  cc_mpactar="select round('"&monto_pactar_uf&"' * ufom_mvalor) valor from uf where ufom_fuf = to_date('" & fecha_operacion & "', 'dd/mm/yyyy')"
	  monto_pactar_m=conexion.consultaUno(cc_mpactar)
	  
	  '----------ACTUALIZA EL ESTADO DEL PAGARE -----------------------------------------
	  
	  if (ingreso <>"" and ufom_ncorr<>0 )then
	      consulta = "UPDATE detalle_envios_pagares SET epag_ccod = "& estado &", audi_tusuario = '" & negocio.ObtenerUsuario & "', audi_fmodificacion = sysdate WHERE enpa_ncorr='" & ingreso & "' and paga_ncorr='"&num_pagare &"'"
           conexion.EstadoTransaccion conexion.EjecutaS(consulta)
	  end if 
	  
	  
	  
	 '------------------------------------------------------------------- 
	 '                  	PACTACION PAGARE 
	 '-------------------------------------------------------------------
	  'if (estado = 4) then 
	   select case estado 
	   case 4:
	      if (ufom_ncorr<>0) then 
		        
	      		consulta = "UPDATE pagares SET epag_ccod = "& estado &", ufom_ncorr="& ufom_ncorr &", audi_tusuario = '" & negocio.ObtenerUsuario & "', audi_fmodificacion = sysdate WHERE paga_ncorr='" & num_pagare & "'"
				conexion.EstadoTransaccion conexion.EjecutaS(consulta)
		  end if
		  
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
		  'f_compromiso.AgregaCampoFilaPost fila, "abon_fabono" , date
		  f_compromiso.AgregaCampoFilaPost fila, "abon_fabono" , fecha_operacion
		  f_compromiso.AgregaCampoFilaPost fila, "abon_mabono" , mvalor
		  
		  '------------------------------- DETALLES INGRESOS ----------------------
		  f_compromiso.AgregaCampoFilaPost fila, "ting_ccod" , 26
		  f_compromiso.AgregaCampoFilaPost fila, "ding_ndocto" , num_pagare
		  f_compromiso.AgregaCampoFilaPost fila, "ding_nsecuencia" , ding_nsecuencia
		  f_compromiso.AgregaCampoFilaPost fila, "ding_ncorrelativo" , 1
		  'f_compromiso.AgregaCampoFilaPost fila, "ding_fdocto" , date
		  f_compromiso.AgregaCampoFilaPost fila, "ding_fdocto" , fecha_operacion
		  f_compromiso.AgregaCampoFilaPost fila, "ding_nsecuencia" , ding_nsecuencia
		  f_compromiso.AgregaCampoFilaPost fila, "ding_mdetalle" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "ding_mdocto" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "edin_ccod" , 15
		  f_compromiso.AgregaCampoFilaPost fila, "ding_bpacta_cuota" , "S"
		  
		  '-----------------------INGRESOS ------------------------------------------
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_ncorr" , nuevo_ingr_ncorr
		  f_ingresos.AgregaCampoFilaPost fila, "eing_ccod" , 4
		  'f_ingresos.AgregaCampoFilaPost fila, "ingr_fpago" , date
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_fpago" , fecha_operacion
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_mefectivo" , 0
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_mdocto" , mvalor
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_mtotal" , mvalor
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_nfolio_referencia" ,ingr_nfolio_referencia
		  f_ingresos.AgregaCampoFilaPost fila, "ting_ccod" , 27
		  f_ingresos.AgregaCampoFilaPost fila, "inst_ccod" , nro_inst
		  
		  '---------------COMPROMISOS, DETALLES_COMPROMISOS, DETALLES ---------------------
		  f_compromiso.AgregaCampoFilaPost fila,"COMP_NDOCTO" , num_pagare
		  f_compromiso.AgregaCampoFilaPost fila, "inst_ccod" , nro_inst
		  f_compromiso.AgregaCampoFilaPost fila, "comp_mdocumento" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "comp_mneto" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "dcom_mdocumento" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "dcom_mcompromiso" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "dcom_mneto" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "tcom_ccod" , 11
		  
		  
		  
		  '-------------------PARA QUE NO ACTUALICE LAS TABLAS DE PRORROGA --------------
		  f_prorroga.AgregaCampoFilaPost fila, "bene_ncorr" , ""
		  f_prorroga.AgregaCampoFilaPost fila, "paga_ncorr" , ""
	  
	  
	 '------------------------------------------------------------------------------------------
	 '                     PACTACION PARCIAL
	 '------------------------------------------------------------------------------------------
	 
	 'else if (estado = 8) then 
	 case 8:
	    '-----------------------------------------------------------------------------------
		'-----------------------ABONO PARCIAL ----------------------------------------------
	 	if (ufom_ncorr<>0) then 
		        
	      		consulta = "UPDATE pagares SET epag_ccod = "& estado &", ufom_ncorr="& ufom_ncorr &", audi_tusuario = '" & negocio.ObtenerUsuario & "', audi_fmodificacion = sysdate  WHERE paga_ncorr='" & num_pagare & "'"
				conexion.EstadoTransaccion conexion.EjecutaS(consulta)
		  end if
		  
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
		  'f_compromiso.AgregaCampoFilaPost fila, "abon_fabono" , date
		  f_compromiso.AgregaCampoFilaPost fila, "abon_fabono" , fecha_operacion
		  f_compromiso.AgregaCampoFilaPost fila, "abon_mabono" , monto_pactar_m
		  
		  '------------------------------- DETALLES INGRESOS ----------------------
		  f_compromiso.AgregaCampoFilaPost fila, "ting_ccod" , 26
		  f_compromiso.AgregaCampoFilaPost fila, "ding_ndocto" , num_pagare
		  f_compromiso.AgregaCampoFilaPost fila, "ding_nsecuencia" , ding_nsecuencia
		  f_compromiso.AgregaCampoFilaPost fila, "ding_ncorrelativo" , 1
		  'f_compromiso.AgregaCampoFilaPost fila, "ding_fdocto" , date
		  f_compromiso.AgregaCampoFilaPost fila, "ding_fdocto" , fecha_operacion
		  f_compromiso.AgregaCampoFilaPost fila, "ding_nsecuencia" , ding_nsecuencia
		  'f_compromiso.AgregaCampoFilaPost fila, "ding_mdetalle" , mvalor
		  'f_compromiso.AgregaCampoFilaPost fila, "ding_mdocto" , mvalor
		  f_compromiso.AgregaCampoFilaPost fila, "ding_mdetalle" , monto_pactar_m
		  f_compromiso.AgregaCampoFilaPost fila, "ding_mdocto" , monto_pactar_m
		  f_compromiso.AgregaCampoFilaPost fila, "edin_ccod" , 15
		  f_compromiso.AgregaCampoFilaPost fila, "ding_bpacta_cuota" , "S"
		  
		  '-----------------------INGRESOS ------------------------------------------
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_ncorr" , nuevo_ingr_ncorr
		  f_ingresos.AgregaCampoFilaPost fila, "eing_ccod" , 4
		  'f_ingresos.AgregaCampoFilaPost fila, "ingr_fpago" , date
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_fpago" , fecha_operacion
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_mefectivo" , 0
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_mdocto" , monto_pactar_m
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_mtotal" , monto_pactar_m
		  f_ingresos.AgregaCampoFilaPost fila, "ingr_nfolio_referencia" ,ingr_nfolio_referencia
		  f_ingresos.AgregaCampoFilaPost fila, "ting_ccod" , 27
		  f_ingresos.AgregaCampoFilaPost fila, "inst_ccod" , nro_inst
		  
		  '---------------COMPROMISOS, DETALLES_COMPROMISOS, DETALLES ---------------------
		  f_compromiso.AgregaCampoFilaPost fila,"COMP_NDOCTO" , num_pagare
		  f_compromiso.AgregaCampoFilaPost fila, "inst_ccod" , nro_inst
		  f_compromiso.AgregaCampoFilaPost fila, "comp_mdocumento" , monto_pactar_m
		  f_compromiso.AgregaCampoFilaPost fila, "comp_mneto" , monto_pactar_m
		  f_compromiso.AgregaCampoFilaPost fila, "dcom_mdocumento" , monto_pactar_m
		  f_compromiso.AgregaCampoFilaPost fila, "dcom_mcompromiso" , monto_pactar_m
		  f_compromiso.AgregaCampoFilaPost fila, "dcom_mneto" , monto_pactar_m
		  f_compromiso.AgregaCampoFilaPost fila, "tcom_ccod" , 11
		  
		  
		  
		'-----------------------------------------------------------------------------------
		'-----------------------PRORROGA SALDO  ----------------------------------------------
		
		  saldo_uf = CDbl(valor_pagar) - CDbl(monto_pactar_uf)
		  
		  'session("mensajeError") = saldo_uf
		  'response.Redirect(Request.ServerVariables("HTTP_REFERER"))
		  
		  
		  f_consulta.Inicializar conexion
		 
		 f_consulta.consultar "select cont_ncorr as cont_ncorr_anterior from pagares where paga_ncorr="&num_pagare
		 f_consulta.siguiente
		 cont_ncorr_anterior = f_consulta.obtenerValor("cont_ncorr_anterior")
		 
		 
		
		 
		 f_consulta.consultar "select stde_ccod,mone_ccod,bene_mmonto_acum_matricula,bene_mmonto_acum_colegiatura from beneficios where bene_ncorr="&bene_ncorr
		 f_consulta.siguiente
		 stde_ccod = f_consulta.obtenerValor("stde_ccod")
		 mone_ccod = f_consulta.obtenerValor("mone_ccod")
		 bene_mmonto_acum_matricula = f_consulta.obtenerValor("bene_mmonto_acum_matricula")
		 bene_mmonto_acum_colegiatura = f_consulta.obtenerValor("bene_mmonto_acum_colegiatura")
		 
		 
		 '-------------SECUENCIA NUEVO PAGARE-------------------------------------------
		 f_consulta.consultar "select paga_ncorr_seq.nextval as nuevo_paga_ncorr from dual"
		 f_consulta.siguiente
		 nuevo_paga_ncorr = f_consulta.obtenerValor("nuevo_paga_ncorr")
		 
		 '-------------SECUENCIA BENEFICIO -------------------------------------------
		 f_consulta.consultar "select bene_ncorr_seq.nextval as nuevo_bene_ncorr from dual"
		 f_consulta.siguiente
		 nuevo_bene_ncorr = f_consulta.obtenerValor("nuevo_bene_ncorr")
		
		  '-------------SECUENCIA NPAGARE-------------------------------------------
		 f_consulta.consultar "select paga_npagare_seq.nextval as nuevo_paga_npagare from dual"
		 f_consulta.siguiente
		 nuevo_paga_npagare =f_consulta.obtenerValor("nuevo_paga_npagare")
		 
		 
		 
		 f_prorroga.ClonaFilaPost(fila)
		 
		 
		 '-----------------------PARA QUE NO ACTUALIZE LAS TABLAS DE PACTACION-----------------------------------------------
		 'f_compromiso.AgregaCampoFilaPost fila, "tcom_ccod" , ""
		 'f_compromiso.AgregaCampoFilaPost fila, "ingr_ncorr", ""
		 'f_ingresos.AgregaCampoFilaPost fila, "ingr_ncorr" , ""
		 
		 '-----------------------PAGARES-----------------------------------------------
		 f_prorroga.AgregaCampoFilaPost fila, "paga_ncorr" , nuevo_paga_ncorr
		 f_prorroga.AgregaCampoFilaPost fila, "paga_npagare" , nuevo_paga_npagare
		 f_prorroga.AgregaCampoFilaPost fila, "cont_ncorr" , CLng(cont_ncorr_anterior)
		 f_prorroga.AgregaCampoFilaPost fila, "enpa_ncorr" , ""
		 f_prorroga.AgregaCampoFilaPost fila, "paga_fpagare" , fecha_operacion
		 f_prorroga.AgregaCampoFilaPost fila, "paga_finicio_pago" , "30/03/"& (ano_actual + 1)
		 f_prorroga.AgregaCampoFilaPost fila, "paga_ftermino_pago" , "28/02/"& (ano_actual + 2)
		 f_prorroga.AgregaCampoFilaPost fila, "epag_ccod" , 1
		 
		 '-----------------------BENEFICIOS-----------------------------------------------
		 f_prorroga.AgregaCampoFilaPost fila, "bene_ncorr" , nuevo_bene_ncorr
		 f_prorroga.AgregaCampoFilaPost fila, "paga_ncorr_anterior" , num_pagare
		 f_prorroga.AgregaCampoFilaPost fila, "eben_ccod" , 1
		 f_prorroga.AgregaCampoFilaPost fila, "bene_fbeneficio" , fecha_operacion
		 f_prorroga.AgregaCampoFilaPost fila, "mone_ccod" , CLng( mone_ccod)
		 f_prorroga.AgregaCampoFilaPost fila, "stde_ccod" ,  CLng(stde_ccod)
		 f_prorroga.AgregaCampoFilaPost fila, "bene_mmonto_acum_matricula" , 0
		 f_prorroga.AgregaCampoFilaPost fila, "bene_mmonto_acum_colegiatura" , Replace(CDbl(saldo_uf), ",",".")
		 if (ufom_ncorr<>0) then  
		 	f_prorroga.AgregaCampoFilaPost fila, "ufom_ncorr" ,   CLng(ufom_ncorr)
		 end if
		 
	 
	 
	  
	 '------------------------------------------------------------------- 
	 '                  	PRORROGAR UN PAGARE 
	 '-------------------------------------------------------------------	  
	  'else
	  case 6:
	    
		 f_consulta.Inicializar conexion
		 
		 f_consulta.consultar "select cont_ncorr as cont_ncorr_anterior from pagares where paga_ncorr="&num_pagare
		 f_consulta.siguiente
		 cont_ncorr_anterior = f_consulta.obtenerValor("cont_ncorr_anterior")
		 
		 
		
		 
		 f_consulta.consultar "select stde_ccod,mone_ccod,bene_mmonto_acum_matricula,bene_mmonto_acum_colegiatura from beneficios where bene_ncorr="&bene_ncorr
		 f_consulta.siguiente
		 stde_ccod = f_consulta.obtenerValor("stde_ccod")
		 mone_ccod = f_consulta.obtenerValor("mone_ccod")
		 bene_mmonto_acum_matricula = f_consulta.obtenerValor("bene_mmonto_acum_matricula")
		 bene_mmonto_acum_colegiatura = f_consulta.obtenerValor("bene_mmonto_acum_colegiatura")
		 
		 
		 
		 f_consulta.consultar "select paga_ncorr_seq.nextval as nuevo_paga_ncorr from dual"
		 f_consulta.siguiente
		 nuevo_paga_ncorr = f_consulta.obtenerValor("nuevo_paga_ncorr")
		 
		 f_consulta.consultar "select bene_ncorr_seq.nextval as nuevo_bene_ncorr from dual"
		 f_consulta.siguiente
		 nuevo_bene_ncorr = f_consulta.obtenerValor("nuevo_bene_ncorr")
		
		 f_consulta.consultar "select paga_npagare_seq.nextval as nuevo_paga_npagare from dual"
		 f_consulta.siguiente
		 nuevo_paga_npagare =f_consulta.obtenerValor("nuevo_paga_npagare")
		 
		 
		 'cc_nuevo_paga_fpagare =  "select to_char (sysdate as nuevo_paga_fpagare from dual"
		 'nuevo_paga_fpagare =conexion.consultaUno(cc_nuevo_paga_fpagare)
		 
		 
		 
		 f_prorroga.ClonaFilaPost(fila)
		 
		 
		 '-----------------------PARA QUE NO ACTUALIZE LAS TABLAS DE PACTACION-----------------------------------------------
		 f_compromiso.AgregaCampoFilaPost fila, "tcom_ccod" , ""
		 f_compromiso.AgregaCampoFilaPost fila, "ingr_ncorr", ""
		 f_ingresos.AgregaCampoFilaPost fila, "ingr_ncorr" , ""
		 
		 '-----------------------PAGARES-----------------------------------------------
		 f_prorroga.AgregaCampoFilaPost fila, "paga_ncorr" , nuevo_paga_ncorr
		 f_prorroga.AgregaCampoFilaPost fila, "paga_npagare" , nuevo_paga_npagare
		 f_prorroga.AgregaCampoFilaPost fila, "cont_ncorr" , CLng(cont_ncorr_anterior)
		 f_prorroga.AgregaCampoFilaPost fila, "enpa_ncorr" , ""
		 f_prorroga.AgregaCampoFilaPost fila, "paga_fpagare" , fecha_operacion
		 f_prorroga.AgregaCampoFilaPost fila, "paga_finicio_pago" , "30/03/"& (ano_actual + 1)
		 f_prorroga.AgregaCampoFilaPost fila, "paga_ftermino_pago" , "28/02/"& (ano_actual + 2)
		 f_prorroga.AgregaCampoFilaPost fila, "epag_ccod" , 1
		 
		 '-----------------------BENEFICIOS-----------------------------------------------
		 f_prorroga.AgregaCampoFilaPost fila, "bene_ncorr" , nuevo_bene_ncorr
		 f_prorroga.AgregaCampoFilaPost fila, "paga_ncorr_anterior" , num_pagare
		 f_prorroga.AgregaCampoFilaPost fila, "eben_ccod" , 1
		 f_prorroga.AgregaCampoFilaPost fila, "bene_fbeneficio" , fecha_operacion
		 f_prorroga.AgregaCampoFilaPost fila, "mone_ccod" , CLng( mone_ccod)
		 f_prorroga.AgregaCampoFilaPost fila, "stde_ccod" ,  CLng(stde_ccod)
		 f_prorroga.AgregaCampoFilaPost fila, "bene_mmonto_acum_matricula" , Replace(CDbl(bene_mmonto_acum_matricula), ",",".")
		 f_prorroga.AgregaCampoFilaPost fila, "bene_mmonto_acum_colegiatura" , Replace(CDbl(bene_mmonto_acum_colegiatura), ",",".")
		 if (ufom_ncorr<>0) then  
		 	f_prorroga.AgregaCampoFilaPost fila, "ufom_ncorr" ,   CLng(ufom_ncorr)
		 end if
		 
		 
	   end select	 
	  'end if
	 
	end if 
next

f_compromiso.AgregaCampoPost "tdet_ccod" , 8
f_compromiso.AgregaCampoPost "ecom_ccod" , 1
f_compromiso.AgregaCampoPost "dcom_ncompromiso" , 1
f_compromiso.AgregaCampoPost "comp_ncuotas" , 1
f_compromiso.AgregaCampoPost "peri_ccod" , Periodo
'f_compromiso.AgregaCampoPost "dcom_fcompromiso" , date
f_compromiso.AgregaCampoPost "dcom_fcompromiso" , fecha_operacion
'f_compromiso.AgregaCampoPost "comp_fdocto" , date
f_compromiso.AgregaCampoPost "comp_fdocto" , fecha_operacion



'------------- PRORROGA --------------------
'if ( estado = 6 ) then 
	IF  (ufom_ncorr=0) then 
		  mensage = " No se ha realizado la operación, debido a que el valor de la UF no se encuentra registrada." 
		  session("mensajeError")= mensage
		 
	ELSE 
	     
	   	  f_prorroga.MantieneTablas false  
		  f_compromiso.MantieneTablas false  	  
		  f_ingresos.MantieneTablas false   
		  'conexion.estadotransaccion false  'roolback  
	end if
	
'end if
'------------- PACTAR  --------------------
'if (estado = 4 ) then 

	'IF  (ufom_ncorr=0) then 
		  'mensage = " No se ha relizado la operación de pactación debido a que el valor de la UF no se encuentra registrada, comuniquese con el administrador del sistema...." 
		 ' session("mensajeError")= mensage
		 
	'ELSE 
			'f_compromiso.MantieneTablas true
	'end if
			
'end if
'f_compromiso.ListarPost
	'conexion.estadotransaccion false  'roolback  
	
	
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>
