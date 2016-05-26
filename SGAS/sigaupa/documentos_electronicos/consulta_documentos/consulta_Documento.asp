<!-- #include file = "consulta_documento_proc.asp" -->
<!-- #include file = "../../biblioteca/_conexion.asp" -->

<%
	Set consulta_controlador = new Controlador_Consulta
	
	documentos = consulta_controlador.Consultar()
	if request.Form("boleta") <> "" then
		response.write request.Form("boleta")
		if request.Form("boleta") <> 39 AND request.Form("boleta") <> 41 then
			consulta_controlador.enviar_dte request.Form("boleta"), request.Form("folio"), request.Form("monto"), request.Form("emision")
		else
			consulta_controlador.enviar_boleta request.Form("boleta"), request.Form("folio"), request.Form("monto"), request.Form("emision")
		end if 
	end if
	if request.QueryString("texto")= 1 then
		response.write "<script>alert('Datos no asociado a documento.');</script>"
	end if
	
	d_now = date()
	d = split(d_now,"-")
	fech = d(2) & "-" & d(1) & "-" & d(0)
%>
<html>
	<head>
		<title>Consulta de Boleta Electrónica</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
		<link href="../../estilos/estilos.css" rel="stylesheet" type="text/css">
		<link href="../../estilos/tabla.css" rel="stylesheet" type="text/css">
		<style>
			.Mimetismo { background-color:#ADADAD;border: 1px #ADADAD solid; font-size:10px; font-style:oblique; font:bold;}
		</style>
		<script language="JavaScript" src="../../biblioteca/tabla.js"></script>
		<script language="JavaScript" src="../../biblioteca/funciones.js"></script>
		<script language="JavaScript" src="../../biblioteca/validadores.js"></script>
		<script language="JavaScript" src="../../biblioteca/popcalendar_v2_mvc.js"></script>
		<script type="text/javascript" src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
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
			
			function Calendario(a,b,c){
				popUpCalendar(a, b, c);
			}
			
			function Obligatortio()
			{
				inputs = document.getElementsByTagName('input');
				for (index = 0; index < inputs.length; ++index) {
					if(document.getElementById(inputs[index].id).className=="O" && document.getElementById(inputs[index].id).value=="")
					{
						alert('Ingrese '+inputs[index].id);
						return false;
					}
				}
				return true;
			}
		</script>	
	</head>
	<body bgcolor="#CC6600" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="Validar();MM_preloadImages('../imagenes/botones/buscar_f2.gif','../images/bot_deshabilitar_f2.gif','../images/agregar2_f2_p.gif','im&amp;#225;genes/marco1_r3_c2_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c4_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c6_f2.gif');MM_preloadImages('im&amp;#225;genes/marco1_r3_c8_f2.gif');MM_preloadImages('../imagenes/botones/cargar_f2.gif','../imagenes/botones/continuar_f2.gif');" >
		<table width="760" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td><img src="../../imagenes/vineta2_r1_c1.gif" width="750" height="62" border="0"></td>
			</tr>
			<tr>
				<td valign="top" bgcolor="#EAEAEA"><br>
			      <table width="90%"  border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#D8D8DE">
					  <tr>
							<td width="9" height="8"><img name="top_r1_c1" src="../../imagenes/top_r1_c1.gif" width="9" height="8" border="0" alt=""></td>
							<td height="8" background="../../imagenes/top_r1_c2.gif"></td>
							<td width="7" height="8"><img name="top_r1_c3" src="../../imagenes/top_r1_c3.gif" width="7" height="8" border="0" alt=""></td>
						</tr>
						<tr>
							<td width="9" background="../../imagenes/izq.gif">&nbsp;</td>
							<td>					
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td>
											<table width="100%" border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td width="6" ><img src="../../imagenes/izq_1.gif" width="6" height="17"></td>
													<td valign="middle" nowrap background="../../imagenes/fondo1.gif" >
														<div align="center">
															<font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif">D.T.E.</font>
														</div>
													</td>
													<td width="6">
														<img src="../../imagenes/derech1.gif" width="6" height="17" >
													</td>
													<td width="100%" bgcolor="#D8D8DE"></td>
												</tr>
											</table>
										</td>
									</tr>
									<tr>
										<td height="2" background="../../imagenes/top_r3_c2.gif"></td>
									</tr>				
									<tr>
										<td bgcolor="#D8D8DE">
											<br/>
											<div align="center"><font size="+1">Consultar Documento Electrónico</font> </div>
											<br/>
											<form name="formulario" id="formulario" action="consulta_documento.asp" method="post" onsubmit="return Obligatortio();">
												<table>
													<tr>
														<td>Empresa</td>
														<td>:</td>
														<td>Universidad del Pacífico</td>
													</tr>
													<tr>
														<td>Tipo Boleta</td>
														<td>:</td>
														<td>
															<select name="boleta" >
																<%
																	for each documento IN documentos
																		response.write "<option value="&documento(0)&">"&documento(1)&"</option>"
																	next
																%>
															</select>
														</td>
													</tr>
													<tr>
														<td>Folio</td>
														<td>:</td>
														<td>
															<input name="folio" id="folio" type="text" onKeyDown="esnumero(this)" onBlur="esnumero(this)" onKeyUp="esnumero(this)" class="O" />
														</td>
													</tr>
													<tr>
														<td>Monto</td>
														<td>:</td>
														<td><input name="monto" id="monto" type="text" onKeyDown="esnumero(this)" onBlur="esnumero(this)" onKeyUp="esnumero(this)" class="O" /></td>
													</tr>
													<tr>
														<td>Fecha Emision (aaaa-mm-dd)</td>
														<td>:</td>
														<td><input name="emision" type="text" id="emision" size="11" class="O" value=<% =fech %>>
															<img src="../../biblioteca/calendario/abajo.png" onClick="Calendario(this, formulario.emision, 'yyyy-mm-dd');">
														</td>
													</tr>
												</table>
												<br /><br />
												<p><input type="submit" value="Consultar Boleta" /></p>
											</form>
										</td>
									</tr>		  
								</table>
							</td>
							<td width="7" background="../../imagenes/der.gif">&nbsp;</td>
						</tr>
						<tr>
							<td width="9" height="28"><img src="../../imagenes/abajo_r1_c1.gif" width="9" height="28"></td>
							<td rowspan="3" background="../../imagenes/abajo_r1_c4.gif"><img src="../../imagenes/abajo_r1_c3.gif" width="12" height="28"></td>
							<td width="7" height="28"><img src="../../imagenes/abajo_r1_c5.gif" width="7" height="28"></td>
						</tr>
					</table>
				</td>
			</tr> 
			<tr>
				<td bgcolor="#EAEAEA">&nbsp;</td>
			</tr>			
		</table>
	</body>
</html>