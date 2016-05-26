<!-- #include file = "../biblioteca/_conexion.asp" -->
<!-- #include file = "../biblioteca/_negocio.asp" -->

<%
set conexion = new CConexion
conexion.Inicializar "upacifico"

set negocio = new CNegocio
negocio.Inicializa conexion

q_pers_nrut = negocio.obtenerUsuario
q_pers_xdv  = conexion.consultaUno("Select pers_xdv from personas where cast(pers_nrut as varchar)='"&q_pers_nrut&"'")
'---------------------------------------------------------------------------------------------------
set f_botonera = new CFormulario
f_botonera.Carga_Parametros "adm_salidas_alumnos.xml", "botonera"

'---------------------------------------------------------------------------------------------------
set f_titulado = new CFormulario
f_titulado.Carga_Parametros "adm_salidas_alumnos.xml", "editar_dpersonales"
f_titulado.Inicializar conexion

SQL = " select a.pers_ncorr, a.pers_nrut, a.pers_xdv, a.pers_tape_paterno, a.pers_tape_materno, a.pers_tnombre, " & vbCrLf & _
	  " b.dire_tcalle, b.dire_tnro, b.dire_tpoblacion, b.ciud_ccod,rtrim(ltrim(cast(a.pers_nnota_ens_media as decimal(2,1)))) pers_nnota_ens_media," & vbCrLf & _
	  " a.pers_nano_egr_media, a.sexo_ccod, a.cole_ccod, " & vbCrLf & _
	  " c.ciud_ccod as ciud_ccod_colegio " & vbCrLf & _
	  " from " & vbCrLf & _
	  " personas a " & vbCrLf & _
	  " left outer join direcciones b " & vbCrLf & _
	  "    on a.pers_ncorr = b.pers_ncorr   and 1 = b.tdir_ccod  " & vbCrLf & _
	  " left outer join colegios c " & vbCrLf & _
	  "    on a.cole_ccod = c.cole_ccod " & vbCrLf & _
	  " where cast(a.pers_nrut as varchar)= '"&q_pers_nrut&"' "

f_titulado.Consultar SQL
f_titulado.SiguienteF
'response.Write("entre")

f_titulado.AgregaCampoCons "pers_nrut", q_pers_nrut
f_titulado.AgregaCampoCons "pers_xdv", q_pers_xdv

'----------------------------------------------------------------------------------------------------

set f_colegio_egreso = new CFormulario
f_colegio_egreso.Carga_Parametros "adm_salidas_alumnos.xml", "colegio_egreso"
f_colegio_egreso.Inicializar conexion
f_colegio_egreso.Consultar SQL
f_colegio_egreso.Siguiente
f_colegio_egreso.AgregaCampoCons "x", "x"

'---------------------------------------------------------------------------------------------------
f_botonera.AgregaBotonUrlParam "siguiente", "pers_nrut", q_pers_nrut
f_botonera.AgregaBotonUrlParam "siguiente", "pers_xdv", q_pers_xdv
'---------------------------------------------------------------------------------------------------
'for each k in request.Form
'	response.Write("<br>" & k & " : " & request.Form(k))
'next

if not EsVacio(Request.Form) then
	f_titulado.AgregaCampoCons "pers_tape_paterno", Request.Form("dp[0][pers_tape_paterno]")	
	f_titulado.AgregaCampoCons "pers_tape_materno", Request.Form("dp[0][pers_tape_materno]")	
	f_titulado.AgregaCampoCons "pers_tnombre", Request.Form("dp[0][pers_tnombre]")
	f_titulado.AgregaCampoCons "sexo_ccod", Request.Form("dp[0][sexo_ccod]")
	f_titulado.AgregaCampoCons "dire_tcalle", Request.Form("dp[0][dire_tcalle]")
	f_titulado.AgregaCampoCons "dire_tnro", Request.Form("dp[0][dire_tnro]")
	f_titulado.AgregaCampoCons "dire_tpoblacion", Request.Form("dp[0][dire_tpoblacion]")
	f_titulado.AgregaCampoCons "ciud_ccod", Request.Form("dp[0][ciud_ccod]")
	f_titulado.AgregaCampoCons "pers_nnota_ens_media", Request.Form("dp[0][pers_nnota_ens_media]")
	f_titulado.AgregaCampoCons "pers_nano_egr_media", Request.Form("dp[0][pers_nano_egr_media]")	
	f_colegio_egreso.AgregaCampoCons "ciud_ccod_colegio", Request.Form("dp[0][ciud_ccod_colegio]")
	v_ciud_ccod_colegio = Request.Form("dp[0][ciud_ccod_colegio]")	
end if


f_colegio_egreso.AgregaCampoParam "cole_ccod", "filtro", " cast(ciud_ccod as varchar)='" & f_colegio_egreso.ObtenerValor("ciud_ccod_colegio") & "'"



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
<script language="JavaScript" src="../biblioteca/tabla.js"></script>
<script language="JavaScript" src="../biblioteca/funciones.js"></script>
<script language="JavaScript" src="../biblioteca/validadores.js"></script>
<script language="JavaScript">


var t_datos;
var o_pers_nrut;
var flag;





function ciud_ccod_colegio_change(p_objeto)
{
	var formulario = document.forms["edicion"];
	
	formulario.method = "post";
	formulario.submit();
}



function dBlur()
{
	flag = 1;
}


function InicioPagina()
{
	t_datos = new CTabla("dp");
	
	flag = 0;
}

</script>
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="InicioPagina();">
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
																<font size="+2"><strong>Actualización datos personales</strong></font>
															</td>
														</tr>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
														</tr>
														<form name="edicion">
														<tr>
															<td width="100%" align="left">
																<table width="98%"  border="0" align="center">
																	<tr>
																	  <td width="15%"><font size="2"><strong><font color="#FF0000">(*)</font>RUT</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%" colspan="4"><font size="2"><%f_titulado.dibujaCampo("pers_nrut")%> - <%f_titulado.dibujaCampo("pers_xdv")%><%f_titulado.dibujaCampo("pers_ncorr")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong><font color="#FF0000">(*)</font>Ap. Paterno</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%"><font size="2"><%f_titulado.dibujaCampo("pers_tape_paterno")%></font></td>
																	  <td width="15%"><font size="2"><strong><font color="#FF0000">(*)</font>Ap. Materno</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%"><font size="2"><%f_titulado.dibujaCampo("pers_tape_materno")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong><font color="#FF0000">(*)</font>Nombres</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td colspan="4"><font size="2"><%f_titulado.dibujaCampo("pers_tnombre")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong>Sexo</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td colspan="4"><font size="2"><%f_titulado.dibujaCampo("sexo_ccod")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong>Calle</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%"><font size="2"><%f_titulado.dibujaCampo("dire_tcalle")%></font></td>
																	  <td width="15%"><font size="2"><strong>N°</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%"><font size="2">&nbsp;</font><%f_titulado.dibujaCampo("dire_tnro")%></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong>Poblaci&oacute;n-Villa</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%" colspan="4"><font size="2"><%f_titulado.dibujaCampo("dire_tpoblacion")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong>Ciudad</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td colspan="4"><font size="2"><%f_titulado.dibujaCampo("ciud_ccod")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2"><strong>Nota E.M.</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%"><font size="2"><%f_titulado.dibujaCampo("pers_nnota_ens_media")%></font></td>
																	  <td width="15%"><font size="2"><strong>A&ntilde;o Egreso E.M.</strong></font></td>
																	  <td width="1%"><font size="2"><strong>:</strong></font></td>
																	  <td width="35%"><font size="2"><%f_titulado.dibujaCampo("pers_nano_egr_media")%></font></td>
																	</tr>
																	<tr>
																	  <td width="15%"><font size="2">&nbsp;</font></td>
																	  <td width="1%"><font size="2">&nbsp;</font></td>
																	  <td width="35%"><font size="2">&nbsp;</font></td>
																	  <td width="15%" colspan="3"><font size="2"><strong><font color="#FF0000">(*)</font></strong>Campos Obligatorios</font></td>
																	</tr>
																 </table>
															</td>
														</tr>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
														</tr>
														
														<tr>
															<td width="100%" align="left">
															    <font size="2">
																<div align="center">
									                                <%f_colegio_egreso.DibujaRegistro%>
										                        </div>
																</font>
															</td>
														</tr>
														</form>
														<tr>
															<td width="100%" align="left">&nbsp;</td>
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
