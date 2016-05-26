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
imprimir_1=request.Form("imprimir_1")

valor21	= request.Form("i[0][ting_ccod]")
ruta 	=	request.Form("ip[0][impr_truta]")

alumno	=	request.Form("alumno")
rut		=	request.Form("rut")
cant_detalle= 	request.form("cant_detalle")
tipo_doc	= 	request.form("i[0][ting_ccod]")
efectivo	=	clng(request.form("i[0][ingr_mefectivo]"))
v_inem_ccod = 	Request.Form("h_inem_ccod")
inst_ccod = request.Form("h_inst_ccod")
tmov_ccod = Request.Form("tmov_ccod")
enter 	= chr(13) & chr(10)
tMargen = enter & enter & enter & enter
lMargen = space(5)
lCodAlumno 	= 11
lCarrera 	= 28
lFecha 		= 11
lRut 		= 11
lDatos 		= 41
lNDoc 		= 8
lDet 		= 25
lValor 		= 9
lFechaVcto 	= 10
Dim d_abono
set d_abono = Server.CreateObject("Scripting.Dictionary")

Dim objFS 'VBScript File System Object
Dim objWSHNet 'Windows Script Host Network Object
Dim objPrinter 'Printer Object to stream text to
Dim strLabel

pers_nrut=left(trim(rut),len(trim(rut))-2)

'Const  fecha=fecha_constante

'---------------------------------------------------------------------------------------
function Ac1(texto,ancho,alineado)
	largo =Len(Trim(texto))
	if isNull(largo) then
		largo=0
	end if
	if largo > ancho then largo=ancho
	if ucase(alineado) = "D" then 
		Ac1=space(ancho-cint(largo))&Left(texto,largo)
	else
		Ac1=Left(texto,largo)&space(ancho-largo)
	end if   
end function
'---------------------------------------------------------------------------------------				
set conectar = new cconexion
conectar.inicializar "upacifico"	

v_fecha = conectar.consultaUno("select protic.trunc(getdate()) as fecha")
'conectar.EstadoTransaccion false
		
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

	'****** Diccionario con todos los abonos *******
	for nA = 0 to nrAbonos - 1 'nA : numero de abono			
		' aqui se inicia la magia de pino (que fallo 2 veces)!!!! jajaja
		if vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso") <> "" then
			
			tcom_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"tcom_ccod")
			inst_ccod = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"inst_ccod")
			comp_ndocto = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"comp_ndocto")
			dcom_ncompromiso = vAbono.obtenervalor("CC_COMPROMISOS_PENDIENTES",nA,"dcom_ncompromiso")			
			
			clave = CStr(tcom_ccod) & "-" & CStr(inst_ccod) & "-" & CStr(comp_ndocto) & "-" & CStr(dcom_ncompromiso)
			d_abono.Add clave, 0	
						
		end if
	
	next
	'********* fin diccionario **********************
	
	'****** ingreso de ingresos monto en efectivo ************
	ingr_mintereses = request.Form("i[0][ingr_mintereses]")
	ingr_mmultas 	= request.Form("i[0][ingr_mmultas]")
	ingr_mefectivo 	= request.Form("i[0][ingr_mefectivo]")
	'fecha = conectar.consultaUno("select convert(varchar,getdate(),103)")
	'fecha = conectar.consultaUno("select convert(datetime,getdate(),103)")
	
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
		ingreso.agregacampopost "ingr_fpago", v_fecha
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
				
		detalle_comprobante = LMargen & "EFECTIVO" & " $" & formatnumber(ingr_mefectivo,0) & enter
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
				dabono.agregacampopost "abon_fabono", v_fecha
				dabono.agregacampopost "abon_mabono", abon_mabono
				dabono.agregacampopost "pers_ncorr", pers_ncorr
				dabono.AgregaCampoPost "peri_ccod", peri_ccod
				dabono.AgregaCampoPost "inem_ccod", v_inem_ccod			
				dabono.mantienetablas false
				'total_abonado = conectar.consultauno("select total_abonado_cuota("&tcom_ccod&","&inst_ccod&","&comp_ndocto&","&dcom_ncompromiso&") from dual")
				
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

			'****** ingreso de ingresos con documentos ************
			set ingreso = new cformulario
			ingreso.carga_parametros "paulo.xml","pagos"
			ingreso.inicializar conectar		
			ingreso.procesaForm			
			
			'ingr_ncorr = conectar.consultaUno("select ingr_ncorr_seq.nextval as s from dual")
			ingr_ncorr = conectar.consultaUno("execute obtenersecuencia 'ingresos'")
			ingr_mdocto = vDingreso.obtenervalor("D",nI,"ding_mdetalle")
			
			ingreso.agregacampopost "ingr_ncorr", ingr_ncorr
			ingreso.agregacampopost "ingr_fpago", v_fecha
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
					dabono.agregacampopost "abon_fabono", v_fecha
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
				'--------------------------------------------------------------------
				' agregado al final para lectura magnetica de plaza
				ding_tplaza_sbif= vDingreso.obtenervalor("D",nI,"ding_tplaza_sbif")
				'--------------------------------------------------------------------				
				banc_ccod= vDingreso.obtenervalor("D",nI,"banc_ccod")
				ding_fdocto= vDingreso.obtenervalor("D",nI,"ding_fdocto")
				ding_mdetalle = vDingreso.obtenervalor("D",nI,"ding_mdetalle")
				ding_mdocto= vDingreso.obtenervalor("D",nI,"ding_mdocto")
				ding_tcuenta_corriente= vDingreso.obtenervalor("D",nI,"ding_tcuenta_corriente")
				' agregado al final para lectura magnetica de plaza
				ding_tplaza_sbif= vDingreso.obtenervalor("D",nI,"ding_tplaza_sbif")
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
				'--------------------------------------------------------------------
				' agregado al final para lectura magnetica de plaza
				dingreso.agregacampopost "ding_tplaza_sbif",ding_tplaza_sbif
				'--------------------------------------------------------------------
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
					if ting_ccod = "13" or ting_ccod = "51" then
						dingreso.agregacampopost "edin_ccod","1"
						dingreso.agregacampopost "ding_ncorrelativo", "1" 
						'dingreso.AgregaCampoPost "ding_bpacta_cuota", ""
					else
						dingreso.agregacampopost "edin_ccod",""
						dingreso.AgregaCampoPost "ding_bpacta_cuota", ""
					end if
				end if				
				dingreso.mantienetablas false					
			end if			
			
			
			
			'if ting_ccod = "3" then 'genera detalle solo para cheques
				'detalle_comprobante = detalle_comprobante & LMargen & "CHEQUE N 312."& ding_ndocto & " " & nombre_banco & " $" & formatnumber(ding_mdetalle,0) & " " & ding_fdocto & enter
			'else
				'ting_tdesc = conectar.consultauno("select ting_tdesc from tipos_ingresos where ting_ccod = '"&ting_ccod&"'")
				'detalle_comprobante = detalle_comprobante & LMargen & ting_tdesc & " " & nombre_banco & " $" & formatnumber(ingr_mefectivo,0) & ". hola 315" & enter
			'end if
			
			
			
			
			'*********** fin detalle de ingresos *****************
	next
	

	nDetPag = 0
	
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
			
			if abon_mabono <> "" then
				tcom_tdesc = conectar.consultauno("select tcom_tdesc from tipos_compromisos where cast(tcom_ccod as varchar) = '"&tcom_ccod&"'")
				comp_fdocto = conectar.consultauno("select comp_fdocto from compromisos where tcom_ccod = '"&tcom_ccod&"' and inst_ccod = '"&inst_ccod &"' and comp_ndocto = '"&comp_ndocto&"'")
				detalle_comprobante_prod = detalle_comprobante_prod & LMargen & Ac1(comp_ndocto,lNDoc,"I") & " " & Ac1(tcom_tdesc,lDet,"I") & " " & Ac1(formatnumber(abon_mabono,0),lValor,"D") & " " & Ac1(comp_fdocto,lFechaVcto,"I") & enter
				nDetPag = nDetPag + 1
			end if
		end if
	next	
	
			'--------------------- DETALLES DOCUMENTOS -------------------------------------------
		set f_detalle_imprimir = new CFormulario
		f_detalle_imprimir.Carga_Parametros "paulo.xml", "imprimir_listado"
		f_detalle_imprimir.Inicializar conectar
		
		
		consulta= "select di.ting_ccod,di.ding_ndocto,di.ding_mdetalle,di.ding_fdocto,ti.ting_tdesc from ingresos ii, " &_
				"detalle_ingresos di, tipos_ingresos ti  " &_
				"where cast(ii.ingr_nfolio_referencia as varchar) =" & nfolio &"  " &_
				"and cast(ii.ting_ccod as varchar) =" & tipo_doc &" " &_
				"and ii.EING_CCOD in (1,4) " &_
				"and ii.ingr_ncorr=di.ingr_ncorr  " &_
				"and di.TING_CCOD=ti.ting_ccod "
				
		f_detalle_imprimir.Consultar consulta
		'response.Write(consulta)
	    while f_detalle_imprimir.Siguiente  
		'response.Write("154212221")
				if f_detalle_imprimir.ObtenerValor("ting_ccod") = "3" then 'genera detalle solo para cheques              
				   ' response.Write("akiiii cheque")
					detalle_comprobante = detalle_comprobante & LMargen & "CHEQUE N."& f_detalle_imprimir.ObtenerValor("ding_ndocto") & " " & nombre_banco & " $" & formatnumber(f_detalle_imprimir.ObtenerValor("ding_mdetalle"),0) & " " & f_detalle_imprimir.ObtenerValor("ding_fdocto") & enter
				else
					'ting_tdesc = conectar.consultauno("select ting_tdesc from tipos_ingresos where ting_ccod = '"&ting_ccod&"'")
					'response.Write("akiiii visa")
					detalle_comprobante = detalle_comprobante & LMargen & f_detalle_imprimir.ObtenerValor("ting_tdesc") & " " & nombre_banco & " $" & formatnumber(f_detalle_imprimir.ObtenerValor("ding_mdetalle"),0) & ". " & enter
			end if
		wend	
		'---------------------------------------------------------------------------------------
	'response.Write(conectar.ObtenerEstadoTransaccion)
	'response.End()		

	'response.Write(imprimir & " " & ruta)
	for ndet = 1 to 12-nrDing-nDetPag
		detalle_comprobante = detalle_comprobante & enter
	next
	detalle_comprobante = detalle_comprobante  & lMargen & space(35) & Ac1(formatnumber(total,0),lValor,"D")
	
	if imprimir_1 = "1"  then 'and ruta <> "" then  'imprimir comprobante de ingreso
	'response.Write("Entre a procesar pues imprimir es 1")
	'response.End()
		'cod_alumno = "123123"
		 
	     'Response.Redirect("http://127.0.0.1/reportes/comp_cajas/comp_cajas.aspx?detalle_comprobante=" & detalle_comprobante_prod)
	'------ de aki 
	
	    'esto lo comentó Marcelo para enviar directamente al archivo proc_genera _impfactura.asp
		'*************************************************************************************** 
		'conectar.consultauno("select codigo_alumno("& pers_ncorr &","&peri_ccod &") from dual")
		'ofer_ncorr = conectar.consultauno("SELECT ofertas_academicas.ofer_ncorr FROM alumnos, ofertas_academicas WHERE (ofertas_academicas.ofer_ncorr = alumnos.ofer_ncorr) AND (alumnos.pers_ncorr = '"&pers_ncorr&"') and (alumnos.emat_ccod=1) ORDER BY ofertas_academicas.peri_ccod DESC")
		'carrera = conectar.consultauno("select protic.obtener_nombre_carrera("&ofer_ncorr&",'CE')")
		'nombre = conectar.consultauno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from personas where cast(pers_ncorr as varchar) = '"&pers_ncorr&"'")
		'rut_deudor = conectar.consultauno("select pers_nrut + '-' + pers_xdv from postulantes, codeudor_postulacion, personas where postulantes.post_ncorr = codeudor_postulacion.post_ncorr and personas.pers_ncorr = codeudor_postulacion.pers_ncorr and cast(postulantes.pers_ncorr as varchar) = '"&pers_ncorr&"' and cast(ofer_ncorr as varchar) = '"&ofer_ncorr&"'")
		'nombre_deudor = conectar.consultauno("select pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno from postulantes, codeudor_postulacion, personas where postulantes.post_ncorr = codeudor_postulacion.post_ncorr and personas.pers_ncorr = codeudor_postulacion.pers_ncorr and cast(postulantes.pers_ncorr as varchar) = '"&pers_ncorr&"' and cast(ofer_ncorr as varchar) = '"&ofer_ncorr&"'")
		'linea = ""
		'for ch = 0 to 54
	    '		linea = linea & "-"
		'next
		'archivo = tMargen & lMargen & space(43) & Ac1(nfolio,10,"I") & enter
		'archivo = archivo & enter & enter
		'archivo = archivo & lMargen & Ac1(cod_alumno,lCodAlumno,"I") & "  " & Ac1(carrera,lCarrera,"I") & "  " & Ac1(fecha,lFecha,"I") & enter
		'archivo = archivo & enter
		'archivo = archivo & lMargen & Ac1(rut,lRut,"I") & "  " & Ac1(nombre,lDatos,"I") & enter
		'archivo = archivo & enter & enter
		'archivo = archivo & lMargen & Ac1(rut_deudor,lRut,"I") & "* " & Ac1(nombre_deudor,lDatos,"I") & enter
		'archivo = archivo & enter & enter & enter & enter & enter                                                                                                                                                                                                         
		'archivo = archivo & detalle_comprobante_prod		
		'archivo = archivo & lMargen & linea & enter		
		'archivo = archivo & detalle_comprobante
		'archivo = archivo & enter & enter & enter & enter		
					   
		session("impresora")="\\INFO4\IBM Proprinter II"
		
		' valores en duro escritos en el código para indicar el tipo de documento que se desea imprimir	son los código de la tabla
		' tipos_ingresos de boleta exenta de iva, boleta no exenta, factura exenta y factura no exenta
		if  valor21="47"then
			response.redirect("proc_genera_impboletaN_afecta.asp?nfolio="&nfolio &"&nro_ting_ccod="&tipo_doc&"&pers_ncorr="&pers_ncorr&"&total="&total&"&peri_ccod="&Periodo)
		elseif valor21="48" then
			response.redirect("proc_genera_impboleta_afecta.asp?nfolio="&nfolio &"&nro_ting_ccod="&tipo_doc&"&pers_ncorr="&pers_ncorr&"&total="&total&"&peri_ccod="&Periodo)
		elseif valor21="49" then
		    response.redirect("proc_genera_impfacturaN_afecta.asp?nfolio="&nfolio &"&nro_ting_ccod="&tipo_doc&"&pers_ncorr="&pers_ncorr&"&total="&total&"&peri_ccod="&Periodo)
		elseif valor21="50" then
		    response.redirect("proc_genera_impfactura_afecta.asp?nfolio="&nfolio &"&nro_ting_ccod="&tipo_doc&"&pers_ncorr="&pers_ncorr&"&total="&total&"&peri_ccod="&Periodo)	
		end if
							'response.Write("<pre>"&archivo&"</pre>")
		
							'Set oFile      = CreateObject("Scripting.FileSystemObject")		
							'Set oPrinter   = oFile.CreateTextFile(ruta)
							'oPrinter.write(archivo)
		'Set oFile      = Nothing
		'Set oPrinter   = Nothing
		
		'Hasta acá lo comente pero lo que esta corrido de margen considerablemente eso ya estava comentado
		'------------- hasta aki 
    'else 
	   
     	'Response.Redirect("http://192.168.2.186/REPORTESNET/comp_cajas.aspx?nfolio=" & nfolio &"&nro_ting_ccod="&tipo_doc&"&pers_ncorr="&pers_ncorr&"&total="&total)
	     'Response.Write("http://192.168.2.186/REPORTESNET/comp_cajas.aspx?nfolio=" & nfolio &"&nro_ting_ccod="&tipo_doc&"&pers_ncorr="&pers_ncorr&"&total="&total)

	end if 'fin imprimir comprobante de ingreso	
	
	'conectar.estadotransaccion false

	
	'set abono = Nothing
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
	set d_abono = Nothing

'response.End()
		
%>
	<script language="JavaScript" type="text/javascript">
	 //alert ('/REPORTESNET/comp_cajas.aspx?nfolio='+  <%=nfolio %> + '&nro_ting_ccod='+<%=tipo_doc%>+'&pers_ncorr='+<%=pers_ncorr%>+'&total='+<%=total%>+'&peri_ccod='+<%=Periodo%>);
	   //self.opener.location.reload();
		<% if imprimir=2 then %>
		   //self.location.href = '/REPORTESNET/comp_cajas.aspx?nfolio='+  <%=nfolio %> + '&nro_ting_ccod='+<%=tipo_doc%>+'&pers_ncorr='+<%=pers_ncorr%>+'&total='+<%=total%>+'&peri_ccod='+<%=Periodo%>;	
			//self.location.href= "http://192.168.2.186/REPORTESNET/comp_cajas.aspx?nfolio="+  <%=nfolio %>"&nro_ting_ccod="+<%=tipo_doc%>+"&pers_ncorr="+<%=pers_ncorr%>+"&total="+<%=total%>;
		<% else %>
		  <% if imprimir=3 then %>
		   self.location.href = 'comp_ingreso.asp?nfolio='+  <%=nfolio %> + '&nro_ting_ccod='+<%=tipo_doc%>+'&pers_ncorr='+<%=pers_ncorr%>+'&total='+<%=total%>+'&peri_ccod='+<%=Periodo%>;	
		  <%else %>
				self.close();
		  <% end if%>
		<% end if%>
		
		//<% if imprimir=1 then %>
		//'self.close();
		//'<% end if%>
	</script> 