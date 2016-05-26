<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x))
'next
'Response.End()

v_registros_rebaje		=	request.Form("cc_compromisos_rebaje[0][tcom_ccod]")
v_registros_devolver	=	request.Form("cc_compromisos_devuelve[0][tcom_ccod]")

q_ting_ccod		=	request.Form("ting_ccod[-1][ting_ccod]")
q_pers_ncorr	=	request.Form("pers_ncorr")
q_nota_credito	=	request.Form("nota_credito")
q_monto_pago		=	request.Form("monto_pago")
q_monto_devolucion	=	request.Form("monto_devolucion")
q_institucion		=	request.Form("institucion")


uso_nota1	=	request.Form("uso_nota1")  
uso_nota2	=	request.Form("uso_nota2") 
uso_nota3	=	request.Form("uso_nota3") 

'response.Write("<pre>"&v_registros_rebaje&"</pre>")
'response.Write("<pre>"&v_registros_devolver&"</pre>")


'Response.End()


set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set cajero = new CCajero
cajero.Inicializar conexion, negocio.ObtenerUsuario, negocio.ObtenerSede

caja_abierta = cajero.obtenerCajaAbierta
usuario = negocio.ObtenerUsuario()
Sede = negocio.ObtenerSede()
periodo = negocio.obtenerPeriodoAcademico("CLASES18")

nuevo_folio_referencia = conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")

'###################################################################
'#################### crear nota de credito	########################
'###################################################################

	v_ndcr_ncorr 	= conexion.consultauno("exec ObtenerSecuencia 'notas_credito'")
	
	SQL_INSERTA_NC= 	" Insert into notas_de_credito (ndcr_ncorr,ndcr_nnota_credito,encr_ccod,ndcr_fnota_credito,pers_ncorr, "& vbcrlf &_
							"INGR_NFOLIO_REFERENCIA, pers_ncorr_aval,mcaj_ncorr,audi_fmodificacion,audi_tusuario, sede_ccod, inst_ccod) " & vbcrlf &_
							" Values("&v_ndcr_ncorr&","&q_nota_credito&",1,getdate(),"&q_pers_ncorr&","& vbcrlf &_
							" "&nuevo_folio_referencia&","&q_pers_ncorr&","&caja_abierta&",getdate(),'"&usuario&"',"&sede&","&q_institucion&") "
'response.Write("<pre>"&"SQL_INSERTA_NC"&SQL_INSERTA_NC&"</pre>")
	conexion.EstadoTransaccion conexion.EjecutaS(SQL_INSERTA_NC)



'########################################################################################
          	sql_rango="  select rncc_ncorr "& vbcrlf &_
						"	from rangos_notas_credito_cajeros a, personas b "& vbcrlf &_
						"	where a.pers_ncorr=b.pers_ncorr "& vbcrlf &_
						"		and b.pers_nrut="&usuario&" "& vbcrlf &_
						"		and sede_ccod="&sede&" "& vbcrlf &_
						"		and inst_ccod="&q_institucion&" "& vbcrlf &_
						"		and ernc_ccod=1 "

			v_rncc_ncorr 	= conexion.consultauno(sql_rango)

          	sql_rango_fin="  select rncc_nfin "& vbcrlf &_
							"	from rangos_notas_credito_cajeros a, personas b "& vbcrlf &_
							"	where a.pers_ncorr=b.pers_ncorr "& vbcrlf &_
							"		and b.pers_nrut="&usuario&" "& vbcrlf &_
							"		and sede_ccod="&sede&" "& vbcrlf &_
							"		and inst_ccod="&q_institucion&" "& vbcrlf &_
							"		and ernc_ccod=1 "
						
			v_rncc_nfin 	= conexion.consultauno(sql_rango_fin)
		
		if EsVacio(v_rncc_nfin) or v_rncc_nfin="" then
			v_rncc_nfin=0
		end if
		
		if Cint(v_ndcr_nfactura)=Cint(v_rncc_nfin) then
			v_estado_rango=2
		else
			v_estado_rango=1
		end if
	
		nota_credito_actual=q_nota_credito+1
        'actualiza el correlativo de la Factura y cambia estado al rango si es necesario
        sql_actualiza_nc=" update rangos_notas_credito_cajeros set rncc_nactual="&nota_credito_actual&", ernc_ccod="&v_estado_rango&" where cast(rncc_ncorr as varchar)='"&v_rncc_ncorr&"'"
		conexion.EjecutaS(sql_actualiza_nc)
		
		if v_estado_rango=2 then
		' si llego a la ultima nota de credito se actualiza el rango en espera como activo
					sql_update_rango_espera= " update  rangos_notas_credito_cajeros set  ernc_ccod=1  "& vbcrlf &_
											 " where pers_ncorr=(select top 1 pers_ncorr from personas where pers_nrut="&usuario&") "& vbcrlf &_
											 " and sede_ccod="&sede&" "& vbcrlf &_
											 " and inst_ccod="&q_institucion&" "& vbcrlf &_
											 " and ernc_ccod=4  "
					'response.Write("<pre>"&"sql_update_rango_espera"&sql_update_rango_espera&"</pre>") 
					conexion.EjecutaS(sql_update_rango_espera)
		end if
'########################################################################################



'--------------------------------------------------------------------------------------------------------------
set f_compromisos_rebaje = new CFormulario
f_compromisos_rebaje.Carga_Parametros "notas_credito.xml", "compromisos_por_rebajar"
f_compromisos_rebaje.Inicializar conexion
f_compromisos_rebaje.ProcesaForm
'v_registros_rebaje=f_compromisos_rebaje.CuentaPost

total_abono=0


if v_registros_rebaje> 0 then
	for fila = 0 to f_compromisos_rebaje.CuentaPost - 1
		v_comp_ndocto		= f_compromisos_rebaje.ObtenerValorPost (fila, "comp_ndocto")
		v_tcom_ccod			= f_compromisos_rebaje.ObtenerValorPost (fila, "tcom_ccod")
		v_inst_ccod			= f_compromisos_rebaje.ObtenerValorPost (fila, "inst_ccod")
		v_dcom_ncompromiso	= f_compromisos_rebaje.ObtenerValorPost (fila, "dcom_ncompromiso")
		v_rebaje			= f_compromisos_rebaje.ObtenerValorPost (fila, "rebaje")
 
		total_abono = Clng(total_abono) + Clng(v_rebaje)
		'response.Write("<BR><BR><PRE>" &"total_abono=    "& total_abono & "</PRE><BR>")
			nuevo_ingr_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
	      	ding_nsecuencia  = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
			
		   	sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,  audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
							 "(SELECT " & nuevo_ingr_ncorr & ",'" & caja_abierta & "' ,1 , getdate() ,'" & v_rebaje& "','" & v_rebaje & "','1',"&nuevo_folio_referencia&", 37, '"&v_inst_ccod&"','"&q_pers_ncorr&"','" & usuario & "', getdate())"& vbCrLf
			'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR>")
			conexion.EstadoTransaccion conexion.EjecutaS(sql)	
								
					
		   	sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr, peri_ccod, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
				      "(SELECT " & nuevo_ingr_ncorr & ",'"&v_tcom_ccod&"','"&v_inst_ccod&"','"&v_comp_ndocto&"','"&v_dcom_ncompromiso&"', getdate() ,'"&v_rebaje&"','" &q_pers_ncorr& "','"&periodo& "','"&usuario&"', getdate())"& vbCrLf
			conexion.EstadoTransaccion conexion.EjecutaS(sql)
			'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR>")	

            sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
							   "(SELECT " & nuevo_ingr_ncorr & ", "&q_ting_ccod&", '"&q_nota_credito&"', "&ding_nsecuencia&",'1', getdate() ,'"&v_rebaje&"','"&v_rebaje&"','" & usuario & "', getdate())"& vbCrLf
			conexion.EstadoTransaccion conexion.EjecutaS(sql) 
			'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR>")	
			
			sql_inserta_detalle_nc="insert into detalle_notas_de_credito (ndcr_ncorr,comp_ndocto,tcom_ccod,inst_ccod,dcom_ncompromiso, " & vbcrlf &_
								" dncr_mdetalle,audi_tusuario,audi_fmodificacion) "& vbcrlf &_
								" values ("&v_ndcr_ncorr&","&v_comp_ndocto&","&v_tcom_ccod&","&v_inst_ccod&","&v_dcom_ncompromiso&","& vbcrlf &_
								" "&v_rebaje&",'"&usuario&"',getdate()) "
			'response.Write("<pre>"&sql_inserta_detalle_nc&"</pre>")
			conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_detalle_nc)
		'response.Write("<br> Estado detalle : "&conexion.obtenerEstadoTransaccion&"<hr>")			
			'sql_actualiza_doc="Update detalle_ingresos set edin_ccod=6, audi_tusuario='"&v_usuario&"-paga oc', audi_fmodificacion=getdate() where cast(ingr_ncorr as varchar)='"&v_ingreso&"' " 
			'response.Write("<pre>"&sql_actualiza_doc&"</pre>")
			conexion.EstadoTransaccion conexion.EjecutaS(sql_actualiza_doc)			
	next

end if
'response.Write("<br> Estado Rebajar : "&conexion.obtenerEstadoTransaccion&"<hr>")


'#########################################################################################
'######################			DEVOLUCION		##########################################
'#########################################################################################

set f_compromisos_devolver = new CFormulario
f_compromisos_devolver.Carga_Parametros "notas_credito.xml", "compromisos_por_devolver"
f_compromisos_devolver.Inicializar conexion
f_compromisos_devolver.ProcesaForm
'v_registros_devolver=f_compromisos_devolver.Nrofilas


total_devolucion=0

if v_registros_devolver> 0 then
	for fila = 0 to f_compromisos_devolver.CuentaPost - 1
		v_comp_ndocto		= f_compromisos_devolver.ObtenerValorPost (fila, "comp_ndocto")
		v_tcom_ccod			= f_compromisos_devolver.ObtenerValorPost (fila, "tcom_ccod")
		v_inst_ccod			= f_compromisos_devolver.ObtenerValorPost (fila, "inst_ccod")
		v_dcom_ncompromiso	= f_compromisos_devolver.ObtenerValorPost (fila, "dcom_ncompromiso")
		v_devuelve			= f_compromisos_devolver.ObtenerValorPost (fila, "devuelve")


		'monto_compromiso = conexion.ConsultaUno("select cast(isnull(dcom_mcompromiso,0) as numeric) from detalle_compromisos where tcom_ccod="&v_tcom_ccod&" and inst_ccod="&v_inst_ccod&" and comp_ndocto="&v_comp_ndocto&" and dcom_ncompromiso="&v_dcom_ncompromiso&" ")
		'response.Write("<pre>"&monto_compromiso&"</pre>")
		total_devolucion = Clng(total_devolucion) + Clng(v_devuelve)

		sql_inserta_detalle_nc="insert into detalle_notas_de_credito (ndcr_ncorr,comp_ndocto,tcom_ccod,inst_ccod,dcom_ncompromiso, " & vbcrlf &_
								" dncr_mdetalle,audi_tusuario,audi_fmodificacion) "& vbcrlf &_
								" values ("&v_ndcr_ncorr&","&v_comp_ndocto&","&v_tcom_ccod&","&v_inst_ccod&","&v_dcom_ncompromiso&","& vbcrlf &_
								" "&v_devuelve&",'"&usuario&"',getdate()) "
	'response.Write("<pre>"&sql_inserta_detalle_nc&"</pre>")
		conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_detalle_nc)

'response.Write("<br> Estado devoluciones : "&conexion.obtenerEstadoTransaccion)		

	next
'response.Write("<br> Estado Transaccion 4: "&conexion.obtenerEstadoTransaccion)

	if (total_devolucion>0) then
		secuencia 		= conexion.consultauno("exec ObtenerSecuencia 'compromisos'")
		tipo_compromiso = 36
		periodo = negocio.ObtenerPeriodoAcademico("POSTULACION")
		
		sql_compromiso_interes = " INSERT INTO compromisos (tcom_ccod, ecom_ccod, inst_ccod, comp_ndocto,  pers_ncorr, comp_fdocto, "&_ 
												 "comp_ncuotas, comp_mneto, comp_mdescuento, comp_mintereses, comp_miva, "&_ 
												 "comp_mexento, comp_mdocumento, sede_ccod, audi_tusuario, audi_fmodificacion) "&_ 
								 " VALUES (" & tipo_compromiso & ",1,1," & secuencia & "," & q_pers_ncorr & ",getdate(),"&_
										   "1," & total_devolucion & ",null,null,null,"&_ 
										   "null," & total_devolucion & "," & Sede & ",'" & Usuario & "',getdate())" 
		'response.Write("<BR><BR><PRE>" & sql_compromiso_interes & "</PRE><BR>")
		sql_detalles_compromiso_interes = " INSERT INTO detalle_compromisos (tcom_ccod,inst_ccod,comp_ndocto,dcom_ncompromiso,dcom_fcompromiso,dcom_mneto,"&_ 
													"dcom_mintereses,dcom_mcompromiso,ecom_ccod,pers_ncorr,peri_ccod,audi_tusuario,audi_fmodificacion) "&_ 
										  " VALUES (" & tipo_compromiso & ",'1'," & secuencia & ",'1',getdate()," & total_devolucion & ","&_
													 "null," & total_devolucion & ",'1'," & q_pers_ncorr & "," & periodo & ",'" & Usuario & "',getdate())"
	
	'response.Write("<BR><BR><PRE>" & sql_detalles_compromiso_interes & "</PRE><BR>")
		sql_detalles_interes =  " INSERT INTO detalles (tcom_ccod,inst_ccod,comp_ndocto,tdet_ccod,deta_ncantidad,deta_mvalor_unitario,"&_ 
								" deta_mvalor_detalle,deta_msubtotal,audi_tusuario, audi_fmodificacion )"&_
								" VALUES (" & tipo_compromiso & ",1," & secuencia & ",1284,1,"&total_devolucion&","&_
								" "&total_devolucion&", "&total_devolucion&",'" & Usuario & "',getdate())"
'response.Write("<BR><BR><PRE>" & sql_detalles_interes & "</PRE><BR>")								

		conexion.EstadoTransaccion conexion.EjecutaS(sql_compromiso_interes)
	'response.Write("<br> Estado Transaccion 2: "&conexion.obtenerEstadoTransaccion)
		conexion.EstadoTransaccion conexion.EjecutaS(sql_detalles_compromiso_interes)
	'response.Write("<br> Estado Transaccion 3: "&conexion.obtenerEstadoTransaccion)
		conexion.EstadoTransaccion conexion.EjecutaS(sql_detalles_interes)
	'response.Write("<br> Estado Transaccion 4: "&conexion.obtenerEstadoTransaccion)

'response.Write("<br> Estado Transaccion 3: "&conexion.obtenerEstadoTransaccion)

		nuevo_ingr_ncorr2 = conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
      	ding_nsecuencia2  = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
		
		sql2 = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,  audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
						 "(SELECT " & nuevo_ingr_ncorr2 & ",'" & caja_abierta & "' ,4 , getdate() ,'" & total_devolucion& "','" & total_devolucion & "','1',"&nuevo_folio_referencia&", 37, '"&v_inst_ccod&"','"&q_pers_ncorr&"','" & usuario & "', getdate())"& vbCrLf
		conexion.EstadoTransaccion conexion.EjecutaS(sql2)	
		'response.Write("<BR><BR><PRE>" & sql2 & "</PRE><BR>")					
				
		sql2 = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr, peri_ccod, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
				  "(SELECT " & nuevo_ingr_ncorr2 & ",'"&tipo_compromiso&"',1,'"&secuencia&"','1', getdate() ,'"&total_devolucion&"','" &q_pers_ncorr& "','"&periodo& "','"&usuario&"', getdate())"& vbCrLf
		conexion.EstadoTransaccion conexion.EjecutaS(sql2)
		'response.Write("<BR><BR><PRE>" & sql2 & "</PRE><BR>")	
	
		sql2 = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, edin_ccod,ding_mdetalle, ding_mdocto,ding_bpacta_cuota, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
						   "(SELECT " & nuevo_ingr_ncorr2 & ", 36, '"&q_nota_credito&"', "&ding_nsecuencia2&",'1', getdate() ,'1','"&total_devolucion&"','"&total_devolucion&"','S','" & usuario & "', getdate())"& vbCrLf
		conexion.EstadoTransaccion conexion.EjecutaS(sql2) 
	'response.Write("<BR><BR><PRE>" & sql2 & "</PRE><BR>")		
	end if
end if

if total_abono ="" then
	total_abono=0
end if
if total_devolucion ="" then
	total_devolucion=0
end if

'response.Write("<br> Estado Transaccion 2: "&conexion.obtenerEstadoTransaccion)

'###############################################################################

total_ndcr=total_abono+total_devolucion

if q_institucion="3" then
	v_monto_neto=clng(total_ndcr*0.81)
	v_monto_iva=total_ndcr-v_monto_neto
	
	updatetotal = "update notas_de_credito set ndcr_mtotal="&v_monto_neto&", ndcr_miva="&v_monto_iva&" where ndcr_ncorr="&v_ndcr_ncorr&" "
	
	conexion.EstadoTransaccion conexion.EjecutaS(updatetotal)	
else
	updatetotal = "update notas_de_credito set ndcr_mtotal="&total_ndcr&" where ndcr_ncorr="&v_ndcr_ncorr&" "
	conexion.EstadoTransaccion conexion.EjecutaS(updatetotal)
end if
'response.Write(" Actualizacion: "&updatetotal)


if uso_nota1<>"" then
	sql_uso="Insert into detalle_uso_nota_credito (ndcr_ncorr,uncr_ccod,dunc_mmonto_asociado, audi_tusuario,audi_fmodificacion) values("&v_ndcr_ncorr&","&uso_nota1&","&q_monto_pago&",'"&usuario&"',getdate())"
	conexion.EstadoTransaccion conexion.EjecutaS(sql_uso)
end if
if uso_nota2<>"" then
	sql_uso2="Insert into detalle_uso_nota_credito (ndcr_ncorr,uncr_ccod,dunc_mmonto_asociado, audi_tusuario,audi_fmodificacion) values("&v_ndcr_ncorr&","&uso_nota2&","&q_monto_devolucion&",'"&usuario&"',getdate())"
	conexion.EstadoTransaccion conexion.EjecutaS(sql_uso2)
end if
if uso_nota3<>"" then
	sql_uso3="Insert into detalle_uso_nota_credito (ndcr_ncorr,uncr_ccod,dunc_mmonto_asociado, audi_tusuario,audi_fmodificacion) values("&v_ndcr_ncorr&","&uso_nota3&","&total_abono&",'"&usuario&"',getdate())"
	conexion.EstadoTransaccion conexion.EjecutaS(sql_uso3)
end if
'###############################################################################
'response.Write("<br> Estado Transaccion 1: "&conexion.obtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'response.End()

%>

<script language="JavaScript" type="text/javascript">

window.open("imprimir_nc.asp?nota_credito=<%=q_nota_credito%>&pers_ncorr=<%=q_pers_ncorr%>&ndcr_ncorr=<%=v_ndcr_ncorr%>","imprimir_nc","height=600,width=800,scrollbars=yes,toolbar=no,location=no");		
		  
</script> 


</body>
</html>
<%
'conexion.EstadoTransaccion false
'response.End()
'------------------------------------------------------------------------------------------------------------------
'Response.Redirect("notas_credito.asp")
%>