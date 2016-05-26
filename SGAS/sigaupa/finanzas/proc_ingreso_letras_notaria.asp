<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next
'response.End()

set conexion = new CConexion
conexion.Inicializar "upacifico"
'conexion.EstadoTransaccion false
set negocio = new CNegocio
negocio.Inicializa conexion

set cajero = new CCajero
cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede

v_msg_auditoria= " - ingreso notaria"

caja_abierta = cajero.obtenerCajaAbierta
usuario = negocio.ObtenerUsuario()
Sede = negocio.ObtenerSede
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

'******* CONSTANTES *******
tipo_compromiso = "5"
tipo_detalle = "13"


'---------------------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "parametros.xml", "tabla"
f_consulta.Inicializar conexion
'---------------------------------------------------------------------


set formulario = new CFormulario
formulario.Carga_Parametros "Ingreso_Letras_Legalizadas.xml", "f_letras"
formulario.Inicializar conexion
formulario.ProcesaForm
'formulario.AgregaCampoPost "edin_ccod" , 3
formulario.AgregaCampoPost "denv_fretorno" , date()
'formulario.ListarPost

'actualizar a "en cartera legalizada (3)" la letra
for fila = 0 to formulario.CuentaPost - 1
   	letra = formulario.ObtenerValorPost (fila, "ding_ndocto")
   	ting_ccod = formulario.ObtenerValorPost (fila, "ting_ccod")
   	ingr_ncorr = formulario.ObtenerValorPost (fila, "ingr_ncorr")
	multa = formulario.ObtenerValorPost (fila, "multa")
	estado = formulario.ObtenerValorPost (fila, "edin_ccod")
	pers_ncorr = conexion.consultauno("SELECT top 1 pers_ncorr FROM ingresos WHERE cast(ingr_ncorr as varchar)='"&ingr_ncorr&"'")

   if letra = "" then
        formulario.EliminaFilaPost fila
   end if 


	if multa <> "" and estado = "54" then
			if caja_abierta="" then
    			conexion.EstadoTransaccion false
				session("mensajeerror")= "No puede ingresar Protestos sin tener una caja abierta"
			  	response.Redirect(Request.ServerVariables("HTTP_REFERER"))
			end if
			  '---------------- INSERTO EL COMPROMISO POR LA MULTA----------------	
			  secuencia = conexion.ConsultaUno("execute obtenersecuencia 'referencias_cargos'")
			  sql = sql_insertar_compromiso()
			  conexion.EstadoTransaccion conexion.EjecutaS(sql)
			  'response.Write(sql & "<BR><BR><BR>") 
			  
			  '----------- INSERTO EL DETALLE COMPROMISO POR LOS MULTA----------------
			  sql = sql_insertar_detalle_compromiso()
			  conexion.EstadoTransaccion conexion.EjecutaS(sql)

			  '---------------- INSERTO EL detalle POR LA MULTA----------------
			  sql = sql_insertar_detalle()
			  conexion.EstadoTransaccion conexion.EjecutaS(sql)	

		  	'FUNCIONES PARA PAGAR EL CARGO  POR CONVEPTO DE MULTA PROTESTO '(ABONO,INGRESO Y DETALLE INGRESOS)
			'---------------- NUEVO INGR_NCORR ------------------------		  	
			nuevo_ingr_ncorr 		= 	conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
			nuevo_folio_referencia	=	conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
			ding_nsecuencia 		= 	conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")

			'------------------INSERTO EL INGRESO POR LA MULTA ------------
			sql = sql_ingreso_multa_protesto()
			conexion.EstadoTransaccion conexion.EjecutaS(sql) 	
			  
			'------------------INSERTO EL ABONO POR LA MULTA ------------
			sql = sql_abono_multa_protesto()
			conexion.EstadoTransaccion conexion.EjecutaS(sql)
				
			'------------------INSERTO EL DETALLE_INGRESO POR LA MULTA ------------	
			sql = sql_detalle_ingresos_protesto() 
			conexion.EstadoTransaccion conexion.EjecutaS(sql)

			'---------ahora el cargo en la tabla referencias_cargos
			sql_agregar_referencia_cargo
			conexion.EstadoTransaccion conexion.EjecutaS(sql)   
	end if	
				  

next
formulario.MantieneTablas false
'response.Write("<br> Estado Transaccion: Final <b>"&conexion.obtenerEstadoTransaccion&"</b>")
'conexion.EstadoTransaccion false
'response.End()



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

'####################################################################################
'######################### INICIO DOCUMENTACION MULTA  ##############################

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
 			"VALUES ("& nuevo_ingr_ncorr & ",87," & letra & ","&ding_nsecuencia&",1,null,"&_ 
				         "null,getdate()," & multa & "," & multa & ",null,"&_
						 "1,null,null,'" & Usuario & "',getdate(),'S')"
			'response.Write("<br>"&sql)				 
        sql_detalle_ingresos_protesto = sql   
end function

function sql_abono_multa_protesto()
		  sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, "&_ 
		                            "pers_ncorr, peri_ccod, inem_ccod, audi_tusuario, audi_fmodificacion) "&_ 
                "VALUES (" & nuevo_ingr_ncorr & "," & tipo_compromiso & ",1," & secuencia & ",1,getdate()," & multa & ","&_ 
				         pers_ncorr & "," & Periodo & ",null,'" & Usuario & "',getdate())"
        '	response.Write("<br>"&sql)
		sql_abono_multa_protesto = sql	
end function
'#####################################################################################
'######################### FIN DOCUMENTACION DE MULTA 	##############################
'#####################################################################################

function sql_agregar_referencia_cargo()
  sql = " insert into REFERENCIAS_CARGOS (RECA_NCORR, TING_CCOD, DING_NDOCTO, INGR_NCORR, RECA_MMONTO, EDIN_CCOD, AUDI_TUSUARIO, AUDI_FMODIFICACION) "&_ 
          "values ("&secuencia&","&ting_ccod&","&letra&","&ingr_ncorr&","&multa&","&estado&",'"&Usuario&"',getdate()) "
   	'response.Write("<br>"&sql)
   sql_agregar_referencia_cargo = sql

end function

response.Redirect(Request.ServerVariables("HTTP_REFERER"))

%>
