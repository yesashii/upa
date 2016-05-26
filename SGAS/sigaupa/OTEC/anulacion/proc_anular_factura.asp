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
cajero 		= cajero.obtenerCajaAbierta

'---------------------------------------------------------------------

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next
'response.End()

set formulario = new CFormulario
formulario.Carga_Parametros "anulacion_facturas.xml", "f_facturas"
formulario.Inicializar conexion
formulario.ProcesaForm		

for fila = 0 to formulario.CuentaPost - 1
	v_fact_ncorr	= formulario.ObtenerValorPost (fila, "fact_ncorr")
	v_monto_fact	= formulario.ObtenerValorPost (fila, "monto")
	v_pers_ncorr	= formulario.ObtenerValorPost (fila, "pers_ncorr")
	v_ting_ccod		= formulario.ObtenerValorPost (fila, "ting_ccod")

	if v_fact_ncorr <> "" then
		v_pote_ncorr= conexion.consultaUno("select top 1 pote_ncorr from postulantes_cargos_factura where fact_ncorr="&v_fact_ncorr)

		v_folio_fact=conexion.consultaUno("select ingr_nfolio_referencia from facturas where fact_ncorr="&v_fact_ncorr)


		if v_pote_ncorr <> "" then

			sql_postulacion="select top 1  * from postulacion_otec where pote_ncorr="&v_pote_ncorr
			
			set datos_postulacion = new CFormulario
			datos_postulacion.Carga_Parametros "consulta.xml", "consulta"
			datos_postulacion.Inicializar conexion
			datos_postulacion.Consultar sql_postulacion
			
			while datos_postulacion.siguiente
			
			v_fpot_ccod		=	datos_postulacion.ObtenerValor("fpot_ccod")
			v_ncorr_empr	=	datos_postulacion.ObtenerValor("empr_ncorr_empresa")
			v_ncorr_otic	=	datos_postulacion.ObtenerValor("empr_ncorr_otic")
			v_norc_otic		=	datos_postulacion.ObtenerValor("norc_otic")
			v_norc_empr		=	datos_postulacion.ObtenerValor("norc_empresa")
			v_dgso_ncorr	=	datos_postulacion.ObtenerValor("dgso_ncorr")
			v_comp_oc		=	datos_postulacion.ObtenerValor("comp_ndocto")
			
			'Para financiamiento individual
			sql_comp_ndocto	=	"select top 1 b.comp_ndocto from ingresos a, abonos b "& vbCrLf &_ 
								"where a.ingr_ncorr=b.ingr_ncorr "& vbCrLf &_ 
								"and a.ingr_nfolio_referencia="&v_folio_fact
			v_comp_ndocto	=	conexion.consultaUno(sql_comp_ndocto)

'response.Write("fpot: "&v_fpot_ccod)
			
			' ##### Evaluar el tipo de postulacion:#####
				' Empresa sola		-\  fpot_ccod=2 y 3
				' Empresa con sence -/
				' Empresa con otic --> fpot_ccod=4
			
				select case v_fpot_ccod
					
					' ********** Financiamiento compartido	*****************
					case "4"	
					
						' se debe buscar empresa y sus compromisos asociados + otic y sus compromisos asociados y anular contra algun concepto
						if v_norc_otic ="" then
							v_norc_otic=v_norc_empr
						end if
						
						' obtiene informacion desde la orden de compra
						sql_datos_oc="select TOP 1 *, isnull(ocot_monto_otic,0) as monto_otic,isnull(ocot_monto_empresa,0) as monto_empresa from ordenes_compras_otec where nord_compra= "&v_norc_otic&" "

						set datos_oc = new CFormulario
						datos_oc.Carga_Parametros "consulta.xml", "consulta"
						datos_oc.Inicializar conexion
						datos_oc.Consultar sql_datos_oc
						v_monto_total=0
						while datos_oc.siguiente
							v_monto_otic	=	Clng(datos_oc.ObtenerValor("monto_otic"))
							v_monto_empresa	=	Clng(datos_oc.ObtenerValor("monto_empresa"))
							v_monto_total	=  v_monto_total+ v_monto_otic+v_monto_empresa
						wend
						
						'response.Write(" v_monto_otic: "&v_monto_otic&" v_monto_empresa: "&v_monto_empresa&" ")
						
						sql_cuenta_fact="select count(*) "& vbCrLf &_
										" from facturas where fact_ncorr in (select fact_ncorr from postulantes_cargos_factura where pote_ncorr="&v_pote_ncorr&")" & vbCrLf &_
										" and efac_ccod not in (3)"
						v_cant_fact=conexion.consultaUno(sql_cuenta_fact)

						
						if v_cant_fact>2 then 	' si es mayor a 2 significa que se han hecho facturas para ambas empresas
												' obtiene los datos de todas las facturas asociadas a esta postulacion.
							sql_datos_facturacion="select c.comp_ndocto,a.ingr_nfolio_referencia,pers_ncorr_alumno as rut_empresa, fact_mtotal as monto_factura, "& vbCrLf &_
												" fact_nfactura as num_factura "& vbCrLf &_
												" from facturas a, ingresos b, abonos c "& vbCrLf &_ 
												" where fact_ncorr in (select fact_ncorr from postulantes_cargos_factura where pote_ncorr="&v_pote_ncorr&")" & vbCrLf &_
												" and efac_ccod not in (3) "& vbCrLf &_
												" and a.ingr_nfolio_referencia=b.ingr_nfolio_referencia"& vbCrLf &_
												" and b.ingr_ncorr=c.ingr_ncorr"& vbCrLf &_
												" order by rut_empresa "
											
							set f_datos_facturacion = new CFormulario
							f_datos_facturacion.Carga_Parametros "consulta.xml", "consulta"
							f_datos_facturacion.Inicializar conexion
							f_datos_facturacion.Consultar sql_datos_facturacion	
							
							while f_datos_facturacion.siguiente
							
								v_monto_factura	=	f_datos_facturacion.ObtenerValor("monto_factura")
								v_rut_empresa	=	f_datos_facturacion.ObtenerValor("rut_empresa")
								v_comp_ndocto	=	f_datos_facturacion.ObtenerValor("comp_ndocto")
								
									folio_referencia 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
									nuevo_ingr_ncorr 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
									v_ding_nsecuencia 	= conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
									
									sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,   audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
									"(SELECT " & nuevo_ingr_ncorr & ",'" & cajero & "' ,1 , getdate() ,'" &  v_monto_factura & "','" & v_monto_factura & "','1'," & folio_referencia  & ", 8, '1','" & v_rut_empresa & "'," & usuario & ", getdate())"& vbCrLf
									conexion.EstadoTransaccion conexion.EjecutaS(sql)						
									'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")
									 
									
									sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr,  audi_tusuario, audi_fmodificacion) "& vbCrLf &_
									"(SELECT " & nuevo_ingr_ncorr & ",'9',1,'" & v_comp_ndocto  & "','1', getdate() ,'" &  v_monto_factura & "','" & v_rut_empresa & "','" & usuario & "', getdate())"& vbCrLf
									conexion.EstadoTransaccion conexion.EjecutaS(sql)
									'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR>")		  
									
									
									ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
									sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
									"(SELECT " & nuevo_ingr_ncorr & ", "&v_ting_ccod&", '" & v_ding_nsecuencia & "', "&v_ding_nsecuencia&",'1', getdate() ,'" &  v_monto_factura & "','" & v_monto_factura & "', " & usuario & ", getdate())"& vbCrLf
									conexion.EstadoTransaccion conexion.EjecutaS(sql) 
									'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")	
									

								
							wend ' fin ciclo de facturacion para mas de 2 facturas
																		
											
						else ' es el caso normal, donde hay una empresa y una otic, pero la empresa puede tener financiamiento cero.

							if v_cant_fact=1 then ' solo se ha facturado a la otic o a la empresa.  se debe revisar.
								sql_quien_es="select top 1 pers_ncorr_alumno from postulantes_cargos_factura a, facturas b "& vbCrLf &_
											 "	where  a.fact_ncorr=b.fact_ncorr "& vbCrLf &_
											 "	and pote_ncorr="&v_pote_ncorr&" "
								v_empre_ncorr=conexion.consultaUno(sql_quien_es)	
								
								if v_empre_ncorr<>"" then ' anula la factura de la institucion encontrada
									folio_referencia 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
									nuevo_ingr_ncorr 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
									v_ding_nsecuencia 	= conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
									
									sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,   audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
									"(SELECT " & nuevo_ingr_ncorr & ",'" & cajero & "' ,1 , getdate() ,'" &  v_monto_total & "','" & v_monto_total & "','1'," & folio_referencia  & ", 17, '1','" & v_empre_ncorr & "'," & usuario & ", getdate())"& vbCrLf
									conexion.EstadoTransaccion conexion.EjecutaS(sql)						
									'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")
									 
									
									sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr,  audi_tusuario, audi_fmodificacion) "& vbCrLf &_
									"(SELECT " & nuevo_ingr_ncorr & ",'9',1,'" & v_comp_ndocto  & "','1', getdate() ,'" &  v_monto_total & "','" & v_empre_ncorr & "','" & usuario & "', getdate())"& vbCrLf
									conexion.EstadoTransaccion conexion.EjecutaS(sql)
									'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR>")		  
									
									
									ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
									sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
									"(SELECT " & nuevo_ingr_ncorr & ", "&v_ting_ccod&", '" & v_ding_nsecuencia & "', "&v_ding_nsecuencia&",'1', getdate() ,'" &  v_monto_total & "','" & v_monto_total & "', " & usuario & ", getdate())"& vbCrLf
									conexion.EstadoTransaccion conexion.EjecutaS(sql) 
									'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")	
									

								end if		 
							else	' significa que son 2 facturas, pero aun no se puede determinar si son de una misma institucion	
							
								sql_quien_es="select count(*) from (select distinct pers_ncorr_alumno from postulantes_cargos_factura a, facturas b "& vbCrLf &_
											 "	where  a.fact_ncorr=b.fact_ncorr "& vbCrLf &_
											 "	and pote_ncorr="&v_pote_ncorr&" ) as tabla"
								v_cantidad_empre=conexion.consultaUno(sql_quien_es)	
								
								'response.Write("<br><b> v_cantidad_empre:</b> "&v_cantidad_empre&" ")								
								if v_cantidad_empre>"0" then ' es una empresa pero que dividio sus 2 facturas por cambio de año o son 2 empresas con una factura cada una
									' obtiene los datos de todas las facturas asociadas a esta postulacion.
									sql_datos_facturacion="select c.comp_ndocto,a.ingr_nfolio_referencia,pers_ncorr_alumno as rut_empresa, fact_mtotal as monto_factura, "& vbCrLf &_
														" fact_nfactura as num_factura "& vbCrLf &_
														" from facturas a, ingresos b, abonos c "& vbCrLf &_ 
														" where fact_ncorr in (select fact_ncorr from postulantes_cargos_factura where pote_ncorr="&v_pote_ncorr&")" & vbCrLf &_
														" and efac_ccod not in (3) "& vbCrLf &_
														" and a.ingr_nfolio_referencia=b.ingr_nfolio_referencia"& vbCrLf &_
														" and b.ingr_ncorr=c.ingr_ncorr"& vbCrLf &_
														" order by rut_empresa "
									
									'response.Write(sql_datos_facturacion)
													
									set f_datos_facturacion = new CFormulario
									f_datos_facturacion.Carga_Parametros "consulta.xml", "consulta"
									f_datos_facturacion.Inicializar conexion
									f_datos_facturacion.Consultar sql_datos_facturacion	
									
									while f_datos_facturacion.siguiente
									
										v_monto_factura	=	f_datos_facturacion.ObtenerValor("monto_factura")
										v_rut_empresa	=	f_datos_facturacion.ObtenerValor("rut_empresa")
										v_comp_ndocto	=	f_datos_facturacion.ObtenerValor("comp_ndocto")
										
											folio_referencia 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
											nuevo_ingr_ncorr 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
											v_ding_nsecuencia 	= conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
											
											sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,   audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
											"(SELECT " & nuevo_ingr_ncorr & ",'" & cajero & "' ,1 , getdate() ,'" &  v_monto_factura & "','" & v_monto_factura & "','1'," & folio_referencia  & ", 17, '1','" & v_rut_empresa & "'," & usuario & ", getdate())"& vbCrLf
											conexion.EstadoTransaccion conexion.EjecutaS(sql)						
											'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")
											 
											
											sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr,  audi_tusuario, audi_fmodificacion) "& vbCrLf &_
											"(SELECT " & nuevo_ingr_ncorr & ",'9',1,'" & v_comp_ndocto  & "','1', getdate() ,'" &  v_monto_factura & "','" & v_rut_empresa & "','" & usuario & "', getdate())"& vbCrLf
											conexion.EstadoTransaccion conexion.EjecutaS(sql)
											'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR>")		  
											
											
											ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
											sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
											"(SELECT " & nuevo_ingr_ncorr & ", "&v_ting_ccod&", '" & v_ding_nsecuencia & "', "&v_ding_nsecuencia&",'1', getdate() ,'" &  v_monto_factura & "','" & v_monto_factura & "', " & usuario & ", getdate())"& vbCrLf
											conexion.EstadoTransaccion conexion.EjecutaS(sql) 
											'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")	
											
		
									wend ' fin ciclo de facturacion para mas de 2 facturas
									
								end if	' fin validacion cantidad empresas
							end if ' Fin if de solo un cargo de factura asociado
						end if
					
					' ********** FINANCIAMIENTO INDIVIDUAL	*****************	
					case else
						' se debe anular los compromisos de la empresa contra algun concepto y dejar la postulacion y la factura anuladas.
						
								' determina si hay mas de una factura para la empresa
								sql_quien_es="select count(*) from (select distinct pers_ncorr_alumno from postulantes_cargos_factura a, facturas b "& vbCrLf &_
								 "	where  a.fact_ncorr=b.fact_ncorr "& vbCrLf &_
								 "	and pote_ncorr="&v_pote_ncorr&" ) as tabla"
								v_cantidad_empre=conexion.consultaUno(sql_quien_es)	
								
								sql_cuenta_fact="select count(*) "& vbCrLf &_
										" from facturas where fact_ncorr in (select fact_ncorr from postulantes_cargos_factura where pote_ncorr="&v_pote_ncorr&")" & vbCrLf &_
										" and efac_ccod not in (3)"
								v_cant_fact=conexion.consultaUno(sql_cuenta_fact)
								
								if v_cantidad_empre="1" and v_cant_fact>1 then ' es una empresa pero que dividio sus 2 facturas por cambio de año
									' obtiene los datos de todas las facturas asociadas a esta postulacion.
									sql_datos_facturacion="select c.comp_ndocto,a.ingr_nfolio_referencia,pers_ncorr_alumno as rut_empresa, fact_mtotal as monto_factura, "& vbCrLf &_
														" fact_nfactura as num_factura "& vbCrLf &_
														" from facturas a, ingresos b, abonos c "& vbCrLf &_ 
														" where fact_ncorr in (select fact_ncorr from postulantes_cargos_factura where pote_ncorr="&v_pote_ncorr&")" & vbCrLf &_
														" and efac_ccod not in (3) "& vbCrLf &_
														" and a.ingr_nfolio_referencia=b.ingr_nfolio_referencia"& vbCrLf &_
														" and b.ingr_ncorr=c.ingr_ncorr"& vbCrLf &_
														" order by rut_empresa "
									'response.Write("<pre>"&sql_datos_facturacion&"</pre>")

									set f_datos_facturacion = new CFormulario
									f_datos_facturacion.Carga_Parametros "consulta.xml", "consulta"
									f_datos_facturacion.Inicializar conexion
									f_datos_facturacion.Consultar sql_datos_facturacion	
								
									
									while f_datos_facturacion.siguiente
									
										v_monto_factura	=	f_datos_facturacion.ObtenerValor("monto_factura")
										v_rut_empresa	=	f_datos_facturacion.ObtenerValor("rut_empresa")
										v_comp_ndocto	=	f_datos_facturacion.ObtenerValor("comp_ndocto")
										
											folio_referencia 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
											nuevo_ingr_ncorr 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
											v_ding_nsecuencia 	= conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
											
											sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,   audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
											"(SELECT " & nuevo_ingr_ncorr & ",'" & cajero & "' ,1 , getdate() ,'" &  v_monto_factura & "','" & v_monto_factura & "','1'," & folio_referencia  & ", 17, '1','" & v_rut_empresa & "'," & usuario & ", getdate())"& vbCrLf
											
											conexion.EstadoTransaccion conexion.EjecutaS(sql)						
											'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")
											
											sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr,  audi_tusuario, audi_fmodificacion) "& vbCrLf &_
											"(SELECT " & nuevo_ingr_ncorr & ",'9',1,'" & v_comp_ndocto  & "','1', getdate() ,'" &  v_monto_factura & "','" & v_rut_empresa & "','" & usuario & "', getdate())"& vbCrLf
											
											conexion.EstadoTransaccion conexion.EjecutaS(sql)
											'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR>")		  
											
											ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
											sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
											"(SELECT " & nuevo_ingr_ncorr & ", "&v_ting_ccod&", '" & v_ding_nsecuencia & "', "&v_ding_nsecuencia&",'1', getdate() ,'" &  v_monto_factura & "','" & v_monto_factura & "', " & usuario & ", getdate())"& vbCrLf
											
											conexion.EstadoTransaccion conexion.EjecutaS(sql) 
											'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")	
		
									wend ' fin ciclo de facturacion para mas de 2 facturas	
								else
						
						
									'---------------- secuencias de ingresos -------------------
									folio_referencia 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos_referencia'")
									nuevo_ingr_ncorr 	= conexion.ConsultaUno("execute obtenersecuencia 'ingresos'")
									v_ding_nsecuencia 	= conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
									
									
									sql = "INSERT INTO ingresos(ingr_ncorr, mcaj_ncorr, eing_ccod, ingr_fpago, ingr_mdocto, ingr_mtotal, ingr_nestado, ingr_nfolio_referencia, ting_ccod, inst_ccod, pers_ncorr,   audi_tusuario, audi_fmodificacion) "& vbCrLf  &_  
									"(SELECT " & nuevo_ingr_ncorr & ",'" & cajero & "' ,1 , getdate() ,'" &  v_monto_fact & "','" & v_monto_fact & "','1'," & folio_referencia  & ", 17, '1','" & v_pers_ncorr & "'," & usuario & ", getdate())"& vbCrLf
									
									conexion.EstadoTransaccion conexion.EjecutaS(sql)						
									'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")
									
									sql = "INSERT INTO abonos (ingr_ncorr, tcom_ccod, inst_ccod, comp_ndocto, dcom_ncompromiso, abon_fabono, abon_mabono, pers_ncorr,  audi_tusuario, audi_fmodificacion) "& vbCrLf &_
									"(SELECT " & nuevo_ingr_ncorr & ",'9',1,'" & v_comp_ndocto  & "','1', getdate() ,'" &  v_monto_fact & "','" & v_pers_ncorr & "','" & usuario & "', getdate())"& vbCrLf
									
									conexion.EstadoTransaccion conexion.EjecutaS(sql)
									'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR>")		  
									
									ding_nsecuencia = conexion.ConsultaUno("execute obtenersecuencia 'detalle_ingresos'")
									sql = "INSERT INTO detalle_ingresos (ingr_ncorr, ting_ccod, ding_ndocto, ding_nsecuencia, ding_ncorrelativo, ding_fdocto, ding_mdetalle, ding_mdocto, audi_tusuario, audi_fmodificacion) "& vbCrLf &_
									"(SELECT " & nuevo_ingr_ncorr & ", "&v_ting_ccod&", '" & v_ding_nsecuencia & "', "&v_ding_nsecuencia&",'1', getdate() ,'" &  v_monto_fact & "','" & v_monto_fact & "', " & usuario & ", getdate())"& vbCrLf
									
									conexion.EstadoTransaccion conexion.EjecutaS(sql) 
									'response.Write("<BR><BR><PRE>" & sql & "</PRE><BR><BR>")	
								
								'**************************************************************
								'********	ACTUALIZAR POSTULACION Y DEJAR PENDIENTE **********
							end if' sin conteo de empresas y facturas
					
				end select
					'response.Write("<pre>")
					'response.Write("<br>v_fpot_ccod-->"&v_fpot_ccod)
					'response.Write("<br>v_ncorr_empr-->"&v_ncorr_empr)
					'response.Write("<br>v_ncorr_otic-->"&v_ncorr_otic)
					'response.Write("<br>v_norc_otic-->"&v_norc_otic)
					'response.Write("<br>v_norc_empr-->"&v_norc_empr)
					'response.Write("<br>v_dgso_ncorr-->"&v_dgso_ncorr)
					'response.Write("<br>v_comp_ndocto-->"&v_comp_ndocto)
					'response.Write("</pre>")
				
			wend ' fin while datos_postulacion
		end if ' fin if postulacion
	'response.Write("<br><b>estado 1: " & conexion.ObtenerEstadoTransaccion & "</b>")

'************************	ANULAR POSTULACIONES ******************** 	
	set f_postulacion_otec = new CFormulario
	f_postulacion_otec.Carga_Parametros "consulta.xml", "consulta"
	f_postulacion_otec.Inicializar conexion
	
	sql_postulantes="select * from postulantes_cargos_factura where fact_ncorr="&v_fact_ncorr&" "
	f_postulacion_otec.Consultar sql_postulantes	
	
	while f_postulacion_otec.siguiente
		v_pote_otec	=	f_postulacion_otec.ObtenerValor("pote_ncorr")
		
		'Anula postulacion y luego la vuelve a crear.
		sql_update_postulante=" update postulacion_otec set epot_ccod=5, audi_tusuario='anula-otec' where pote_ncorr in ("&v_pote_otec&")"
		conexion.EstadoTransaccion conexion.EjecutaS(sql_update_postulante)
		
		nuevo_pote_ncorr	=	conexion.ConsultaUno("execute obtenersecuencia 'postulacion_otec'")
		
		sql_inserta_nuevo_pote= " insert into postulacion_otec (pote_ncorr,pers_ncorr,epot_ccod,fecha_postulacion,dgso_ncorr,utiliza_sence,fpot_ccod,"& vbCrLf &_
								" empr_ncorr_empresa,norc_empresa,empr_ncorr_otic,norc_otic,nied_ccod,tdet_ccod,datos_persona_correctos,"& vbCrLf &_
								" datos_empresa_correctos,datos_otic_correctos,audi_tusuario,audi_fmodificacion,comp_ndocto) "& vbCrLf &_
								" (select "&nuevo_pote_ncorr&" as pote_ncorr,pers_ncorr, 1 as epot_ccod,fecha_postulacion,dgso_ncorr,utiliza_sence,fpot_ccod,"& vbCrLf &_
								" empr_ncorr_empresa,norc_empresa,empr_ncorr_otic,norc_otic,nied_ccod,tdet_ccod,datos_persona_correctos,"& vbCrLf &_
								" datos_empresa_correctos,datos_otic_correctos,audi_tusuario,audi_fmodificacion,comp_ndocto "& vbCrLf &_            
								" from postulacion_otec where pote_ncorr="&v_pote_otec& ") "
								
		'response.Write("<pre>"&sql_inserta_nuevo_pote&"</pre>")	
		conexion.EstadoTransaccion conexion.EjecutaS(sql_inserta_nuevo_pote)							
	wend

	'************************	ANULAR FACTURAS ******************** 	
	set f_factura_otec = new CFormulario
	f_factura_otec.Carga_Parametros "consulta.xml", "consulta"
	f_factura_otec.Inicializar conexion
	
	sql_facturas="select * from postulantes_cargos_factura where pote_ncorr="&v_pote_ncorr&" "
	f_factura_otec.Consultar sql_facturas	
	
	while f_factura_otec.siguiente
		v_fact_otec	=	f_factura_otec.ObtenerValor("fact_ncorr")
		
		sql_update_facturas=" update facturas set efac_ccod=3, audi_tusuario='anula-otec' where fact_ncorr ="&v_fact_otec&" "
		'response.Write("<pre>"&sql_update_facturas&"</pre>")	
		conexion.EstadoTransaccion conexion.EjecutaS(sql_update_facturas)
	wend

	'response.Write("<br><b>estado 2: " & conexion.ObtenerEstadoTransaccion & "</b>")

	'response.Write("<pre>"&sql_update_postulantes&"</pre>")	
	
	end if ' fin if facturas (v_fact_ncorr)
next

'conexion.EstadoTransaccion false
'response.End()
'*****************************************************************************

if conexion.ObtenerEstadoTransaccion  then
	session("mensajeError")="Las Boletas selecionados fueron guardadas correctamente "
else
	session("mensajeError")="Ocurrio un error al intentar anular una o mas facturas.\nAsegurece de haber ingresado los datos correctos y vuelva a intentarlo."
end if
'response.End()
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>