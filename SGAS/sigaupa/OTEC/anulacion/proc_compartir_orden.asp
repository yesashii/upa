<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

set cajero = new CCajero
cajero.inicializar conexion, negocio.obtenerUsuario, negocio.obtenerSede

sede_ccod	= negocio.obtenerSede
usuario 	= negocio.ObtenerUsuario()
v_mcaj_ncorr= cajero.obtenerCajaAbierta
v_periodo 	= negocio.ObtenerPeriodoAcademico("POSTULACION")
'---------------------------------------------------------------------




'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

' RESUMEN EJECUTIVO
'*[P01] Pagar la Orden de Compra contra el ingreso del curso
'*[P02] Generar la nueva deuda en Otic asociada al programa y con la nueva OC
'*[P03] Generar la deuda en la Empresa asociada al programa y con la nueva OC
'*[P04] Guardar los alumnos en las respectivas empresas
'*[P05] Guardar los datos de la nueva Orden de Compra en alguna tabla 


set formulario = new CFormulario
formulario.Carga_Parametros "anulacion_facturas.xml", "f_ordenes"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1
	v_ingr_ncorr		= formulario.ObtenerValorPost (fila, "ingr_ncorr")
	v_monto_oc			= formulario.ObtenerValorPost (fila, "monto_orden")
	v_pers_ncorr_otic	= formulario.ObtenerValorPost (fila, "pers_ncorr_otic")
	v_pers_ncorr_empre	= formulario.ObtenerValorPost (fila, "pers_ncorr_empresa")
	
	v_new_numero_orden	= formulario.ObtenerValorPost (fila, "new_numero_orden")
	v_new_monto_otic	= formulario.ObtenerValorPost (fila, "new_monto_otic")
	v_new_monto_empre	= formulario.ObtenerValorPost (fila, "new_monto_empre")



	if v_ingr_ncorr <> "" then
	
'*[P01]					
				'######## PAGAR COMPROMISO DE FACTURA ANTIGUA #########
					comp_ndocto_oc=conexion.consultaUno("select top 1 comp_ndocto from abonos where ingr_ncorr="&v_ingr_ncorr&" ")
					v_ting_ccod_anu=29
					folio_referencia 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
					nuevo_ingr_ncorr 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
					v_ding_nsecuencia 	= conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
					'response.Write("<br><b>Estado Conexion 3: </b> "&conexion.obtenerEstadoTransaccion)
					'Response.Write("<HR><br><b>PAGAR COMPROMISO ANTIGUO</b>")	
									
					sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,   audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
					"(SELECT " & nuevo_ingr_ncorr & ",'" & v_mcaj_ncorr & "' ,1 , getdate() ,'" &  v_monto_oc & "','" & v_monto_oc & "','1'," & folio_referencia  & ", 17, '1','" & v_pers_ncorr_otic & "','" & usuario & " -anula oc', getdate())"& vbCrLf
					conexion.EstadoTransaccion conexion.EjecutaS(sql)						
'					response.Write("<PRE>" & sql & "</PRE>")
					
					sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr,  audi_tusuario, audi_fmodificacion) "& vbCrLf &_
					"(SELECT " & nuevo_ingr_ncorr & ",'7',1,'" & comp_ndocto_oc  & "','1', getdate() ,'" &  v_monto_oc & "','" & v_pers_ncorr_otic & "','" & usuario & " -anula oc', getdate())"& vbCrLf
					conexion.EstadoTransaccion conexion.EjecutaS(sql)
'					response.Write("<PRE>" & sql & "</PRE>")		  
					
					ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
					sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
					"(SELECT " & nuevo_ingr_ncorr & ", "&v_ting_ccod_anu&", '" & v_ding_nsecuencia & "', "&v_ding_nsecuencia&",'1', getdate() ,'" &  v_monto_oc & "','" & v_monto_oc & "', '" & usuario & " -anula oc', getdate())"& vbCrLf
					conexion.EstadoTransaccion conexion.EjecutaS(sql)
'					response.Write("<PRE>" & sql & "</PRE>")
					
					
					sql_upate_det_ingr	=	"update detalle_ingresos set edin_ccod=6, audi_tusuario='"&usuario&" -anula oc', audi_fmodificacion=getdate() where ingr_ncorr="&v_ingr_ncorr&" and ting_ccod=5"
					conexion.EstadoTransaccion conexion.EjecutaS(sql_upate_det_ingr)
'					response.Write("<PRE>" & sql_upate_det_ingr & "</PRE>")
					
'					response.Write("<br><b>Estado Conexion 4: </b> "&conexion.obtenerEstadoTransaccion)

'RESPONSE.Write("<HR><b>CREAR COMPROMISO ORDEN COMPRA NUEVA PARA OTIC</b><HR>")

'###########################################################################################
'*[P02]	
				'## CREAR COMPROMISO ORDEN COMPRA NUEVA PARA OTIC
				if v_new_monto_otic>0 then ' Siempre que la Otic pague algo, se genera nueva deuda
				
					v_comp_ndocto_otic=conexion.consultauno("exec ObtenerSecuencia 'compromisos'")

					sql_tdet_ccod	=   " select c.tdet_ccod from abonos a, detalle_compromisos b, detalles c "& vbcrlf &_
										" where a.ingr_ncorr="&v_ingr_ncorr&" "& vbcrlf &_
										" and a.tcom_ccod=b.tcom_ccod and a.comp_ndocto=b.comp_ndocto "& vbcrlf &_
										" and b.comp_ndocto=c.comp_ndocto and c.tdet_ccod not in (909) "
					v_tdet_ccod		=	conexion.consultaUno(sql_tdet_ccod)

					'Response.Write("<HR><br><b>CREA COMPROMISO NUEVO</b>")
						
					sql_inserta_compromisos="insert into compromisos (tcom_ccod, inst_ccod, comp_ndocto, ecom_ccod, pers_ncorr, comp_fdocto, comp_ncuotas, "& vbcrlf &_
					" comp_mneto,comp_miva, comp_mdescuento, comp_mdocumento, audi_tusuario, audi_fmodificacion, sede_ccod) "& vbcrlf &_
					" Values (7, 1, "&v_comp_ndocto_otic&", 1, "&v_pers_ncorr_otic&", getdate(), 1, '"&v_new_monto_otic&"','"&v_new_monto_otic&"', 0, "&v_new_monto_otic&", '"&usuario&"-ingresa oc2',getdate(), "&sede_ccod&" ) "
'					response.Write("<pre>"&sql_inserta_compromisos&"</pre>")	
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_compromisos)	
					
					'response.Write("<br><b>Estado Conexion 1: </b> "&conexion.obtenerEstadoTransaccion)
					sql_inserta_detalle_compromiso="insert into detalle_compromisos (tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, dcom_fcompromiso, "& vbcrlf &_
					" dcom_mneto, dcom_mintereses, dcom_mcompromiso, ecom_ccod, pers_ncorr, peri_ccod, audi_tusuario, audi_fmodificacion) "& vbcrlf &_
					" Values (7, 1, "&v_comp_ndocto_otic&", 1, getdate(), '"&v_new_monto_otic&"', 0, "&v_new_monto_otic&", 1, "&v_pers_ncorr_otic&", "&v_periodo&", '"&usuario&"-ingresa oc2',getdate()) "
'					response.Write("<pre>"&sql_inserta_detalle_compromiso&"</pre>")	
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_detalle_compromiso)
					
					'response.Write("<br><b>Estado Conexion 2: </b> "&conexion.obtenerEstadoTransaccion)	
					sql_inserta_detalles="insert into detalles (tcom_ccod, inst_ccod, comp_ndocto, tdet_ccod, deta_ncantidad, deta_mvalor_unitario, "& vbcrlf &_
					" deta_mvalor_detalle, deta_msubtotal, audi_tusuario, audi_fmodificacion) "& vbcrlf &_
					" Values (7, 1, "&v_comp_ndocto_otic&", "&v_tdet_ccod&", 1, "&v_new_monto_otic&","&v_new_monto_otic&", "&v_new_monto_otic&", '"&usuario&"-ingresa oc2',getdate()) "
'					response.Write("<pre>"&sql_inserta_detalles&"</pre>")	
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_detalles)		

					
					' ********** 	Documentar el compromiso 	************	
					v_folio_ref_oc 			= 	conexion.consultauno("exec ObtenerSecuencia 'ingresos_referencia'")
					v_ingr_ncorr_oc 		= 	conexion.consultauno("exec ObtenerSecuencia 'ingresos'")
					v_ding_nsecuencia_oc 	= 	conexion.consultauno("exec ObtenerSecuencia 'detalle_ingresos'")
					v_ting_ccod=5
					
					'response.Write("<br><b>Estado Conexion 2: </b> "&conexion.obtenerEstadoTransaccion)
'					Response.Write("<br><b>DOCUMENTAR COMPROMISO NUEVO OTIC</b>")
											
					sql_inserta_ingreso_oc=" insert into ingresos (ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mefectivo, ingr_mdocto,ingr_mtotal, "& vbcrlf &_
					"  ingr_nfolio_referencia, ting_ccod, audi_tusuario, audi_fmodificacion, inst_ccod, pers_ncorr, tmov_ccod) "& vbcrlf &_
					" values ("&v_ingr_ncorr_oc&", "&v_mcaj_ncorr&", 4, getdate(), 0, "&v_new_monto_otic&", "&v_new_monto_otic&", "&v_folio_ref_oc&", 33, '"&usuario&"', getdate(),1 , "&v_pers_ncorr_otic&", 1) "
'					response.Write("<pre>"&sql_inserta_ingreso_oc&"</pre>")
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_ingreso_oc)				
					
					
					sql_inserta_abono_oc=	" insert into abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, "& vbcrlf &_
					" abon_mabono, audi_tusuario, audi_fmodificacion, pers_ncorr, peri_ccod) "& vbcrlf &_
					" values ("&v_ingr_ncorr_oc&", 7, 1, "&v_comp_ndocto_otic&", 1, getdate(), "&v_new_monto_otic&", '"&usuario&"', getdate(), "&v_pers_ncorr_otic&", "&v_periodo&") "
'					response.Write("<pre>"&sql_inserta_abono_oc&"</pre>")
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_abono_oc)				
					
					
					sql_inserta_detalle_oc="insert into detalle_ingresos (ting_ccod,ding_ndocto,ingr_ncorr,ding_nsecuencia,ding_ncorrelativo,ding_fdocto,"& vbcrlf &_
					" edin_ccod,ding_mdetalle,ding_mdocto,ding_bpacta_cuota,audi_tusuario,audi_fmodificacion) "& vbcrlf &_
					" values ("&v_ting_ccod&","&v_new_numero_orden&","&v_ingr_ncorr_oc&","&v_ding_nsecuencia_oc&",1,getdate(), 1, "&v_new_monto_otic&","&v_new_monto_otic&",'S','"&usuario&"',getdate()) "
'					response.Write("<pre>"&sql_inserta_detalle_oc&"</pre>")
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_detalle_oc)					

'					response.Write("<br><b>Estado Conexion 4: </b> "&conexion.obtenerEstadoTransaccion)

				end if ' Fin validacion de monto Cero para la Otic
'###########################################################################################
'*[P03]	
				'## CREAR COMPROMISO ORDEN COMPRA NUEVA PARA EMPRESA

'RESPONSE.Write("<HR><b>CREAR COMPROMISO ORDEN COMPRA NUEVA PARA EMPRESA</b><HR>")
				
					v_comp_ndocto_empre=conexion.consultauno("exec ObtenerSecuencia 'compromisos'")
				
					sql_inserta_compromisos="insert into compromisos (tcom_ccod, inst_ccod, comp_ndocto, ecom_ccod, pers_ncorr, comp_fdocto, comp_ncuotas, "& vbcrlf &_
					" comp_mneto,comp_miva, comp_mdescuento, comp_mdocumento, audi_tusuario, audi_fmodificacion, sede_ccod) "& vbcrlf &_
					" Values (7, 1, "&v_comp_ndocto_empre&", 1, "&v_pers_ncorr_empre&", getdate(), 1, '"&v_new_monto_empre&"','"&v_new_monto_empre&"', 0, "&v_new_monto_empre&", '"&usuario&"-ingresa oc2',getdate(), "&sede_ccod&" ) "
'					response.Write("<pre>"&sql_inserta_compromisos&"</pre>")	
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_compromisos)	
					
					'response.Write("<br><b>Estado Conexion 1: </b> "&conexion.obtenerEstadoTransaccion)
					sql_inserta_detalle_compromiso="insert into detalle_compromisos (tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, dcom_fcompromiso, "& vbcrlf &_
					" dcom_mneto, dcom_mintereses, dcom_mcompromiso, ecom_ccod, pers_ncorr, peri_ccod, audi_tusuario, audi_fmodificacion) "& vbcrlf &_
					" Values (7, 1, "&v_comp_ndocto_empre&", 1, getdate(), '"&v_new_monto_empre&"', 0, "&v_new_monto_empre&", 1, "&v_pers_ncorr_empre&", "&v_periodo&", '"&usuario&"-ingresa oc2',getdate()) "
'					response.Write("<pre>"&sql_inserta_detalle_compromiso&"</pre>")	
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_detalle_compromiso)
					
					'response.Write("<br><b>Estado Conexion 2: </b> "&conexion.obtenerEstadoTransaccion)	
					sql_inserta_detalles="insert into detalles (tcom_ccod, inst_ccod, comp_ndocto, tdet_ccod, deta_ncantidad, deta_mvalor_unitario, "& vbcrlf &_
					" deta_mvalor_detalle, deta_msubtotal, audi_tusuario, audi_fmodificacion) "& vbcrlf &_
					" Values (7, 1, "&v_comp_ndocto_empre&", "&v_tdet_ccod&", 1, "&v_new_monto_empre&","&v_new_monto_empre&", "&v_new_monto_empre&", '"&usuario&"-ingresa oc2',getdate()) "
'					response.Write("<pre>"&sql_inserta_detalles&"</pre>")	
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_detalles)		

					
					' ********** 	Documentar el compromiso 	************	
					v_folio_ref_oc2 		= 	conexion.consultauno("exec ObtenerSecuencia 'ingresos_referencia'")
					v_ingr_ncorr_oc2 		= 	conexion.consultauno("exec ObtenerSecuencia 'ingresos'")
					v_ding_nsecuencia_oc2 	= 	conexion.consultauno("exec ObtenerSecuencia 'detalle_ingresos'")
					v_ting_ccod=5
					
					'response.Write("<br><b>Estado Conexion 2: </b> "&conexion.obtenerEstadoTransaccion)
'					Response.Write("<br><b>DOCUMENTAR COMPROMISO NUEVO EMPRESA</b>")
											
					sql_inserta_ingreso_oc2=" insert into ingresos (ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mefectivo, ingr_mdocto,ingr_mtotal, "& vbcrlf &_
					"  ingr_nfolio_referencia, ting_ccod, audi_tusuario, audi_fmodificacion, inst_ccod, pers_ncorr, tmov_ccod) "& vbcrlf &_
					" values ("&v_ingr_ncorr_oc2&", "&v_mcaj_ncorr&", 4, getdate(), 0, "&v_new_monto_empre&", "&v_new_monto_empre&", "&v_folio_ref_oc2&", 33, '"&usuario&"', getdate(),1 , "&v_pers_ncorr_empre&", 1) "
'					response.Write("<pre>"&sql_inserta_ingreso_oc2&"</pre>")
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_ingreso_oc2)				
					
					
					sql_inserta_abono_oc2=	" insert into abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, "& vbcrlf &_
					" abon_mabono, audi_tusuario, audi_fmodificacion, pers_ncorr, peri_ccod) "& vbcrlf &_
					" values ("&v_ingr_ncorr_oc2&", 7, 1, "&v_comp_ndocto_empre&", 1, getdate(), "&v_new_monto_empre&", '"&usuario&"', getdate(), "&v_pers_ncorr_empre&", "&v_periodo&") "
'					response.Write("<pre>"&sql_inserta_abono_oc2&"</pre>")
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_abono_oc2)				
					
					
					sql_inserta_detalle_oc2="insert into detalle_ingresos (ting_ccod,ding_ndocto,ingr_ncorr,ding_nsecuencia,ding_ncorrelativo,ding_fdocto,"& vbcrlf &_
					" edin_ccod,ding_mdetalle,ding_mdocto,ding_bpacta_cuota,audi_tusuario,audi_fmodificacion) "& vbcrlf &_
					" values ("&v_ting_ccod&","&v_new_numero_orden&","&v_ingr_ncorr_oc2&","&v_ding_nsecuencia_oc2&",1,getdate(), 1, "&v_new_monto_empre&","&v_new_monto_empre&",'S','"&usuario&"',getdate()) "
'					response.Write("<pre>"&sql_inserta_detalle_oc2&"</pre>")
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_detalle_oc2)					

'					response.Write("<br><b>Estado Conexion 5: </b> "&conexion.obtenerEstadoTransaccion)

'###########################################################################################

'conexion.EstadoTransaccion false				
'response.End()	
				
	end if' fin si no hay ingr_ncorr

next


set f_alumnos = new CFormulario
f_alumnos.Carga_Parametros "anulacion_facturas.xml", "f_alumnos"
f_alumnos.Inicializar conexion
f_alumnos.ProcesaForm	

'*[P04]	
				'## INGRESAR LOS ALUMNOS EN LAS RESPECTIVAS EMPRESAS
for fila = 0 to f_alumnos.CuentaPost - 1

	v_pote_ncorr	= f_alumnos.ObtenerValorPost (fila, "pote_ncorr")
	v_empresa		= f_alumnos.ObtenerValorPost (fila, "empresa")
	'response.Write("<br>"&v_pote_ncorr)
	if v_pote_ncorr <> "" then
		if v_empresa="2" then
			sql_orden_alumno= " Insert into postulantes_cargos_otec (pote_ncorr,comp_ndocto,pers_ncorr_institucion,tipo_institucion) "& vbcrlf &_
						  	  "	values("&v_pote_ncorr&",'"&v_comp_ndocto_empre&"','"&v_pers_ncorr_empre&"',2) "
		else
			sql_orden_alumno= " Insert into postulantes_cargos_otec (pote_ncorr,comp_ndocto,pers_ncorr_institucion,tipo_institucion) "& vbcrlf &_
						  	  "	values("&v_pote_ncorr&",'"&v_comp_ndocto_otic&"','"&v_pers_ncorr_otic&"',3) "
		end if		
		conexion.EstadoTransaccion conexion.EjecutaS(sql_orden_alumno)	

'		response.Write("<br> sql_orden_alumno :"&sql_orden_alumno)						  
	end if
next

'response.Write("<br><b>Estado Conexion 6: </b> "&conexion.obtenerEstadoTransaccion)

'conexion.EstadoTransaccion false
'response.End()
'*****************************************************************************
'###########################################################################################



if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="La Orden de compra selecionada fue distribuida correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar anular la Orden de compra seleccionada.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect("anular_x_compartido.asp")
%>