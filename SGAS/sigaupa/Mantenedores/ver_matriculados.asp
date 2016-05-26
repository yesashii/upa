<!-- #include file = "ver_matriculados_proc.asp" -->

<%
'---------------------------------------------------------------------------------------------------

Set matricula_controlador = new controlador_matricula

set pagina = new CPagina
pagina.Titulo = "Ver Matriculados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

periodo = matricula_controlador.obtener_periodo()
periodo_buscar 	= 	Request.Form("periodo_buscar")
nuevo	= 	Request.Form("nuevo")


encontrados = false
if periodo_buscar <> "" then
	tabla = matricula_controlador.obtener_matriculador(periodo_buscar, nuevo)
	encontrados = true
end if




%>
<html>
	<head>
		<title><% = pagina.Titulo %></title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="../estilos/estilos.css" rel="stylesheet" type="text/css">
		<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">
	
		<script language="JavaScript" src="../biblioteca/tabla.js"></script>
		<script language="JavaScript" src="../biblioteca/funciones.js"></script>
		<script language="JavaScript" src="../biblioteca/validadores.js"></script>
	
		<script language="JavaScript">
			function Solo_Numerico(variable){
				Numer=parseInt(variable);
				if (isNaN(Numer)){
					return "";
				}
				return Numer;
			}
				
			function esnumero(Control){
				Control.value=Solo_Numerico(Control.value);
			}
		</script>
	</head>
	<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
		<table width="750" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td height="65"><img src="../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
			</tr>
			<%pagina.DibujarEncabezado()%>
			<tr>
				<td valign="top" bgcolor="#EAEAEA">
				<br>
					<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
						<tr>
							<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
							<td height="8" background="../imagenes/top_r1_c2.gif"></td>
							<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
						</tr>
						<tr>
							<td width="9" background="../imagenes/izq.gif"></td>
							<td>
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><%pagina.DibujarLenguetas Array("Buscador"), 1 %></td>
									</tr>
									<tr>
										<td height="2" background="../imagenes/top_r3_c2.gif"></td>
									</tr>
									<tr>
										<td>
											<form name="buscador" method="post">
												<br>
												<table width="98%"  border="0" align="center">
													<tr>
														<td>
															<div align="center">
																<table width="90%"  border="0" cellspacing="0" cellpadding="0">
																	<tr>
																		<td><div align="right"><strong>Buscar Periodo </strong></div></td>
																		<td width="7%"><div align="center"><strong>:</strong></div></td>
																		<td width="61%">
																			<div align="left">
																				<select name="periodo_buscar" id ="periodo_buscar">
																					<%
																						for each item in periodo
																							if periodo_buscar <> "" then
																								if cstr(item(0)) = cstr(periodo_buscar) then
																									response.write "<option value="&item(0)&" selected>"&item(1)&"</option>"
																								else
																									response.write "<option value="&item(0)&">"&item(1)&"</option>"
																								end if
																							else
																								response.write "<option value="&item(0)&">"&item(1)&"</option>"
																							end if
																						next
																					%>
																				</select>
																			</div>
																		</td>
																	</tr>
																	<tr>
																		<td>Alumnos</td>
																		<td>:</td>
																		<td>
																			<input type="radio" id="nuevo" name="nuevo" value="S"> Nuevo<br>
																			<input type="radio" id="nuevo" name="nuevo" value="V"> Antiguos<br>
																			<input type="radio" id="nuevo" name="nuevo" value="" checked> Todos
																		</td>
																	</tr>
																</table>
															</div>
														</td>
														<td><div align="center"><input type="submit" value="Buscar"></div></td>
													</tr>
												</table>
											</form>
										</td>
									</tr>
								</table>
							</td>
							<td width="7" background="../imagenes/der.gif"></td>
						</tr>
						<tr>
							<td width="9" height="13"><img src="../imagenes/base1.gif" width="9" height="13"></td>
							<td height="13" background="../imagenes/base2.gif"></td>
							<td width="7" height="13"><img src="../imagenes/base3.gif" width="7" height="13"></td>
						</tr>
					</table>
					<br>
					<table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
						<tr>
							<td width="9" height="8"><img name="top_r1_c1" src="../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
							<td height="8" background="../imagenes/top_r1_c2.gif"></td>
							<td width="7" height="8"><img name="top_r1_c3" src="../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
						</tr>
						<tr>
							<td width="9" background="../imagenes/izq.gif">&nbsp;</td>
							<td>
								<table width="100%"  border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td><%pagina.DibujarLenguetas Array("Resultados de la búsqueda"), 1 %></td>
									</tr>
									<tr>
										<td height="2" background="../imagenes/top_r3_c2.gif"></td>
									</tr>          
									<tr>
										<td>
											<div align="center"><br>
												<%pagina.DibujarTituloPagina%><br><br>
											</div>   
											<% if encontrados then %>
												<table>
													<table bgcolor='#000000'>
														<tr bgcolor='#9898a7'>
															<th>#</th>
															<th>Codigo Persona</th>
															<th>Nombre</th>
															<th>Apellido Paterno</th>
															<th>Apellido Materno</th>
															<th>R.U.N.</th>
															<th>Año Ingreso</th>
															<th>Contrato</th>
															<th>Fecha Contrato</th>
															<th>Carrera</th>
															<th>Sede</th>
														</tr>
												<%
													i=0
													For Each item in tabla
														if i mod 2=0 then
															response.write "<tr bgcolor='#b6ebff'>"
														else
															response.write "<tr bgcolor='#FFFFFF'>"
														end if
														response.write "<td nowrap>"& i+1 &"</td>"
														response.write "<td nowrap>"& item(0) &"</td>"
														response.write "<td nowrap>"& item(6) &"</td>"
														response.write "<td nowrap>"& item(7) &"</td>"
														response.write "<td nowrap>"& item(8) &"</td>"
														response.write "<td nowrap>"& item(1) &"</td>"
														response.write "<td nowrap>"& item(5) &"</td>"
														response.write "<td nowrap>"& item(2) &"</td>"
														response.write "<td nowrap>"& item(3) &"</td>"
														carrera = Split(item(4),"(")
														response.write "<td nowrap>"& carrera(0) &"</td>"
														response.write "<td nowrap>"& item(9) &"</td>"
														response.write "</tr>"
														i=i+1
													next
													%>
												</table>
												<%
											end if %>
										</td>
									</tr>            
								</table>		
							</td>
							<td width="7" background="../imagenes/der.gif">&nbsp;</td>
						</tr>
						<tr>
							<td width="9" height="28"><img src="../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
							<td height="28">
								<table width="100%" height="28"  border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td></td>
									</tr>
										
									<tr>
										<td width="18%" height="20"><div align="center">
										
											<table width="90%"  border="0" cellspacing="0" cellpadding="0" align="center">
												<tr>
													<td width="55%">
														<div align="center">
															<input type="button" value="salir">
														</div>
													</td>
												</tr>
											</table>
										</div></td>
										<td width="82%" rowspan="2" background="../imagenes/abajo_r1_c4.gif"><img src="../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
									</tr>
									<tr>
										<td height="8" background="../imagenes/abajo_r2_c2.gif"></td>
									</tr>
								</table>
							</td>
							<td width="7" height="28"><img src="../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
						</tr>
					</table>
					<br>
					<br>
				</td>
			</tr>  
		</table>
	</body>
</html>