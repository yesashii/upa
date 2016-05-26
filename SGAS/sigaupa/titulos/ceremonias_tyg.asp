<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conectar = new CConexion
conectar.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conectar

carr_ccod = request.querystring("busqueda[0][carr_ccod]")
retorno = request.querystring("retorno")
usuario = negocio.obtenerUsuario
rut = conectar.consultaUno("select cast(pers_nrut as varchar)+'-'+pers_xdv from personas where cast(pers_nrut as varchar)='"&usuario&"'")
nombre = conectar.consultaUno("select protic.initcap(pers_tnombre+' '+pers_tape_paterno+' '+pers_tape_materno) from personas where cast(pers_nrut as varchar)='"&usuario&"'")
pers_ncorr = conectar.consultaUno("select pers_ncorr from personas where cast(pers_nrut as varchar)='"&usuario&"'")


set f_listado = new CFormulario
f_listado.Carga_Parametros "consulta.xml", "consulta" 
f_listado.Inicializar conectar

c_listado = " select protic.initcap(sede_tdesc) as sede,fecha_ceremonia, protic.trunc(fecha_ceremonia) as fechac, hora_inicio,lugar, "& vbCrLf &_ 
			"       (select count(distinct pers_ncorr) from detalles_titulacion_carrera tt where tt.id_ceremonia=a.id_ceremonia) as total_alumnos "& vbCrLf &_        
			" from ceremonias_titulacion a, sedes b "& vbCrLf &_ 
			" where a.sede_ccod=b.sede_ccod "& vbCrLf &_ 
			" and datepart(year,fecha_ceremonia) = datepart(year,getDate()) "& vbCrLf &_ 
			" order by sede, fecha_ceremonia  "

f_listado.consultar c_listado

pendientes = f_listado.nroFilas

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
<script language="JavaScript" type="text/javascript">
</script>
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
									<td width="5" height="40" align="center" >&nbsp;</td>
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
															<td width="100%" align="left">
																<font size="+2"><strong>Listados Ceremonias 2010</strong></font>
															</td>
														</tr>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
														</tr>
														<tr>
															<td width="100%" align="left">
																<table width="100%" cellpadding="0" cellspacing="0">
																	<tr>
																		<td width="19%" align="left"><font size="2"><strong>Rut</strong></font></td>
																		<td width="1%" align="center"><font size="2"><strong>:</strong></font></td>
																		<td align="left"><font size="2"><%=rut%></font></td>
																	</tr>
																	<tr>
																		<td width="19%" align="left"><font size="2"><strong>Nombre</strong></font></td>
																		<td width="1%" align="center"><font size="2"><strong>:</strong></font></td>
																		<td align="left"><font size="2"><%=nombre%></font></td>
																	</tr>
																	<tr>
																		<td colspan="3">&nbsp;</td>
																	</tr>
																</table>
															</td>
														</tr>
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
											<tr valign="top">
												<td bgcolor="#FFFFFF" width="8" background="img/izquierda.png">&nbsp;</td>
												<td bgcolor="#FFFFFF">
													 <table width="100%" cellpadding="0" cellspacing="0">
														<tr>
															<td width="100%" align="left">
																<font size="2"><strong>Detalle solicitud de certificados</strong></font>
															</td>
														</tr>
														<tr>
															<td width="100%" align="left">
																<table align="center" width="98%" cellpadding="0" cellspacing="0" border="1" bordercolor="#99CCFF">
																	<tr valign="top">
																		<td align="center" bgcolor="#99CCFF"><strong>Sede</strong></td>
																		<td align="center" bgcolor="#99CCFF"><strong>Fecha</strong></td>
																		<td align="center" bgcolor="#99CCFF"><strong>Horario</strong></td>
																		<td align="center" bgcolor="#99CCFF"><strong>Lugar</strong></td>
																		<td align="center" bgcolor="#99CCFF"><strong>Participantes</strong></td>
																	</tr>
																	<%while f_listado.siguiente%>
																	<tr>
																		<td align="left" bgcolor="#FFFFFF"><%=f_listado.obtenerValor("sede")%>&nbsp;</td>
																		<td align="left" bgcolor="#FFFFFF"><%=f_listado.obtenerValor("fechac")%>&nbsp;</td>
																		<td align="left" bgcolor="#FFFFFF"><%=f_listado.obtenerValor("hora_inicio")%>&nbsp;</td>
																		<td align="left" bgcolor="#FFFFFF"><%=f_listado.obtenerValor("lugar")%>&nbsp;</td>
																		<td align="center" bgcolor="#FFFFFF"><%=f_listado.obtenerValor("total_alumnos")%>&nbsp;</td>
																	</tr>
																	<%wend%>
																</table>
															</td>
														</tr>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
														</tr>
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
