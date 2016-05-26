<!-- #include file = "reporte_parcial_nota_proc.asp" -->

<%
'---------------------------------------------------------------------------------------------------

Set reporte_notas_controlador = new controlador_reporte_notas

set pagina = new CPagina
pagina.Titulo = "Ver Matriculados"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion
periodo_buscar 	= 	Request.Form("periodo_buscar")
periodo = reporte_notas_controlador.obtener_periodo()

encontrados = false
if periodo_buscar <> "" then
	url = "http://admision.upacifico.cl/postulacion/www/reporte_general_parciales_excel.php?periodo="&periodo_buscar
	Response.Write("<script type='text/javascript'>window.open('"&url&"');</script>")
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
				</td>
			</tr>  
		</table>
	</body>
</html>