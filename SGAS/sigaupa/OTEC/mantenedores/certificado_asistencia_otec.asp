<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
'for each k in request.querystring
'	response.write(k&"="&request.querystring(k)&"<br>")
'next
'response.End()
'---------------------------------------------------------------->Captura de variables de la busqueda
pers_nrut		= Request.QueryString("busqueda[0][pers_nrut]")
pers_xdv		= Request.QueryString("busqueda[0][pers_xdv]")
tipo_persona	= Request.QueryString("busqueda[0][tipo_persona]")
tipo_doc		= Request.QueryString("busqueda[0][tipo_doc]")
estado			= 4
errorDeInfo 	= "No existe la información en la base de datos"
'----------------------------------------------------------------<Captura de variables de la busqueda

set pagina = new CPagina
pagina.Titulo = "Certificado de asistencia Otec"
'----------------------------------->>Creación de de la página
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
'----------------------------------->>Creación de la conección

set f_botonera = new CFormulario
f_botonera.Carga_Parametros "certificado_asistencia_otec.xml", "botonera"
set errores = new CErrores
'----------------------------------->>Creación de la botonera
'** INICIO f_busqueda **'
'*************************************************************************'
set f_busqueda = new CFormulario
f_busqueda.Carga_Parametros "certificado_asistencia_otec.xml", "busqueda"
f_busqueda.Inicializar conexion
f_busqueda.Consultar "select '' "
f_busqueda.Siguiente

f_busqueda.AgregaCampoCons "pers_nrut", pers_nrut
f_busqueda.AgregaCampoCons "pers_xdv", pers_xdv
f_busqueda.AgregaCampoCons "tipo_persona", tipo_persona
f_busqueda.AgregaCampoCons "tipo_doc", tipo_doc
'*************************************************************************'
'** FIN f_busqueda **'



if tipo_doc <> "" and pers_nrut <> "" then
'*************************'
'**	DETERMINANDO ESTADO	**'	
'*************************'------------------
'-------------------------------------------------------variables

	'**dgso_ncorr>>
		consulta 	= "" & vbCrLf & _
					"select dgso_ncorr                   " & vbCrLf & _
					"from   ordenes_compras_otec         " & vbCrLf & _
					"where  cast(nord_compra as varchar) = '"&tipo_doc&"' " 				
		dgso_ncorr = conexion.consultaUno(consulta)
	'**dgso_ncorr<<	
	'**empr_ncorr>> determina el empr_ncorr puede ser de la otic o de la empresa de loq ue s eingresó
		consulta 	= "" & vbCrLf & _
					"select empr_ncorr                  " & vbCrLf & _
					"from   empresas                    " & vbCrLf & _
					"where  cast(empr_nrut as varchar) = '"&pers_nrut&"' "
		empr_ncorr = conexion.consultaUno(consulta)
	'**empr_ncorr<<	

	'**empr_ncorr_2>> determina si existe este campo, si existe entonces hay empresa con otic y el campo empr_ncorr_2 es de la empresa y empr_ncorr es de la OTIC
		consulta 	= "" & vbCrLf & _
					"select empr_ncorr_2                  	" & vbCrLf & _
					"from   ordenes_compras_otec          	" & vbCrLf & _
					"where  cast(empr_ncorr as varchar) = '"&empr_ncorr&"' 	" & vbCrLf & _
					"and empr_ncorr_2 is not null			" & vbCrLf & _
					"and cast(nord_compra as varchar) = '"&tipo_doc&"'		"
'response.write(consulta)
'response.end()					
		empr_ncorr_2 = conexion.consultaUno("select isnull(("&consulta&"),'0')")
	'**empr_ncorr_2<<

	'**condicionEmpresa>> si no es solo empresa retorna 0 	
		consulta 	= "" & vbCrLf & _
					"select distinct a.empr_ncorr                      		" & vbCrLf & _
					"from   ordenes_compras_otec as a                		" & vbCrLf & _
					"       inner join postulacion_otec as b         		" & vbCrLf & _
					"               on a.dgso_ncorr = b.dgso_ncorr   		" & vbCrLf & _
					"                  and cast(b.norc_empresa as varchar) = '"&tipo_doc&"' 	" & vbCrLf & _
					"where  a.empr_ncorr_2 is null                   		" & vbCrLf & _
					"       and cast(empr_ncorr as varchar) = '"&empr_ncorr&"'        		"
					
		condicionEmpresa = conexion.consultaUno("select isnull(("&consulta&"),'0')")		
	'**condicionEmpresa<<
'response.End()	
	'**condicionEmpresaConOtic>>
		consulta 	= "" & vbCrLf & _	
					"select distinct a.empr_ncorr                  			" & vbCrLf & _
					"from   ordenes_compras_otec as a              			" & vbCrLf & _
					"       inner join postulacion_otec as b       			" & vbCrLf & _
					"               on a.dgso_ncorr = b.dgso_ncorr 			" & vbCrLf & _
					"                  and cast(b.norc_otic as varchar) = '"&tipo_doc&"'  	" & vbCrLf & _
					"where  cast(a.empr_ncorr_2 as varchar) = '"&empr_ncorr&"' 			   	"
					condicionEmpresaCO = conexion.consultaUno("select isnull((" & consulta& "),'0')")
	'**condicionEmpresaConOtic<<
		
	'**condicionOticConEmpresa>>	
		consulta 	= "" & vbCrLf & _	
					"select distinct a.empr_ncorr                  			" & vbCrLf & _
					"from   ordenes_compras_otec as a              			" & vbCrLf & _
					"       inner join postulacion_otec as b       			" & vbCrLf & _
					"               on a.dgso_ncorr = b.dgso_ncorr 			" & vbCrLf & _
					"                  and cast(b.norc_otic as varchar) = '"&tipo_doc&"'  	" & vbCrLf & _
					"where  a.empr_ncorr_2 is not null             			" & vbCrLf & _
					"       and cast(a.empr_ncorr as varchar) = '"&empr_ncorr&"'             " 
					condicionOticCE = conexion.consultaUno("select isnull((" & consulta & "),'0')")
	'**condicionOticConEmpresa<<
	if (condicionEmpresa <> "0") then ' es empresa y el usuario ingresó un rut de empresa
		estado = 1		
	end if	
	if (condicionOticCE <> "0") then ' es otic con empresa y el usuario ingresó un rut de otic
		estado = 3		
	end if
	if (condicionEmpresaCO <> "0") then ' es empresa con otic y el usuario ingresó un rut de empresa
		estado = 2		
	end if
'response.write("Estado = " & estado)
'response.end()	
'*************************'------------------
'**	DETERMINANDO ESTADO	**'	
'*************************'
'*********************************************************************************'
'**																				**'
'**								 SI ES EMPRESA									**'
'**																				**'
'*********************************************************************************'-------------

	if estado = 1 then	
'-----------------------variables	
'**dgso_ncorr>>
		consulta = "" & vbCrLf & _
		"select dgso_ncorr                                           					" & vbCrLf &_
		"from   ordenes_compras_otec                                 					" & vbCrLf &_
		"where  cast(nord_compra as varchar) = cast('"&tipo_doc&"' as varchar)			" & vbCrLf &_
		"       and cast(empr_ncorr as varchar) = (select empr_ncorr 					" & vbCrLf &_
		"                                          from   empresas   					" & vbCrLf &_
		"                                          where             					" & vbCrLf &_
		"           cast(empr_nrut as varchar) = cast('"&pers_nrut&"' as varchar) )     " 
'---------------------------------------****Debug
'Response.Write("<pre>"&consulta&"</pre>")				
'---------------------------------------****Debug							
dgso_ncorr = conexion.consultaUno(consulta)
'**dgso_ncorr<<

			'**empr_ncorr>>
				consulta = "" & vbCrLf & _
				"select empr_ncorr                  " & vbCrLf & _
				"from   empresas                    " & vbCrLf & _
				"where  cast(empr_nrut as varchar) = '"&pers_nrut&"' "
'---------------------------------------****Debug
'Response.Write("<pre>"&consulta&"</pre>")				
'---------------------------------------****Debug				
				empr_ncorr = conexion.consultaUno(consulta)
			'**empr_ncorr<<

			'**nord_compra>>			
				nord_compra = tipo_doc		
			'**nord_compra<<
			
			'**anioIni>>
				consulta = "" & vbCrLf & _
				"select datepart(year,dgso_finicio)    	" & vbCrLf & _	
				"from   datos_generales_secciones_otec 	" & vbCrLf & _
				"where  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'  	" 
				anioIni = conexion.consultaUno(consulta)
			'**anioIni<<

			'**anioTer>>
				consulta = "" & vbCrLf & _
				"select datepart(year,dgso_ftermino)   	" & vbCrLf & _	
				"from   datos_generales_secciones_otec 	" & vbCrLf & _
				"where  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'  	" 
				anioTer = conexion.consultaUno(consulta)
			'**anioTer<<	

			'**dgso_finicio>>
				consulta = "" & vbCrLf & _
				"select dgso_finicio			    	" & vbCrLf & _	
				"from   datos_generales_secciones_otec 	" & vbCrLf & _
				"where  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'  	" 
				dgso_finicio = conexion.consultaUno(consulta)
			'**dgso_finicio<<
		
			'**dgso_ftermino>>
				consulta = "" & vbCrLf & _
				"select dgso_ftermino				   	" & vbCrLf & _	
				"from   datos_generales_secciones_otec 	" & vbCrLf & _
				"where  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'  	" 
				dgso_ftermino = conexion.consultaUno(consulta)	
			'**dgso_ftermino<<					
		'-----------------------variables
		'-------------------------------------->>para saber si es multi año 	
			if anioIni <> anioTer then 
				multianio = "1"
			else
				multianio = "0"
			end if
			
			'-------------------------------------------------------Debug
			'response.write("multianio = "&multianio		&"<br/>")
			'response.write("dgso_ncorr = "&dgso_ncorr	&"<br/>")
			'response.write("empr_ncorr = "&empr_ncorr	&"<br/>")
			'response.write("nord_compra = "&nord_compra	&"<br/>")
			'response.write("dgso_ftermino = "&dgso_ftermino	&"<br/>")
			'response.write("dgso_finicio = "&dgso_finicio	&"<br/>")
			'response.end()
			'-------------------------------------------------------Debug
		'--------------------------------------<<para saber si es multi año 
		'-------------------------------------->>VARIABLES PARA EL DOCUMENTO
			'------------------DATOS PARCIALES>>
				'**rut_e<<	
					consulta_rut_e 	= "select protic.obtener_rut('"&empr_ncorr&"')"  
					rut_e 			= conexion.consultaUno(consulta_rut_e)	
				'**rut_e<<		
				'**nombre_e>>
					consulta_nombre_e	= "select protic.obtener_nombre_completo('"&empr_ncorr&"', 'n')"
					nombre_e 			= conexion.consultaUno(consulta_nombre_e)
				'**nombre_e<<
				'**nom_dip>>
					consulta_nom_dip	= "" & vbCrLf & _
										"select isnull(b.dcur_nombre_sence, b.dcur_tdesc) 					" & vbCrLf & _
										"from   datos_generales_secciones_otec as a       					" & vbCrLf & _
										"       inner join diplomados_cursos as b         					" & vbCrLf & _
										"               on a.dcur_ncorr = b.dcur_ncorr    					" & vbCrLf & _
										"where  cast(a.dgso_ncorr as varchar) = '"&dgso_ncorr&"'           	" 
'---------------------------------------****Debug
'Response.Write("<pre>"&consulta_nom_dip&"</pre>")				
'---------------------------------------****Debug				
					nom_dip 			= conexion.consultaUno(consulta_nom_dip)
				'**nom_dip<<
				'**cod_sence>>
					consulta_cod_sence 	= "" & vbCrLf & _
										"select dcur_nsence 							  " & vbCrLf & _
										"from   datos_generales_secciones_otec as a       " & vbCrLf & _
										"       inner join diplomados_cursos as b         " & vbCrLf & _
										"               on a.dcur_ncorr = b.dcur_ncorr    " & vbCrLf & _
										"where  cast(a.dgso_ncorr as varchar) = '"&dgso_ncorr&"'           " 
					cod_sence 			= conexion.consultaUno(consulta_cod_sence)	
				'**cod_sence<<	
				'**accion_sense>>
				consulta_accion_sense 	= "" & vbCrLf & _
										"select isnull(cast(ocot_nro_registro_sence as varchar),'"&errorDeInfo&"') 	" & vbCrLf & _
										"from   ordenes_compras_otec                								" & vbCrLf & _
										"where  cast(empr_ncorr as varchar) = '"&empr_ncorr&"'       				" & vbCrLf & _
										"  and  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'   					" & vbCrLf & _
										"  and  cast(nord_compra as varchar) = '"&nord_compra&"' 					" 
										
				accion_sense  = conexion.consultaUno("select isnull((" & consulta_accion_sense& "),'"&errorDeInfo&"')")	
				'**accion_sense<<	

				'**anio>>	
					consulta_anio	= "" & vbCrLf & _
									"select datepart(year, dgso_ftermino)  " & vbCrLf & _
									"from   datos_generales_secciones_otec " & vbCrLf & _
									"where  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'  " 
					anio 			= conexion.consultaUno(consulta_anio)							
				'**anio<<
			
				'**horas>>
		consulta_horas 	= "" & vbCrLf & _  
						"select isnull((select b.dorc_nhoras                                                    " & vbCrLf & _
						"               from   ordenes_compras_otec as a                                        " & vbCrLf & _
						"                      inner join detalle_ordenes_compras_otec as b                     " & vbCrLf & _
						"                              on a.orco_ncorr = b.orco_ncorr                           " & vbCrLf & _
						"                                 and cast(anos_ccod as varchar) = '"&anioIni&"'        " & vbCrLf & _
						"                                 and cast(b.dorc_num_oc as varchar) = '"&tipo_doc&"' 	" & vbCrLf & _
						"                                 and cast(b.empr_ncorr as varchar) = '"&empr_ncorr&"' 	" & vbCrLf & _
						"               where  cast(a.dgso_ncorr as varchar) = '"&dgso_ncorr&"'),               " & vbCrLf & _
						"              (select sum(maot_nhoras_programa)                                        " & vbCrLf & _
						"               from   mallas_otec                                                      " & vbCrLf & _
						"               where                                                                   " & vbCrLf & _
						"              dcur_ncorr = (select dcur_ncorr                                          " & vbCrLf & _
						"                            from   datos_generales_secciones_otec                      " & vbCrLf & _
						"                            where  dgso_ncorr = '"&dgso_ncorr&"')))                    " 			
'---------------------------------------****Debug
'Response.Write("Numero de horas: <hr/>")	
'Response.Write("<pre>"&consulta_horas&"</pre>")				
'---------------------------------------****Debug						
					horas_aux 		= conexion.consultaUno(consulta_horas)					
					if horas_aux = "0" then
						'response.write("horas_aux = "&horas_aux	&"<br/>")
						horas = "No existe información."
					else
						horas = horas_aux
					end if						
				'**horas<<	
				
				'**NumFactura>>	
						consulta_f = "" & vbCrLf & _				
						"select isnull(d.fact_nfactura,'0')                                        					" & vbCrLf & _
						"from   postulacion_otec as a                                              					" & vbCrLf & _
						"       inner join datos_generales_secciones_otec as b                     					" & vbCrLf & _
						"               on a.dgso_ncorr = b.dgso_ncorr                             					" & vbCrLf & _
						"                  and datepart(year, b.dgso_finicio) = '"&anio&"' 		   					" & vbCrLf & _
						"       inner join postulantes_cargos_factura as c                         					" & vbCrLf & _
						"               on a.pote_ncorr = c.pote_ncorr                             					" & vbCrLf & _
						"       inner join facturas as d                                           					" & vbCrLf & _
						"               on c.fact_ncorr = d.fact_ncorr                             					" & vbCrLf & _
						"                  and d.empr_ncorr = (select pers_ncorr                   					" & vbCrLf & _
						"                                      from   personas                     					" & vbCrLf & _
						"                                      where  cast(pers_nrut as varchar)= '"&pers_nrut&"') 	"
'---------------------------------------****Debug
'Response.Write("Numero de factura: <hr/>")	
'Response.Write("<pre>"&consulta_f&"</pre>")				
'---------------------------------------****Debug				
						factura 		= Cstr(conexion.consultaUno(consulta_f)) 
						if 	len(""&factura) = 0 then
							factura = " No existe la factura hasta la fecha "
						end if
				'**NumFactura<<
				'------------------DATOS PARCIALES<<
				'-------------------------------------->>PARA EL AÑO SIGUIENTE (SI APLICA)>>
				if multianio = "1" then	
					set f_datosDelDocumentoEmpresaMA = new CFormulario
					f_datosDelDocumentoEmpresaMA.Carga_Parametros "tabla_vacia.xml", "tabla"
					f_datosDelDocumentoEmpresaMA.Inicializar conexion
					consulta = 	"" & vbCrLf & _
								"select isnull(cast(f.dorc_num_oc as varchar), '"&errorDeInfo&"')    		as dorc_num_oc,   	" & vbCrLf & _								
								"       isnull(cast(f.dorc_naccion_sence as varchar), '"&errorDeInfo&"')  	as accion_sense, 	" & vbCrLf & _
								"       isnull(cast(f.dorc_nhoras as varchar), '"&errorDeInfo&"')          	as horas          	" & vbCrLf & _
								"from   personas as a                                                       					" & vbCrLf & _
								"       inner join postulacion_otec as b                                    					" & vbCrLf & _
								"               on a.pers_ncorr = b.pers_ncorr                              					" & vbCrLf & _
								"                 and cast(b.norc_empresa as varchar) = '"&tipo_doc&"'    						" & vbCrLf & _ 
								"                  and epot_ccod = '4' 															" & vbCrLf & _
								"       inner join datos_generales_secciones_otec as c                      					" & vbCrLf & _
								"               on b.dgso_ncorr = c.dgso_ncorr                              					" & vbCrLf & _
								"       inner join diplomados_cursos as d                                   					" & vbCrLf & _
								"               on c.dcur_ncorr = d.dcur_ncorr                              					" & vbCrLf & _
								"       inner join empresas as e                                            					" & vbCrLf & _
								"               on b.empr_ncorr_empresa = e.empr_ncorr                      					" & vbCrLf & _
								"                 and cast(e.empr_nrut as varchar)= '" & pers_nrut & "'     					" & vbCrLf & _
								"       inner join detalle_ordenes_compras_otec as f 											" & vbCrLf & _	
								"               on b.norc_empresa = f.dorc_num_oc                           					" & vbCrLf & _
								"                  and f.anos_ccod = datepart(year, c.dgso_ftermino)   							" 	
					f_datosDelDocumentoEmpresaMA.Consultar consulta
					f_datosDelDocumentoEmpresaMA.Siguiente	
					accion_senseMA = f_datosDelDocumentoEmpresaMA.obtenerValor("accion_sense")
					horasMA = f_datosDelDocumentoEmpresaMA.obtenerValor("horas")
					dorc_num_ocMA = f_datosDelDocumentoEmpresaMA.obtenerValor("dorc_num_oc")
					'================================================NumFactura
						consulta_f = "" & vbCrLf & _				
						"select d.fact_nfactura                                                    		" & vbCrLf & _
						"from   postulacion_otec as a                                              		" & vbCrLf & _
						"       inner join datos_generales_secciones_otec as b                     		" & vbCrLf & _
						"               on a.dgso_ncorr = b.dgso_ncorr                             		" & vbCrLf & _
						"                  and datepart(year, b.dgso_ftermino) = '"&anio&"'			 	" & vbCrLf & _
						"       inner join postulantes_cargos_factura as c                         		" & vbCrLf & _
						"               on a.pote_ncorr = c.pote_ncorr                             		" & vbCrLf & _
						"       inner join facturas as d                                           		" & vbCrLf & _
						"               on c.fact_ncorr = d.fact_ncorr                             		" & vbCrLf & _
						"                  and d.empr_ncorr = (select pers_ncorr                   		" & vbCrLf & _
						"                                      from   personas                     		" & vbCrLf & _
						"                                      where  cast(pers_nrut as varchar)= '"&pers_nrut&"')   "						
						facturaMA 		= conexion.consultaUno(consulta_f) 
						if 	len(""&facturaMA) = 0 then
							facturaMA = " No existe la factura hasta la fecha "
						end if		
					'================================================NumFactura				
				end if'if multianio = "1" then			
				'-------------------------------------->>PARA EL AÑO SIGUIENTE (SI APLICA)<<				
		'--------------------------------------<<VARIABLES PARA EL DOCUMENTO
	end if'if estado = 1 then
'*********************************************************************************'-------------
'**																				**'
'**								 SI ES EMPRESA									**'
'**																				**'
'*********************************************************************************'

'*********************************************************************************'
'**																				**'
'**					SI ES OTIC CON EMPRESA (INGRESO RUT OTIC)					**'
'**																				**'
'*********************************************************************************'-------------
	if estado = 3 or estado = 2 then
	
		'-----------------------variables			
			'**nord_compra>>			
				nord_compra = tipo_doc		
			'**nord_compra<<
			'**anioIni>>
				consulta = "" & vbCrLf & _
				"select datepart(year,dgso_finicio)    	" & vbCrLf & _	
				"from   datos_generales_secciones_otec 	" & vbCrLf & _
				"where  cast(dgso_ncorr as varchar)= '"&dgso_ncorr&"'  	" 
				anioIni = conexion.consultaUno(consulta)
			'**anioIni<<
			
			'**anioTer>>
				consulta = "" & vbCrLf & _
				"select datepart(year,dgso_ftermino)   	" & vbCrLf & _	
				"from   datos_generales_secciones_otec 	" & vbCrLf & _
				"where  cast(dgso_ncorr as varchar)= '"&dgso_ncorr&"'  	" 
				anioTer = conexion.consultaUno(consulta)
			'**anioTer<<	
			'**dgso_finicio>>
				consulta = "" & vbCrLf & _
				"select dgso_finicio			    	" & vbCrLf & _	
				"from   datos_generales_secciones_otec 	" & vbCrLf & _
				"where  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'  	" 
				dgso_finicio = conexion.consultaUno(consulta)
			'**dgso_finicio<<
			
			'**dgso_ftermino>>
				consulta = "" & vbCrLf & _
				"select dgso_ftermino				   	" & vbCrLf & _	
				"from   datos_generales_secciones_otec 	" & vbCrLf & _
				"where  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'  	" 
				dgso_ftermino = conexion.consultaUno(consulta)	
			'**dgso_ftermino<<					
		'-----------------------variables
		'-------------------------------------->>para saber si es multi año 	
			if anioIni <> anioTer then 
				multianio = "1"
			else
				multianio = "0"
			end if
			'-------------------------------------------------------Debug
			'response.write("multianio = "&multianio		&"<br/>")
			'response.write("dgso_ncorr = "&dgso_ncorr	&"<br/>")
			'response.write("empr_ncorr = "&empr_ncorr	&"<br/>")
			'response.write("nord_compra = "&nord_compra	&"<br/>")
			'response.write("dgso_ftermino = "&dgso_ftermino	&"<br/>")
			'response.write("dgso_finicio = "&dgso_finicio	&"<br/>")
			'response.end()
			'-------------------------------------------------------Debug
		'--------------------------------------<<para saber si es multi año 
		'-------------------------------------->>VARIABLES PARA EL DOCUMENTO
			'------------------DATOS PARCIALES>>
			if estado = 2 then			
			
				'**empr_ncorr_2>> determina si existe este campo, si existe entonces hay empresa con otic y el campo empr_ncorr_2 es de la empresa y empr_ncorr es de la OTIC
					consulta 	= "" & vbCrLf & _
								"select distinct empr_ncorr_2          	" & vbCrLf & _
								"from   ordenes_compras_otec          	" & vbCrLf & _
								"where  cast(empr_ncorr_2 as varchar) = '"&empr_ncorr&"' " & vbCrLf & _
								"and empr_ncorr_2 is not null			"									
					empr_ncorr_2 = conexion.consultaUno("select isnull(("&consulta&"),'0')")
				'**empr_ncorr_2<<
				'**empr_nrut_o>>			
					consulta 	= "" & vbCrLf & _			
								"select distinct a.empr_nrut                     " & vbCrLf & _
								"from   empresas as a                            " & vbCrLf & _
								"       inner join ordenes_compras_otec as b     " & vbCrLf & _
								"               on a.empr_ncorr = b.empr_ncorr   " & vbCrLf & _
								"                  and cast(b.empr_ncorr_2 as varchar) = '"&empr_ncorr_2&"' " & vbCrLf & _
								"       inner join postulacion_otec as c         " & vbCrLf & _ 
								"               on b.dgso_ncorr = c.dgso_ncorr   " & vbCrLf & _
								"                  and cast(norc_otic as varchar) = '"&nord_compra&"' 	 "
								empr_nrut_o = conexion.consultaUno("select isnull(("&consulta&"),'0')")
				'**empr_nrut_o<<
				'**empr_ncorr>> determina el empr_ncorr puede ser de la otic o de la empresa de loq ue s eingresó
					consulta 	= "" & vbCrLf & _
								"select empr_ncorr                  	" & vbCrLf & _
								"from   empresas                    	" & vbCrLf & _
								"where  cast(empr_nrut as varchar) = '"&empr_nrut_o&"'	"
					empr_ncorr = conexion.consultaUno(consulta)
				'**empr_ncorr<<	
			end if			
				'**rut_e<<	
					consulta_rut_e 	= "select protic.obtener_rut('"&empr_ncorr_2&"')"  
					rut_e 			= conexion.consultaUno(consulta_rut_e)	
				'**rut_e<<

				'**rut_ot<<					
					consulta_rut_ot 	= "select protic.obtener_rut('"&empr_ncorr&"')"  
					rut_ot				= conexion.consultaUno(consulta_rut_ot)	
				'**rut_ot<<	
			
				'**nombre_ot>>
					consulta_nombre_ot	= "select protic.obtener_nombre_completo('"&empr_ncorr&"', 'n')"
					nombre_ot 			= conexion.consultaUno("select isnull((" & consulta_nombre_ot & "),'"&errorDeInfo&"')")	
										
				'**nombre_ot<<
				
				'**nombre_e>>
					consulta_nombre_e	= "select protic.obtener_nombre_completo('"&empr_ncorr_2&"', 'n')"
					nombre_e 			= conexion.consultaUno("select isnull((" & consulta_nombre_e & "),'"&errorDeInfo&"')")											
				'**nombre_e<<
				
				'**nom_dip>>
					consulta_nom_dip	= "" & vbCrLf & _
										"select isnull(b.dcur_nombre_sence, b.dcur_tdesc) " & vbCrLf & _
										"from   datos_generales_secciones_otec as a       " & vbCrLf & _
										"       inner join diplomados_cursos as b         " & vbCrLf & _
										"               on a.dcur_ncorr = b.dcur_ncorr    " & vbCrLf & _
										"where  cast(a.dgso_ncorr as varchar) = '"&dgso_ncorr&"'           " 
					nom_dip 			= conexion.consultaUno("select isnull((" & consulta_nom_dip & "),'"&errorDeInfo&"')")						
				'**nom_dip<<
				
				'**cod_sence>>
					consulta_cod_sence 	= "" & vbCrLf & _
										"select cast(dcur_nsence as varchar)    		  " & vbCrLf & _
										"from   datos_generales_secciones_otec as a       " & vbCrLf & _
										"       inner join diplomados_cursos as b         " & vbCrLf & _
										"               on a.dcur_ncorr = b.dcur_ncorr    " & vbCrLf & _
										"where  cast(a.dgso_ncorr as varchar) = '"&dgso_ncorr&"'           " 
					cod_sence 			= conexion.consultaUno("select isnull((" & consulta_cod_sence & "),'"&errorDeInfo&"')")	
					
				'**cod_sence<<	
				'**accion_sense>>
					consulta_accion_sense 	= "" & vbCrLf & _
											"select cast(ocot_nro_registro_sence as varchar)  " & vbCrLf & _
											"from   ordenes_compras_otec                " & vbCrLf & _
											"where  cast(empr_ncorr as varchar) = '"&empr_ncorr&"'       " & vbCrLf & _
											"  and  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'   " & vbCrLf & _
											"  and  cast(nord_compra as varchar) = '"&nord_compra&"' " 									
					accion_sense 			= conexion.consultaUno("select isnull((" & consulta_accion_sense & "),'"&errorDeInfo&"')")					
				'**accion_sense<<	
				'**anio>>	
					consulta_anio	= "" & vbCrLf & _
									"select datepart(year, dgso_ftermino)  " & vbCrLf & _
									"from   datos_generales_secciones_otec " & vbCrLf & _
									"where  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'  " 
					anio 			= conexion.consultaUno(consulta_anio)							
				'**anio<<
				'**horas>>
				
	consulta_horas 		= "" & vbCrLf & _  
						"select isnull((select b.dorc_nhoras                                " & vbCrLf & _
						"               from   ordenes_compras_otec as a                    " & vbCrLf & _
						"                      inner join detalle_ordenes_compras_otec as b " & vbCrLf & _
						"                              on a.orco_ncorr = b.orco_ncorr       " & vbCrLf & _
						"                                 and cast(anos_ccod as varchar) = '"&anioIni&"'     " & vbCrLf & _
						"                                 and cast(b.dorc_num_oc as varchar) = '"&tipo_doc&"'" & vbCrLf & _
						"                                 and cast(b.empr_ncorr as varchar) = '"&empr_ncorr&"'" & vbCrLf & _										
						"               where  cast(a.dgso_ncorr as varchar) = '"&dgso_ncorr&"'), '0') 		"		
					
					horas_aux 		= conexion.consultaUno(consulta_horas)		
				

					if horas_aux = "0" then
						'response.write("horas_aux = "&horas_aux	&"<br/>")
						horas = errorDeInfo
					else
						horas = horas_aux
					end if						
				'**horas<<	
				
				'------------------DATOS PARCIALES<<
				'-------------------------------------->>PARA EL AÑO SIGUIENTE (SI APLICA)>>
				if multianio = "1" then	
					set f_datosDelDocumentoEmpresaMA = new CFormulario
					f_datosDelDocumentoEmpresaMA.Carga_Parametros "tabla_vacia.xml", "tabla"
					f_datosDelDocumentoEmpresaMA.Inicializar conexion
					consulta = "" & vbCrLf & _
					"select isnull(cast(f.dorc_num_oc as varchar), '"&errorDeInfo&"')    	  	as dorc_num_oc,   	" & vbCrLf & _								
				    "       isnull(cast(f.dorc_naccion_sence as varchar) , '"&errorDeInfo&"')  	as accion_sense,  	" & vbCrLf & _
					"       isnull(cast(f.dorc_nhoras as varchar) , '"&errorDeInfo&"')          as horas   		  	" & vbCrLf & _
					"from   personas as a                                     				      					" & vbCrLf & _
					"       inner join postulacion_otec as b                                    					" & vbCrLf & _
					"               on a.pers_ncorr = b.pers_ncorr                              					" & vbCrLf & _
					"                  and cast(b.norc_otic as varchar) = '"&tipo_doc&"'                            " & vbCrLf & _
					"                  and epot_ccod = '4'                                      					" & vbCrLf & _
					"       inner join datos_generales_secciones_otec as c                      					" & vbCrLf & _
					"               on b.dgso_ncorr = c.dgso_ncorr                              					" & vbCrLf & _
					"       inner join diplomados_cursos as d                                   					" & vbCrLf & _
					"               on c.dcur_ncorr = d.dcur_ncorr                              					" & vbCrLf & _
					"       inner join empresas as e                                            					" & vbCrLf & _
					"               on b.empr_ncorr_otic = e.empr_ncorr                         					" & vbCrLf & _
					"       inner join ordenes_compras_otec as g                                					" & vbCrLf & _
					"				on c.dgso_ncorr = g.dgso_ncorr                              					" & vbCrLf & _
					"       inner join detalle_ordenes_compras_otec as f                        					" & vbCrLf & _
					"               on g.orco_ncorr = f.orco_ncorr                              					" & vbCrLf & _
					"                  and f.anos_ccod = datepart(year, c.dgso_ftermino)         					" & vbCrLf & _
					"                  and cast(f.empr_ncorr as varchar)= '"&empr_ncorr&"' 			              	" 					
					f_datosDelDocumentoEmpresaMA.Consultar consulta
					f_datosDelDocumentoEmpresaMA.Siguiente	
					
					accion_senseMA = f_datosDelDocumentoEmpresaMA.obtenerValor("accion_sense")
					horasMA = f_datosDelDocumentoEmpresaMA.obtenerValor("horas")
					dorc_num_ocMA = f_datosDelDocumentoEmpresaMA.obtenerValor("dorc_num_oc")					
				end if'if multianio = "1" then			
				'-------------------------------------->>PARA EL AÑO SIGUIENTE (SI APLICA)<<				
		'--------------------------------------<<VARIABLES PARA EL DOCUMENTO
	end if'if estado = 3 then
'*********************************************************************************'-------------
'**																				**'
'**								 	SI ES OTIC									**'
'**																				**'
'*********************************************************************************'


	
end if' if tipo_persona <> "" then
'---------------------------------<<condicion OTIC o EMPRESA


'*****************************************'
'**		INICIO DE BUSQUEDA DE ALUMNOS	**'
'*****************************************'
'-------------------------------------------------------------------------------------------------------------

set f_cargo = new CFormulario
f_cargo.Carga_Parametros "certificado_asistencia_otec.xml", "cargo"
f_cargo.Inicializar conexion
if pers_nrut <> "" then
	consulta = "" & vbCrLf & _
"select	protic.obtener_rut(a.pers_ncorr)	as rut,               		" & vbCrLf & _   		
"		a.pers_tnombre						as pers_tnombre,      		" & vbCrLf & _   		
"		a.pers_tape_paterno					as pers_tape_paterno, 		" & vbCrLf & _   		
"		a.pers_tape_materno					as pers_tape_materno, 		" & vbCrLf & _
"		isnull(b.pote_nasistencia, '0')  as asistencia            		" & vbCrLf & _
"from	personas as a                                             		" & vbCrLf & _
"		inner join postulacion_otec as b                          		" & vbCrLf & _	
"			on a.pers_ncorr = b.pers_ncorr                    	  		" & vbCrLf & _
"				and b.epot_ccod = '4'                             		" & vbCrLf & _
"				and isnull(norc_empresa, norc_otic) = '"&tipo_doc&"'    "
'response.write("<pre>"&consulta&"</pre>")                  
'response.end()                                             
			f_cargo.Consultar consulta                                  
end if
'---------------------------------------------------------------------------------------------------
set f_cargo2 = new CFormulario
f_cargo2.Carga_Parametros "certificado_asistencia_otec.xml", "multigrilla"
f_cargo2.Inicializar conexion
if pers_nrut <> "" then
	consulta = "" & vbCrLf & _
	"select protic.obtener_rut(a.pers_ncorr) 				as rut,                  				" & vbCrLf & _
	"       a.pers_tnombre                   				as pers_tnombre,         				" & vbCrLf & _
	"       a.pers_tape_paterno              				as pers_tape_paterno,    				" & vbCrLf & _
	"       a.pers_tape_materno              				as pers_tape_materno,    				" & vbCrLf & _
	"       isnull(e.pote_nasistencia_parcial, '0')  		as pote_nasistencia_parcial, 	      	" & vbCrLf & _
	"       isnull(e.pote_nasistencia_complementaria, '0')  as pote_nasistencia_complementaria, 	" & vbCrLf & _
	"       b.pote_ncorr  					 				as pote_ncorr,							" & vbCrLf & _
	"       c.dgso_ncorr  					 				as dgso_ncorr 							" & vbCrLf & _
	"from   personas as a                                             								" & vbCrLf & _
	"       inner join postulacion_otec as b                          								" & vbCrLf & _
	"               on a.pers_ncorr = b.pers_ncorr                    								" & vbCrLf & _
	"                  and epot_ccod = '4'                            								" & vbCrLf & _
	"                  and isnull(norc_empresa, norc_otic) = '"&tipo_doc&"' 						" & vbCrLf & _
	"       left join postulacion_otec_asistencias_parciales as e            						" & vbCrLf & _	
	"               on b.pote_ncorr = e.pote_ncorr                    								" & vbCrLf & _	
	"       inner join datos_generales_secciones_otec as c            								" & vbCrLf & _
	"               on b.dgso_ncorr = c.dgso_ncorr                    								" & vbCrLf & _
	"       inner join ordenes_compras_otec as d                      								" & vbCrLf & _
	"               on c.dgso_ncorr = d.dgso_ncorr                    								" & vbCrLf & _
	"                  and cast(nord_compra as varchar) = '"&tipo_doc&"' 	                						" 

'response.write("<pre>"&consulta&"</pre>")                  
'response.end()                                             
			f_cargo2.Consultar consulta                                  
end if	
'-------------------------------------------------------------------------------------------------------------	
'*************************************'
'**	  FIN DE BUSQUEDA DE ALUMNOS	**'
'*************************************'

%>
<html>
<head>
<title><%=pagina.Titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>



<script language="JavaScript">
function cambiarTextoD()
{
	//texto = document.getElementById("busqueda[0][tipo_persona]").value;
	opcion = document.buscador.elements["busqueda[0][tipo_persona]"].value; 
	if (opcion == 1)
	{
		document.getElementById("detDoc").innerHTML = '<strong>N° Factura</strong>';
		return false;
	}
	if (opcion == 2)
	{
		document.getElementById("detDoc").innerHTML = '<strong>N° OC</strong>';
		return false;
	}
	if (opcion == "")
	{
		document.getElementById("detDoc").innerHTML = '<strong>Documento</strong>';
		return false;
	}	
	return true;
	//alert(texto);
}


function uno_seleccionado(form){
	  	nro = form.elements.length;
   		num =0;
	   for( i = 0; i < nro; i++ ) {
		  comp = form.elements[i];
		  str  = form.elements[i].name;
		  v_indice=extrae_indice(str);
		  if((comp.type == 'checkbox') && (comp.checked == true) && (str != 'chk_selTodo')){
	 		num += 1;
			document.edicion.indice.value=v_indice;
		  }
	   }
	   return num;
 }

function Validar(formulario)
{
	valor = uno_seleccionado(formulario);
	if	(valor == 1)// se selecciono uno
	{
		return true;
	}else{
		alert("Debe seleccionar una opcion a la vez");
	}
}


function ValidaBusqueda()
{
	n_rut=document.buscador.elements["busqueda[0][pers_nrut]"].value;
	n_dv=document.buscador.elements["busqueda[0][pers_xdv]"].value;
	rut=n_rut+ '-' +n_dv;
	if (!valida_rut(rut)) {
		alert('Ingrese un rut válido.');		
		document.buscador.elements["busqueda[0][pers_nrut]"].focus();
		return false;
	}
	
	return true;	
}

function ventana_modificar(origen,tipo,dgso_ncorr,pers_nrut){

	pagina = "../facturacion/prefacturar.asp?origen="+origen+"&tipo="+tipo+"&dgso_ncorr="+dgso_ncorr+"&pers_nrut="+pers_nrut;
	window.open(pagina,"prefactura","width=805px, height=700px, scrollbars=yes, resizable=yes");
	//resultado = open(pagina,"wAgregar","width=805px, height=600px, scrollbars=yes, resizable=yes");
	//resultado.focus();

}	
function pdf_1(pers_nrut, pers_xdv, tipo_persona, tipo_doc, opcion) 
{
	if (opcion == 1)
	{
	direccion = "certificado_asistencia_otec_normal_pdf.asp?pers_nrut="+pers_nrut+"&pers_xdv="+pers_xdv+"&tipo_persona="+tipo_persona+"&tipo_doc="+tipo_doc+"";	
	resultado=window.open(direccion, "ventana1","width=800,height=1000,scrollbars=yes, left=380, top=350");		
	}
	if (opcion == 2)
	{
	direccion = "certificado_asistencia_otec_parcial_pdf.asp?pers_nrut="+pers_nrut+"&pers_xdv="+pers_xdv+"&tipo_persona="+tipo_persona+"&tipo_doc="+tipo_doc+"";
	resultado=window.open(direccion, "ventana1","width=800,height=1000,scrollbars=yes, left=380, top=350");
	}
	if (opcion == 3)
	{
	direccion = "certificado_asistencia_otec_complementario_pdf.asp?pers_nrut="+pers_nrut+"&pers_xdv="+pers_xdv+"&tipo_persona="+tipo_persona+"&tipo_doc="+tipo_doc+"";
	resultado=window.open(direccion, "ventana1","width=800,height=1000,scrollbars=yes, left=380, top=350");
	}
 
}
function sinResultados()
{
	alert("Sin resultados para la busqueda realizada");
}
function valida_carga()
{	
	cargando();
	return true;
}
function cargando()
{	
	cargar=document.getElementById('esperar');
	//cargar es mi id del div que esta oculto con la imagen y lo pongo visible hasta el final.
	tem=document.getElementById('tiempo');
	//tiempo es mi "id" de la imagen gif que hace del loader. que es cargar3.gif
	cargar.style.visibility='visible';	
	setTimeout('tem.src = "../biblioteca/imagenes/2u95w85.gif"', 200); //recarga la imagen despues de pulsar el boton submit
}
</script>
  <style type="text/css">
  	.noEncontrado
	{
    color: red;
	font-size:14px;
	}
  </style>
</head>
<% if rut_e <> "" then %>
	<body bgcolor="#D8D8DE" leftmargin="0" topmargin="10" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
<% else %>
	<% if pers_nrut <> "" then %>	 
	<body bgcolor="#D8D8DE" leftmargin="0" topmargin="10" marginwidth="0" marginheight="0" onLoad="sinResultados();">
	<% else %>
	<body bgcolor="#D8D8DE" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" onBlur="revisaVentana();">
	<%end if%>
<%end if%>
<div id="esperar" style="position: absolute; left: 300; top: 300; visibility: hidden; width: 50px; height: 50px;">
	<img src="../biblioteca/imagenes/2u95w85.gif" id="tiempo" align="middle" width="50" height="50" style="vertical-align:middle"/>
</div> 
<table width="" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="top" bgcolor="#EAEAEA">	  
	<table width="70%" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td>
		<table border="0" cellpadding="0" cellspacing="0" width="400">       
            <tr>
              <td><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
              <td height="8"><img name="top_r1_c2" src="../imagenes/top_r1_c2.gif" width="400" height="8" border="0" alt=""></td>
              <td><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
            </tr>
            <tr>
            	<td><img name="top_r2_c1" src="../imagenes/top_r2_c1.gif" width="9" height="17" border="0" alt=""></td>
            	<td><%pagina.DibujarLenguetas Array("Datos institución que financia"), 1%></td>
            	<td><img name="top_r2_c3" src="../imagenes/top_r2_c3.gif" width="7" height="17" border="0" alt=""></td>
            </tr>
            <tr> 
                <td><img name="top_r3_c1" src="../imagenes/top_r3_c1.gif" width="9" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c2" src="../imagenes/top_r3_c2.gif" width="400" height="2" border="0" alt=""></td>
                <td><img name="top_r3_c3" src="../imagenes/top_r3_c3.gif" width="7" height="2" border="0" alt=""></td>
            </tr>                   
         </table>
         <table width="320" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="9" height="62" align="left" background="../imagenes/izq.gif">&nbsp;</td>
                <td bgcolor="#D8D8DE">
<form name="buscador">
              <br>
              <table width="400"  border="0" align="center">
                <tr>
                  <td width="81%"><div align="center">
                    <table width="98%"  border="0" cellspacing="0" cellpadding="0">
                      <tr>
                        <td width="88"><div align="left"><strong>RUT</strong></div></td>
                        <td width="10"><div align="left">:</div></td>
                        <td width="214"><%f_busqueda.DibujaCampo("pers_nrut")%>-<%f_busqueda.DibujaCampo("pers_xdv")
						'pagina.DibujarBuscaPersonas "busqueda[0][pers_nrut]", "busqueda[0][pers_xdv]"
						%></td>
						</tr>						
                      <tr>
						<td width="88"><div id="detDoc" align="left"><strong>N° OC</strong></div></td>
						<td width="10">:</td>
						<td width="214"><%f_busqueda.DibujaCampo("tipo_doc")%></td>
                      </tr>                      
                    </table>
                  </div></td>
                  <td width="19%"><div align="center"><%f_botonera.DibujaBoton("buscar")%></div></td>
                </tr>
              </table>
            </form></td>
                <td width="7" align="right" background="../imagenes/der.gif">&nbsp;</td>
              </tr>
              <tr>
                <td align="left" valign="top"><img src="../imagenes/base1.gif" width="9" height="13"></td>
                <td valign="top" bgcolor="#D8D8DE"><img src="../imagenes/base2.gif" width="400" height="13"></td>
                <td align="right" valign="top"><img src="../imagenes/base3.gif" width="7" height="13"></td>
              </tr>
            </table>			
          </td>
      </tr>
    </table>
<br>
<% if rut_e <> "" then %>
	<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
      <tr>
        <td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
        <td height="8" background="../imagenes/top_r1_c2.gif"></td>
        <td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
      </tr>
      <tr>
        <td width="9" background="../imagenes/izq.gif">&nbsp;</td>		
        <td><table width="100%"  border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td></td>
          </tr>
          <tr>
            <td height="2" background=""></td>
          </tr>
          <tr>
            <td><div align="center">
              <br>
              <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                <tr>
                  <td>
					
						<table width="96%"  border="0" cellspacing="0" cellpadding="0">
                        	<tr>
                            	<td colspan="3"><%pagina.DibujarSubtitulo "Datos del documento "%><br/><br/>
                            </tr>
							<tr>
								<td width="42%"><strong><%= response.Write("Razón social OTEC, CFT o entidad niveladora") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
								<td width="55%"><%= response.Write("Universidad Del Pacífico") %></td>
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr>
							<tr>
								<td width="42%"><strong><%= response.Write("RUT OTEC, CFT o entidad niveladora") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
								<td width="55%"><%= response.Write("71.704.700-1") %></td>
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr>
                            <tr>
								<td width="42%"><strong><%= response.Write("Razón social de la empresa") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
									<td width="55%"><%= response.Write(nombre_e) %></td>
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr>
                            <tr>
								<td width="42%"><strong><%= response.Write("RUT empresa") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
								<td width="55%"><%= response.Write(rut_e) %></td>								
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr>                            
                            <tr>
								<td width="42%"><strong><%= response.Write("Razón social OTIC (si corresponde a actividad intermediada por éste)") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
								<% if estado = 2 or estado = 3 then %>
									<td width="55%"><%= response.Write(nombre_ot) %></td>
								<% else %>
									<td width="55%"><%= response.Write("-") %></td>
								<% end if %>	
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr>
                            <tr>
								<td width="42%"><strong><%= response.Write("RUT OTIC (si corresponde a actividad intermediada por éste)") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
								<% if estado = 2 or estado = 3 then %>
									<td width="55%"><%= response.Write(rut_ot) %></td>
								<% else %>
									<td width="55%"><%= response.Write("-") %></td>
								<% end if %>
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr>  
                            <tr>
								<td width="42%"><strong><%= response.Write("Nombre de la actividad") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
								<td width="55%"><%= response.Write(nom_dip) %></td>
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr>   
                            <tr>
								<td width="42%"><strong><%= response.Write("Código Sence") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
								<td width="55%"><%= response.Write(cod_sence) %></td>
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr>  
                            <tr>
								<td width="42%"><strong><%= response.Write("Fecha inicio") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
								<td width="55%"><%= response.Write(dgso_finicio) %></td>
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr>  
                            <tr>
								<td width="42%"><strong><%= response.Write("Fecha término") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
								<td width="55%"><%= response.Write(dgso_ftermino) %></td>
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr> 
							<tr>
								<td style="text-align:justify;" width="42%"><strong><%= response.Write("N° de horas (para actividades parciales o complementarias, indicar número efectivo de horas realizadas en el año correspondiente") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
								<% if multianio = "0" then %>
								<td width="55%" <% if Cstr(horas)=errorDeInfo then response.Write("class='noEncontrado'") end if %> ><% response.Write(horas) %></td>
								<% end if %>
								<% if multianio = "1" then %>
								<td <% if Cstr(horas)=errorDeInfo then response.Write("class='noEncontrado'") end if %> width="55%" ><% response.Write(horas&", Complementario ( " & horasMA & " )") %></td>
								<% end if %>
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr> 
                            <tr>
								<td style="text-align:justify;" width="42%"><strong><%= response.Write("N° de factura (o de orden de compra o trabajo, para actividades intermediadas por OTIC.") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
								<% if multianio = "0" then %>
									<% if factura <> "" then %>
										<td width="55%" <% if factura=errorDeInfo then response.Write("class='noEncontrado'") end if %> ><%= response.Write("Num. Factura: " & factura) %></td>
										<% else %>
										<td width="55%"><%= response.Write(tipo_doc) %></td>
									<% end if %>
								<% end if %>
								<% if multianio = "1" then %>
									<% if factura <> "" then %>
										<td width="55%" <% if factura=errorDeInfo then response.Write("class='noEncontrado'") end if %>  ><%= response.Write("Num. Factura: " & factura & " / " & facturaMA & " (Complementario)") %></td>
										<% else %>
										<td width="55%" <% if factura=errorDeInfo or dorc_num_ocMA=errorDeInfo then response.Write("class='noEncontrado'") end if %> ><% response.Write(tipo_doc&", Complementario ( " & dorc_num_ocMA & " )") %></td>
									<% end if %>								
								<% end if %>
								
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr>   
                            <tr>
								<td width="42%"><strong><%= response.Write("N° registro acción Sence") %></strong></td>
								<td width="3%" align="center"><strong>:</strong></td>
								<% if multianio = "0" then %>
								<td width="55%" <% if accion_sense=errorDeInfo then response.Write("class='noEncontrado'") end if %>><%= response.Write(accion_sense) %></td>
								<% end if %>
								<% if multianio = "1" then %>
								<td width="55%" <% if accion_sense=errorDeInfo then response.Write("class='noEncontrado'") end if %> ><% response.Write(accion_sense&", Complementario ( " & accion_senseMA & " )") %></td>
								<% end if %>								
							</tr>
                            <tr>
                            	<td colspan="3"><hr /></td>
							</tr>                                                                                      
			
						  </table>
						  
				</td>
                </tr>
              </table>
              </div>			  
              <form name="edicion">
				<input type="hidden" name="pers_nrut" value="<%=q_pers_nrut%>" >
				<input type="hidden" name="pers_xdv" value="<%=q_pers_xdv%>" >
				<input type="hidden" name="tipo_persona" value="<%=q_tipo_persona%>" >
				<input type="hidden" name="indice" value="<%=v_indice%>" >
                <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">
                  <tr>
                    <td><%pagina.DibujarSubtitulo "Participantes "%>

                      <table width="98%"  border="0" align="center" cellpadding="0" cellspacing="0">                        
						<% if multianio <> "" and multianio = "0" then %>
						<tr>
							<td><div align="right">P&aacute;ginas : <%f_cargo.AccesoPagina%></div></td>
						</tr>
                        <tr>
                          <td><% f_cargo.DibujaTabla %></td> 
                        </tr>  
						<% end if %>                        
						<% if multianio <> "" and multianio = "1" then %>
						<tr>
							<td><div align="right">P&aacute;ginas : <%f_cargo2.AccesoPagina%></div></td>
						</tr>						
                        <tr>
						 <td><% f_cargo2.DibujaTabla%></td>
                         </tr>
                         <tr>
							<td align="right" ><% f_botonera.DibujaBoton "guardar" %><td>
						 </tr>
						 <% end if %>						 
                      </table></td>
                  </tr>
                </table>


                          <br>
            </form></td></tr>
        </table></td>
        <td width="7" background="../imagenes/der.gif">&nbsp;</td>
      </tr>
      <tr>
        <td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
        <td height="28"><table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td width="23%" height="20"><div align="center">
              <table width="90%"  border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><div align="center">
				  <%
				   if(multianio = "1") then
					f_botonera.agregaBotonParam  "anioCalendario",	"deshabilitado", "TRUE"
				  end if
					f_botonera.agregaBotonParam  "anioCalendario", "funcion" , "pdf_1('"&pers_nrut&"', '"&pers_xdv&"','"&tipo_persona&"','"&tipo_doc&"','1');"
					f_botonera.dibujaboton "anioCalendario"  
				  %></div></td>
                  <td><div align="center">
				  <%
				  if(multianio = "0") then
					f_botonera.agregaBotonParam  "anioParcial",	"deshabilitado", "TRUE"
				  end if
					f_botonera.agregaBotonParam  "anioParcial", "funcion" , "pdf_1('"&pers_nrut&"', '"&pers_xdv&"','"&tipo_persona&"','"&tipo_doc&"','2')"
					f_botonera.dibujaboton "anioParcial"  
				  %></div></td>				  
				  <td><div align="center">
				  <%
				  if(multianio = "0") then
					f_botonera.agregaBotonParam  "anioComplementario",	"deshabilitado", "TRUE"
				  end if
					f_botonera.agregaBotonParam  "anioComplementario", "funcion" , "pdf_1('"&pers_nrut&"', '"&pers_xdv&"','"&tipo_persona&"','"&tipo_doc&"','3')"
					f_botonera.dibujaboton "anioComplementario"  
				  %></div></td>
                  </tr>
              </table>
            </div></td>
            <td width="77%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
            </tr>
          <tr>
            <td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
          </tr>
        </table></td>
        <td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
      </tr>
    </table>
	<% end if %>
	<br>
	<br>
	</td>
  </tr>  
  
</table>
</body>
</html>
