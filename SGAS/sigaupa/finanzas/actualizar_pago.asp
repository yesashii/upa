<!-- #include file = "../biblioteca/_negocio.asp" -->
<!-- #include file="../biblioteca/_conexion.asp" -->
<%
'for each x in request.Form
	'response.Write("<br>"&x&" -> "&request.Form(x))
'next
'response.End()
nfolio	=	request.Form("n_folio")
total	=	request.form("total")
imprimir=	3

valor21= request.Form("i[0][ting_ccod]")

rut		=	request.Form("rut")
cant_detalle= request.form("cant_detalle")
tipo_doc	= request.form("i[0][ting_ccod]")

efectivo=clng(request.form("i[0][ingr_mefectivo]"))
v_inem_ccod = Request.Form("h_inem_ccod")
inst_ccod = request.Form("h_inst_ccod")
tmov_ccod = Request.Form("tmov_ccod")

Dim d_abono
set d_abono = Server.CreateObject("Scripting.Dictionary")

'Dim abono 
'abono = array()

pers_nrut=left(trim(rut),len(trim(rut))-2)
'---------------------------------------------------------------------------------------				
set conectar = new cconexion
conectar.inicializar "upacifico"	
		
set negocio = new CNegocio
negocio.Inicializa conectar
	
peri_ccod = negocio.ObtenerPeriodoAcademico("CLASES18")
Periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")



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
detalle_comprobante_prod = ""
detall_comprobante = ""

	'****** arreglo con todos los abonos *******

	
	for nA = 0 to nrAbonos - 1 'nA : numero de abono			
		'response.Write(max_tcom_ccod&"-"&max_inst_ccod&"-"&max_comp_ndocto&"-"&max_dcom_ncompromiso&"***<br>")
		if vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso") <> "" then
			tcom_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"tcom_ccod")
			inst_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"inst_ccod")
			comp_ndocto = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"comp_ndocto")
			dcom_ncompromiso = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso")			
			
	
			clave = CStr(tcom_ccod) & "-" & CStr(inst_ccod) & "-" & CStr(comp_ndocto) & "-" & CStr(dcom_ncompromiso)
			d_abono.Add clave, 0
		
		end if
	next
	'ReDim abono(max_tcom_ccod,max_inst_ccod,max_comp_ndocto,max_dcom_ncompromiso)
	'********* fin arreglo **********************
	
	'****** ingreso de ingresos monto en efectivo ************
	ingr_mintereses = request.Form("i[0][ingr_mintereses]")
	ingr_mmultas = request.Form("i[0][ingr_mmultas]")
	ingr_mefectivo = request.Form("i[0][ingr_mefectivo]")
	fecha = conectar.consultaUno("select convert(varchar,getdate(),103)")
	pers_ncorr = conectar.consultaUno("Select pers_ncorr from personas where cast(pers_nrut as varchar) ='" & pers_nrut & "'")
	if EsVacio(pers_ncorr) then 
		pers_ncorr = conectar.consultaUno("Select pers_ncorr from personas_postulante where cast(pers_nrut as varchar) ='" & pers_nrut & "'")
	end if

	if ingr_mefectivo <> "" and ingr_mefectivo <> "0" then
		set ingreso = new cformulario
		ingreso.carga_parametros "paulo.xml","pagos"
		ingreso.inicializar conectar		
		ingreso.procesaForm
					
		m_detalle = 0 'calcular la suma en el detalle si es que tiene
		m_anticipado = 0 'obtener m_anticipado

		'ingr_ncorr = conectar.consultaUno("select ingr_ncorr_seq.nextval as s from dual")
		ingr_ncorr = conectar.consultaUno("execute obtenersecuencia 'ingresos'")			
		
		ingreso.agregacampopost "ingr_ncorr", ingr_ncorr
		ingreso.agregacampopost "ingr_fpago", fecha
		ingreso.agregacampopost "eing_ccod", "1"
		ingreso.agregacampopost "ingr_mefectivo", ingr_mefectivo
		ingreso.agregacampopost "ingr_mdocto", m_detalle
		ingreso.agregacampopost "ingr_mtotal", ingr_mefectivo
		ingreso.agregacampopost "ingr_nestado", "1"
		ingreso.agregacampopost "pers_ncorr", pers_ncorr
		ingreso.agregacampopost "inst_ccod", inst_ccod
		ingreso.AgregaCampoPost "ingr_manticipado", "0"
		ingreso.AgregaCampoPost "ingr_mmultas",ingr_mmultas
		ingreso.AgregaCampoPost "ingr_mintereses",ingr_mintereses
		ingreso.AgregaCampoPost "inem_ccod", v_inem_ccod
		ingreso.agregacampopost "ingr_nfolio_referencia", nfolio
		ingreso.agregacampopost "tmov_ccod", tmov_ccod
		ingreso.mantienetablas false
		ingr_mintereses=0
		ingr_mmultas=0
				
		'detalle_comprobante = LMargen & "EFECTIVO" & " $" & formatnumber(ingr_mefectivo,0) & enter
		'**** abono del ingreso *******			
		saldo_abono = ingr_mefectivo
		'response.Write(saldo_abono&"-<br>")
		for nA = 0 to nrAbonos - 1 'nA : numero de abono			
			if vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso") <> "" and saldo_abono > 0 then
				'response.Write("<hr>")
				dcom_ncompromiso = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso")
				tcom_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"tcom_ccod")
				inst_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"inst_ccod")
				comp_ndocto = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"comp_ndocto")

				total_abonado = conectar.consultauno("select protic.total_abonado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&")")

				dcom_mcompromiso = conectar.consultauno("select dcom_mcompromiso from detalle_compromisos where tcom_ccod = "&tcom_ccod&" and inst_ccod = "&inst_ccod&" and comp_ndocto = "&comp_ndocto &" and dcom_ncompromiso="&dcom_ncompromiso)
				
				'total_pagar = dcom_mcompromiso - total_abonado
				total_pagar = CLng(conectar.ConsultaUno("select protic.total_recepcionar_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&")"))
			
				if clng(saldo_abono) >= clng(total_pagar) then
					abon_mabono = total_pagar
					saldo_abono = saldo_abono - total_pagar
				else
					abon_mabono = saldo_abono
					saldo_abono = 0						
				end if
				'response.Write(tcom_ccod&"-"&inst_ccod&"-"&comp_ndocto&"-"&dcom_ncompromiso&"="&abon_mabono&":"&"<br>")
				'abono(tcom_ccod,inst_ccod,comp_ndocto,dcom_ncompromiso) = abono(tcom_ccod,inst_ccod,comp_ndocto,dcom_ncompromiso)+abon_mabono					
				
				clave = CStr(tcom_ccod) & "-" & CStr(inst_ccod) & "-" & CStr(comp_ndocto) & "-" & CStr(dcom_ncompromiso)
				d_abono.Item(clave) = d_abono.Item(clave) + abon_mabono
				
				set dabono = new cformulario		
				dabono.carga_parametros "paulo.xml","ingresos_abonos"
				dabono.inicializar conectar
				dabono.procesaForm
			
				dabono.agregacampopost "ingr_ncorr", ingr_ncorr
				dabono.agregacampopost "tcom_ccod", tcom_ccod
				dabono.agregacampopost "inst_ccod", inst_ccod
				dabono.agregacampopost "comp_ndocto",comp_ndocto
				dabono.agregacampopost "dcom_ncompromiso",dcom_ncompromiso	
				dabono.agregacampopost "abon_fabono", fecha
				dabono.agregacampopost "abon_mabono", abon_mabono
				dabono.agregacampopost "pers_ncorr", pers_ncorr
				dabono.AgregaCampoPost "peri_ccod", peri_ccod
				dabono.AgregaCampoPost "inem_ccod", v_inem_ccod			
				dabono.mantienetablas false
				'total_abonado = conectar.consultauno("select total_abonado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&") from dual")
				'response.Write(total_abonado&"**<br>")
				
				v_total_saldo = conectar.consultauno("select protic.total_recepcionar_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&") ")
				if  clng(v_total_saldo)=0 then
					' Actualiza pago del documento
					v_ingr_asociado = conectar.consultauno("select protic.documento_asociado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&",'ingr_ncorr') ")
					sql_actualiza_estado_doc=" update detalle_ingresos set edin_ccod=6,audi_tusuario='"&negocio.ObtenerUsuario&"-Regulariza' where cast(ingr_ncorr as varchar) ='"&v_ingr_asociado&"'"
					
					conectar.EstadoTransaccion conectar.EjecutaS(sql_actualiza_estado_doc)	
				end if
				
				nAPendiente = Na 'guarda el ultimo compromiso pendiente para seguir abonando
			end if
		next
		'******* fin de abono del ingreso *****
	end if
	'*************** fin ingreso de ingresos en efectivo ************
			
		set vDIngreso = new cVariables
		vDingreso.procesaform
		nrDIng = vDingreso.nrofilas("D")
				
		for nI = 0 to nrDing - 1
			'response.Write("<hr>")			
			
			'****** ingreso de ingresos con documentos ************
			set ingreso = new cformulario
			ingreso.carga_parametros "paulo.xml","pagos"
			ingreso.inicializar conectar		
			ingreso.procesaForm			
			
			'ingr_ncorr = conectar.consultaUno("select ingr_ncorr_seq.nextval as s from dual")
			ingr_ncorr = conectar.consultaUno("execute obtenersecuencia 'ingresos'")
			ingr_mdocto = vDingreso.obtenervalor("D",nI,"ding_mdetalle")
			
			ingreso.agregacampopost "ingr_ncorr", ingr_ncorr
			ingreso.agregacampopost "ingr_fpago", fecha
			ting_ccod = vDingreso.obtenervalor("D",nI,"ting_ccod")
			if ting_ccod = "3" then 'cheque: estado ingreso es documentado
				ingreso.agregacampopost "eing_ccod", "4"
			else
				ingreso.agregacampopost "eing_ccod", "1"
			end if
			ingreso.agregacampopost "ingr_mefectivo", "0"
			ingreso.agregacampopost "ingr_mdocto", ingr_mdocto		
			ingreso.agregacampopost "ingr_mtotal", ingr_mdocto		
			ingreso.agregacampopost "ingr_nestado", "1"
			ingreso.agregacampopost "pers_ncorr", pers_ncorr
			ingreso.agregacampopost "inst_ccod", inst_ccod
			ingreso.AgregaCampoPost "ingr_manticipado", "0"
			ingreso.AgregaCampoPost "ingr_mmultas",ingr_mmultas
			ingreso.AgregaCampoPost "ingr_mintereses",ingr_mintereses
			ingreso.AgregaCampoPost "inem_ccod", v_inem_ccod
			ingreso.agregacampopost "ingr_nfolio_referencia", nfolio			
			ingreso.agregacampopost "tmov_ccod", tmov_ccod
			ingreso.mantienetablas false
			ingr_mintereses=0
			ingr_mmultas=0			
			'*************** fin ingreso de ingresos ************
			'********** ingreso de abonos ***********************
			saldo_abono = saldo_abono + ingr_mdocto
			for nA = nAPendiente to nrAbonos - 1 'nA : numero de abono			
				if vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso") <> "" and saldo_abono > 0 then
					'response.Write("<hr>")
					dcom_ncompromiso = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso")
					tcom_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"tcom_ccod")
					inst_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"inst_ccod")
					comp_ndocto = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"comp_ndocto")
					
					total_abonado = conectar.consultauno("select protic.total_abonado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&")")
					dcom_mcompromiso = conectar.consultauno("select dcom_mcompromiso from detalle_compromisos where cast(tcom_ccod as varchar) = "&tcom_ccod&" and cast(inst_ccod as varchar) = "&inst_ccod&" and cast(comp_ndocto as varchar) = "&comp_ndocto &" and cast(dcom_ncompromiso as varchar) ="&dcom_ncompromiso)
					
					'total_pagar = dcom_mcompromiso - total_abonado
					total_pagar = CLng(conectar.ConsultaUno("select cast(protic.total_recepcionar_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&") as varchar)"))
					
					if clng(saldo_abono) >= clng(total_pagar) then					
						abon_mabono = total_pagar
						saldo_abono = saldo_abono - total_pagar
					else
						abon_mabono = saldo_abono
						saldo_abono = 0
					end if
					
					'abono(tcom_ccod,inst_ccod,comp_ndocto,dcom_ncompromiso) = abono(tcom_ccod,inst_ccod,comp_ndocto,dcom_ncompromiso)+abon_mabono
					'response.Write(tcom_ccod&"-"&inst_ccod&"-"&comp_ndocto&"-"&dcom_ncompromiso&"="&abon_mabono&":"&abono(tcom_ccod,inst_ccod,comp_ndocto,dcom_ncompromiso)&"<br>")
					
					clave = CStr(tcom_ccod) & "-" & CStr(inst_ccod) & "-" & CStr(comp_ndocto) & "-" & CStr(dcom_ncompromiso)
					d_abono.Item(clave) = d_abono.Item(clave) + abon_mabono
					
					set dabono = new cformulario		
					dabono.carga_parametros "paulo.xml","ingresos_abonos"
					dabono.inicializar conectar
					dabono.procesaForm
				
					dabono.agregacampopost "ingr_ncorr", ingr_ncorr
					dabono.agregacampopost "tcom_ccod", tcom_ccod
					dabono.agregacampopost "inst_ccod", inst_ccod
					dabono.agregacampopost "comp_ndocto",comp_ndocto
					dabono.agregacampopost "dcom_ncompromiso",dcom_ncompromiso	
					dabono.agregacampopost "abon_fabono", fecha
					dabono.agregacampopost "abon_mabono", abon_mabono
					dabono.agregacampopost "pers_ncorr", pers_ncorr
					dabono.AgregaCampoPost "peri_ccod", peri_ccod
					dabono.AgregaCampoPost "inem_ccod", v_inem_ccod			
					dabono.mantienetablas false
					'total_abonado = conectar.consultauno("select total_abonado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&") from dual")
					'response.Write(total_abonado&"**<br>")
					nAPendiente = Na
				end if
			next			
			'********** fin ingreso de abonos *******************
			
			'********** inicio detalle de ingresos ***************
			'response.Write("<hr>")
			ting_ccod = vDingreso.obtenervalor("D",nI,"ting_ccod")
			if ting_ccod <> "6" then 'genera detalle cuando no es efectivo
				ding_ndocto = vDingreso.obtenervalor("D",nI,"ding_ndocto")
				plaz_ccod= vDingreso.obtenervalor("D",nI,"plaz_ccod")
				banc_ccod= vDingreso.obtenervalor("D",nI,"banc_ccod")
				ding_fdocto= vDingreso.obtenervalor("D",nI,"ding_fdocto")
				ding_mdetalle = vDingreso.obtenervalor("D",nI,"ding_mdetalle")
				ding_mdocto= vDingreso.obtenervalor("D",nI,"ding_mdocto")
				ding_tcuenta_corriente= vDingreso.obtenervalor("D",nI,"ding_tcuenta_corriente")
				nombre_banco = conectar.consultauno("select banc_tdesc from bancos where cast(banc_ccod as varchar) = '"&banc_ccod&"'")
				edin_ccod = 1				

				'detalle_comprobante = detalle_comprobante & LMargen & "CHEQUE N 286."& ding_ndocto & " " & nombre_banco & " $" & formatnumber(ding_mdetalle,0) & " " & ding_fdocto & enter

				set dingreso = new cformulario
				dingreso.carga_parametros "paulo.xml", "detalle_ingresos"
				dingreso.inicializar conectar
				dingreso.procesaForm
								
				dingreso.agregacampopost "ting_ccod",ting_ccod
				dingreso.agregacampopost "ding_ndocto",ding_ndocto
				dingreso.agregacampopost "ingr_ncorr", ingr_ncorr
				'dingreso.agregacampopost "ding_nsecuencia",conectar.consultauno("select ding_nsecuencia_seq.nextval from dual")
				dingreso.agregacampopost "ding_nsecuencia",conectar.consultauno("execute obtenersecuencia 'detalle_ingresos'")
				'dingreso.agregacampopost "ding_ncorrelativo","1"
				dingreso.agregacampopost "plaz_ccod",plaz_ccod
				dingreso.agregacampopost "banc_ccod",banc_ccod
				dingreso.agregacampopost "ding_fdocto",ding_fdocto
				dingreso.agregacampopost "ding_mdetalle",ding_mdetalle
				'dingreso.agregacampopost "ding_mdocto",ding_mdetalle
				dingreso.agregacampopost "ding_tcuenta_corriente",ding_tcuenta_corriente
				
								
				if ting_ccod = "3" then
					dingreso.agregacampopost "edin_ccod",1
					dingreso.AgregaCampoPost "ding_bpacta_cuota", "N"
					
					'-------------------------------------------------------------------------------------
					sql = "select isnull(max(ding_ncorrelativo), 0) + 1 as nuevo_correlativo," & vbCrLf &_
						  "        isnull(sum(ding_mdetalle), 0) + " & ding_mdetalle & " as nuevo_mdocto, isnull(max(ding_mdocto), 0)" & vbCrLf &_
						  "from detalle_ingresos " & vbCrLf &_
						  "where ting_ccod = 3 " & vbCrLf &_
						  "  and ding_ncorrelativo > 0 " & vbCrLf &_
						  "  and cast(ding_ndocto as varchar)= '" & ding_ndocto & "' " & vbCrLf &_
						  "  and cast(banc_ccod as varchar)= '" & banc_ccod & "' " & vbCrLf &_
						  "  and cast(ding_tcuenta_corriente as varchar)= '" & ding_tcuenta_corriente & "'"
					'response.Write("<pre>"&sql&"</pre>")
 
					f_consulta.Inicializar conectar
					f_consulta.Consultar sql
					f_consulta.Siguiente
					v_ding_ncorrelativo = f_consulta.ObtenerValor("nuevo_correlativo")
					v_ding_mdocto = f_consulta.ObtenerValor("nuevo_mdocto")				
					
					dingreso.agregacampopost "ding_ncorrelativo", v_ding_ncorrelativo
					dingreso.agregacampopost "ding_mdocto", v_ding_mdocto
					
					sentencia = "update detalle_ingresos " & vbCrLf &_
								"set ding_mdocto = '" & v_ding_mdocto & "', " & vbCrLf &_
								"    audi_tusuario = '" & negocio.ObtenerUsuario & "', " & vbCrLf &_
								"	audi_fmodificacion = getdate() " & vbCrLf &_
								"where ting_ccod = 3 " & vbCrLf &_
								"  and ding_ncorrelativo > 0  " & vbCrLf &_
								"  and cast(ding_ndocto as varchar) = '" & ding_ndocto & "'  " & vbCrLf &_
								"  and cast(banc_ccod as varchar) = '" & banc_ccod & "'  " & vbCrLf &_
								"  and cast(ding_tcuenta_corriente as varchar) = '" & ding_tcuenta_corriente & "'"
						  
					'response.Write("<pre>" & sentencia & "</pre>")
					conectar.EstadoTransaccion conectar.EjecutaS(sentencia)	  
						  
					'-------------------------------------------------------------------------------------
					
					
				else
					dingreso.agregacampopost "edin_ccod",""
					dingreso.AgregaCampoPost "ding_bpacta_cuota", ""
				end if				
				dingreso.mantienetablas false					
			end if			

	next


	'******************************************************************************
	'***********	 for para recorrer los documentos pagados *********************
	'******************************************************************************
	for nA = 0 to nrAbonos - 1 'nA : numero de abono			
		if vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso") <> "" then
			'response.Write("<hr>")
			tcom_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"tcom_ccod")
			inst_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"inst_ccod")
			comp_ndocto = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"comp_ndocto")
			dcom_ncompromiso = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso")
			
			'abon_mabono = abono(tcom_ccod,inst_ccod,comp_ndocto,dcom_ncompromiso)
			'abon_mabono = d_abono.Item(tcom_ccod).Item(inst_ccod).Item(comp_ndocto).Item(dcom_ncompromiso)
			clave = CStr(tcom_ccod) & "-" & CStr(inst_ccod) & "-" & CStr(comp_ndocto) & "-" & CStr(dcom_ncompromiso)
		    abon_mabono = d_abono.Item(clave)
			
		
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
				sql_actualiza_estado_doc=" update detalle_ingresos set edin_ccod=6,audi_tusuario='"&negocio.ObtenerUsuario&"-Regulariza' where cast(ingr_ncorr as varchar) ='"&v_ingr_asociado&"'"
				
				conectar.EstadoTransaccion conectar.EjecutaS(sql_actualiza_estado_doc)	
			end if
		'==================================================================================================				
		' 								FIN ACTUALIZA PAGO DOCUMENTO
		'==================================================================================================
		end if
	next	
	'******************************************************************************
	'***********	 Fin para recorrer los documentos pagados *********************
	'******************************************************************************
sql_crea_descuento="Exec inserta_descuento_posterior "&nfolio&" " 
v_salida=conectar.ConsultaUno(sql_crea_descuento)


	set abono = Nothing
	set f_detalle_imprimir = Nothing
	set dingreso = Nothing
	set ingreso = Nothing
	set vDIngreso = Nothing
	set dabono = Nothing
	set ingreso = Nothing
	set vAbono = Nothing
	set f_consulta = Nothing
	set negocio = Nothing
	set conectar = Nothing

%>
	<script language="JavaScript" type="text/javascript">

		<% if imprimir=2 then %>
		
		<% else %>
		  <% if imprimir=3 then %>
		   self.location.href = '../cajas/comp_ingreso.asp?nfolio='+<%=nfolio %>+'&nro_ting_ccod='+<%=tipo_doc%>+'&pers_ncorr='+<%=pers_ncorr%>+'&total='+<%=total%>+'&peri_ccod='+<%=Periodo%>;	
		  <%else %>
				self.close();
		  <% end if%>
		<% end if%>
		

	</script> 