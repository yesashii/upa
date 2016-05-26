<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

usuario = negocio.obtenerUsuario
nombre = conectar.consultaUno("select protic.initcap(pers_tnombre) from personas where cast(pers_nrut as varchar)='"&usuario&"'")
pers_ncorr = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")
id_ceremonia = conectar.consultaUno("select id_ceremonia from detalles_titulacion_carrera where cast(pers_ncorr as varchar)='"&pers_ncorr&"'")
fecha_ceremonia = conectar.consultaUno("select protic.trunc(fecha_ceremonia) from ceremonias_titulacion where cast(id_ceremonia as varchar)='"&id_ceremonia&"'")
sede_ceremonia = conectar.consultaUno("select protic.initCap(sede_tdesc) from ceremonias_titulacion a, sedes b where a.sede_ccod=b.sede_ccod and cast(id_ceremonia as varchar)='"&id_ceremonia&"'")
hora_ceremonia = conectar.consultaUno("select hora_inicio from ceremonias_titulacion where cast(id_ceremonia as varchar)='"&id_ceremonia&"'")
lugar_ceremonia = conectar.consultaUno("select lugar from ceremonias_titulacion where cast(id_ceremonia as varchar)='"&id_ceremonia&"'")

consulta =  " select distinct b.sede_ccod,protic.initCap(d.sede_tdesc) as sede_tdesc,a.carr_ccod,protic.initCap(e.carr_tdesc) as carr_tdesc "& vbCrLf &_
			" from detalles_titulacion_carrera a, alumnos_salidas_carrera b, "& vbCrLf &_
			" salidas_carrera c, sedes d, carreras e "& vbCrLf &_
			" where cast(a.id_ceremonia as varchar)='"&id_ceremonia&"' "& vbCrLf &_
			" and a.pers_ncorr=b.pers_ncorr and b.saca_ncorr=c.saca_ncorr "& vbCrLf &_
			" and a.carr_ccod=c.carr_ccod and c.tsca_ccod in (1,2,3,4)  "& vbCrLf &_
			" and b.sede_ccod=d.sede_ccod and a.carr_ccod=e.carr_ccod "& vbCrLf &_
			" order by sede_tdesc, carr_tdesc " 

set f_carrera = new cFormulario
f_carrera.carga_parametros	"tabla_vacia.xml" , "tabla"
f_carrera.inicializar		conectar
f_carrera.consultar 		consulta
registros = f_carrera.nrofilas

%>


<html>
<head>
<title>Universidad del Pacífico</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style>
a {
	color: #000000;
	text-decoration: none;
	font-weight:bold;	
}

a:hover {
	color: #63ABCC;
}
</style>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table align="center" height="100%" background="img/bg.gif"  width="1060" cellpadding="0" cellspacing="0">
<tr valign="top">
	<td width="100%" align="center">
		<table width="760" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
		  <tr>
			<td height="100" align="center"><img src="img/frame.png" width="760" height="100" border="0"></td>
		  </tr>
		  <tr valign="top">
		  	<td width="100%">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr valign="top">
						<td width="200" align="center">
							<table width="100%" align="center">
							    <tr valign="middle">
									<td width="5" height="40" align="center">&nbsp;</td>
									<td width="150" height="40" align="center" background="img/cuadro.png"><a href="dinamico_tyg.asp" target="_top"><font size="2"><strong>Inicio</strong></font></a></td>
									<td width="45" height="40" align="center">&nbsp;</td>
								</tr>
								<tr valign="middle">
									<td width="5" height="40" align="center">&nbsp;</td>
									<td width="150" height="40" align="center" background="img/cuadro.png"><a href="solicitud_tyg.asp" target="_top"><font size="2"><strong>Solicitud de Certificados</strong></font></a></td>
									<td width="45" height="40" align="center">&nbsp;</td>
								</tr>
								<tr valign="middle">
									<td width="5" height="40" align="center">&nbsp;</td>
									<td width="150" height="40" align="center" background="img/cuadro.png"><a href="nomina_tyg.asp" target="_top"><font size="2"><strong>Nómina de convocados a ceremonia</strong></font></a></td>
									<td width="45" height="40" align="center">&nbsp;</td>
								</tr>
								<tr valign="middle">
									<td width="5" height="40" align="center">&nbsp;</td>
									<td width="150" height="40" align="center" background="img/cuadro.png"><a href="ceremonias_tyg.asp" target="_top"><font size="2"><strong>Fechas de Ceremonia de titulación</strong></font></a></td>
									<td width="45" height="40" align="center">&nbsp;</td>
								</tr>
								<tr valign="middle">
									<td width="5" height="40" align="center">&nbsp;</td>
									<td width="150" height="40" align="center" background="img/cuadro.png"><a href="actualizacion_datos_tyg.asp" target="_top"><font size="2"><strong>Actualización de datos</strong></font></a></td>
									<td width="45" height="40" align="center">&nbsp;</td>
								</tr>
							</table>
						</td>
						<td align="center">
							<table width="100%" cellpadding="0" cellspacing="0">
								<tr>
								    <td width="100%">
										<table width="100%" cellpadding="0" cellspacing="0" border="0">
											<tr valign="bottom">
												<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_sup_izq.png"></td>
												<td bgcolor="#FFFFFF" height="18" background="img/superior.png">&nbsp;</td>
												<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_sup_der.png"></td>
											</tr>
											<tr>
												<td bgcolor="#FFFFFF" width="8" background="img/izquierda.png">&nbsp;</td>
												<td bgcolor="#FFFFFF">
													<table width="100%" cellpadding="0" cellspacing="0">
														<tr>
															<td width="100%" colspan="3" align="left">
																<font size="+2"><strong>Nómina convocados a ceremonia de Titulación</strong></font>
															</td>
														</tr>
														<tr>
															<td width="100%" colspan="3" align="left">&nbsp;</td>
														</tr>
														<tr>
															<td width="14%" align="left">
																<font size="2"><strong>Fecha</strong></font>
															</td>
															<td width="14%" align="center">
																<font size="2"><strong>:</strong></font>
															</td>
															<td width="85%" align="left">
																<font size="2"><%=fecha_ceremonia%></font>
															</td>
														</tr>
														<tr>
															<td width="14%" align="left">
																<font size="2"><strong>Sede</strong></font>
															</td>
															<td width="14%" align="center">
																<font size="2"><strong>:</strong></font>
															</td>
															<td width="85%" align="left">
																<font size="2"><%=sede_ceremonia%></font>
															</td>
														</tr>
														<tr>
															<td width="14%" align="left">
																<font size="2"><strong>Lugar</strong></font>
															</td>
															<td width="14%" align="center">
																<font size="2"><strong>:</strong></font>
															</td>
															<td width="85%" align="left">
																<font size="2"><%=lugar_ceremonia%></font>
															</td>
														</tr>
														<tr>
															<td width="14%" align="left">
																<font size="2"><strong>Horario</strong></font>
															</td>
															<td width="14%" align="center">
																<font size="2"><strong>:</strong></font>
															</td>
															<td width="85%" align="left">
																<font size="2"><%=hora_ceremonia%></font>
															</td>
														</tr>
														<tr><td colspan="3">&nbsp;</td></tr>
													</table>
												</td>
												<td bgcolor="#FFFFFF" width="12" background="img/derecha.png">&nbsp;</td>
											</tr>
											<tr valign="top">
												<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_inf_izq.png"></td>
												<td bgcolor="#FFFFFF" height="18" background="img/inferior.png">&nbsp;</td>
												<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_inf_der.png"></td>
											</tr>
										</table>
									</td>
							    </tr>
								<tr>
								    <td width="100%">
										<table width="100%" cellpadding="0" cellspacing="0" border="0">
											<tr valign="bottom">
												<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_sup_izq.png"></td>
												<td bgcolor="#FFFFFF" height="18" background="img/superior.png">&nbsp;</td>
												<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_sup_der.png"></td>
											</tr>
											<tr>
												<td bgcolor="#FFFFFF" width="8" background="img/izquierda.png">&nbsp;</td>
												<td bgcolor="#FFFFFF">
													<table width="100%" cellpadding="0" cellspacing="0">
													    <% while f_carrera.siguiente 
														    sede_ccod = f_carrera.obtenerValor("sede_ccod")
															sede_tdesc = f_carrera.obtenerValor("sede_tdesc")
															carr_ccod = f_carrera.obtenerValor("carr_ccod")
															carr_tdesc = f_carrera.obtenerValor("carr_tdesc")
															
															consulta =  " select distinct f.pers_ncorr,cast(f.pers_nrut as varchar)+'-'+f.pers_xdv as rut,  "& vbCrLf &_
																		" protic.initCap(f.pers_tape_paterno + ' ' + f.pers_tape_materno + ', '+ f.pers_tnombre) as nombre  "& vbCrLf &_
																		" from detalles_titulacion_carrera a, alumnos_salidas_carrera b,   "& vbCrLf &_
																		"    salidas_carrera c, sedes d, carreras e, personas f  "& vbCrLf &_
																		" where cast(a.id_ceremonia as varchar)='"&id_ceremonia&"'  "& vbCrLf &_
																		" and a.pers_ncorr=b.pers_ncorr and b.saca_ncorr=c.saca_ncorr  "& vbCrLf &_
																		" and a.carr_ccod=c.carr_ccod and c.tsca_ccod in (1,2,3,4) "& vbCrLf &_
																		" and b.sede_ccod=d.sede_ccod and a.carr_ccod=e.carr_ccod  "& vbCrLf &_
																		" and cast(d.sede_ccod as varchar)='"&sede_ccod&"' and e.carr_ccod='"&carr_ccod&"' "& vbCrLf &_
																		" and a.pers_ncorr=f.pers_ncorr  "& vbCrLf &_
																		" order by nombre asc "

															
															set f_alumnos = new cFormulario
															f_alumnos.carga_parametros	"tabla_vacia.xml" , "tabla"
															f_alumnos.inicializar		conectar
															f_alumnos.consultar 		consulta
															total_alumnos = f_alumnos.nrofilas
															%>
															<tr>
																<td width="100%" colspan="3" align="left">
																	<font size="+2"><strong><%=carr_tdesc%></strong></font>
																</td>
															</tr>
															<tr>
																<td width="100%" colspan="3" align="left">
																	<font size="+1"><strong><%=sede_tdesc%></strong></font>
																</td>
															</tr>
															<%if total_alumnos > 0 then%>
															<tr>
																<td width="100%" colspan="3" align="left">
																	<table width="100%" cellpadding="0" cellspacing="0" border="0" bordercolor="#000000">
																		<tr>
																			<td width="30%" align="center" bgcolor="#99CCFF"><strong>Rut</strong></td>
																			<td width="30%" align="center" bgcolor="#99CCFF"><strong>Alumno</strong></td>
																		</tr>
																		<%while f_alumnos.siguiente
																		    pers_ncorr2 = f_alumnos.obtenerValor("pers_ncorr") 
																			  color = "#FFFFFF"
																			 if cstr(pers_ncorr) = cstr(pers_ncorr2) then
																			  color = "#FFCC99" 	
																			 end if
																			%>
																		<tr>
																			<td width="30%" align="left" bgcolor="<%=color%>"><%=f_alumnos.obtenerValor("rut")%></td>
																			<td width="30%" align="left" bgcolor="<%=color%>"><%=f_alumnos.obtenerValor("nombre")%></td>
																		</tr>
																		<%wend%>
																	</table>
																</td>
															</tr>
															<tr>
																<td width="100%" colspan="3" align="left">&nbsp;</td>
															</tr>
															<%end if%>
														<%wend%>
														<tr><td colspan="3">&nbsp;</td></tr>
													</table>
												</td>
												<td bgcolor="#FFFFFF" width="12" background="img/derecha.png">&nbsp;</td>
											</tr>
											<tr valign="top">
												<td bgcolor="#FFFFFF" width="8" height="18"><img width="8" height="18" src="img/esq_inf_izq.png"></td>
												<td bgcolor="#FFFFFF" height="18" background="img/inferior.png">&nbsp;</td>
												<td bgcolor="#FFFFFF" width="12" height="18"><img width="12" height="18" src="img/esq_inf_der.png"></td>
											</tr>
										</table>
									</td>
							    </tr>
							</table>
						</td>
					</tr>
				</table>
			</td>
		  </tr>
		  <tr>
			<td align="center"><hr color="#CCCCCC"></td>
		  </tr>
		  <tr>
			<td align="center"><font color="#CCCCCC">Universidad del Pacífico - Derechos Reservados</font></td>
		  </tr>
		</table>
	</td>
</tr>
</table>

</body>
</html>
