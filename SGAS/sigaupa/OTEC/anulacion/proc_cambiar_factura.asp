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
v_tfac_ccod=2

pers_corr_caj=conexion.consultaUno("select pers_ncorr from personas where pers_nrut ="&usuario&" ")	

no_print 	= Request.Form("no_print")
if no_print="" then
	no_print=0
end if

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next

'response.End()

set formulario = new CFormulario
formulario.Carga_Parametros "anulacion_facturas.xml", "f_facturas"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1
	v_fact_ncorr		= formulario.ObtenerValorPost (fila, "fact_ncorr")
	v_monto_fact		= formulario.ObtenerValorPost (fila, "monto")
	v_pers_ncorr		= formulario.ObtenerValorPost (fila, "pers_ncorr")
	v_num_factura		= formulario.ObtenerValorPost (fila, "num_factura")
	v_ting_ccod_anu		= formulario.ObtenerValorPost (fila, "ting_ccod")


	if v_fact_ncorr <> "" then
	
			v_folio_fact	=	conexion.consultaUno("select ingr_nfolio_referencia from facturas where fact_ncorr="&v_fact_ncorr)
			sql_comp_ndocto	=	"select top 1 b.comp_ndocto from ingresos a, abonos b "& vbCrLf &_ 
								"where a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_ 
								"and a.ingr_nfolio_referencia="&v_folio_fact
			comp_ndocto_fact=	conexion.consultaUno(sql_comp_ndocto)
		
			v_tdet_ccod=conexion.consultaUno("select tdet_ccod from detalles where comp_ndocto='"&comp_ndocto_fact&"' and tcom_ccod=9 and deta_ncantidad>0")

		'response.Write("select inst_ccod from rangos_facturas_cajeros rfc where rfc.tfac_ccod="&v_tfac_ccod&" and rfc.sede_ccod="&sede_ccod&" and rfc.pers_ncorr="&pers_corr_caj&" and  "&v_fact_nfactura&" between rfca_ninicio and rfca_nfin")

		'v_inst_ccod=conexion.consultaUno("select inst_ccod from rangos_facturas_cajeros rfc where rfc.tfac_ccod="&v_tfac_ccod&" and rfc.sede_ccod="&sede_ccod&" and rfc.pers_ncorr="&pers_corr_caj&" and  "&v_num_factura&" between rfca_ninicio and rfca_nfin")
		v_inst_ccod=1
		if(v_inst_ccod<>"") then
			


		if no_print=0 then ' If que controla si genera o no una nueva factura inmediatamente anulada la anterior
				'********************************************************************************************			
				'  Obtiene el numero de la nueva factura, para asignarla al nuevo registro
				sql_nuevo_numero="  select isnull(rfca_nactual,rfca_ninicio) as num "& vbCrLf &_ 
								" from rangos_facturas_cajeros "& vbCrLf &_ 
								" where pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut='"&usuario&"') "& vbCrLf &_ 
								" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_ 
								" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
								" and inst_ccod="&v_inst_ccod&" "& vbCrLf &_ 
								" and erfa_ccod=1"

'response.Write("<hr>"&sql_nuevo_numero&"<hr>")	
'response.End()			
				v_nuevo_numero=conexion.ConsultaUno(sql_nuevo_numero)

				if Esvacio(v_nuevo_numero) then
					session("mensajeError")="No se puede anular el documento seleccionado (Factura).\nNo presenta rangos de facturas asociados a su Caja."
					response.Redirect(Request.ServerVariables("HTTP_REFERER"))
					'v_nuevo_numero=99999
				end if

				sql_factura_existe=	"select count(fact_nfactura) from facturas where sede_ccod="&sede_ccod&" and tfac_ccod="&v_tfac_ccod&" and fact_nfactura="&v_nuevo_numero&" And fact_ncorr <> "&v_fact_ncorr&" "
				v_factura_existe=conexion.consultaUno(sql_factura_existe)
				'response.Write("<hr>"&sql_factura_existe&"<hr>")	
				
				if v_factura_existe >="1" then
						conexion.EstadoTransaccion false
						session("mensajeError")="el numero ingresado para la factura ya existe"
						response.Redirect(Request.ServerVariables("HTTP_REFERER"))
				end if
	
				v_nuevo_fact_ncorr = conexion.ConsultaUno("execute obtenersecuencia 'facturas'")  
				'response.Write("<br><b>Estado Conexion 0: </b> "&conexion.obtenerEstadoTransaccion)

				'********************************************************************************************			
				'  Inserta nuevo registro para una factura

				sql_inserta_factura= "Insert into facturas  "& vbCrLf &_ 
						"(fact_ncorr,fact_nfactura,efac_ccod,tfac_ccod,fact_ffactura, fact_mtotal,fact_miva,fact_mneto,ingr_nfolio_referencia, "& vbCrLf &_ 
						" folio_abono_factura, pers_ncorr_alumno, empr_ncorr,mcaj_ncorr, audi_fmodificacion,audi_tusuario,sede_ccod)"& vbCrLf &_ 
						"(select  "&v_nuevo_fact_ncorr&" as fact_ncorr,"&v_nuevo_numero&" as fact_nboleta,efac_ccod,tfac_ccod,fact_ffactura, "& vbCrLf &_ 
						"fact_mtotal,fact_miva,fact_mneto,ingr_nfolio_referencia,folio_abono_factura, pers_ncorr_alumno, empr_ncorr,"&v_mcaj_ncorr&" as mcaj_ncorr,"& vbCrLf &_ 
						"audi_fmodificacion,audi_tusuario,sede_ccod from facturas where fact_ncorr="&v_fact_ncorr&")"
				'response.Write("<hr>"&sql_inserta_factura&"<hr>")						
				conexion.EjecutaS(sql_inserta_factura)

				' Inserta detalle
				sql_inserta_detalle_factura= "Insert into detalle_factura  "& vbCrLf &_ 
											"select  "&v_nuevo_fact_ncorr&" as fact_ncorr,comp_ndocto,tcom_ccod,inst_ccod,dcom_ncompromiso,dfac_mdetalle,"& vbCrLf &_ 
											"audi_tusuario,audi_fmodificacion from detalle_factura where fact_ncorr="&v_fact_ncorr
				conexion.EjecutaS(sql_inserta_detalle_factura)
				
				sql_actualiza_cargos= "update postulantes_cargos_factura set fact_ncorr="&v_nuevo_fact_ncorr&" where fact_ncorr="&v_fact_ncorr
				conexion.EjecutaS(sql_actualiza_cargos)

				'Response.Write("<br> Transaccion 3:"&conexion.ObtenerEstadoTransaccion)	
				'********************************************************************************************
				if v_nuevo_numero<>"null"  then
					' Actualiza el numero de boleta
					v_fact_siguiente=Clng(v_nuevo_numero) + 1
					sql_actualiza_numero=" Update rangos_facturas_cajeros set rfca_nactual="&v_fact_siguiente&"  "& vbCrLf &_ 
											" where pers_ncorr in (select top 1 pers_ncorr from personas where pers_nrut='"&usuario&"') "& vbCrLf &_ 
											" and tfac_ccod="&v_tfac_ccod&" "& vbCrLf &_ 
											" and sede_ccod="&sede_ccod&" "& vbCrLf &_ 
											" and inst_ccod="&v_inst_ccod&" "& vbCrLf &_ 
											" and erfa_ccod=1"
					'response.Write("<pre>"&sql_actualiza_numero&"</pre>")											
					conexion.EjecutaS(sql_actualiza_numero)
				end if			
					
				'********************************************************************************************
				
				'## CREAR COMPROMISO FACTURA NUEVA
					v_comp_ndocto=conexion.consultauno("exec ObtenerSecuencia 'compromisos'")
	
					if v_tfac_ccod=1 then
						v_monto_neto=clng(v_monto_fact*0.81)
						v_monto_iva=v_monto_fact-v_monto_neto
						v_ting_ccod=50
					else
						v_monto_neto=v_monto_fact
						v_monto_iva=0
						v_ting_ccod=49
					end if
	
					'response.Write("<br><b>Estado Conexion 1: </b> "&conexion.obtenerEstadoTransaccion)
					'Response.Write("<HR><br><b>CREA COMPROMISO NUEVO</b>")
						
					sql_inserta_compromisos="insert into compromisos (tcom_ccod, inst_ccod, comp_ndocto, ecom_ccod, pers_ncorr, comp_fdocto, comp_ncuotas, "& vbcrlf &_
					" comp_mneto,comp_miva, comp_mdescuento, comp_mdocumento, audi_tusuario, audi_fmodificacion, sede_ccod) "& vbcrlf &_
					" Values (9, 1, "&v_comp_ndocto&", 1, "&v_pers_ncorr&", getdate(), 1, '"&v_monto_neto&"','"&v_monto_iva&"', 0, "&v_monto_fact&", '"&usuario&"',getdate(), "&sede_ccod&" ) "
					'response.Write("<pre>"&sql_inserta_compromisos&"</pre>")	
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_compromisos)	
					
					'response.Write("<br><b>Estado Conexion 1: </b> "&conexion.obtenerEstadoTransaccion)
					sql_inserta_detalle_compromiso="insert into detalle_compromisos (tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, dcom_fcompromiso, "& vbcrlf &_
					" dcom_mneto, dcom_mintereses, dcom_mcompromiso, ecom_ccod, pers_ncorr, peri_ccod, audi_tusuario, audi_fmodificacion) "& vbcrlf &_
					" Values (9, 1, "&v_comp_ndocto&", 1, getdate(), '"&v_monto_neto&"', 0, "&v_monto_fact&", 1, "&v_pers_ncorr&", "&v_periodo&", '"&usuario&"',getdate()) "
					'response.Write("<pre>"&sql_inserta_detalle_compromiso&"</pre>")	
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_detalle_compromiso)
					
					'response.Write("<br><b>Estado Conexion 2: </b> "&conexion.obtenerEstadoTransaccion)	
					sql_inserta_detalles="insert into detalles (tcom_ccod, inst_ccod, comp_ndocto, tdet_ccod, deta_ncantidad, deta_mvalor_unitario, "& vbcrlf &_
					" deta_mvalor_detalle, deta_msubtotal, audi_tusuario, audi_fmodificacion) "& vbcrlf &_
					" Values (9, 1, "&v_comp_ndocto&", "&v_tdet_ccod&", 1, "&v_monto_fact&","&v_monto_fact&", "&v_monto_fact&", '"&usuario&"',getdate()) "
					'response.Write("<pre>"&sql_inserta_detalles&"</pre>")	
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_detalles)		

					
					' ********** 	Documentar el compromiso 	************	
					v_folio_ref_fac 		= 	conexion.consultauno("exec ObtenerSecuencia 'ingresos_referencia'")
					v_ingr_ncorr_fac 		= 	conexion.consultauno("exec ObtenerSecuencia 'ingresos'")
					v_ding_nsecuencia_fac 	= 	conexion.consultauno("exec ObtenerSecuencia 'detalle_ingresos'")

					'response.Write("<br><b>Estado Conexion 2: </b> "&conexion.obtenerEstadoTransaccion)
					'Response.Write("<HR><br><b>DOCUMENTAR COMPROMISO NUEVO</b>")
											
					sql_inserta_ingreso_fac=" insert into ingresos (ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mefectivo, ingr_mdocto,ingr_mtotal, "& vbcrlf &_
					"  ingr_nfolio_referencia, ting_ccod, audi_tusuario, audi_fmodificacion, inst_ccod, pers_ncorr, tmov_ccod) "& vbcrlf &_
					" values ("&v_ingr_ncorr_fac&", "&v_mcaj_ncorr&", 4, getdate(), 0, "&v_monto_fact&", "&v_monto_fact&", "&v_folio_ref_fac&", 2, '"&usuario&"', getdate(),1 , "&v_pers_ncorr&", 1) "
					'response.Write("<pre>"&sql_inserta_ingreso_fac&"</pre>")
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_ingreso_fac)				
					
					
					sql_inserta_abono_fac=	" insert into abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, "& vbcrlf &_
					" abon_mabono, audi_tusuario, audi_fmodificacion, pers_ncorr, peri_ccod) "& vbcrlf &_
					" values ("&v_ingr_ncorr_fac&", 9, "&v_inst_ccod&", "&v_comp_ndocto&", 1, getdate(), "&v_monto_fact&", '"&usuario&"', getdate(), "&v_pers_ncorr&", "&v_periodo&") "
					'response.Write("<pre>"&sql_inserta_abono_fac&"</pre>")
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_abono_fac)				
					
					
					sql_inserta_detalle_fac="insert into detalle_ingresos (ting_ccod,ding_ndocto,ingr_ncorr,ding_nsecuencia,ding_ncorrelativo,ding_fdocto,"& vbcrlf &_
					" edin_ccod,ding_mdetalle,ding_mdocto,ding_bpacta_cuota,audi_tusuario,audi_fmodificacion) "& vbcrlf &_
					" values ("&v_ting_ccod&","&v_nuevo_numero&","&v_ingr_ncorr_fac&","&v_ding_nsecuencia_fac&",1,getdate(), 1, "&v_monto_fact&","&v_monto_fact&",'S','"&usuario&"',getdate()) "
					'response.Write("<pre>"&sql_inserta_detalle_fac&"</pre>")
					conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_detalle_fac)					
end if ' Fin no_print

				
				'## PAGAR COMPROMISO DE FACTURA ANTIGUA
				
				
					folio_referencia 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
					nuevo_ingr_ncorr 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
					v_ding_nsecuencia 	= conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
					'response.Write("<br><b>Estado Conexion 1: </b> "&conexion.obtenerEstadoTransaccion)
					'Response.Write("<HR><br><b>PAGAR COMPROMISO ANTIGUO</b>")	
									
					sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,   audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
					"(SELECT " & nuevo_ingr_ncorr & ",'" & v_mcaj_ncorr & "' ,1 , getdate() ,'" &  v_monto_fact & "','" & v_monto_fact & "','1'," & folio_referencia  & ", 17, '1','" & v_pers_ncorr & "'," & usuario & ", getdate())"& vbCrLf
					conexion.EstadoTransaccion conexion.EjecutaS(sql)						
					'response.Write("<PRE>" & sql & "</PRE>")
					
					'response.Write("<br><b>Estado Conexion 2: </b> "&conexion.obtenerEstadoTransaccion)
					
					sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr,  audi_tusuario, audi_fmodificacion) "& vbCrLf &_
					"(SELECT " & nuevo_ingr_ncorr & ",'9',1,'" & comp_ndocto_fact  & "','1', getdate() ,'" &  v_monto_fact & "','" & v_pers_ncorr & "','" & usuario & "', getdate())"& vbCrLf
					conexion.EstadoTransaccion conexion.EjecutaS(sql)
					'response.Write("<PRE>" & sql & "</PRE>")		  
					
					ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
					sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
					"(SELECT " & nuevo_ingr_ncorr & ", "&v_ting_ccod_anu&", '" & v_ding_nsecuencia & "', "&v_ding_nsecuencia&",'1', getdate() ,'" &  v_monto_fact & "','" & v_monto_fact & "', " & usuario & ", getdate())"& vbCrLf
					conexion.EstadoTransaccion conexion.EjecutaS(sql)
					'response.Write("<PRE>" & sql & "</PRE>")
					'response.Write("<br><b>Estado Conexion 3: </b> "&conexion.obtenerEstadoTransaccion)
					
					sql_update_fact		=	"update facturas set efac_ccod=3, audi_tusuario='"&usuario&" -anula fact', audi_fmodificacion=getdate() where fact_ncorr="&v_fact_ncorr
					conexion.EstadoTransaccion conexion.EjecutaS(sql_update_fact)
					'response.Write("<PRE>" & sql_update_fact & "</PRE>")
					
					sql_upate_det_ingr	=	"update detalle_ingresos set edin_ccod=6, audi_tusuario='"&usuario&" -anula fact', audi_fmodificacion=getdate() where ding_ndocto="&v_num_factura&" and ting_ccod=49"
					conexion.EstadoTransaccion conexion.EjecutaS(sql_upate_det_ingr)
					'response.Write("<PRE>" & sql_upate_det_ingr & "</PRE>")
					
					'response.Write("<br><b>Estado Conexion 4: </b> "&conexion.obtenerEstadoTransaccion)
				
		else ' di no pertenece a la institucion
			conexion.EstadoTransaccion false
			session("mensajeError")="El tipo de factura que desea anular, no ha sido asociada al cajero."	
			response.Redirect(Request.ServerVariables("HTTP_REFERER"))
		end if											
	end if' fin si no hay fact_ncorr

next

'response.Write("Estado Final: "&conexion.obtenerEstadoTransaccion)
'conexion.EstadoTransaccion false
'response.End()
'*****************************************************************************
'###########################################################################################
'###########################################################################################


if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="La factura selecionada fue anulada correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar anular la Factura seleccionada.\nAsegurece de haber ingresado los datos correctos, tener caja abierta y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>