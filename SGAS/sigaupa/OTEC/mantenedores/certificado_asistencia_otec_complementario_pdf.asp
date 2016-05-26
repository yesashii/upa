<!-- #include file = "../biblioteca/fpdf.asp" -->
<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
'for each k in request.querystring
'	response.write(k&"="&request.querystring(k)&"<br>")
'next
'response.End()
set conexion = new CConexion
conexion.Inicializar "upacifico"
set negocio = new CNegocio
negocio.Inicializa conexion
set errores = new cErrores
'-------------variables traídas
pers_nrut		= Request.QueryString("pers_nrut")
pers_xdv		= Request.QueryString("pers_xdv")
tipo_persona	= Request.QueryString("tipo_persona")
tipo_doc		= Request.QueryString("tipo_doc")
'-------------variables traídas
estado			= 4
errorDeInfo 	= "No existe la información en la base de datos"

'-------------------------------
set f_portada = new CFormulario
f_portada.Carga_Parametros "tabla_vacia.xml", "tabla"
f_portada.Inicializar conexion
fechaActual = conexion.consultaUno("select protic.trunc( GETDATE())") ' Poner sólo fecha dá problemas
'-------------------------------
'*************************************************************************************'
'**																					**'
'**					INICIO DE CAPTURA DE VARIABLES PARA LA TABLA 1				   	**'
'**																					**'
'*************************************************************************************'
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
					"select distinct a.empr_ncorr                             		" & vbCrLf & _
					"from   ordenes_compras_otec as a                		" & vbCrLf & _
					"       inner join postulacion_otec as b         		" & vbCrLf & _
					"               on a.dgso_ncorr = b.dgso_ncorr   		" & vbCrLf & _
					"                  and cast(b.norc_empresa as varchar) = '"&tipo_doc&"' 	" & vbCrLf & _
					"where  a.empr_ncorr_2 is null                   		" & vbCrLf & _
					"       and cast(empr_ncorr as varchar) = '"&empr_ncorr&"'        		"
					
		condicionEmpresa = conexion.consultaUno("select isnull(("&consulta&"),'0')")		
	'**condicionEmpresa<<
	
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
						"select dgso_ncorr                   " & vbCrLf & _
						"from   ordenes_compras_otec         " & vbCrLf & _
						"where  cast(nord_compra as varchar) = '"&tipo_doc&"' " 
				dgso_ncorr = conexion.consultaUno(consulta)
			'**dgso_ncorr<<

			'**empr_ncorr>>
				consulta = "" & vbCrLf & _
				"select empr_ncorr                  " & vbCrLf & _
				"from   empresas                    " & vbCrLf & _
				"where  cast(empr_nrut as varchar) = '"&pers_nrut&"' "
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
				"select protic.trunc(dgso_finicio)    	" & vbCrLf & _	
				"from   datos_generales_secciones_otec 	" & vbCrLf & _
				"where  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'  	" 
				dgso_finicio = conexion.consultaUno(consulta)
			'**dgso_finicio<<
		
			'**dgso_ftermino>>
				consulta = "" & vbCrLf & _
				"select protic.trunc(dgso_ftermino)	   	" & vbCrLf & _	
				"from   datos_generales_secciones_otec 	" & vbCrLf & _
				"where  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'  	" 
				dgso_ftermino = conexion.consultaUno(consulta)	
			'**dgso_ftermino<<					
		'-----------------------variables	
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
										"select isnull(b.dcur_nombre_sence, b.dcur_tdesc) " & vbCrLf & _
										"from   datos_generales_secciones_otec as a       " & vbCrLf & _
										"       inner join diplomados_cursos as b         " & vbCrLf & _
										"               on a.dcur_ncorr = b.dcur_ncorr    " & vbCrLf & _
										"where  cast(a.dgso_ncorr as varchar) = '"&dgso_ncorr&"'           " 
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
										"select isnull(cast(f.dorc_naccion_sence as varchar) , '"&errorDeInfo&"') as accion_sense " & vbCrLf & _
										"from   personas as a                                                       " & vbCrLf & _
										"       inner join postulacion_otec as b                                    " & vbCrLf & _
										"               on a.pers_ncorr = b.pers_ncorr                              " & vbCrLf & _
										"                 and cast(b.norc_empresa as varchar) = '"&tipo_doc&"'     	" & vbCrLf & _ 
										"                  and epot_ccod = '4' 										" & vbCrLf & _
										"       inner join datos_generales_secciones_otec as c                      " & vbCrLf & _
										"               on b.dgso_ncorr = c.dgso_ncorr                              " & vbCrLf & _
										"       inner join diplomados_cursos as d                                   " & vbCrLf & _
										"               on c.dcur_ncorr = d.dcur_ncorr                              " & vbCrLf & _
										"       inner join empresas as e                                            " & vbCrLf & _
										"               on b.empr_ncorr_empresa = e.empr_ncorr                      " & vbCrLf & _
										"                 and cast(e.empr_nrut as varchar)= '" & pers_nrut & "'     " & vbCrLf & _
										"       inner join detalle_ordenes_compras_otec as f 						" & vbCrLf & _	
										"               on b.norc_empresa = f.dorc_num_oc                           " & vbCrLf & _
										"                  and f.anos_ccod = datepart(year, c.dgso_ftermino)   		"
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
	consulta_horas 		= "" & vbCrLf & _  
						"select isnull(cast(f.dorc_nhoras as varchar) , '"&errorDeInfo&"')          as horas                           						" & vbCrLf & _
						"from   personas as a                                                       " & vbCrLf & _
						"       inner join postulacion_otec as b                                    " & vbCrLf & _
						"               on a.pers_ncorr = b.pers_ncorr                              " & vbCrLf & _
						"                 and cast(b.norc_empresa as varchar) = '"&tipo_doc&"'     	" & vbCrLf & _ 
						"                  and epot_ccod = '4' 										" & vbCrLf & _
						"       inner join datos_generales_secciones_otec as c                      " & vbCrLf & _
						"               on b.dgso_ncorr = c.dgso_ncorr                              " & vbCrLf & _
						"       inner join diplomados_cursos as d                                   " & vbCrLf & _
						"               on c.dcur_ncorr = d.dcur_ncorr                              " & vbCrLf & _
						"       inner join empresas as e                                            " & vbCrLf & _
						"               on b.empr_ncorr_empresa = e.empr_ncorr                      " & vbCrLf & _
						"                 and cast(e.empr_nrut as varchar) = '" & pers_nrut & "'    " & vbCrLf & _
						"       inner join detalle_ordenes_compras_otec as f 						" & vbCrLf & _	
						"               on b.norc_empresa = f.dorc_num_oc                           " & vbCrLf & _
						"                  and f.anos_ccod = datepart(year, c.dgso_ftermino)   		"								
					horas_aux 		= conexion.consultaUno("select isnull((" & consulta_horas& "),'"&errorDeInfo&"')")		
					if horas_aux = "0" then
						'response.write("horas_aux = "&horas_aux	&"<br/>")
						'horas = "No existe información."
					else
						horas = horas_aux
					end if						
				'**horas<<	
				
				'**NumFactura>>	
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
						"                                      where  cast(pers_nrut as varchar) = '"&pers_nrut&"') "
						if 	len(""&factura) = 0 then
							factura = " No existe la factura hasta la fecha "
						end if
				'**NumFactura<<
				'------------------DATOS PARCIALES<<			
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
				"select protic.trunc(dgso_finicio)   	" & vbCrLf & _	
				"from   datos_generales_secciones_otec 	" & vbCrLf & _
				"where  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'  	" 
				dgso_finicio = conexion.consultaUno(consulta)
			'**dgso_finicio<<
			
			'**dgso_ftermino>>
				consulta = "" & vbCrLf & _
				"select protic.trunc(dgso_ftermino)				   	" & vbCrLf & _	
				"from   datos_generales_secciones_otec 	" & vbCrLf & _
				"where  cast(dgso_ncorr as varchar) = '"&dgso_ncorr&"'  	" 
				dgso_ftermino = conexion.consultaUno(consulta)	
			'**dgso_ftermino<<	
						
		'-----------------------variables		
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
										"select cast(isnull(b.dcur_nombre_sence, b.dcur_tdesc) as varchar) " & vbCrLf & _
										"from   datos_generales_secciones_otec as a       " & vbCrLf & _
										"       inner join diplomados_cursos as b         " & vbCrLf & _
										"               on a.dcur_ncorr = b.dcur_ncorr    " & vbCrLf & _
										"where  cast(a.dgso_ncorr as varchar) = '"&dgso_ncorr&"'   " 
					nom_dip 			= conexion.consultaUno("select isnull((" & consulta_nom_dip & "),'"&errorDeInfo&"')")						
				'**nom_dip<<
				
				'**cod_sence>>
					consulta_cod_sence 	= "" & vbCrLf & _
										"select cast(dcur_nsence as varchar)    		  " & vbCrLf & _
										"from   datos_generales_secciones_otec as a       " & vbCrLf & _
										"       inner join diplomados_cursos as b         " & vbCrLf & _
										"               on a.dcur_ncorr = b.dcur_ncorr    " & vbCrLf & _
										"where  cast(a.dgso_ncorr as varchar) = '"&dgso_ncorr&"'       " 
					cod_sence 			= conexion.consultaUno("select isnull((" & consulta_cod_sence & "),'"&errorDeInfo&"')")	
				
				'**cod_sence<<	
				'**accion_sense>>
					consulta_accion_sense 	= "select " & vbCrLf & _
											"isnull(cast(f.dorc_naccion_sence as varchar) , '"&errorDeInfo&"')  as accion_sense" & vbCrLf & _
						"from   personas as a                                                       " & vbCrLf & _
						"       inner join postulacion_otec as b                                    " & vbCrLf & _
						"               on a.pers_ncorr = b.pers_ncorr                              " & vbCrLf & _
						"                 and cast(b.norc_empresa as varchar) = '"&tipo_doc&"'     	" & vbCrLf & _ 
						"                 and epot_ccod = '4' 										" & vbCrLf & _
						"       inner join datos_generales_secciones_otec as c                      " & vbCrLf & _
						"               on b.dgso_ncorr = c.dgso_ncorr                              " & vbCrLf & _
						"       inner join diplomados_cursos as d                                   " & vbCrLf & _
						"               on c.dcur_ncorr = d.dcur_ncorr                              " & vbCrLf & _
						"       inner join empresas as e                                            " & vbCrLf & _
						"               on b.empr_ncorr_empresa = e.empr_ncorr                      " & vbCrLf & _
						"                 and cast(e.empr_nrut as varchar) = '" & pers_nrut & "'    " & vbCrLf & _
						"       inner join detalle_ordenes_compras_otec as f 						" & vbCrLf & _	
						"               on b.norc_empresa = f.dorc_num_oc                           " & vbCrLf & _
						"                  and f.anos_ccod = datepart(year, c.dgso_ftermino)   		"									
					
					
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
						"select isnull(cast(f.dorc_nhoras as varchar), '"&errorDeInfo&"')          as horas		    " & vbCrLf & _
						"from   personas as a                                                       " & vbCrLf & _
						"       inner join postulacion_otec as b                                    " & vbCrLf & _
						"               on a.pers_ncorr = b.pers_ncorr                              " & vbCrLf & _
						"                 and cast(b.norc_empresa as varchar) = '"&tipo_doc&"'     	" & vbCrLf & _ 
						"                  and epot_ccod = '4' 										" & vbCrLf & _
						"       inner join datos_generales_secciones_otec as c                      " & vbCrLf & _
						"               on b.dgso_ncorr = c.dgso_ncorr                              " & vbCrLf & _
						"       inner join diplomados_cursos as d                                   " & vbCrLf & _
						"               on c.dcur_ncorr = d.dcur_ncorr                              " & vbCrLf & _
						"       inner join empresas as e                                            " & vbCrLf & _
						"               on b.empr_ncorr_empresa = e.empr_ncorr                      " & vbCrLf & _
						"                 and cast(e.empr_nrut as varchar) = '" & pers_nrut & "'    " & vbCrLf & _
						"       inner join detalle_ordenes_compras_otec as f 						" & vbCrLf & _	
						"               on b.norc_empresa = f.dorc_num_oc                           " & vbCrLf & _
						"                  and f.anos_ccod = datepart(year, c.dgso_ftermino)   		"	
					
					horas_aux 		= conexion.consultaUno("select isnull((" & consulta_horas & "),'"&errorDeInfo&"')")	
										
				'response.Write("<pre>select isnull((" & consulta_accion_sense & "),'"&errorDeInfo&"')</pre>")
			        'response.End()

					if horas_aux = "0" then
						'response.write("horas_aux = "&horas_aux	&"<br/>")
						horas = errorDeInfo
					else
						horas = horas_aux
					end if						
				'**horas<<	
				
				'------------------DATOS PARCIALES<<					
		'--------------------------------------<<VARIABLES PARA EL DOCUMENTO
	end if'if estado = 3 then
'*********************************************************************************'-------------
'**																				**'
'**								 	SI ES OTIC									**'
'**																				**'
'*********************************************************************************'


'*************************************************************************************'
'**																					**'
'**					FIN DE CAPTURA DE VARIABLES PARA LA TABLA 1					   	**'
'**																					**'
'*************************************************************************************'


'*********************'
'* creación del pdf  *'
'*********************'   
Set pdf=CreateJsObject("FPDF")
pdf.CreatePDF "p","mm","Letter"
pdf.SetPath("../biblioteca/fpdf/" )
pdf.LoadModels("certificado_de_asistencia") 
'pdf.SetAutoPageBreak TRUE,20
pdf.SetFont "Arial","B",12
pdf.Open()
pdf.AddPage()
'*********************'  

'------------------------------------ACTIVIDADES>>
'-----------------------------linea_1>>
pdf.SetFont "Arial","B",14
pdf.SetX(22)
pdf.Cell 10,9,"X","1","0","C"
pdf.SetFont "Arial","",9
pdf.Cell 65,2,"","0","1","L"
pdf.SetX(32)
pdf.Cell 65,5,"Actividad dentro del año calendario","0","1","L"
pdf.SetX(32)
pdf.Cell 65,2,"","0","1","L"
pdf.SetX(22)
pdf.Cell 75,2,"","0","1","L"
'-----------------------------linea_1<<
'-----------------------------linea_1>>
pdf.SetFont "Arial","B",14
pdf.SetX(22)
pdf.Cell 10,9,"","1","0","C"
pdf.SetFont "Arial","",9
pdf.Cell 65,2,"","0","1","L"
pdf.SetX(32)
pdf.Cell 65,5,"Actividad parcial","0","1","L"
pdf.SetX(32)
pdf.Cell 65,2,"","0","1","L"
pdf.SetX(22)
pdf.Cell 75,2,"","0","1","L"
'-----------------------------linea_1<<
'-----------------------------linea_1>>
pdf.SetFont "Arial","B",14
pdf.SetX(22)
pdf.Cell 10,9,"","1","0","C"
pdf.SetFont "Arial","",9
pdf.Cell 65,2,"","0","1","L"
pdf.SetX(32)
pdf.Cell 65,5,"Actividad complementaria","0","1","L"
pdf.SetX(32)
pdf.Cell 65,2,"","0","1","L"
pdf.SetX(22)
pdf.Cell 75,2,"","0","1","L"
'-----------------------------linea_1<<
'-----------------------------mini pié>>
pdf.SetX(22)
pdf.SetFont "Arial","",9
pdf.Cell 178,4,"Se  extiende  el   presente   certificado   de   asistencia   correspondiente   a   la  actividad   de   capacitación   que   a","0","1","L"
pdf.SetX(22)
pdf.Cell 75,1,"","0","1","L"
pdf.SetX(22)
pdf.Cell 178,3,"continuación se señala:","0","1","L"
'-----------------------------mini pié<<
pdf.ln(2)
'------------------------------------ACTIVIDADES<<
function setFila( texto_1, texto_2 )	
	largo_1 = len(texto_1)
	largo_2 = len(texto_2)
	pdf.SetX 15
	if largo_2 > largo_1 then
	'---------------------------------caso texto_2 > texto_1
		pdf.SetFont "Arial","",8
		y1 = pdf.GetY()
		x1 = pdf.GetX() + 92
		pdf.SetXY x1,y1	
		pdf.MultiCell 92,4,texto_2,"1","J","0"	
		y = pdf.GetY()
		resta = y - y1
		pdf.SetXY x1 - 92,y1
		pdf.SetFont "Arial","B",9	
		pdf.MultiCell 92,resta,texto_1,"1","J","0"
	'---------------------------------caso texto_2 > texto_1
	else		
	'---------------------------------caso texto_2 < texto_1
		pdf.SetFont "Arial","B",9
		y1 = pdf.GetY()
		x1 = pdf.GetX()
		pdf.MultiCell 92,4,texto_1,"1","J","0"
		y = pdf.GetY()
		resta = y - y1
		pdf.SetXY x1 + 92,y1
		pdf.SetFont "Arial","",8	
		pdf.MultiCell 92,resta,texto_2,"1","J","0"	
	'---------------------------------caso texto_2 < texto_1	
	end if
	
	
end function

function setPrimeraFila2(val_x, val_y )
	yA = pdf.GetY()
	pdf.SetX 15
	pdf.SetFont "Arial","",9
	pdf.SetX 15
	pdf.Cell 10,5,"","0","0","C"
	if yA > 190 then
		pdf.Cell 30,5,"","0","1","C"
	end if
	pdf.Cell 30,5,"Participantes:","0","1","C"	
'----------------------------------------------------
	pdf.SetX 15
	pdf.SetFont "Arial","B",9	
	pdf.Cell 10,10,"N°","1","0","C"
	pdf.Cell 30,10,"RUT","1","0","C"
	pdf.Cell 34,10,"Apellido paterno","1","0","C"
	pdf.Cell 34,10,"Apellido materno","1","0","C"
	pdf.Cell 42,10,"Nombres","1","0","C"
	pdf.MultiCell 34,5,"Porcentaje asistencia","1","C","0"	
end function
function setelemento(num, rut, aPater, aMater, nom, porAsis )
	y = pdf.GetY()
	if y > 255 then
		pdf.Ln(5)
		setPrimeraFila2 "val","val"
	end if
	num2 = CStr(num)
	pdf.SetX 15
	pdf.SetFont "Arial","",8	
	pdf.Cell 10,6,num2,"1","0","C"
	pdf.Cell 30,6,RUT,"1","0","C"
	pdf.Cell 34,6,aPater,"1","0","C"
	pdf.Cell 34,6,aMater,"1","0","C"
	pdf.Cell 42,6,nom,"1","0","C"
	pdf.Cell 34,6,porAsis&"%","1","1","C"
end function

'*********************'
'**	PRIMERA TABLA	**'
'*********************'
'------------------------------------------------------------
'>>>>>>>>>>>>>>fila_1
	text_1 = "Razón social OTEC, CFT o entidad niveladora"
	text_2 = "Universidad Del Pacífico"
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_1
'>>>>>>>>>>>>>>fila_2
	text_1 = "RUT OTEC, CFT o entidad niveladora"
	text_2 = "71.704.700-1"
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_2
'>>>>>>>>>>>>>>fila_2.5
	text_1 = "Razón social empresa"
	text_2 = nombre_e		
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_2.5
'>>>>>>>>>>>>>>fila_3
	text_1 = "RUT empresa"
	text_2 = "78623820-K"		
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_3
'>>>>>>>>>>>>>>fila_4	
	text_1 = "Razón social OTIC (si corresponde a actividad intermediada por éste)"
	if estado = 2 or estado = 3 then
		text_2 = nombre_ot 	
	else
		text_2 = "" 	
	end if
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_4
'>>>>>>>>>>>>>>fila_5
	text_1 = "RUT OTIC (si corresponde a actividad intermediada por éste)"
	if estado = 2 or estado = 3 then
		text_2 = rut_ot 	
	else
		text_2 = "" 
	end if	
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_5
'>>>>>>>>>>>>>>fila_6
	text_1 = "Nombre de la actividad¹"
	text_2 = nom_dip 
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_6
'>>>>>>>>>>>>>>fila_7
	text_1 = "Código Sence"
	text_2 = cod_sence 
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_7
'>>>>>>>>>>>>>>fila_8
	text_1 = "Fecha inicio"
	text_2 = dgso_finicio	
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_8
'>>>>>>>>>>>>>>fila_9
	text_1 = "Fecha término"
	text_2 = dgso_ftermino
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_9
'>>>>>>>>>>>>>>fila_10
	text_1 = "N° de horas (para actividades parciales o complementarias, indicar número efectivo de horas realizadas en el año correspondiente"
	text_2 = horas 
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_10
'>>>>>>>>>>>>>>fila_11
	text_1 = "N° de factura (o de orden de compra o trabajo, para actividades intermediadas por OTIC."
	if estado = 1 then
		text_2 = "Num. Factura: "&factura
	else
		text_2 = tipo_doc
	end if
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_11
'>>>>>>>>>>>>>>fila_12
	text_1 = "N° registro acción Sence"
	text_2 = accion_sense 
	setFila text_1, text_2
'>>>>>>>>>>>>>>fila_12

'*********************'-------------------
'**	PRIMERA TABLA	**'
'*********************'


'*****************************'
'**	  TABLA PARTICIPANTES	**'
'*****************************'
pdf.ln(5)
numInt = 1
setPrimeraFila2 "uno", "dos"
'>>>>>>>>>>>>>>
'-------------------------------------------------------------------------------------------------------------

set f_cargo = new CFormulario
f_cargo.Carga_Parametros "tabla_vacia.xml", "tabla"
f_cargo.Inicializar conexion
consulta = "" & vbCrLf & _
"select protic.obtener_rut(a.pers_ncorr) as rut, 						" & vbCrLf & _
"       case a.pers_tnombre 											" & vbCrLf & _
"         when '' then '' 												" & vbCrLf & _
"         else protic.initcap(a.pers_tnombre) 							" & vbCrLf & _
"       end                              as pers_tnombre, 				" & vbCrLf & _
"       case a.pers_tape_paterno 										" & vbCrLf & _
"         when '' then '' 												" & vbCrLf & _
"         else protic.initcap(a.pers_tape_paterno) 						" & vbCrLf & _
"       end                              as pers_tape_paterno, 			" & vbCrLf & _
"       case a.pers_tape_materno 										" & vbCrLf & _
"         when '' then '' 												" & vbCrLf & _
"         else protic.initcap(a.pers_tape_materno) 						" & vbCrLf & _
"       end                              as pers_tape_materno, 			" & vbCrLf & _
"       isnull(e.pote_nasistencia_complementaria, '0')  as asistencia	" & vbCrLf & _
"from   personas as a                                             		" & vbCrLf & _
"       inner join postulacion_otec as b                          		" & vbCrLf & _
"               on a.pers_ncorr = b.pers_ncorr                    		" & vbCrLf & _
"                  and epot_ccod = '4'                            		" & vbCrLf & _
"                  and isnull(norc_empresa, norc_otic) = '"&tipo_doc&"' " & vbCrLf & _
"       inner join postulacion_otec_asistencias_parciales as e          " & vbCrLf & _	
"               on b.pote_ncorr = e.pote_ncorr                    		" & vbCrLf & _	
"       inner join datos_generales_secciones_otec as c            		" & vbCrLf & _
"               on b.dgso_ncorr = c.dgso_ncorr                    		" & vbCrLf & _
"       inner join ordenes_compras_otec as d                      		" & vbCrLf & _
"               on c.dgso_ncorr = d.dgso_ncorr                    		" & vbCrLf & _
"                  and cast(nord_compra as varchar) = '"&tipo_doc&"'    " 


'response.write("<pre>"&consulta&"</pre>")                  
'response.end()                                             
f_cargo.Consultar consulta                                  
'---------------------------------------------------------------------------------------------------
'------------------------------------------------------------
while f_cargo.Siguiente
	'---------variables
	rut 						= f_cargo.obtenerValor("rut")
	pers_tnombre 				= f_cargo.obtenerValor("pers_tnombre")
	pers_tape_paterno 			= f_cargo.obtenerValor("pers_tape_paterno")
	pers_tape_materno 			= f_cargo.obtenerValor("pers_tape_materno")
	asistencia 					= f_cargo.obtenerValor("asistencia")
	'---------variables
	setelemento numInt, rut, pers_tape_paterno, pers_tape_materno, pers_tnombre, asistencia 
	numInt = numInt + 1
wend
'-----------------------------------------------------


'-----------------------------------------------------

'>>>>>>>>>>>>>>
'------------------------------------------------------------
'*****************************'
'**	  TABLA PARTICIPANTES	**'
'*****************************'




'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>tabla_3
pdf.Ln(3)
y = pdf.GetY()
pdf.Sety 191
if y > 192 then
	pdf.AddPage()
	y2 = (187)
	pdf.Sety y2
end if

'pdf.MultiCell 47,4,"y = "&y,"1","J",""
'---------fila_1
pdf.SetX 15 
pdf.SetFont "Arial","B",9
y1 = pdf.GetY()
x1 = pdf.GetX()
'--------------------------------------------------firmaImagen
pdf.Image "../imagenes/firma.jpg", 65, y1 - 5, 50, 30, "JPG"
'--------------------------------------------------firmaImagen
pdf.MultiCell 47,4,"Firma representante legal OTEC, CFT o entidad niveladora","1","J","0"
y = pdf.GetY()
resta = y - y1
pdf.SetXY x1 + 47,y1
pdf.SetFont "Arial","",9	
pdf.MultiCell 47,resta,"","1","J","0"	
'---------fila_1
'---------fila_2
pdf.SetX 15 
pdf.SetFont "Arial","B",9
y1 = pdf.GetY()
x1 = pdf.GetX()
pdf.MultiCell 47,4,"Nombre representante legal OTEC, CFT o entidad niveladora","1","J","0"
y = pdf.GetY()
resta = y - y1
pdf.SetXY x1 + 47,y1
pdf.SetFont "Arial","",9	
pdf.MultiCell 47,resta,"Ítalo Giraudo Torres","1","C","0"	
'---------fila_2
'---------fila_3
pdf.SetX 15 
pdf.SetFont "Arial","B",9
y1 = pdf.GetY()
x1 = pdf.GetX()
pdf.MultiCell 47,4,"RUT representante legal OTEC, CFT o entidad niveladora","1","J","0"
y = pdf.GetY()
resta = y - y1
pdf.SetXY x1 + 47,y1
pdf.SetFont "Arial","",9	
pdf.MultiCell 47,resta,"6.629.316-5","1","C","0"	

pdf.SetXY x1 + 130,y1
pdf.SetFont "Arial","",9	
pdf.MultiCell 47,resta,"Fecha emición: "&fechaActual,"1","C","0"
'---------fila_3
'>>>>>>>>>>>>>>>>>>>>>>>>>>>>>tabla_3
'>>>>>>>>>>>>>>>>>>>>>>>firma
pdf.SetX 25 
pdf.Cell 40,12,"","B","1","L"
'>>>>>>>>>>>>>>>>>>>>>>>firma
pdf.Ln(8)
'>>>>>>>>>>>>>>>>>>>>>>>leyenda
pdf.SetX 25 
y1 = pdf.GetY()
x1 = pdf.GetX()
pdf.Cell 160,16,"","1","1","L"
pdf.SetXY x1 + 1,y1 + 1

pdf.SetFont "Arial","",7
pdf.MultiCell 158,14,"","1","J","0"
pdf.SetXY x1 + 1,y1 + 2
pdf.MultiCell 158,3,"1- Actividad de capacitación financiada, total o parcialmente, a través de la franquicia tributaria de capacitación, administrada por el Servicio de Capacitación y Empleo, Gobierno de Chile. Actividad no conducente al otorgamiento de un título o grado académico, a excepción de los módulos de formación en competencias laborales normadas por el decreto supremo N°186.","0","J","0"
'x = pdf.GetX()
pdf.Ln(1)
pdf.SetX x1 + 1
pdf.MultiCell 158,3,"2- O de algún responsable del OTEC debidamente autorizado por el Servicio.","0","J","0"

'>>>>>>>>>>>>>>>>>>>>>>>leyenda

'----------------------------fin pdf
pdf.Close()
pdf.Output()
%>





