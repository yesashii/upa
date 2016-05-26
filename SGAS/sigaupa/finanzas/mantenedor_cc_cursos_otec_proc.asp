<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%

'for each x in request.Form
'	response.Write("<br>clave:"&x&"->"&request.Form(x)&"<hr>")
'next
'response.End()

v_crear_documentos=false

set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
usuario = negocio.ObtenerUsuario()


set f_tipos_detalle = new CFormulario
f_tipos_detalle.Carga_Parametros "mantenedor_cc_cursos_otec.xml", "tipos_detalle"
f_tipos_detalle.Inicializar conexion
f_tipos_detalle.ProcesaForm


for fila = 0 to f_tipos_detalle.CuentaPost - 1

	v_tdet_ccod		= f_tipos_detalle.ObtenerValorPost (fila, "tdet_ccod")
	centro_costo	= f_tipos_detalle.ObtenerValorPost (fila, "ccos_tcompuesto")
	descripcion_cc	= f_tipos_detalle.ObtenerValorPost (fila, "ccos_tdesc")
	v_codigo_cc 	= Replace(centro_costo,"-","")

'response.Write("<pre>"&sql_existe&"</pre>")

		if v_tdet_ccod<>"" then
		
		sql_existe="select ccos_ccod from centros_costo "& vbCrLf &_
		" where cast(ccos_tcodigo as varchar)='"&v_codigo_cc&"'"
		'response.Write("<pre>"&sql_existe&"</pre>")
		v_existe_cc= conexion.consultaUno(sql_existe)
		
		if EsVacio(v_existe_cc) then
			v_ccos_ccod = conexion.ConsultaUno("execute obtenersecuencia 'centros_costo'")
			v_crear_documentos= true

			sql_inserta_cc=" insert into centros_costo "& vbCrLf &_
						" (ccos_ccod,ccos_tcompuesto,ccos_tcodigo,ccos_tdesc,audi_tusuario, audi_fmodificacion) "& vbCrLf &_
						" Values ('"&v_ccos_ccod&"','"&centro_costo&"','"&v_codigo_cc&"','"&descripcion_cc&"','"&usuario&"', getdate()) "
			'response.Write("<pre>"&sql_inserta_cc&"</pre>")
			conexion.estadoTransaccion conexion.ejecutaS(sql_inserta_cc)
			'response.Write("<hr> 0: "&conexion.ObtenerEstadoTransaccion)			
		else
			v_ccos_ccod=Cint(v_existe_cc)
			'response.Write("El centro de costo ingresado ya existe. Asegurece de ingresar el codigo correcto.")
		end if
		

		'valida que los CC sean ingresados correctamente
			if v_ccos_ccod>0 and conexion.ObtenerEstadoTransaccion then
			
					sql_existe="select count(*) from centros_costos_asignados "& vbCrLf &_
							" where cast(tdet_ccod as varchar)='"&v_tdet_ccod&"'"
				
				
				'response.Write("<pre>"&sql_existe&"</pre>")
				v_asocia_cc= conexion.consultaUno(sql_existe)
'response.Write("<hr> 1: "&conexion.ObtenerEstadoTransaccion)					
				'si la asignacion ya existe, se avisa que no puede agregarse el centro de costo a los parametros
				if v_asocia_cc > 0 then
					msg_proceso="No se pudo agregar el centro de costo seleccionado ("&centro_costo&") a los parametros elegidos.\nLos parametros elegidos ya registran un centro de costo asociado.\nbusque dicho centro y edite los datos."
				else
					sql_agrega_cc=" insert into centros_costos_asignados "& vbCrLf &_
								" (ccos_ccod,cenc_ccod_sede,cenc_ccod_carrera,cenc_ccod_jornada,tdet_ccod)"& vbCrLf &_
								" Values ('"&v_ccos_ccod&"',null,null,null,'"&v_tdet_ccod&"') "	
					'response.Write("<pre>"&sql_inserta_cc&"</pre>")			
					conexion.estadoTransaccion conexion.ejecutaS(sql_agrega_cc) 
					msg_proceso="Los datos fueron agregados correctamente."
				end if
				 
			end if ' ---Fin if validacion creacion de CC
'response.Write("<hr> 2: "&conexion.ObtenerEstadoTransaccion)			
		end if ' fin si selecciono tipo_detalle


	' crea las cuentas contables asociadas a los distintos tipos de documentos con que se pagara ese centro de costo
	if v_crear_documentos then
	
	'response.Write("<hr> 3 Creando documentos asociados: "&conexion.ObtenerEstadoTransaccion)	
	
		'########################################################### 
		'########## Cheque	##########
		pre_cuenta="1-10-040-30-"&v_codigo_cc
		v_nom_cuenta="Cta. Cte. "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		
		if v_existe =0 then
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_cta_cte= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','N','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		
		v_estado_transaccion=conexion.ejecutaS(sql_cta_cte)
		'response.Write("<pre>"&sql_cheque&"</pre>")
		end if
		'############################################################
		
		
		'########################################################### 
		'########## Cheque	##########
		pre_cuenta="1-10-050-10-"&v_codigo_cc
		v_nom_cuenta="D.x.Cobrar "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		
		if v_existe =0 then
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_cheque= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		
		v_estado_transaccion=conexion.ejecutaS(sql_cheque)
		'response.Write("<pre>"&sql_cheque&"</pre>")
		end if
		'############################################################
		
		
		'###########################################################  
		'########## Letra	##########
		pre_cuenta="1-10-050-20-"&v_codigo_cc
		v_nom_cuenta="L.x.Cobrar "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		if v_existe =0 then
		
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_letra= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		v_estado_transaccion=conexion.ejecutaS(sql_letra)
		'response.Write("<pre>"&sql_letra&"</pre>")
		end if
		'############################################################
		
		
		'############################################################  
		'######### Pagare TBK	########
		pre_cuenta="1-10-050-40-"&v_codigo_cc
		v_nom_cuenta="Pag.TBK. "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		if v_existe =0 then
		
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_pagare_tbk= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		v_estado_transaccion=conexion.ejecutaS(sql_pagare_tbk)
		'response.Write("<pre>"&sql_pagare_tbk&"</pre>")
		end if
		'############################################################
		
		
		'############################################################  
		'########## T. Credito	##########
		pre_cuenta="1-10-050-50-"&v_codigo_cc
		v_nom_cuenta="T.Cred.TBK. "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		if v_existe =0 then
		
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_credito= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		
		v_estado_transaccion=conexion.ejecutaS(sql_credito)
		'response.Write("<pre>"&sql_credito&"</pre>")
		end if
		'############################################################
		
		
		'############################################################
		'########## T. Credito 3 cuotas	#########
		pre_cuenta="1-10-050-60-"&v_codigo_cc
		v_nom_cuenta="TBK.3 Ctas.P.C. "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		if v_existe =0 then
		
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_credito_3c= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		v_estado_transaccion=conexion.ejecutaS(sql_credito_3c)
		'response.Write("<pre>"&sql_credito_3c&"</pre>")
		end if
		'############################################################
		
		
		'#############################################################
		'########## T. debito (Redbanc)	##########
		pre_cuenta="1-10-050-70-"&v_codigo_cc
		v_nom_cuenta="Red.Compra "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		if v_existe =0 then
		
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_debito= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		v_estado_transaccion=conexion.ejecutaS(sql_debito)
		'response.Write("<pre>"&sql_debito&"</pre>")
		end if
		'############################################################
		
		
		'###############################################################
		'########## Gasto Protesto	##########
		pre_cuenta="1-10-050-25-"&v_codigo_cc
		v_nom_cuenta="G.P. Cobrar "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		if v_existe =0 then
		
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_gasto_protesto= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		v_estado_transaccion=conexion.ejecutaS(sql_gasto_protesto)
		'response.Write("<pre>"&sql_gasto_protesto&"</pre>")
		end if
		'############################################################
		
		
		'############################# 
		'########## Pagare	##########
		pre_cuenta="1-10-050-30-"&v_codigo_cc
		v_nom_cuenta="P.x.Cobrar "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		if v_existe =0 then
		
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_pagare= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		
		v_estado_transaccion=conexion.ejecutaS(sql_pagare)
		'response.Write("<pre>"&sql_pagare&"</pre>")
		end if
		'############################################################ 
		
		
		'############################# 
		'########## Factura	##########
		pre_cuenta="1-10-040-10-"&v_codigo_cc
		v_nom_cuenta="F.x.Cobrar "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		if v_existe =0 then
		
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_factura= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		
		v_estado_transaccion=conexion.ejecutaS(sql_factura)
		'response.Write("<pre>"&sql_pagare&"</pre>")
		end if
		'############################################################ 
		
		
		'#####################################
		'########## Orde de Compra	##########
		pre_cuenta="1-10-040-15-"&v_codigo_cc
		v_nom_cuenta="OC.x.Cobrar "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		if v_existe =0 then
		
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_oc= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		
		v_estado_transaccion=conexion.ejecutaS(sql_oc)
		'response.Write("<pre>"&sql_pagare&"</pre>")
		end if
		'############################################################ 
		
		
		'############################################################  
		'######### MULTIDEBITO	########
		pre_cuenta="1-10-050-80-"&v_codigo_cc
		v_nom_cuenta="T.Mul. "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		if v_existe =0 then
		
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_multidebito= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		v_estado_transaccion=conexion.ejecutaS(sql_multidebito)
		'response.Write("<pre>"&sql_multidebito&"</pre>")
		end if
		'############################################################
		
		
		'############################################################  
		'######### PAGARE UPA	########
		pre_cuenta="1-10-050-35-"&v_codigo_cc
		v_nom_cuenta="P.UPA. "&descripcion_cc
		
		sql_existe_cuenta="select count(*)  from cuentas_softland where cuenta ='"&pre_cuenta&"'"
		v_existe=conexion.consultaUno(sql_existe_cuenta)
		if v_existe =0 then
		
			v_csof_ncorr=conexion.consultaUno("exec obtenersecuencia 'cuentas_softland' ")
			sql_pagare_upa= " Insert Into cuentas_softland (csof_ncorr, cuenta, nombre_cuenta, usa_controla_doc, usa_centro_costo, usa_auxiliar, usa_detalle_gasto,usa_conciliacion, usa_pto_caja, AUDI_FMODIFICACION, AUDI_TUSUARIO) " &_
						" Values ("&v_csof_ncorr&", '"&pre_cuenta&"','"&v_nom_cuenta&"','S','N','S','N','N', 'N',getdate(), '"&negocio.ObtenerUsuario&"')"
		v_estado_transaccion=conexion.ejecutaS(sql_pagare_upa)
		'response.Write("<pre>"&sql_multidebito&"</pre>")
		end if
		'############################################################
		
	end if

next


'response.write("<br/>"&msg_proceso)

if conexion.ObtenerEstadoTransaccion= true then
	session("mensaje_error")=msg_proceso
end if

'conexion.EstadoTransaccion false
'response.End()

response.Redirect(request.ServerVariables("HTTP_REFERER"))   
%>