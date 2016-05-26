<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set pagina = new CPagina
pagina.Titulo = "Creación de Mensajes"

'---------------------------------------------------------------------------------------------------
set conexion = new CConexion
conexion.Inicializar "upacifico"

'set negocio = new CNegocio
'negocio.Inicializa conexion

'---------------------------------------------------------------------------------------------------
set botonera = new CFormulario
botonera.Carga_Parametros "mensajes.xml", "botonera"

'---------------------------------------------------------------------------------------------------
mepe_ncorr = Request.QueryString("mepe_ncorr")
pers_ncorr_origen = Request.QueryString("pers_ncorr")
tipo = Request.QueryString("tipo")
origen  = conexion.consultaUno("select protic.initcap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_origen&"'")
anos_ccod = conexion.consultaUno("select datepart(year,getDate())")
respuesta = request.QueryString("respuesta")

set formulario = new CFormulario
formulario.Carga_Parametros "mensajes.xml", "edita_mensaje"
formulario.Inicializar conexion

if mepe_ncorr <> "" then
     'actualizamos el estado a leído
	 c_update = "update mensajes_entre_personas set estado='Leído' where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'"
	 conexion.ejecutaS c_update
	 
	if respuesta <> "1" then
		 consulta = "select * from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'"
		 pers_ncorr_destino = conexion.consultaUno("select pers_ncorr_destino from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'")
		 destino = conexion.consultaUno("Select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_destino&"'")
     else
		 consulta = " select mepe_ncorr,pers_ncorr_origen,pers_ncorr_destino,fecha_emision,fecha_vencimiento, " & vbCrLf &_
					" 'Re: '+ ltrim(rtrim(titulo)) as titulo,'--->' + ltrim(rtrim(contenido)) as contenido, " & vbCrLf &_
					" tipo_origen,audi_tusuario,audi_fmodificacion,estado  " & vbCrLf &_
					" from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'"
		 pers_ncorr_origen = conexion.consultaUno("select pers_ncorr_destino from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'")
		 origen = conexion.consultaUno("Select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_origen&"'")
		 pers_ncorr_destino = conexion.consultaUno("select pers_ncorr_origen from mensajes_entre_personas where cast(mepe_ncorr as varchar)='"&mepe_ncorr&"'")
		 destino = conexion.consultaUno("Select protic.initCap(pers_tnombre + ' ' + pers_tape_paterno + ' ' + pers_tape_materno) from personas where cast(pers_ncorr as varchar)='"&pers_ncorr_destino&"'")
	 end if
else  'modificar
  	 consulta = " select ''"
	 pers_ncorr_destino=""
end if

formulario.Consultar consulta
if tipo = "1" then
c_destino = " (select distinct cc.pers_ncorr as pers_ncorr_destino, protic.initcap(pers_tape_paterno + ' ' + pers_tape_materno + ', ' +pers_tnombre) as nombre " & vbCrLf &_
			" from cargas_academicas aa, alumnos bb, personas cc " & vbCrLf &_
			" where aa.matr_ncorr=bb.matr_ncorr and bb.pers_ncorr=cc.pers_ncorr " & vbCrLf &_
			" and aa.secc_ccod in (select distinct secc_ccod " & vbCrLf &_
			"                     from alumnos a, ofertas_academicas b, periodos_academicos c, cargas_academicas d " & vbCrLf &_
			"                     where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod=c.peri_ccod " & vbCrLf &_
			"                     and a.matr_ncorr=d.matr_ncorr " & vbCrLf &_
			"                     and cast(c.anos_ccod as varchar)='"&anos_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr_origen&"' and a.emat_ccod <> 9) " & vbCrLf &_
			" ) a   "
titulo = "Crear mensaje a Compañero"			
elseif tipo="2" then
c_destino = " (select distinct dd.pers_ncorr as pers_ncorr_destino, protic.initcap(pers_tape_paterno + ' ' + pers_tape_materno + ', ' +pers_tnombre) as nombre " & vbCrLf &_
			" from cargas_academicas aa, bloques_horarios bb, bloques_profesores cc,personas dd " & vbCrLf &_
			" where aa.secc_ccod=bb.secc_Ccod and bb.bloq_ccod=cc.bloq_ccod and cc.pers_ncorr=dd.pers_ncorr " & vbCrLf &_
			" and aa.matr_ncorr in (select distinct matr_ncorr " & vbCrLf &_
			"                     from alumnos a, ofertas_academicas b, periodos_academicos c " & vbCrLf &_
			"                     where a.ofer_ncorr=b.ofer_ncorr and b.peri_ccod=c.peri_ccod " & vbCrLf &_
			"                     and cast(c.anos_ccod as varchar)='"&anos_ccod&"' and cast(a.pers_ncorr as varchar)='"&pers_ncorr_origen&"' and a.emat_ccod <> 9)  " & vbCrLf &_
			" ) a   "
titulo = "Crear mensaje a Profesor"			
end if
			
'response.Write("<pre>"&c_destino&"</pre>")
formulario.agregaCampoParam "pers_ncorr_destino","destino",c_destino
'formulario.agregaCampoCons "pers_ncorr_destino", pers_ncorr_destino
formulario.Siguiente

if mepe_ncorr <> "" then
	 if clng(pers_ncorr_origen) <> clng(pers_ncorr_destino) and pers_ncorr_destino <> "" and respuesta="" then
		ruta_responder = "editar_mensaje.asp?mepe_ncorr="&mepe_ncorr&"&pers_ncorr="&pers_ncorr_origen&"&tipo="&tipo&"&respuesta=1"
	 end if 
end if


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><%=titulo%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../estilos/estilos_alumnos.css" rel="stylesheet" type="text/css">
<link href="../estilos/tabla.css" rel="stylesheet" type="text/css">

<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>

<script language="JavaScript">
function cerrar()
{
	opener.location.reload();
	close();
}
</script>

<style type="text/css">
#menu div.barraMenu,
#menu div.barraMenu a.botonMenu {
font-family: sans-serif, Verdana, Arial;
font-size: 8pt;
color: white;
}

#menu div.barraMenu {
text-align: left;
}

#menu div.barraMenu a.botonMenu {
background-color: #4b73a6;
border-bottom-style:double;
border-color:#FFFFFF;
color: white;
cursor: pointer;
padding: 4px 6px 2px 5px;
text-decoration: none;
}

#menu div.barraMenu a.botonMenu:hover {
background-color: #FFFFFF;
color:#4b73a6;
}

#menu div.barraMenu a.botonMenu:active {
background-color: #637D4D;
color: black;
}
</style>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#CC6600" background="imagenes/fondo.jpg">
<center>
<table align="center" width="550">
	<tr>
		<td width="100%" align="center"><font size="5" face="Georgia, Times New Roman, Times, serif" color="#23354d"><strong><%=titulo%></strong></font></td>
	</tr>
	<tr>
		<td width="100%" align="center">
			<table width="530" cellpadding="0" cellspacing="0" border="0" bgcolor="#4b73a6">
				<tr><td><font size="-1">&nbsp;</font></td></tr>
				<tr valign="middle">
				    <td width="100%" align="center">
						<table width="98%" border="0" bgcolor="#f7faff">
							<tr>
								<td width="100%" align="center">
									<table width="100%">
										<tr>
										   <td width="37%"><font size="3" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Creación de Mensajes</strong></font></td>
										   <td width="63%"><hr></td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td width="100%" align="center">
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
									  <tr valign="top">
									      <td colspan="4">
										  <form name="edicion">
											<%formulario.DibujaCampo("pers_ncorr")  %>
											<%formulario.DibujaCampo("come_ncorr")  %>
											<input type="hidden" name="tipo" value="<%=tipo%>">
											<table width="100%" border="0">
											  <tr valign="top"> 
												<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>De</strong></font></td>
												<td><strong>:</strong></td>
												<td><%=origen%><input type="hidden" name="m[0][pers_ncorr_origen]" value="<%=pers_ncorr_origen%>"> </td>
											  </tr>
											  <tr valign="top"> 
												<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Para</strong></font></td>
												<td><strong>:</strong></td>
												<td><% if destino <> "" then 
														   response.Write(destino) %>
														   <input type="hidden" name="m[0][pers_ncorr_destino]" value="<%=pers_ncorr_destino%>">
													   <%
													   else 
														   formulario.DibujaCampo("pers_ncorr_destino") 
													   end if%></td>
											  </tr>
											  <tr valign="top"> 
												<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Asunto</strong></font></td>
												<td><strong>:</strong></td>
												<td><%formulario.DibujaCampo("titulo")  %> </td>
											  </tr>
											  <tr valign="top"> 
												<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Contenido</strong></font></td>
												<td><strong>:</strong></td>
												<td><%formulario.DibujaCampo("contenido")  %> </td>
											  </tr>
											  <tr> 
												<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Expiración</strong></font></td>
												<td><strong>:</strong></td>
												<td><%formulario.DibujaCampo("fecha_vencimiento")  %> (dd/mm/aaaa) </td>
											  </tr>
											  <tr> 
												<td><font size="2" face="Georgia, Times New Roman, Times, serif" color="#496da6"><strong>Dejar copia</strong></font></td>
												<td><strong>:</strong></td>
												<td><%formulario.DibujaCampo("mandar_copia")  %></td>
											  </tr>
					                        </table>
											</form>
										  </td>
									  </tr>
									  <tr>
									    <td colspan="4" align="center">
											<table width="50%" cellpadding="0" cellspacing="0">
												<tr>
													<td align="right"><%if mepe_ncorr = "" or respuesta="1" then
										                                    'botonera.dibujaboton "enviar"
																		 end if%></td>
													<td align="center"><%'botonera.dibujaboton "cerrar"%></td>
													<td align="left"><%if mepe_ncorr <> "" then
													                        if clng(pers_ncorr_origen) <> clng(pers_ncorr_destino) and pers_ncorr_destino <> "" and respuesta="" then
																				'botonera.agregaBotonParam "responder","url","editar_mensaje.asp?mepe_ncorr="&mepe_ncorr&"&pers_ncorr="&pers_ncorr_origen&"&tipo="&tipo&"&respuesta=1"
																				'botonera.dibujaboton "responder"
																			end if 
																		end if
					                                                   %>
											        </td>
												</tr>
												<tr valign="top">
													<td align="right"><% origen = 0
													                     if mepe_ncorr = "" or respuesta="1" then%>
										                                   <a href="javascript:_Guardar(this, document.forms['edicion'], 'editar_mensaje_proc.asp','', '', '', 'FALSE');"
																				onmouseover="window.status='botón pulsado';document.images[<%=origen%>].src='imagenes/GUARDAR2.png';return true "
																				onmouseout="window.status='';document.images[<%=origen%>].src='imagenes/GUARDAR1.png';return true ">
																				<img src="imagenes/GUARDAR1.png" border="0" width="70" height="70" alt="Enviar Mensaje"> 
																			</a>
																		 	<%origen = origen + 1 
																		   end if%></td>
													<td align="center">
																		<a href="javascript:cerrar();"
																				onmouseover="window.status='botón pulsado';document.images[<%=origen%>].src='imagenes/SALIR2.png';return true "
																				onmouseout="window.status='';document.images[<%=origen%>].src='imagenes/SALIR1.png';return true ">
																				<img src="imagenes/SALIR1.png" border="0" width="70" height="70" alt="CERRAR VENTANA"> 
																		</a>
													</td>
													<td align="left">
													                  <%if mepe_ncorr <> "" then
													                        if clng(pers_ncorr_origen) <> clng(pers_ncorr_destino) and pers_ncorr_destino <> "" and respuesta="" then
																				origen = origen + 1
																			%>
																				  <a href="javascript:_Navegar(this,'<%=ruta_responder%>', 'FALSE');"
																							onmouseover="window.status='botón pulsado';document.images[<%=origen%>].src='imagenes/RESPONDER2.png';return true "
																							onmouseout="window.status='';document.images[<%=origen%>].src='imagenes/RESPONDER1.png';return true ">
																							<img src="imagenes/RESPONDER1.png" border="0" width="70" height="70" alt="RESPONDER MENSAJE"> 
																				  </a>
													                  <%    end if 
																		end if%>
											        </td>
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
				<tr><td><font size="-1">&nbsp;</font></td></tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td width="100%"><font size="-1">&nbsp;</font></td>
	</tr>
</table>
</center>
</body>
</html>