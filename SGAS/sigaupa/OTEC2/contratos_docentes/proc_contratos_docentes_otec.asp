<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->
<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

usuario = negocio.ObtenerUsuario()

'for each k in request.form
'	response.write(k&"="&request.Form(k)&"<br>")
'next


'response.write(FormatCurrency(20000,2))
'numero=FormatCurrency(20000,2)
'response.Write(numero)
'response.End()
cont=0

set formulario = new CFormulario
formulario.Carga_Parametros "contratos_docentes_otec.xml", "generar_contratos"
formulario.Inicializar conexion
formulario.ProcesaForm		
contador1=0	
contador2=0
conta_nom=0

contador_gra=0
conta_con_contr=0
relator_creado=""

for fila = 0 to formulario.CuentaPost - 1
   v_persona 	= formulario.ObtenerValorPost (fila, "pers_ncorr")
   v_sede 		= formulario.ObtenerValorPost (fila, "sede_ccod")
   v_dcur_ncorr 	= formulario.ObtenerValorPost (fila, "dcur_ncorr")
 v_tcdo_ccod= formulario.ObtenerValorPost (fila, "tcdo_ccod")
z_tcdo_ccod= formulario.ObtenerValorPost (fila, "z_tcdo_ccod")			
guarda=0

if v_tcdo_ccod="" then
v_tcdo_ccod=z_tcdo_ccod
end if

if v_persona <> ""  then
 


		 
		 
						set f_maot_asignados  = new cformulario
						f_maot_asignados.carga_parametros "tabla_vacia.xml", "tabla" 
						f_maot_asignados.inicializar conexion							
						
						 
								sql="select  mot.MAOT_NCORR,"& vbCrLf &_
								"case when(select count(bro1.pers_ncorr)"& vbCrLf &_ 
								"from modulos_otec mo1,"& vbCrLf &_
								"mallas_otec mot1,"& vbCrLf &_
								"bloques_relatores_otec bro1,"& vbCrLf &_
								"bloques_horarios_otec bho1,"& vbCrLf &_
								"secciones_otec so1,"& vbCrLf &_
								"relatores_programa rp1"& vbCrLf &_
								"where mot1.mote_ccod=mo1.mote_ccod"& vbCrLf &_
								"and mot1.maot_ncorr=so1.maot_ncorr"& vbCrLf &_
								"and bho1.seot_ncorr=so1.seot_ncorr"& vbCrLf &_
								"and bho1.bhot_ccod=bro1.bhot_ccod"& vbCrLf &_
								"and bro1.pers_ncorr=rp1.pers_ncorr"& vbCrLf &_
								"and so1.dgso_ncorr=rp1.dgso_ncorr"& vbCrLf &_
								"and mot1.dcur_ncorr=mot.dcur_ncorr"& vbCrLf &_
								"and mot1.MAOT_NCORR=mot.MAOT_NCORR"& vbCrLf &_
								"group by mot1.MAOT_NCORR) =seot_ncantidad_relator then 'Si' else 'No' end as cant_asignada,so.seot_ncorr,so.dgso_ncorr,seot_ncantidad_relator"& vbCrLf &_
								 "from modulos_otec mo,"& vbCrLf &_
								 "mallas_otec mot,"& vbCrLf &_
								 "bloques_relatores_otec bro,"& vbCrLf &_
								 "bloques_horarios_otec bho,"& vbCrLf &_
								 "secciones_otec so,"& vbCrLf &_
								 "relatores_programa rp"& vbCrLf &_
								 "where mot.mote_ccod=mo.mote_ccod"& vbCrLf &_
								 "and mot.maot_ncorr=so.maot_ncorr"& vbCrLf &_
								 "and bho.seot_ncorr=so.seot_ncorr"& vbCrLf &_
								 "and bho.bhot_ccod=bro.bhot_ccod"& vbCrLf &_
								 "and bro.pers_ncorr=rp.pers_ncorr"& vbCrLf &_
								 "and so.dgso_ncorr=rp.dgso_ncorr"& vbCrLf &_
								 "and dcur_ncorr="&v_dcur_ncorr&""& vbCrLf &_
								 "and rp.pers_ncorr="&v_persona&""
						conta_nom=0		 
						
						'response.write("<br>"&sql)
						f_maot_asignados.consultar sql
						
						
						b_guarda="" 
						while f_maot_asignados.Siguiente
						
						cantidad_asignada=f_maot_asignados.ObtenerValor("cant_asignada")
						MAOT_NCORR=f_maot_asignados.ObtenerValor("MAOT_NCORR")
						seot_ncorr=f_maot_asignados.ObtenerValor("seot_ncorr")
						dgso_ncorr=f_maot_asignados.ObtenerValor("dgso_ncorr")
						seot_ncantidad_relator=f_maot_asignados.ObtenerValor("seot_ncantidad_relator")
						contador1=contador1+1
'						
						response.write("<br>cantidad_asignada= "&cantidad_asignada)
						response.write("<br>v_persona= "&v_persona)
'						
'								if cantidad_asignada="Si" then
'								'contador2=contador2+1
'						response.write("<br>contador1= "&contador1)
'						response.write("<br>contador2= "&contador2)
'								else
''										
'							
'								end if
''						
'						response.write("<br>contador1= "&contador1)
'						response.write("<br>contador2= "&contador2)
								if cantidad_asignada="Si" then
'						
'
'														
										contador_gra=contador_gra+1	 
										sql_tiene_contr="select case count(distinct mo.mote_ccod)when 0 then 'No' else 'Si'end"& vbCrLf &_ 
										"from modulos_otec mo, "& vbCrLf &_ 
										"mallas_otec mot, "& vbCrLf &_ 
										"bloques_relatores_otec bro," & vbCrLf &_ 
										"bloques_horarios_otec bho," & vbCrLf &_ 
										"secciones_otec so, "& vbCrLf &_ 
										"relatores_programa rp,"& vbCrLf &_ 
										"anexos_otec ane,"& vbCrLf &_
										"contratos_docentes_otec cdo"& vbCrLf &_
										"where mot.mote_ccod=mo.mote_ccod "& vbCrLf &_ 
										"and mot.maot_ncorr=so.maot_ncorr" & vbCrLf &_ 
										"and bho.seot_ncorr=so.seot_ncorr "& vbCrLf &_ 
										"and bho.bhot_ccod=bro.bhot_ccod "& vbCrLf &_ 
										"and bro.pers_ncorr=rp.pers_ncorr" & vbCrLf &_ 
										"and so.dgso_ncorr=rp.dgso_ncorr"& vbCrLf &_ 
										"and mo.mote_ccod=ane.mote_ccod "& vbCrLf &_ 
										"and ane.cdot_ncorr=cdo.cdot_ncorr"& vbCrLf &_ 
										"and cdo.ecdo_ccod=1"& vbCrLf &_
										"and mot.maot_ncorr="&MAOT_NCORR&"" & vbCrLf &_ 
										"and dcur_ncorr="&v_dcur_ncorr&""& vbCrLf &_
										"and cdo.pers_ncorr="&v_persona&""
										
										'response.Write(sql_tiene_contr)
										tiene_contr=conexion.ConsultaUno(sql_tiene_contr)
										'response.Write("<BR>"&tiene_contr)
									if tiene_contr = "No" then
													existe_pago_relatores=conexion.ConsultaUno("select count(monto_asignado) from pago_relatores_otec where seot_ncorr="&seot_ncorr&" and pers_ncorr="&v_persona&" and monto_asignado is not null")
													existe_hora_pago_relatores=conexion.ConsultaUno("select count(hora_asignada) from pago_relatores_otec where seot_ncorr="&seot_ncorr&" and pers_ncorr="&v_persona&" and hora_asignada is not null")
													
													response.write("<br>select count(hora_asignada) from pago_relatores_otec where seot_ncorr="&seot_ncorr&" and pers_ncorr="&v_persona&" and hora_asignada is not null <br>")
													response.write("<br>existe_hora_pago_relatores="&existe_hora_pago_relatores&"<br>")
													tcat_valor=conexion.ConsultaUno("select tcat_valor from  relatores_programa a,tipos_categoria b where a.tcat_ccod=b.tcat_ccod and pers_ncorr="&v_persona&" and dgso_ncorr="&dgso_ncorr&"")
													
													
													horas_programa=conexion.ConsultaUno("select maot_nhoras_programa from  mallas_otec where maot_ncorr="&MAOT_NCORR&"")
'													
															if cint(existe_pago_relatores) >0 then
															response.write("<br>existe_pago_relatores >0 <br>")
																monto1=conexion.ConsultaUno("select monto_asignado from pago_relatores_otec where seot_ncorr="&seot_ncorr&" and pers_ncorr="&v_persona&"")
																
																if existe_hora_pago_relatores="0" then
																monto2=CDbl(tcat_valor)*(round(CDbl(horas_programa)/CDbl(seot_ncantidad_relator)))
																
																else
																hora_pago_relatores=conexion.ConsultaUno("select hora_asignada from pago_relatores_otec where seot_ncorr="&seot_ncorr&" and pers_ncorr="&v_persona&"")
																monto2=CDbl(tcat_valor)*(CDbl(hora_pago_relatores))
																end if
																
																		response.write("<br>monto1= "&CDbl(monto1))
																		response.write("<br>monto2= "&CDbl(monto2))
															
																	if CDbl(monto2)<>CDbl(monto1) then
																		
																		nombre=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas where pers_ncorr="&v_persona&"")
																		busqueda5=InStr(relator,nombre)
																		Largo=Len(relator)
																		
'																		response.write("<br>busqueda6= "&busqueda6)
'																		response.write("<br>conta_nom= "&conta_nom)
												conta_nom=conta_nom+1
																			if  busqueda5=0 and Largo=0 then
																			
																			relator=nombre
																			end if
																			if  busqueda5=0 and Largo <>0 then
																		
																			relator=relator&", "&nombre
																			
																			end if
																		
																		
																		
																		
																		programa=conexion.ConsultaUno("Select distinct mo1.mote_tdesc from modulos_otec mo1,mallas_otec mot1,bloques_relatores_otec bro1,bloques_horarios_otec bho1,secciones_otec so1,relatores_programa rp1 where mot1.mote_ccod=mo1.mote_ccod and mot1.maot_ncorr=so1.maot_ncorr and bho1.seot_ncorr=so1.seot_ncorr and bho1.bhot_ccod=bro1.bhot_ccod and bro1.pers_ncorr=rp1.pers_ncorr and so1.dgso_ncorr=rp1.dgso_ncorr and mot1.dcur_ncorr="&v_dcur_ncorr&" and mot1.MAOT_NCORR="&MAOT_NCORR&"")
									busqueda11=InStr(msn_programa,programa)
									busqueda12=" y el "
									busqueda13=InStr(msn_programa2,busqueda12)
							  
						
																	if  busqueda11=0 then
																		if busqueda13=0 then
																		msn_programa2=programa
																		else
																		msn_programa2=msn_programa2&" y el "&programa2
																		end if
																		
																	end if
																	
																	C_error=C_error&" 2"
																	guarda=guarda+1
																	
																	'response.write("<br> si es =")
																	
																else
																'response.write("<br> no es =")
'																						
																		guarda=guarda+0
'																		
																		nombre_creado=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas where pers_ncorr="&v_persona&"")
																		busqueda9=InStr(relator_creado,nombre_creado)
																		Largo=Len(relator_creado)
												
																		if  busqueda9=0 and Largo=0 then
																			
																			relator_creado=nombre_creado
																			end if
																		if  busqueda9=0 and Largo <>0 then
																		
																			relator_creado=relator_creado&", "&nombre_creado
																			
																		end if
																		conta_nom=conta_nom+1
																end if
'																	
														else
															'response.write("<br>existe_pago_relatores <>0 <br>")
															existe_pago_relatores=conexion.ConsultaUno("select count(monto_asignado) from pago_relatores_otec where seot_ncorr="&seot_ncorr&"")
'															
															presupuesto_programa=conexion.ConsultaUno("select MAOT_NPRESUPUESTO_RELATOR from  mallas_otec where maot_ncorr="&MAOT_NCORR&"")
														
															
																if cint(existe_pago_relatore) >0 then
																
																'response.write("<br>existe_pago_relatores <>0  <br>")
																
																suma_pago_relatores=conexion.ConsultaUno("select sum(monto_asignado) from pago_relatores_otec where seot_ncorr="&seot_ncorr&"")
																relatore_pago_relatores=conexion.ConsultaUno("select count(pers_ncorr) from pago_relatores_otec where seot_ncorr="&seot_ncorr&"")
'																
'																		response.write("<br>suma_pago_relatores= "&suma_pago_relatores)
'																		response.write("<br>relatore_pago_relatores= "&relatore_pago_relatores)
'																		response.write("<br>conta_nom= "&conta_nom)
'											
'																
																relatores_del_presupuesto=CDbl(seot_ncantidad_relator)-CDbl(relatore_pago_relatores)
																resto_presupuesto=round((CDbl(presupuesto_programa)-CDbl(suma_pago_relatores))/CDbl(relatores_del_presupuesto))
																
																if existe_hora_pago_relatores="0" then
																monto3=CDbl(tcat_valor)*(round(CDbl(horas_programa)/CDbl(seot_ncantidad_relator)))
																
																else
																hora_pago_relatores=conexion.ConsultaUno("select hora_asignada from pago_relatores_otec where seot_ncorr="&seot_ncorr&" and pers_ncorr="&v_persona&"")
																monto3=CDbl(tcat_valor)*(CDbl(hora_pago_relatores))
																end if
																
																	if CDbl(monto3) <= CDbl(resto_presupuesto) then
																	response.write("<br>existe_pago_relatores <>0 1 <br>")
																	guarda=guarda+0
'																	
																	nombre_creado=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas where pers_ncorr="&v_persona&"")
																		busqueda20=InStr(relator_creado,nombre_creado)
																	Largo=Len(relator_creado)
												'response.write("<br>relator_creado antes= "&relator_creado&"<br>")
																		if  busqueda20=0 and Largo=0 then
																			
																			relator_creado=nombre_creado
																			end if
																		if  busqueda20=0 and Largo <>0 then
																		
																			relator_creado=relator_creado&", "&nombre_creado
																			
																		end if
																		conta_nom=conta_nom+1
												'response.write("<br>relator_creado despues= "&relator_creado&"<br>")
												
																	else
																		C_error=C_error&" 7"
																		programa33=conexion.ConsultaUno("Select distinct mo1.mote_tdesc from modulos_otec mo1,mallas_otec mot1,bloques_relatores_otec bro1,bloques_horarios_otec bho1,secciones_otec so1,relatores_programa rp1 where mot1.mote_ccod=mo1.mote_ccod and mot1.maot_ncorr=so1.maot_ncorr and bho1.seot_ncorr=so1.seot_ncorr and bho1.bhot_ccod=bro1.bhot_ccod and bro1.pers_ncorr=rp1.pers_ncorr and so1.dgso_ncorr=rp1.dgso_ncorr and mot1.dcur_ncorr="&v_dcur_ncorr&" and mot1.MAOT_NCORR="&MAOT_NCORR&"")
																	
																	busqueda30=InStr(programa_no_creado,programa33)
																		Largo=Len(programa_no_creado)
																	
																	nombre_no_creado=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas where pers_ncorr="&v_persona&"")
																	busqueda28=InStr(relator_no_creado,nombre_no_creado)
																		Largo=Len(relator_no_creado)
												
																		if  busqueda28=0 and Largo=0 then
																			
																			relator_no_creado=nombre_no_creado
																			end if
																		if  busqueda28=0 and Largo <>0 then
																		
																			relator_no_creado=relator_no_creado&", "&nombre_no_creado
																			
																		end if
																		
																		if  busqueda30=0 and Largo=0 then
																			
																			programa_no_creado=programa33
																			end if
																		if  busqueda30=0 and Largo <>0 then
																		
																			programa_no_creado=programa_no_creado&" Y EL "&programa33
																			
																		end if
																		guarda=guarda+1
																	end if
'																
																else
																	response.write("<br>existe_pago_relatores <>0 2 <br>")
																	response.write("<br>"&existe_hora_pago_relatores&"<br>")
																	
																	
																	if existe_hora_pago_relatores="0" then
																	
																	monto4=CDbl(tcat_valor)*(round(CDbl(horas_programa)/CDbl(seot_ncantidad_relator)))
																	response.write("sin hora")
																	response.write("<br> seccion"&seot_ncorr)
																	else
																	hora_pago_relatores=conexion.ConsultaUno("select hora_asignada from pago_relatores_otec where seot_ncorr="&seot_ncorr&" and pers_ncorr="&v_persona&"")
																	monto4=CDbl(tcat_valor)*(CDbl(hora_pago_relatores))
																	response.write("con hora")
																	end if
																
																	monto5=round(CDbl(presupuesto_programa)/CDbl(seot_ncantidad_relator))
																	conta_nom=conta_nom+1
																	if CDbl(monto4) <= CDbl(monto5) then
'											
																	guarda=guarda+0
																	nombre_creado=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas where pers_ncorr="&v_persona&"")
																		busqueda21=InStr(relator_creado,nombre_creado)
																		Largo=Len(relator_creado)
																		
																		if  busqueda21=0 and Largo=0 then
																			
																			relator_creado=nombre_creado
																			end if

																		if  busqueda21=0 and Largo <>0 then
																		
																			relator_creado=relator_creado&", "&nombre_creado
																		end if
																		conta_nom=conta_nom+1
														'response.write("<br>relator_creado despues= "&relator_creado&"<br>")			
																	else
																	C_error=C_error&" 7"
																	
																	programa33=conexion.ConsultaUno("Select distinct mo1.mote_tdesc from modulos_otec mo1,mallas_otec mot1,bloques_relatores_otec bro1,bloques_horarios_otec bho1,secciones_otec so1,relatores_programa rp1 where mot1.mote_ccod=mo1.mote_ccod and mot1.maot_ncorr=so1.maot_ncorr and bho1.seot_ncorr=so1.seot_ncorr and bho1.bhot_ccod=bro1.bhot_ccod and bro1.pers_ncorr=rp1.pers_ncorr and so1.dgso_ncorr=rp1.dgso_ncorr and mot1.dcur_ncorr="&v_dcur_ncorr&" and mot1.MAOT_NCORR="&MAOT_NCORR&"")
																	
																	busqueda30=InStr(programa_no_creado,programa33)
																		Largo=Len(programa_no_creado)
																	
																	nombre_no_creado=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas where pers_ncorr="&v_persona&"")
																	busqueda28=InStr(relator_no_creado,nombre_no_creado)
																		Largo=Len(relator_no_creado)
												
																		if  busqueda28=0 and Largo=0 then
																			
																			relator_no_creado=nombre_no_creado
																			end if
																		if  busqueda28=0 and Largo <>0 then
																		
																			relator_no_creado=relator_no_creado&", "&nombre_no_creado
																			
																		end if
																		
																		if  busqueda30=0 and Largo=0 then
																			
																			programa_no_creado=programa33
																			end if
																		if  busqueda30=0 and Largo <>0 then
																		
																			programa_no_creado=programa_no_creado&" Y EL "&programa33
																			
																		end if
																	'session("mensajeError")="El valor hora del relator "&relator&" es mas alto de lo que permite el presupuesto"
																	guarda=guarda+1
																	end if
'																
																end if
'															
'															
'											
'					
'												
															end if
'							
'						
							else
																		
							
																		nombre_con_cont=conexion.ConsultaUno("select pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno from personas where pers_ncorr="&v_persona&"")
																		
																		programa22=conexion.ConsultaUno("Select distinct mo1.mote_tdesc from modulos_otec mo1,mallas_otec mot1,bloques_relatores_otec bro1,bloques_horarios_otec bho1,secciones_otec so1,relatores_programa rp1 where mot1.mote_ccod=mo1.mote_ccod and mot1.maot_ncorr=so1.maot_ncorr and bho1.seot_ncorr=so1.seot_ncorr and bho1.bhot_ccod=bro1.bhot_ccod and bro1.pers_ncorr=rp1.pers_ncorr and so1.dgso_ncorr=rp1.dgso_ncorr and mot1.dcur_ncorr="&v_dcur_ncorr&" and mot1.MAOT_NCORR="&MAOT_NCORR&"")
																		busqueda8=InStr(relator_con_cont,nombre_con_cont)
'																	
																		conta_con_contr=conta_con_contr+1
																		if  busqueda8=0 and conta_con_contr=1 then
																			
																			relator_con_cont=nombre_con_cont
																			end if
																		if  busqueda8=0 and conta_con_contr >1 then
																		
																			relator_con_cont=relator_con_cont&", "&nombre_con_cont
																			
																		end if
																		'response.write("<br> msn_programa3= "&msn_programa3)
																		
																		busqueda15=InStr(msn_programa3,programa22)
																		busqueda16=" y el "
																		busqueda17=InStr(msn_programa3,busqueda16)	
																					
																		if  busqueda15=0 then
																		'response.write("<br> paso1 "&contador_gra)
																			
																			if busqueda17=0 and conta_con_contr =1 then
																			'response.write("<br> paso2")
																			msn_programa3=programa22
																			end if
																			
																			if busqueda17=0 and conta_con_contr >1 then
																		
																			msn_programa3=msn_programa3&" y el "&programa22
																			
																			end if
												
																		end if
																		
																		C_error=C_error&" 8"
							guarda=1
							end if
'						
								else
						
									b_guarda="No"
								guarda=1
								programa=conexion.ConsultaUno("Select distinct mo1.mote_tdesc from modulos_otec mo1,mallas_otec mot1,bloques_relatores_otec bro1,bloques_horarios_otec bho1,secciones_otec so1,relatores_programa rp1 where mot1.mote_ccod=mo1.mote_ccod and mot1.maot_ncorr=so1.maot_ncorr and bho1.seot_ncorr=so1.seot_ncorr and bho1.bhot_ccod=bro1.bhot_ccod and bro1.pers_ncorr=rp1.pers_ncorr and so1.dgso_ncorr=rp1.dgso_ncorr and mot1.dcur_ncorr="&v_dcur_ncorr&" and mot1.MAOT_NCORR="&MAOT_NCORR&"")
									busqueda=InStr(msn_programa,programa)
									busqueda2=" y el "
									busqueda3=InStr(msn_programa,busqueda2)
							  
						
											if  busqueda=0 then
												if busqueda3=0 then
												msn_programa=programa
												else
												msn_programa=msn_programa&" y el "&programa
												end if
											end if
								
								C_error=C_error&" 1"
								
								end if
								
								
								total_guarda=cint(guarda)+cint(guarda) 
										if total_guarda <>0 and b_guarda="No" then
										relator_creado=""
										conta_nom=0
										end if
										'response.Write("<br>conta_nom=======================================>"&conta_nom)
						wend
						
						'response.Write("<br>relator_creado=======================================>"&relator_creado)
						if guarda=0 and b_guarda=""then
						
						
						
												sql_genera="Exec GENERA_CONTRATO_DOCENTE_OTEC  "&v_persona&", "&v_sede&" ,"&v_dcur_ncorr&", "&v_tcdo_ccod&", '"&usuario&"' "
													response.write("<br> sql_genera= "&sql_genera)
													'response.end()
													v_salida= conexion.ConsultaUno(sql_genera)
													if v_salida="2" then
													v_nombre=conexion.consultaUno("select protic.obtener_nombre("&v_persona&",'an')")
														msg_error=msg_error + "\n-Contrato para "&v_nombre&" que no genero anexos"
													end if
													 cont=cont+1
													if conexion.ObtenerEstadoTransaccion  then
												if cont =0 then
												
													C_error=C_error&" 3"
												else
													if msg_error <> "" then
														msg_error="\nExcepto :"&msg_error&"\nRevise la integridad de los datos. "
														C_error=C_error&" 4"
													end if
													C_error=C_error&" 5"
												end if
											else
												C_error=C_error&" 6"
											end if 
						end if
						
						
						
						'response.write("<br> C_error="&C_error)
								
								
								buscaC_error_3=InStr(C_error,"3")
								buscaC_error_4=InStr(C_error,"4")
								buscaC_error_6=InStr(C_error,"6")
								buscaC_error_7=InStr(C_error,"7")
								
								'if buscaC_error_2<>0 then
'								mensa=mensa&"El valor hora del relator "&relator&" en el progroma "&msn_programa2&" es mas alto de lo asignado.\n"
'								end if
								if buscaC_error_3<>0 then
								mensa=mensa&"\nNo se realizo ningun calculo.\n"
								end if
								if buscaC_error_4<>0 then
								mensa=mensa&"\nExcepto :"&msg_error&"\nRevise la integridad de los datos.\n"
								end if
								'if C_error=5 then
								'mensa=mensa&"Los Contratos para "&nombre_creado&" fueron creados correctamente.\n"
								'end if		
								if buscaC_error_6<>0 then
								mensa=mensa&"\nOcurrio un error al intentar crear uno o mas contratos para los relatores.\nAsegurece de haber ingresado los datos necesarios y vuelva a intentarlo.\n"
								end if
								
								
									
'response.write("<br>conta_con_contr= "&conta_con_contr)
								
						
end if
response.write("<br>C_error= "&C_error)											


											
next
								buscaC_error_1=InStr(C_error,"1")
								buscaC_error_2=InStr(C_error,"2")
								buscaC_error_5=InStr(C_error,"5")
								buscaC_error_8=InStr(C_error,"8")	
								
								
								if buscaC_error_1<>0 then
								
								
								nombre_programa=conexion.ConsultaUno("select dcur_tdesc from diplomados_cursos where dcur_ncorr="&v_dcur_ncorr&"")
								
								
								mensa=mensa&"\nEl Programa "&msn_programa&" del "&nombre_programa&" en que el o los relatores que dictan clases no tiene todos sus docentes asignados\n"
								end if
								
								if buscaC_error_2<>0then
								mensa=mensa&"\nEl valor hora del relator "&relator&" en el programa "&msn_programa2&" no es igual a lo asignado.\n"
								end if

								if buscaC_error_5<>0 then
								mensa=mensa&"\nLos Contratos para "&relator_creado&" fueron creados correctamente.\n"
								end if	
								
								if buscaC_error_7<>0 then
								mensa=mensa&"\nEl valor hora del relator "&relator_no_creado&" es más alto de lo que permite el presupuesto para el Programa "&programa_no_creado&" .\n"
								end if

								if buscaC_error_8<>0 then
								mensa=mensa&"\nEl calculo para el programa "&msn_programa3&" del relator "&relator_con_cont&" no se realizo por que ya tiene contrato hecho.\n"
								end if
								'response.write("<br>relator_creado= "&relator_con_cont)
		if 	C_error <> "" then
		session("mensajeError")=""&mensa&""
		response.write("<br> mensa2= "&mensa)
		end if
		
'response.End()
'response.End()
'conexion.estadotransaccion false
response.Redirect(Request.ServerVariables("HTTP_REFERER"))
%>