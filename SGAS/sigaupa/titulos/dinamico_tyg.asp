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
															<td width="100%" align="left">
																<font size="+2"><strong>Bienvenidos a la Web de Títulos y Grados</strong></font>
															</td>
														</tr>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
														</tr>
														<tr>
															<td width="100%" align="left">
																<font size="2">El   Departamento  de  Títulos y Grados dependiente  de   Secretaría    General,   es    el     encargado    del proceso  de  titulación  y certificación de egresados y titulados de pre y post-grado de nuestra Universidad.</font><br><br>
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
									<td width="100%"><font size="-1">&nbsp;</font></td>
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
														<tr>
															<td width="100%" align="left">
																<font size="+1"><strong>Estimado(a) <%=nombre%>, acá podrás realizar:</strong></font>
															</td>
														</tr>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
														</tr>
														<tr>
															<td width="100%" align="left">
															    <li><font size="2">Solicitud de uno o más certificados, entregados en la sede que lo desees.</font></li>
																<li><font size="2">Revisar la nómina de convocados a la ceremonia, horario y lugar.</font></li>
																<li><font size="2">Actualizar tus datos personales para mejorar la comunicación con la universidad.</font></li>
																<br><br>
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
