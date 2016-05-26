<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"


set negocio = new CNegocio
negocio.Inicializa conexion

set cajero = new CCajero
cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede
'-----------------------------------------------------------------------
caja_abierta = cajero.obtenerCajaAbierta
usuario = negocio.ObtenerUsuario()
Sede = negocio.ObtenerSede
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
'-----------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
'-----------------------------------------------------------------------
set formulario = new CFormulario
formulario.Carga_Parametros "Ingreso_Cedentes.xml", "f_letras"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.ListarPost

'if EsVacio(formulario.ListarPost) or Isempty(formulario.ListarPost) or isnull(formulario.ListarPost) then
'	response.Redirect(Request.ServerVariables("HTTP_REFERER"))
'else	
for fila = 0 to formulario.CuentaPost - 1
   'num_doc = formulario.ObtenerValorPost (fila, "ding_ndocto")
   num_doc = formulario.ObtenerValorPost (fila, "oculto")
   'response.Write(num_doc & "<BR>")
   ingreso = formulario.ObtenerValorPost (fila, "ingr_ncorr")
   
   f_consulta.Inicializar conexion
   'f_consulta.siguiente
   'secuencia = f_consulta.obtenerValor("reca_ncorr")
   secuencia = conexion.ConsultaUno("execute obtenersecuencia 'referencias_cargos'")
   
   'secuencia = formulario.ObtenerValorPost (fila, "ding_nsecuencia")
   tipo_ingreso =  formulario.ObtenerValorPost (fila, "ting_ccod")  
   multa =  formulario.ObtenerValorPost (fila, "multa")
   nueva_fecha =  formulario.ObtenerValorPost (fila, "nueva_fecha")  
   cajero  = caja_abierta 
   tipo_compromiso = ""
   tipo_detalle = ""    
  
	if num_doc <> "" then
		f_consulta.Inicializar conexion
		'f_consulta.siguiente
		'nuevo_folio_referencia = f_consulta.obtenerValor("nuevo_folio_ref")
		nuevo_folio_referencia=conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")


		estado = formulario.ObtenerValorPost (fila, "edin_ccod")
		pers_ncorr = conexion.consultauno("SELECT pers_ncorr FROM ingresos WHERE cast(ingr_ncorr as varchar)='" & ingreso&"'")
		monto_doc = conexion.consultauno("select ding_mdocto from detalle_ingresos where cast(ingr_ncorr as varchar)='" & ingreso&"'")

		if estado = "7" then  ' SI ES DEVUELTA POR BANCO SE ACTUALIZA LA SEDE
			sql_update=", sede_actual=8 " ' puede usaurse la variable de sesion de la caja apra agregar la sede real
		end if

		asignar_tipo_compromiso()
		sql = sql_actualizar_detalle()
		'response.Write(sql & "<BR><BR><BR>")
		
		conexion.EstadoTransaccion conexion.EjecutaS(sql)  
		


		if estado = "6" or estado = "18" then        '----  SI EL ESTADO ES 'PAGADO' O 'PAGADO CON INTERESES'----		 
		  '---------------- NUEVO INGR_NCORR ------------------------		  
		   nuevo_ingr_ncorr = obtener_nuevo_ingr_ncorr()
		   'response.Write("<hr>====>Nuevo_ingreso_ncorr "&nuevo_ingr_ncorr&"<hr>")
		   respaldo = nuevo_ingr_ncorr     'este respaldo es para poder consultar abajo 
					  
			'---------------- INSERTO EL NUEVO INGRESO ----------------
			sql = sql_insertar_ingreso()			
			conexion.EstadoTransaccion conexion.EjecutaS(sql)
			'response.Write(sql & "<BR><BR><BR>")
		   
		   '--------------- INSERTO EN NUEVO ABONO ------------------	   
			sql = sql_insertar_abono() 
			conexion.EstadoTransaccion conexion.EjecutaS(sql)
			'response.Write(sql & "<BR><BR><BR>")
							
			
			ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")  
			'---------------- INSERTO EL NUEVO DETALLE INGRESO ----------------
			sql = sql_insertar_detalle_ingreso()
			conexion.EstadoTransaccion conexion.EjecutaS(sql) 
			'response.Write("<hr>**************detalle_ingresos "&ding_nsecuencia&"<hr>")'response.Write(sql & "<BR><BR><BR>")
		end if
	  
		if estado = "20" then  
			'------------------TRASPASO LA LETRA A LA 'TABLA DETALLE_INGRESOS_LOG'------------------------
			sql = sql_copiar_letra() 
			conexion.EstadoTransaccion conexion.EjecutaS(sql)
			'response.Write(sql & "<BR><BR><BR>")
			'response.Write("<b>"&conexion.ObtenerEstadoTransaccion&"</b>")
			'----------------------ACTUALIZAR FECHAS  DOCUEMNTO ORIGINAL ----------------------
			actualizar_fechas()  'detalle_compromiso y detalle_ingreso 
		end if
	  
		if estado = "18" or estado = "19" or estado = "20" then     'agregar el cargo por LA MULTA   
		'(18=pagada intereses, 19=protesto, 20=prorrogada) 
			if multa <> "" then
			  '---------------- INSERTO EL COMPROMISO POR LA MULTA----------------	
			  sql = sql_insertar_compromiso()
			  conexion.EstadoTransaccion conexion.EjecutaS(sql)
			  'response.Write(sql & "<BR><BR><BR>") 
			  'response.Write("<b>"&conexion.ObtenerEstadoTransaccion&"</b>")  
			  
			  '----------- INSERTO EL DETALLE COMPROMISO POR LOS MULTA----------------
			  sql = sql_insertar_detalle_compromiso()
			  conexion.EstadoTransaccion conexion.EjecutaS(sql)
			
			  '---------------- INSERTO EL detalle POR LA MULTA----------------
			  sql = sql_insertar_detalle()
			  conexion.EstadoTransaccion conexion.EjecutaS(sql)	
				
				if estado = "18" then
				  'FUNCIONES PARA PAGAR EL CARGO ANTERIOR  '(ABONO,INGRESO Y DETALLE INGRESOS)
				  '---------------- NUEVO INGR_NCORR ------------------------		  	
					nuevo_ingr_ncorr = obtener_nuevo_ingr_ncorr()
					ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
			
					
						'------------------INSERTO EL INGRESO POR LA MULTA ------------
					   sql = sql_ingreso_interes()
					   conexion.EstadoTransaccion conexion.EjecutaS(sql) 	
								  
					  '------------------INSERTO EL ABONO POR LA MULTA ------------
					  sql = sql_abono_interes()
					  conexion.EstadoTransaccion conexion.EjecutaS(sql)
							
					  '------------------INSERTO EL DETALLE_INGRESO POR LA MULTA ------------	
					  sql = sql_detalle_ingresos_interes() 
					  conexion.EstadoTransaccion conexion.EjecutaS(sql)
				   end if  
				  
				if estado = "19" then
				  'FUNCIONES PARA PAGAR EL CARGO ANTERIOR  '(ABONO,INGRESO Y DETALLE INGRESOS)
				  '---------------- NUEVO INGR_NCORR ------------------------		  	
					nuevo_ingr_ncorr = obtener_nuevo_ingr_ncorr()
					ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
			
					
						'------------------INSERTO EL INGRESO POR LA MULTA ------------
					   sql = sql_ingreso_multa_protesto()
					   conexion.EstadoTransaccion conexion.EjecutaS(sql) 	
								  
					  '------------------INSERTO EL ABONO POR LA MULTA ------------
					  sql = sql_abono_interes()
					  conexion.EstadoTransaccion conexion.EjecutaS(sql)
							
					  '------------------INSERTO EL DETALLE_INGRESO POR LA MULTA ------------	
					  sql = sql_detalle_ingresos_protesto() 
					  conexion.EstadoTransaccion conexion.EjecutaS(sql)
				   end if  
				   
				  '---------ahora el cargo en la tabla referencias_cargos
				  sql_agregar_referencia_cargo
				  conexion.EstadoTransaccion conexion.EjecutaS(sql)
				  
			end if	   
		end if  
	  
   else 
      formulario.EliminaFilaPost fila
   end if 
next
'end if

'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------
'----------------------------------------------------------------------------------------
function asignar_tipo_compromiso()
    select case estado
	  case "18":    'PAGADO CON INTERESES
	     tipo_compromiso = "6"
		 tipo_detalle = "14" 
	  case "19":    'PROTESTADO POR BANCO
   	     tipo_compromiso = "5"
		 tipo_detalle = "13"	  
  	  case "20":     'PRORROGADO POR BANCO
	     tipo_compromiso = "5"
		 tipo_detalle = "15"
	 case "52":    'PROTESTADO POR BANCO BCI C.C.
   	     tipo_compromiso = "5"
		 tipo_detalle = "13"
	 case "53":    'PROTESTADO POR BANCO SCOTIABANK C.C.
   	     tipo_compromiso = "5"
		 tipo_detalle = "13"
	end select		    
end function


function sql_actualizar_detalle()
   sql = "UPDATE detalle_ingresos SET edin_ccod =" & estado  & ", "&_ 
                "audi_tusuario ='" & usuario & "', audi_fmodificacion = getdate() "&sql_update&" "&_ 
		 "WHERE cast(ingr_ncorr as varchar)='" & ingreso & "' "&_
		   "and cast(ting_ccod as varchar)='" & tipo_ingreso & "' "&_
		   "and cast(ding_ndocto as varchar) ='" & num_doc &"'"	 
'response.Write("<br>"&sql)  		  
'response.End()
   sql_actualizar_detalle = sql	   		 
end function

function obtener_nuevo_ingr_ncorr()
    f_consulta.Inicializar conexion
	'f_consulta.consultar "select ingr_ncorr_seq.nextval as nuevo_ingr_ncorr from dual"
	'f_consulta.siguiente
	valor = conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
    obtener_nuevo_ingr_ncorr = valor
end function

function sql_insertar_abono()
   	    sql = "SELECT isnull(tcom_ccod,0) as tcom_ccod, "&_
	            " isnull(inst_ccod,0) as inst_ccod, "&_
				" isnull(comp_ndocto,0) as comp_ndocto, "&_
				" isnull(dcom_ncompromiso,0)as dcom_ncompromiso, "&_
				" convert(varchar,abon_fabono,103) as abon_fabono,"&_
				" isnull(abon_mabono,0) as abon_mabono, "&_ 
				" isnull(pers_ncorr,0)as pers_ncorr, "&_
				" isnull(peri_ccod,0)as peri_ccod,"&_
				" isnull(inem_ccod,0) as inem_ccod FROM abonos WHERE cast(ingr_ncorr as varchar)='" & ingreso &"'"			
	f_consulta.Inicializar conexion
	f_consulta.consultar sql
	f_consulta.siguiente
		   		   
	sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr, peri_ccod, inem_ccod, audi_tusuario, audi_fmodificacion) "&_ 
		 "(SELECT " & nuevo_ingr_ncorr & "," & f_consulta.obtenervalor("tcom_ccod") & "," & f_consulta.obtenervalor("inst_ccod")  & "," & f_consulta.obtenervalor("comp_ndocto")  & ","&_ 
			 f_consulta.obtenervalor("dcom_ncompromiso") & ", getdate() ," &  f_consulta.obtenervalor("abon_mabono") & "," & f_consulta.obtenervalor("pers_ncorr") & "," & f_consulta.obtenervalor("peri_ccod") & "," & f_consulta.obtenervalor("inem_ccod") & ",'" & usuario & "', getdate())"
    'response.Write("<br>"&sql)
	sql_insertar_abono = sql	
end function

function sql_insertar_ingreso
	sql =  "SELECT convert(varchar,ingr_fpago,103) as ingr_fpago,"&_
	       " isnull(ingr_mefectivo,0)as ingr_mefectivo,"&_
		   " isnull(ingr_mdocto,0)as ingr_mdocto,"&_
		   " isnull(ingr_mtotal,0)as ingr_mtotal,"&_
		   " isnull(ingr_nestado,0)as ingr_nestado, "&_
		   " isnull(ingr_nfolio_referencia,0)as ingr_nfolio_referencia, "&_ 
	       " isnull(ting_ccod,0)as ting_ccod,"&_
		   " isnull(inst_ccod,0)as inst_ccod,"&_
		   " isnull(ingr_mintereses,0)as_ingr_mintereses,"&_
		   " isnull(ingr_mmultas,0)as ingr_mmultas,"&_
		   " isnull(pers_ncorr,0)as pers_ncorr,"&_
		   " isnull(ingr_manticipado,0)as ingr_manticipado,"&_
		   " isnull(inem_ccod,0) as inem_ccod "&_ 
				  " FROM ingresos WHERE cast(ingr_ncorr as varchar)='" & ingreso&"'"			  
	      'response.Write("<hr>"&sql&"<hr>")
		   f_consulta.Inicializar conexion
		   f_consulta.consultar sql
		   f_consulta.siguiente
		   pers_ncorr = f_consulta.obtenervalor("pers_ncorr")
		   sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mefectivo, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,  inem_ccod, audi_tusuario, audi_fmodificacion) "&_ 
				 "(SELECT " & nuevo_ingr_ncorr & "," & cajero & ",1 , getdate() ," & f_consulta.obtenervalor("ingr_mefectivo") & ","&_ 
				  f_consulta.obtenervalor("ingr_mdocto") & "," & f_consulta.obtenervalor("ingr_mtotal") & "," & f_consulta.obtenervalor("ingr_nestado") & "," & nuevo_folio_referencia  & ", 10," & f_consulta.obtenervalor("inst_ccod") & ","&_ 
				  f_consulta.obtenervalor("pers_ncorr") & "," & f_consulta.obtenervalor("inem_ccod") & ",'" & usuario & "', getdate())"
		   'response.Write("<br>"&sql)	  
	sql_insertar_ingreso = sql
end function

function sql_insertar_detalle_ingreso()
	sql = "SELECT isnull(ting_ccod,0)as ting_ccod,"&_
	      " isnull(ding_ndocto,0)as ding_ndocto,"&_
		  " isnull(ingr_ncorr,0)as ingr_ncorr,"&_
		  " isnull(ding_nsecuencia,0)as ding_nsecuencia,"&_
		  " isnull(ding_ncorrelativo,0)as ding_ncorrelativo,"&_
		  " isnull(plaz_ccod,0) as plaz_ccod,"&_
		  " isnull(banc_ccod,0)as banc_ccod,"&_
		  " protic.trunc(ding_fdocto) as ding_fdocto, "&_
		  " isnull(ding_mdetalle,0)as ding_mdetalle,"&_
		  " isnull(ding_mdocto,0)as ding_mdocto,"&_
		  " isnull(ding_tcuenta_corriente,0)as ding_tcuenta_corriente,"&_
		  " isnull(edin_ccod,0)as edin_ccod,"&_
		  " isnull(envi_ncorr,0)as envi_ncorr,"&_
		  " isnull(repa_ncorr,0)as repa_ncorr, audi_tusuario, audi_fmodificacion  "&_
  	       " FROM detalle_ingresos "&_ 
		   "  WHERE cast(ingr_ncorr as varchar)='" & ingreso & "' and cast(ting_ccod as varchar)='" & tipo_ingreso & "' and cast(ding_ndocto as varchar)='" & num_doc&"'"
'response.Write("<BR> ESTA ES: "& sql  & "<BR><BR>")
			 f_consulta.Inicializar conexion
			 'ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
			 
			 'response.Write("<hr>detalle_ingresos "&ding_nsecuencia&"<hr>")
		     f_consulta.consultar sql
		     f_consulta.siguiente
		     sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, ding_tcuenta_corriente, edin_ccod, audi_tusuario, audi_fmodificacion) "&_ 
				   "(SELECT " & nuevo_ingr_ncorr & ", 10," & f_consulta.obtenervalor("ding_nsecuencia") & ","&ding_nsecuencia&", 1 , getdate() ,"&_ 
				    f_consulta.obtenervalor("ding_mdetalle") & "," & f_consulta.obtenervalor("ding_mdetalle") & ","&_ 
				    "'" & f_consulta.obtenervalor("ding_tcuenta_corriente") & "' , 17 ,'" & usuario & "', getdate())"
			'response.Write("<br><hr>"&sql&"<hr>")		
   sql_insertar_detalle_ingreso = sql
end function


'#####################################################################################
'######################### CREA COMPROMISOS DE LA MULTA	 #############################
'#####################################################################################
function sql_insertar_compromiso()
    sql = "INSERT INTO compromisos (tcom_ccod, ecom_ccod, inst_ccod, comp_ndocto,  pers_ncorr, comp_fdocto, "&_ 
		                                 "comp_ncuotas, comp_mneto, comp_mdescuento, comp_mintereses, comp_miva, "&_ 
										 "comp_mexento, comp_mdocumento, sede_ccod, audi_tusuario, audi_fmodificacion) "&_ 
	       "VALUES (" & tipo_compromiso & ",1,1," & secuencia & "," & pers_ncorr & ",getdate(),"&_
			           "1,cast('" & multa & "'as numeric),null,null,null,"&_ 
					   "null," & multa & "," & Sede & ",'" & Usuario & "',getdate())"   
	'response.Write("<br>"&sql)				   
	sql_insertar_compromiso = sql				   
end function

function sql_insertar_detalle_compromiso()
     sql = "INSERT INTO detalle_compromisos (tcom_ccod,inst_ccod,comp_ndocto,dcom_ncompromiso,dcom_fcompromiso,dcom_mneto,"&_ 
		                                    "dcom_mintereses,dcom_mcompromiso,ecom_ccod,pers_ncorr,peri_ccod,audi_tusuario,audi_fmodificacion) "&_ 
			"VALUES (" & tipo_compromiso & ",'1'," & secuencia & ",'1',getdate()," & multa & ","&_
				         "null," & multa & ",'1'," & pers_ncorr & "," & Periodo & ",'" & Usuario & "',getdate())"
     '	response.Write("<br>"&sql)
	 sql_insertar_detalle_compromiso = sql
end function

function sql_insertar_detalle()
     sql = "INSERT INTO detalles (tcom_ccod,inst_ccod,comp_ndocto,tdet_ccod,deta_ncantidad,deta_mvalor_unitario,"&_ 
		                         "deta_mvalor_detalle,deta_msubtotal,audi_tusuario, audi_fmodificacion )"&_
			"VALUES (" & tipo_compromiso & ",1," & secuencia & "," & tipo_detalle & ",1," & multa & ","&_
				multa & "," & multa & ",'" & Usuario & "',getdate())"
	'response.Write("<br>"&sql)			
	sql_insertar_detalle = sql
end function
'#####################################################################################
'######################### FIN COMPROMISOS DE LA MULTA	 #############################
'#####################################################################################



'#####################################################################################
'######################### CREA INGRESOS DE MULTA ASIGANADA #############################
'#####################################################################################

function sql_ingreso_interes()
		  sql =  "INSERT INTO ingresos (ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mefectivo, ingr_mdocto, ingr_mtotal, "&_ 
		                           "ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, ingr_mintereses, ingr_mmultas, "&_
								   "pers_ncorr, ingr_manticipado,inem_ccod, audi_tusuario, audi_fmodificacion) "&_ 
	   		      "VALUES (" & nuevo_ingr_ncorr & "," & caja_abierta & ",1,getdate(),null," & multa & "," & multa & ","&_ 
			              "1," & nuevo_folio_referencia & ",10,1,null,null,"&_ 
					       pers_ncorr & ",null,null,'" & Usuario & "',getdate())"
			'response.Write("<br>"&sql)				   
          sql_ingreso_interes = sql
end function

function sql_detalle_ingresos_interes()
       'response.Write("<hr>2.-detalle_ingresos "&ding_nsecuencia&"<hr>")
       sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto,  ding_nsecuencia, ding_ncorrelativo, plaz_ccod, "&_ 
		                                   "banc_ccod, ding_fdocto, ding_mdetalle, ding_mdocto, ding_tcuenta_corriente, "&_ 
		   							       "edin_ccod, envi_ncorr, repa_ncorr, audi_tusuario, audi_fmodificacion,ding_bpacta_cuota) "&_ 
 			"VALUES ("& nuevo_ingr_ncorr & ",10," & num_doc & ","&ding_nsecuencia&",1,null,"&_ 
				         "null,getdate()," & multa & "," & multa & ",null,"&_
						 "17,null,null,'" & Usuario & "',getdate(),'S')"
			'response.Write("<br>"&sql)				 
        sql_detalle_ingresos_interes = sql   
end function

function sql_abono_interes()
		  sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, "&_ 
		                            "pers_ncorr, peri_ccod, inem_ccod, audi_tusuario, audi_fmodificacion) "&_ 
                "VALUES (" & nuevo_ingr_ncorr & "," & tipo_compromiso & ",1," & secuencia & ",1,getdate()," & multa & ","&_ 
				         pers_ncorr & "," & Periodo & ",null,'" & Usuario & "',getdate())"
        '	response.Write("<br>"&sql)
		sql_abono_interes = sql	
end function
'--#######################################################3
function sql_ingreso_multa_protesto()
		  sql =  "INSERT INTO ingresos (ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mefectivo, ingr_mdocto, ingr_mtotal, "&_ 
		                           "ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, ingr_mintereses, ingr_mmultas, "&_
								   "pers_ncorr, ingr_manticipado,inem_ccod, audi_tusuario, audi_fmodificacion) "&_ 
	   		      "VALUES (" & nuevo_ingr_ncorr & "," & caja_abierta & ",4,getdate(),null," & multa & "," & multa & ","&_ 
			              "1," & nuevo_folio_referencia & ",87,1,null,null,"&_ 
					       pers_ncorr & ",null,null,'" & Usuario & "',getdate())"
			'response.Write("<br>"&sql)				   
          sql_ingreso_multa_protesto = sql
end function

function sql_detalle_ingresos_protesto()
       'response.Write("<hr>2.-detalle_ingresos "&ding_nsecuencia&"<hr>")
       sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto,  ding_nsecuencia, ding_ncorrelativo, plaz_ccod, "&_ 
		                                   "banc_ccod, ding_fdocto, ding_mdetalle, ding_mdocto, ding_tcuenta_corriente, "&_ 
		   							       "edin_ccod, envi_ncorr, repa_ncorr, audi_tusuario, audi_fmodificacion,ding_bpacta_cuota) "&_ 
 			"VALUES ("& nuevo_ingr_ncorr & ",87," & num_doc & ","&ding_nsecuencia&",1,null,"&_ 
				         "null,getdate()," & multa & "," & multa & ",null,"&_
						 "1,null,null,'" & Usuario & "',getdate(),'S')"
			'response.Write("<br>"&sql)				 
        sql_detalle_ingresos_protesto = sql   
end function
'#####################################################################################
'######################### FIN PAGOS DE MULTA ASIGANADA ##############################
'#####################################################################################


function sql_copiar_letra()
     f_consulta.Inicializar conexion
     'f_consulta.consultar "select dilg_ncorr_seq.nextval as nuevo_dilg_ncorr from dual"
     'f_consulta.siguiente
     'dilg_ncorr = f_consulta.obtenerValor("nuevo_dilg_ncorr")
	 dilg_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos_correlativo'")
	
	 sql = "select * from detalle_ingresos  WHERE cast(ingr_ncorr as varchar)='" & ingreso & "' and cast(ting_ccod as varchar)='" & tipo_ingreso & "' and cast(ding_ndocto as varchar)='" & num_doc&"'"
	 'response.Write("<br>"&sql&"<hr>")
	 f_consulta.Inicializar conexion
	 f_consulta.consultar sql
	 f_consulta.siguiente
	 
	 repa_ncorr	=	f_consulta.obtenervalor("repa_ncorr")
	 banc_ccod	=	f_consulta.obtenervalor("banc_ccod")
	 plaz_ccod	=	f_consulta.obtenervalor("plaz_ccod")
	 envi_ncorr =	f_consulta.obtenervalor("envi_ncorr")
	 
	 if  ESVACIO(repa_ncorr) then
	 	repa_ncorr="null"
	 end if
	 if ESVACIO(banc_ccod) then
	 	banc_ccod="null"
	 end if
	 if ESVACIO(plaz_ccod) then
	 	plaz_ccod="null"
	 end if
	 if ESVACIO(envi_ncorr) then
	 	envi_ncorr="0"
	 end if
	
	 
	 sql = "INSERT INTO detalle_ingresos_log (dilg_ncorr, ingr_ncorr, ting_ccod, ding_ndocto,  ding_nsecuencia, ding_ncorrelativo, plaz_ccod, "&_ 
		                                   "banc_ccod, ding_fdocto, ding_mdetalle, ding_mdocto, ding_tcuenta_corriente, "&_ 
		   							       "edin_ccod, envi_ncorr, repa_ncorr, audi_tusuario, audi_fmodificacion) "&_	
	       "(SELECT cast('" & dilg_ncorr & "'as numeric),cast('" & f_consulta.obtenervalor("ingr_ncorr") & "'as numeric),cast('" & f_consulta.obtenervalor("ting_ccod") & "' as numeric),cast('" & f_consulta.obtenervalor("ding_ndocto")&_ 
	         "' as numeric),cast('" & f_consulta.obtenervalor("ding_nsecuencia") & "' as numeric),cast('" & f_consulta.obtenervalor("ding_ncorrelativo") & "'as numeric),isnull(" &plaz_ccod&_
			 ", null),isnull("& banc_ccod &", null),cast('" & f_consulta.obtenervalor("ding_fdocto") & "' as varchar),cast('" & f_consulta.obtenervalor("ding_mdetalle") & "' as numeric),cast('" & f_consulta.obtenervalor("ding_mdocto")&_
			 "' as numeric),cast('" & f_consulta.obtenervalor("ding_tcuenta_corriente") & "' as varchar), 4, cast('" & envi_ncorr&" '"&_ 
			 " as numeric),isnull("& repa_ncorr &", null),'" & Usuario & "',getdate())"
   '	response.Write("<br>"&sql)
   sql_copiar_letra = sql
end function

function actualizar_fechas()
  sql = "UPDATE detalle_ingresos SET ding_fdocto ='" & nueva_fecha  & "', "&_ 
                "audi_tusuario ='" & usuario & "', audi_fmodificacion = getdate() "&_ 
		 "WHERE cast(ingr_ncorr as varchar)='" & ingreso & "' and cast(ting_ccod as varchar)='" & tipo_ingreso & "' and cast(ding_ndocto as varchar)='" & num_doc&"'"
  'response.Write("<br>"&sql)
  conexion.EstadoTransaccion conexion.EjecutaS(sql)
 ' response.Write(sql & "<BR><BR><BR>")
  'response.Write("<b>"&conexion.ObtenerEstadoTransaccion&"</b>")

  
  sql = " SELECT b.tcom_ccod,b.inst_ccod,b.comp_ndocto,b.dcom_ncompromiso "&_ 
		" FROM detalle_compromisos b, abonos c, ingresos d, detalle_ingresos e "&_
		" WHERE b.tcom_ccod = c.tcom_ccod  and b.inst_ccod = c.inst_ccod  and b.comp_ndocto = c.comp_ndocto "&_
		  "and b.dcom_ncompromiso = c.dcom_ncompromiso  and c.ingr_ncorr = d.ingr_ncorr  and d.ingr_ncorr = e.ingr_ncorr "&_
		  "and cast(e.ingr_ncorr as varchar)='" & ingreso & "' and cast(e.ting_ccod as varchar)='" & tipo_ingreso & "' and cast(e.ding_ndocto as varchar)='" & num_doc&"'"

   f_consulta.Inicializar conexion
   f_consulta.consultar sql
   f_consulta.siguiente
  
  sql = "UPDATE detalle_compromisos SET dcom_fcompromiso ='" & nueva_fecha  & "', "&_ 
                "audi_tusuario ='" & usuario & "', audi_fmodificacion = getdate() "&_ 
		 "WHERE cast(tcom_ccod as varchar)='" & f_consulta.obtenervalor("tcom_ccod") & "' "&_ 
		   "and cast(inst_ccod as varchar)='" & f_consulta.obtenervalor("inst_ccod") & "' "&_
		   "and cast(comp_ndocto as varchar)='" & f_consulta.obtenervalor("comp_ndocto") & "' "&_
		   "and cast(dcom_ncompromiso as varchar)='" & f_consulta.obtenervalor("dcom_ncompromiso")&"'"
	'response.Write(sql & "<BR><BR><BR>")	   
  '	response.Write("<br>"&sql)
  conexion.EstadoTransaccion conexion.EjecutaS(sql)
  'response.Write("<b> update final : "&conexion.ObtenerEstadoTransaccion&"</b>")

end function

function sql_agregar_referencia_cargo()
  sql = " insert into REFERENCIAS_CARGOS (RECA_NCORR, TING_CCOD, DING_NDOCTO, INGR_NCORR, RECA_MMONTO, EDIN_CCOD, AUDI_TUSUARIO, AUDI_FMODIFICACION) "&_ 
          "values ("&secuencia&","&tipo_ingreso&","&num_doc&","&ingreso&","&multa&","&estado&",'"&Usuario&"',getdate()) "
   '	response.Write("<br>"&sql)
   sql_agregar_referencia_cargo = sql

end function

'response.Write("<br> Ultima: <b>"&conexion.ObtenerEstadoTransaccion&"</b>")
'conexion.estadotransaccion false  'roolback  
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
