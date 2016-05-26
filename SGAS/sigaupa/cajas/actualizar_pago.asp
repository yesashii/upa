<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file="../biblioteca/_conexion.asp" -->
<%
'for each x in request.Form
'	response.Write("<br>"&x&" -> "&request.Form(x))
'next
'response.End()
nfolio	=	request.Form("n_folio")
total	=	request.form("total")
imprimir=	request.Form("imprimir")
imprimir_2 =	request.Form("imprimir_2")
imprimir_1 = 	request.Form("imprimir_1")
'imprimir_2 = 2

if (imprimir_1 = "" and imprimir_2 <> "") then
	imprime = 2
else
	imprime = 1
end if
'response.Write(imprime)
'response.End()


alumno	=	request.Form("alumno")
rut		=	request.Form("rut")
cant_detalle= 	request.form("cant_detalle")
tipo_doc	= 	request.form("i[0][ting_ccod]")
efectivo	=	clng(request.form("i[0][ingr_mefectivo]"))
v_inem_ccod = 	Request.Form("h_inem_ccod")
inst_ccod = request.Form("h_inst_ccod")
tmov_ccod = Request.Form("tmov_ccod")


pers_nrut=left(trim(rut),len(trim(rut))-2)

'---------------------------------------------------------------------------------------				
set conectar = new cconexion
conectar.inicializar "upacifico"	

v_fecha = conectar.consultaUno("select protic.trunc(getdate()) as fecha")
'conectar.EstadoTransaccion false
		
set negocio = new CNegocio
negocio.Inicializa conectar
	
peri_ccod = negocio.ObtenerPeriodoAcademico("CLASES18")
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")

'********** Agregado para las boletas	********
v_sede = negocio.ObtenerSede()
v_numero_caja=	request.form("i[0][mcaj_ncorr]")
v_usuario_pago= negocio.ObtenerUsuario
'*********************************************************************
'*******************	obtiene el correlativo de caja   *************	
sql_correlativo_caja=	"SELECT ISNULL(MAX(INGR_NCORRELATIVO_CAJA),0) FROM INGRESOS WHERE MCAJ_NCORR="&v_numero_caja
v_correlativo_caja	=	conectar.consultaUno(sql_correlativo_caja)
v_correlativo_caja	=	cint(v_correlativo_caja) + 1
'*********************************************************************

'---------------------------------------------------------
set f_consulta = new CFormulario
f_consulta.Carga_Parametros "consulta.xml", "consulta"
'---------------------------------------------------------------------------------------				
sql = "select ingr_ncorr from ingresos where cast(ingr_nfolio_referencia as varchar) = " & nfolio & " and cast(ting_ccod as varchar) = " & tipo_doc
resp = conectar.consultaUno(sql)

if resp <> "" then
   response.Write("<script language=""JavaScript"" type=""text/javascript"">  alert(""Ya existe "&conectar.ConsultaUno("select ting_tdesc from tipos_ingresos where cast(ting_ccod as varchar) = '" & tipo_doc & "'")&" con el folio " & nfolio & ". Por favor, ingrese otro número de documento.""); history.go (-1)   </script> ")
   response.End()
end if


'---------------------------------------------------------------------------------------					
nAPendiente = 0 ' nº abono pendiente o de cual debo empezar abonar
set vAbono = new CVariables' reconocer variables para abono
vAbono.procesaform			
abon_mabono = 0
saldo_abono = 0
total_pagar = 0
nrAbonos = vAbono.nrofilas("CC_COMPROMISOS_PENDIENTES")

	'****** Diccionario con todos los abonos *******
	for nA = 0 to nrAbonos - 1 'nA : numero de abono			
		if vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso") <> "" then
			tcom_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"tcom_ccod")
			inst_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"inst_ccod")
			comp_ndocto = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"comp_ndocto")
			dcom_ncompromiso = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso")			
		end if
	next
	'********* fin diccionario **********************
	

'#################################################################################	
	'****** Inicio ingreso de ingresos monto en efectivo ************
'#################################################################################
	


	ingr_mefectivo 	= request.Form("i[0][ingr_mefectivo]")
	
	pers_ncorr = conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar) ='" & pers_nrut & "'")

	if EsVacio(pers_ncorr) then 
		pers_ncorr = conectar.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar) ='" & pers_nrut & "'")
	end if

	if ingr_mefectivo <> "" and ingr_mefectivo <> "0" then
					
		m_detalle = 0 'calcular la suma en el detalle si es que tiene
		m_anticipado = 0 'obtener m_anticipado

		ingr_ncorr = conectar.consultaUno("execute obtenersecuencia 'ingresos'")			


		sql_insert_ingreso=" Insert into ingresos (ingr_ncorr,mcaj_ncorr,ingr_fpago,eing_ccod,ingr_mefectivo,ingr_mdocto,ingr_mtotal,ingr_nestado,pers_ncorr, "&_	
						 " inst_ccod,ingr_manticipado,inem_ccod,ingr_nfolio_referencia,ting_ccod,tmov_ccod,ingr_ncorrelativo_caja, audi_tusuario,audi_fmodificacion) "&_	
						 " values ("&ingr_ncorr&","&v_numero_caja&",'"&v_fecha&"',1,"&ingr_mefectivo&","&m_detalle&","&ingr_mefectivo&",1,"&pers_ncorr&" "&_
						 " ,"&inst_ccod&",0,"&v_inem_ccod&","&nfolio&","&tipo_doc&","&tmov_ccod&","&v_correlativo_caja&",'"&v_usuario_pago&"',getdate()) "
		
		
		conectar.EstadoTransaccion conectar.EjecutaS(sql_insert_ingreso)	
		
		'response.Write("1: " & sql_insert_ingreso&"-<br>")
		'response.Flush()
		
		'**** abono del ingreso *******			
		saldo_abono = ingr_mefectivo
		'response.Write(saldo_abono&"-<br>")

		'recorrer compromisos para ir abonando uno a uno partiendo por el efectivo
		for nA = 0 to nrAbonos - 1 'nA : numero de abono			
			if vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso") <> "" and saldo_abono > 0 then
				'response.Write("<hr>")
				dcom_ncompromiso = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso")
				tcom_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"tcom_ccod")
				inst_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"inst_ccod")
				comp_ndocto = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"comp_ndocto")

				' lo que ya esta pagado
				total_abonado = conectar.consultauno("select protic.total_abonado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&")")
				' lo que se debe de la cuota
				dcom_mcompromiso = conectar.consultauno("select dcom_mcompromiso from detalle_compromisos where tcom_ccod = "&tcom_ccod&" and inst_ccod = "&inst_ccod&" and comp_ndocto = "&comp_ndocto &" and dcom_ncompromiso="&dcom_ncompromiso)
				
				'total_pagar = dcom_mcompromiso - total_abonado
				total_pagar = CLng(conectar.ConsultaUno("select protic.total_recepcionar_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&")"))
			
'response.Write("<br> total_abonado: "& total_abonado & "dcom_mcompromiso: "&dcom_mcompromiso&" total_pagar: " &total_pagar)

				if clng(saldo_abono) >= clng(total_pagar) then
					abon_mabono = total_pagar
					saldo_abono = saldo_abono - total_pagar
				else
					abon_mabono = saldo_abono
					saldo_abono = 0						
				end if
				
				' ************ inserta abono por efectivo ***********
				sql_insert_abono=" Insert into abonos (ingr_ncorr,tcom_ccod,inst_ccod,comp_ndocto,dcom_ncompromiso,abon_fabono,abon_mabono,pers_ncorr,peri_ccod,inem_ccod, audi_tusuario,audi_fmodificacion) "&_	
					 " values ("&ingr_ncorr&","&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&",'"&v_fecha&"',"&abon_mabono&","&pers_ncorr&","&peri_ccod&","&v_inem_ccod&",'"&v_usuario_pago&"',getdate() ) "
	'response.Write("<hr>"&sql_insert_abono&"<hr>")
				conectar.EstadoTransaccion conectar.EjecutaS(sql_insert_abono)	

				v_total_saldo = conectar.consultauno("select protic.total_recepcionar_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&") ")
				
			'response.Write(tcom_ccod &","& inst_ccod &","& comp_ndocto &","& dcom_ncompromiso)
				if  clng(v_total_saldo)=0 then
					' Actualiza pago del documento
					v_ingr_asociado = conectar.consultauno("select protic.documento_asociado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&",'ingr_ncorr') ")
					sql_actualiza_estado_doc=" update detalle_ingresos set edin_ccod=6, audi_tusuario='"&v_usuario_pago&"-pagado' where cast(ingr_ncorr as varchar) ='"&v_ingr_asociado&"'"
					'response.Write("<hr>"&sql_actualiza_estado_doc&"<hr>")
					conectar.EstadoTransaccion conectar.EjecutaS(sql_actualiza_estado_doc)	
				end if
				
				nAPendiente = Na 'guarda el ultimo compromiso pendiente para seguir abonando
			end if
		next


		'******* fin de abono del ingreso *****
	end if
'conectar.EstadoTransaccion false
'response.End()
'#################################################################################	
	'*************** fin ingreso de ingresos en efectivo ************
'#################################################################################



'#################################################################################
	'****** CREACION DE INGRESOS CON DOCUMENTOS ************
'#################################################################################
	
		set vDIngreso = new cVariables
		vDingreso.procesaform
		nrDIng = vDingreso.nrofilas("D")
'response.Write("nrDing: "&nrDing)
	' por cada detalle de ingresos se genera un ingreso				
		for nI = 0 to nrDing - 1

			'****** ingreso de ingresos con documentos ************
			ingr_ncorr = conectar.consultaUno("execute obtenersecuencia 'ingresos'")
			ingr_mdocto = vDingreso.obtenervalor("D",nI,"ding_mdetalle")
			
			ting_ccod = vDingreso.obtenervalor("D",nI,"ting_ccod")

			'cheque,vale vista, credito, debito : son pagos con estado ingreso  documentado
			if ting_ccod = "3" or ting_ccod="14" or ting_ccod = "13" or ting_ccod = "51"  then 
				v_eing_ccod="4"
			else
				v_eing_ccod="1"
			end if


			sql_insert_ingreso_documentado=" Insert into ingresos (ingr_ncorr,mcaj_ncorr,ingr_fpago,eing_ccod,ingr_mefectivo,ingr_mdocto,ingr_mtotal,ingr_nestado,pers_ncorr, "&_	
							 " inst_ccod,ingr_manticipado,inem_ccod,ingr_nfolio_referencia,ting_ccod,tmov_ccod,ingr_ncorrelativo_caja, audi_tusuario,audi_fmodificacion) "&_	
							 " values ("&ingr_ncorr&","&v_numero_caja&",'"&v_fecha&"',"&v_eing_ccod&",0,"&ingr_mdocto&","&ingr_mdocto&",1,"&pers_ncorr&" "&_
							 " ,"&inst_ccod&",0,"&v_inem_ccod&","&nfolio&","&tipo_doc&","&tmov_ccod&","&v_correlativo_caja&",'"&v_usuario_pago&"',getdate()) "
			conectar.EstadoTransaccion conectar.EjecutaS(sql_insert_ingreso_documentado)	
'response.Write("2: " &sql_insert_ingreso_documentado)
'response.End()
			'*************** fin ingreso de ingresos ************

			'********** ingreso de abonos segun compromisos ***********************
			saldo_abono = saldo_abono + ingr_mdocto
			for nA = nAPendiente to nrAbonos - 1 'nA : numero de abono			
				if vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso") <> "" and saldo_abono > 0 then

					dcom_ncompromiso = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso")
					tcom_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"tcom_ccod")
					inst_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"inst_ccod")
					comp_ndocto = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"comp_ndocto")
					
					total_abonado = conectar.consultauno("select protic.total_abonado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&")")
					dcom_mcompromiso = conectar.consultauno("select dcom_mcompromiso from detalle_compromisos where cast(tcom_ccod as varchar) = "&tcom_ccod&" and cast(inst_ccod as varchar) = "&inst_ccod&" and cast(comp_ndocto as varchar) = "&comp_ndocto &" and cast(dcom_ncompromiso as varchar) ="&dcom_ncompromiso)
					
					total_pagar = CLng(conectar.ConsultaUno("select cast(protic.total_recepcionar_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&") as varchar)"))
					
					if clng(saldo_abono) >= clng(total_pagar) then					
						abon_mabono = total_pagar
						saldo_abono = saldo_abono - total_pagar
					else
						abon_mabono = saldo_abono
						saldo_abono = 0
					end if
					
					' ************ inserta abono por efectivo ***********
					sql_insert_abono=" Insert into abonos (ingr_ncorr,tcom_ccod,inst_ccod,comp_ndocto,dcom_ncompromiso,abon_fabono,abon_mabono,pers_ncorr,peri_ccod,inem_ccod, audi_tusuario,audi_fmodificacion) "&_	
						 			 " values ("&ingr_ncorr&","&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&",'"&v_fecha&"',"&abon_mabono&","&pers_ncorr&","&peri_ccod&","&v_inem_ccod&",'"&v_usuario_pago&"',getdate()) "
					conectar.EstadoTransaccion conectar.EjecutaS(sql_insert_abono)	

					nAPendiente = Na
				end if

			next			
			'********** fin ingreso de abonos *******************
		
			'********** inicio detalle de ingresos ***************

			ting_ccod = vDingreso.obtenervalor("D",nI,"ting_ccod")

			if ting_ccod <> "6" then 'genera detalle cuando no es efectivo
				
				v_ding_nsecuencia=conectar.consultauno("execute obtenersecuencia 'detalle_ingresos'")

				ding_ndocto 	= vDingreso.obtenervalor("D",nI,"ding_ndocto")
				plaz_ccod		= vDingreso.obtenervalor("D",nI,"plaz_ccod")
				ding_tplaza_sbif= vDingreso.obtenervalor("D",nI,"ding_tplaza_sbif")
				banc_ccod		= vDingreso.obtenervalor("D",nI,"banc_ccod")
				ding_fdocto		= vDingreso.obtenervalor("D",nI,"ding_fdocto")
				ding_mdetalle 	= vDingreso.obtenervalor("D",nI,"ding_mdetalle")
				ding_mdocto		= vDingreso.obtenervalor("D",nI,"ding_mdocto")
				ding_tcuenta_corriente= vDingreso.obtenervalor("D",nI,"ding_tcuenta_corriente")
				nombre_banco 	= conectar.consultauno("select banc_tdesc from bancos where cast(banc_ccod as varchar) = '"&banc_ccod&"'")
				edin_ccod 		= 1				
				
			
				if ting_ccod = "3" or ting_ccod = "14" or ting_ccod = "13" or ting_ccod = "51" then

					v_ding_bpacta_cuota="N"
	'-----------------------------------------------------------------
	'--- cuando se pague en 2 partes y se anule el primer comprobante 
	'--- hay que ingresar un correlativo en 1 (Pendiente de hacer)
	'-----------------------------------------------------------------
					if ting_ccod = "3" or ting_ccod = "14" then
						sql = "select isnull(max(ding_ncorrelativo), 0) + 1 as nuevo_correlativo," & vbCrLf &_
							  "        isnull(sum(ding_mdetalle), 0) + " & ding_mdetalle & " as nuevo_mdocto, isnull(max(ding_mdocto), 0)" & vbCrLf &_
							  "from detalle_ingresos " & vbCrLf &_
							  "where ting_ccod in(3,14) " & vbCrLf &_
							  "  and ding_ncorrelativo > 0 " & vbCrLf &_
							  "  and edin_ccod not in (6) " & vbCrLf &_
							  "  and cast(ding_ndocto as varchar)= '" & ding_ndocto & "' " & vbCrLf &_
							  "  and cast(banc_ccod as varchar)= '" & banc_ccod & "' " & vbCrLf &_
							  "  and cast(ding_tcuenta_corriente as varchar)= '" & ding_tcuenta_corriente & "'"& vbCrLf &_
							  " and protic.trunc(ding_fdocto)='"&ding_fdocto&"'" 
					else ' Tarjetas
						sql = "select isnull(max(ding_ncorrelativo), 0) + 1 as nuevo_correlativo," & vbCrLf &_
							  "        isnull(sum(ding_mdetalle), 0) + " & ding_mdetalle & " as nuevo_mdocto, isnull(max(ding_mdocto), 0)" & vbCrLf &_
							  "from detalle_ingresos " & vbCrLf &_
							  "where ting_ccod in(13,51) " & vbCrLf &_
							  "  and ding_ncorrelativo > 0 " & vbCrLf &_
							  "  and cast(ding_ndocto as varchar)= '" & ding_ndocto & "' " & vbCrLf &_
							  "  and cast(banc_ccod as varchar)= '" & banc_ccod & "' " & vbCrLf &_
							  "  and cast(ding_tcuenta_corriente as varchar)= '" & ding_tcuenta_corriente & "'"
					end if		  

					f_consulta.Inicializar conectar
					f_consulta.Consultar sql
					f_consulta.Siguiente
	
					v_ding_ncorrelativo = f_consulta.ObtenerValor("nuevo_correlativo")
					v_ding_mdocto = f_consulta.ObtenerValor("nuevo_mdocto")				
					
					if ting_ccod = "3" or ting_ccod = "14" then					
						sentencia = "update detalle_ingresos " & vbCrLf &_
									"set ding_mdocto = '" & v_ding_mdocto & "', " & vbCrLf &_
									"    audi_tusuario = '" & v_usuario_pago & "', " & vbCrLf &_
									"	audi_fmodificacion = getdate() " & vbCrLf &_
									"where ting_ccod in(3,14) " & vbCrLf &_
									"  and ding_ncorrelativo > 0  " & vbCrLf &_
									"  and cast(ding_ndocto as varchar) = '" & ding_ndocto & "'  " & vbCrLf &_
									"  and cast(banc_ccod as varchar) = '" & banc_ccod & "'  " & vbCrLf &_
									"  and cast(ding_tcuenta_corriente as varchar) = '" & ding_tcuenta_corriente & "'"& vbCrLf &_
									"  and protic.trunc(ding_fdocto)='"&ding_fdocto&"'" 
					else ' tarjetas
						sentencia = "update detalle_ingresos " & vbCrLf &_
								"set ding_mdocto = '" & v_ding_mdocto & "', " & vbCrLf &_
								"    audi_tusuario = '" & v_usuario_pago & "', " & vbCrLf &_
								"	audi_fmodificacion = getdate() " & vbCrLf &_
								"where ting_ccod in(13,51) " & vbCrLf &_
								"  and ding_ncorrelativo > 0  " & vbCrLf &_
								"  and cast(ding_ndocto as varchar) = '" & ding_ndocto & "'  " & vbCrLf &_
								"  and cast(banc_ccod as varchar) = '" & banc_ccod & "'  " & vbCrLf &_
								"  and cast(ding_tcuenta_corriente as varchar) = '" & ding_tcuenta_corriente & "'"
					end if					
						'response.Write("<br><pre>" & sentencia & "</pre>")
						conectar.EstadoTransaccion conectar.EjecutaS(sentencia)	  
					'-------------------------------------------------------------------------------------

				end if	

				sql_insert_detalle_ingresos=" Insert into detalle_ingresos (ingr_ncorr,ting_ccod,ding_ndocto,ding_nsecuencia,plaz_ccod,ding_tplaza_sbif,banc_ccod,ding_fdocto, "&_
											" ding_mdetalle,ding_tcuenta_corriente,edin_ccod,ding_bpacta_cuota,ding_ncorrelativo,ding_mdocto, audi_tusuario,audi_fmodificacion) "&_	
											" values ("&ingr_ncorr&","&ting_ccod&","&ding_ndocto&","&v_ding_nsecuencia&","&plaz_ccod&",'"&ding_tplaza_sbif&"',"&banc_ccod&",'"&ding_fdocto&"' "&_
											" ,"&ding_mdetalle&",'"&ding_tcuenta_corriente&"',"&edin_ccod&",'"&v_ding_bpacta_cuota&"',"&v_ding_ncorrelativo&","&v_ding_mdocto&",'"&v_usuario_pago&"',getdate()) "
				conectar.EstadoTransaccion conectar.EjecutaS(sql_insert_detalle_ingresos)	
			
			end if			
			
			'*********** fin detalle_ingresos *****************
	next
'#################################################################################
	'****** ingreso de ingresos con documentos ************
'#################################################################################



	
	for nA = 0 to nrAbonos - 1 'nA : numero de abono			
		if vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso") <> "" then

			tcom_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"tcom_ccod")
			inst_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"inst_ccod")
			comp_ndocto = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"comp_ndocto")
			dcom_ncompromiso = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso")
		
			'==================================================================================================
			'						ACTUALIZA ESTADO DEL DOCUMENTO PAGADO
			'==================================================================================================
				
					v_dcom_mcompromiso 		= 	conectar.consultauno("select dcom_mcompromiso from detalle_compromisos where tcom_ccod = "&tcom_ccod&" and inst_ccod = "&inst_ccod&" and comp_ndocto = "&comp_ndocto &" and dcom_ncompromiso="&dcom_ncompromiso)
					v_total_documentado		=	conectar.consultauno("select protic.total_abono_documentado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&") ")
					v_total_abonado 		= 	conectar.consultauno("select protic.total_abonado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&")")
					v_total_saldo 			= 	clng(v_dcom_mcompromiso) - ( clng(v_total_abonado) + clng(v_total_documentado) ) 
					
					if  clng(v_total_saldo)=0 then
						' Actualiza pago del documento
						v_ingr_asociado = conectar.consultauno("select protic.documento_asociado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&",'ingr_ncorr') ")
						sql_actualiza_estado_doc=" update detalle_ingresos set edin_ccod=6,audi_tusuario='"&v_usuario_pago&"-pagado' where cast(ingr_ncorr as varchar) ='"&v_ingr_asociado&"'"
						conectar.EstadoTransaccion conectar.EjecutaS(sql_actualiza_estado_doc)	
					end if
					'conectar.EstadoTransaccion false
					'response.End()
			'==================================================================================================				
			' 								FIN ACTUALIZA PAGO DOCUMENTO
			'==================================================================================================
		end if
	next	

'response.Write("genera_boletas_electronicas 1,"&nfolio&", "&tipo_doc&", "&v_sede&","&v_numero_caja&", '"&v_usuario_pago&"' ")
'response.End()
'genera_boletas_electronicas
sql_crea_boletas="Exec genera_boletas_electronicas 1,"&nfolio&", "&tipo_doc&", "&v_sede&","&v_numero_caja&", '"&v_usuario_pago&"' "
v_salida=conectar.ConsultaUno(sql_crea_boletas)

 sql_boletas="select pers_ncorr,isnull(pers_ncorr_aval,pers_ncorr)as pers_ncorr_aval,bole_ncorr from boletas where ingr_nfolio_referencia="&nfolio

     set f_boletas = new CFormulario	
	 f_boletas.Carga_Parametros "tabla_vacia.xml","tabla"
	 f_boletas.Inicializar conectar
	 f_boletas.Consultar sql_boletas

%>
	<script language="JavaScript" type="text/javascript">
	 
	 <%
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
%>
</script>  

	<script language="JavaScript" type="text/javascript">
		//alert(imprimir_2)
	  <% if imprime=2 then %>
		//alert('Dirijase a imprimir la boleta desde la pantalla Detalle Boleta, boton E-boleta.');
				 
		//self.location.href = 'boleta_electronica.asp?monto='+<'%=total%>+'&usuario='+<'%=v_usuario_pago%>+'&bole_ncorr='+<'%=v_bole_ncorr%>+'&pers_ncorr='+<'%=pers_ncorr%>;
		 self.location.href = 'comp_ingreso.asp?nfolio='+  <%=nfolio %> + '&nro_ting_ccod='+<%=tipo_doc%>+'&pers_ncorr='+<%=pers_ncorr%>+'&total='+<%=total%>+'&peri_ccod='+<%=Periodo%>;	
		//close();
		  <%else %>
				self.close();
		  <% end if%>
		  
	</script> 